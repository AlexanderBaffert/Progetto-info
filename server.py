import json
from flask import Flask, g, jsonify, render_template, request, redirect, url_for, flash, session
import sqlite3
import os
import sys


# Check if running in a virtual environment
def check_venv():
    base_prefix = getattr(sys, "base_prefix", None)
    if base_prefix is None:
        base_prefix = getattr(sys, "real_prefix", None)
    
    if base_prefix != sys.prefix:
        return True  # Running in a virtual environment
    return False


if not check_venv():
    print("\n" + "=" * 80)
    print("WARNING: You are not running in a virtual environment!")
    print("This application should be run in a virtual environment to avoid dependency issues.")
    print("\nTo set up a virtual environment:")
    print("1. Run: python3 -m venv venv")
    print("2. Activate it: source venv/bin/activate (Linux/Mac) or .\\venv\\Scripts\\activate (Windows)")
    print("3. Install requirements: pip install -r requirements.txt")
    print("4. Run the app again: python server.py")
    print("=" * 80 + "\n")
    
    # Uncomment to force exit if not in a virtual environment
    # sys.exit(1)

app = Flask(__name__)
app.secret_key = "your-secret-key-here"

# Build the path to config.json relative to this file
config_path = os.path.join(os.path.dirname(__file__), "config.json")
with open(config_path) as config_file:
    config = json.load(config_file)
    DATABASE = config["DATABASE"]
    INITIALIZATION = config["INITIALIZATION"]


def get_db():
    """Connessione al database"""
    if "db" not in g:
        g.db = sqlite3.connect(DATABASE)
        g.db.row_factory = sqlite3.Row
    return g.db


def init_db():
    """Inizializza il database"""
    with app.app_context():
        db = get_db()
        try:
            # Load schema from queries folder
            with app.open_resource(INITIALIZATION) as f:
                db.executescript(f.read().decode("utf8"))
            db.commit()
            print("Database inizializzato con successo.")
        except Exception as e:
            db.rollback()
            print(f"Errore nell'inizializzazione del database: {str(e)}")


# Aggiungi questa route per inizializzare il database manualmente
@app.route("/init-db")
def initialize_db():
    init_db()
    return "Database inizializzato. Controlla la console per eventuali errori."


@app.route("/")
def index():
    return render_template("main.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    return render_template("reg_page.html")


@app.route("/reg", methods=["POST"])
def reg():
    email = request.form["email"]
    password = request.form["password"]

    if not email or not password:
        error = "Email and password are required"
        return render_template("reg_page.html", error=error)

    try:
        db = get_db()
        cursor = db.cursor()
        # Check if email already exists
        cursor.execute("SELECT * FROM users WHERE email=?", (email,))
        if cursor.fetchone():
            error = "Email already registered. Please log in."
            return render_template("reg_page.html", error=error)
        # Insert new user
        cursor.execute("INSERT INTO users (email, password) VALUES (?, ?)", (email, password))
        db.commit()
        flash("Register Completed", "success")
        return redirect(url_for("login"))
    except sqlite3.Error as e:
        error = "Error: " + str(e)
        return render_template("reg_page.html", error=error)


@app.route("/login", methods=["GET", "POST"])
def login():
    return render_template("log_page.html")


@app.route("/log", methods=["POST"])
def log():
    email = request.form["email"]
    password = request.form["password"]

    try:
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT * FROM users WHERE email = ? AND password = ?", (email, password))
        user = cursor.fetchone()
        
        if user:
            session["logged_in"] = True
            session["user_email"] = email
            return redirect(url_for("index"))  # Successful login returns to main page
        else:
            flash("No account found, try changing the email or password", "error")
            return redirect(url_for("login"))
    except sqlite3.Error as e:
        error = "Error: " + str(e)
        return render_template("log_page.html", error=error)


@app.route("/logout", methods=["POST"])
def logout():
    session.pop("logged_in", None)
    session.pop("user_email", None)
    return {"status": "ok"}


@app.route("/model/<model_slug>")
def model_detail(model_slug):
    try:
        # Connessione al database
        db = get_db()
        cursor = db.cursor()
        
        # Trova la moto in base allo slug
        cursor.execute("""
            SELECT id, model, year, price, power, seat_height 
            FROM Bikes 
            WHERE LOWER(REPLACE(REPLACE(model, ' ', '-'), '_', '-')) = ?
        """, (model_slug,))
        
        bike = cursor.fetchone()
        
        if not bike:
            return "Model not found", 404
        
        bike_id = bike['id']
        model_details = {
            "name": bike['model'],
            "year": str(bike['year']),
            "price": float(bike['price']),
            "power": bike['power'],
            "seat_height": bike['seat_height']
        }
        
        # Ottieni le immagini - VERSIONE CORRETTA
        cursor.execute("""
            SELECT url FROM Image WHERE bike_id = ? 
            ORDER BY 
                CASE 
                    WHEN url LIKE '%.mp4' AND bike_id != 1 THEN 0  -- Priorità ai MP4 eccetto ID=1 (S1000RR)
                    ELSE 1
                END, 
                id
        """, (bike_id,))
        
        images = cursor.fetchall()
        
        if images:
            model_details["image"] = images[0]['url']
            
            # Aggiungi le immagini aggiuntive se disponibili
            for i, img in enumerate(images[1:], 2):
                model_details[f"image_{i}"] = img['url']
        
        # Ottieni le descrizioni
        cursor.execute("SELECT type, text FROM Description WHERE bike_id = ? ORDER BY id", (bike_id,))
        descriptions = cursor.fetchall()
        
        for desc in descriptions:
            if desc['type'] == 'main':
                model_details["description"] = desc['text']
            else:
                model_details[desc['type']] = desc['text']
        
        # Ottieni i colori
        cursor.execute("SELECT name, swatch, image FROM Color WHERE bike_id = ? ORDER BY id", (bike_id,))
        colors = cursor.fetchall()
        
        if colors:
            model_details["colors"] = []
            for color in colors:
                # Gestisci la conversione dei colori JSON
                swatch_value = color['swatch']
                try:
                    # Tenta di convertire il JSON se è un oggetto
                    import json
                    if swatch_value and isinstance(swatch_value, str) and swatch_value.startswith('{'):
                        swatch_value = json.loads(swatch_value)
                except:
                    # Se fallisce, usa il valore come stringa
                    pass
                    
                model_details["colors"].append({
                    "name": color['name'],
                    "swatch": swatch_value,
                    "image": color['image']
                })
        
        return render_template("model.html", model=model_details)
    
    except Exception as e:
        print(f"Errore nel caricamento del modello: {str(e)}")
        return "Error loading model details", 500


@app.route("/models")
def models_list():
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Ottieni tutte le moto dal database
        cursor.execute("SELECT id, model, year, price, power, seat_height FROM Bikes ORDER BY model")
        bikes = cursor.fetchall()
        
        # Prepara i dati per la visualizzazione
        categorized_bikes = {
            "sport": [],
            "premium": [],
            "naked": [],
            "race": [],
            "a2": []
        }
        
        # Assegna le moto alle categorie in base a prezzo e id
        for bike in bikes:
            bike_id = bike['id']
            
            # Ottieni l'immagine principale per questa moto
            cursor.execute("SELECT url FROM Image WHERE bike_id = ? LIMIT 1", (bike_id,))
            image_result = cursor.fetchone()
            image = image_result['url'] if image_result else "static/favicon/bikes/no-image.jpg"
            
            bike_data = {
                "id": bike_id,
                "name": bike['model'],
                "year": str(bike['year']),
                "price": float(bike['price']),
                "power": bike['power'],
                "seat_height": bike['seat_height'],
                "img": image,
                "slug": bike['model'].lower().replace(' ', '-').replace('_', '-')
            }
            
            # Categorizzazione in base a prezzo e id
            if bike_id <= 7:  # Primi 7 ID sono sport bikes
                categorized_bikes["sport"].append(bike_data)
            elif bike_id <= 13:  # ID 8-13 sono premium bikes
                categorized_bikes["premium"].append(bike_data)
            elif bike_id <= 20:  # ID 14-20 sono naked bikes
                categorized_bikes["naked"].append(bike_data)
            elif bike_id <= 22:  # ID 21-22 sono race bikes
                categorized_bikes["race"].append(bike_data)
            else:  # Il resto sono A2 bikes
                categorized_bikes["a2"].append(bike_data)
        
        return render_template("models.html", categories=categorized_bikes)
    
    except Exception as e:
        print(f"Errore nel caricamento dei modelli: {str(e)}")
        return "Error loading models", 500


@app.route("/api/models")
def api_models():
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Ottieni tutte le moto dal database
        cursor.execute("""
            SELECT b.id, b.model, b.year, b.price, b.power, b.seat_height, i.url as img 
            FROM Bikes b
            LEFT JOIN (
                SELECT bike_id, MIN(id) as min_id 
                FROM Image 
                GROUP BY bike_id
            ) m ON b.id = m.bike_id
            LEFT JOIN Image i ON m.min_id = i.id
        """)
        
        bikes = cursor.fetchall()
        
        result = []
        for bike in bikes:
            result.append({
                "id": bike['id'],
                "name": bike['model'],
                "year": str(bike['year']),
                "price": float(bike['price']),
                "power": bike['power'],
                "seat_height": bike['seat_height'],
                "img": bike['img'] if bike['img'] else "static/favicon/bikes/no-image.jpg",
                "slug": bike['model'].lower().replace(' ', '-').replace('_', '-')
            })
        
        return jsonify(result)
    
    except Exception as e:
        print(f"Errore nell'API dei modelli: {str(e)}")
        return jsonify({"error": str(e)}), 500


@app.route("/api/filter-models")
def filter_models():
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Get filter parameters
        brand = request.args.get('brand', '')
        min_price = request.args.get('min_price', '')
        max_price = request.args.get('max_price', '')
        min_power = request.args.get('min_power', '')
        max_power = request.args.get('max_power', '')
        min_seat_height = request.args.get('min_seat_height', '')
        max_seat_height = request.args.get('max_seat_height', '')
        
        # Build the query - MODIFIED to avoid MP4 files as primary images
        query = """
            SELECT b.id, b.model, b.year, b.price, b.power, b.seat_height, 
                   (SELECT url FROM Image WHERE bike_id = b.id AND url NOT LIKE '%.mp4' ORDER BY id LIMIT 1) as img
            FROM Bikes b
            WHERE 1=1
        """
        
        params = []
        
        # Add filter conditions
        if brand:
            query += " AND b.model LIKE ?"
            params.append(f"%{brand}%")
        
        if min_price:
            query += " AND b.price >= ?"
            params.append(float(min_price))
            
        if max_price:
            query += " AND b.price <= ?"
            params.append(float(max_price))
            
        if min_power:
            query += " AND b.power >= ?"
            params.append(int(min_power))
            
        if max_power:
            query += " AND b.power <= ?"
            params.append(int(max_power))
            
        if min_seat_height:
            query += " AND b.seat_height >= ?"
            params.append(int(min_seat_height))
            
        if max_seat_height:
            query += " AND b.seat_height <= ?"
            params.append(int(max_seat_height))
            
        # Execute the query
        cursor.execute(query, params)
        bikes = cursor.fetchall()
        
        result = []
        for bike in bikes:
            # Check if image exists and fix path if needed
            img_path = bike['img'] if bike['img'] else "static/favicon/bikes/no-image.jpg"
            
            # If we still got a video, try to replace with image
            if img_path.lower().endswith('.mp4'):
                # Try to find any non-video image for this bike
                cursor.execute(
                    "SELECT url FROM Image WHERE bike_id = ? AND url NOT LIKE '%.mp4' LIMIT 1", 
                    (bike['id'],)
                )
                alt_img = cursor.fetchone()
                if alt_img:
                    img_path = alt_img['url']
                else:
                    # Default to no-image if no alternatives found
                    img_path = "static/favicon/bikes/no-image.jpg"
                    
            # Ensure the path is standardized (no double slashes)
            img_path = img_path.replace("//", "/")
            if img_path.startswith("static"):
                img_path = "/" + img_path
            
            result.append({
                "id": bike['id'],
                "name": bike['model'],
                "year": str(bike['year']),
                "price": float(bike['price']),
                "power": bike['power'] if bike['power'] is not None else 0,
                "seat_height": bike['seat_height'] if bike['seat_height'] is not None else 0,
                "img": img_path,
                "slug": bike['model'].lower().replace(' ', '-').replace('_', '-')
            })
        
        # Debug info to help identify missing images
        print(f"Filter API found {len(result)} bikes")
        for bike in result:
            if 'no-image' in bike['img']:
                print(f"Missing image for: {bike['name']} (ID: {bike['id']})")
        
        return jsonify(result)
        
    except Exception as e:
        print(f"Errore nel filtro dei modelli: {str(e)}")
        return jsonify({"error": str(e)}), 500


@app.route("/request-quote")
def request_quote():
    return render_template("request_quote.html")


@app.route("/add-records")
def add_new_records():
    try:
        # Connessione al database
        db = get_db()
        cursor = db.cursor()
        
        # Percorso del file SQL per i nuovi record
        add_records_path = os.path.join(os.path.dirname(__file__), "queries/add_records.sql")
        
        # Leggi ed esegui il file SQL
        with open(add_records_path, 'r') as f:
            sql_script = f.read()
        
        # Esegui lo script
        cursor.executescript(sql_script)
        
        # Commit dei cambiamenti
        db.commit()
        return "Nuovi record aggiunti con successo. <a href='/'>Torna alla home</a>"
        
    except Exception as e:
        print(f"Errore nell'aggiunta dei nuovi record: {str(e)}")
        return f"Errore: {str(e)}", 500


@app.route("/add-records-fixed")
def add_new_records_fixed():
    try:
        # Connessione al database
        db = get_db()
        cursor = db.cursor()
        
        # Percorso del file SQL per i nuovi record
        add_records_path = os.path.join(os.path.dirname(__file__), "queries/add_records_fixed.sql")
        
        # Leggi ed esegui il file SQL
        with open(add_records_path, 'r') as f:
            sql_script = f.read()
        
        # Esegui lo script
        cursor.executescript(sql_script)
        
        # Commit dei cambiamenti
        db.commit()
        return "Nuovi campi aggiunti e aggiornati con successo. <a href='/'>Torna alla home</a>"
        
    except Exception as e:
        print(f"Errore nell'aggiunta dei nuovi campi: {str(e)}")
        return f"Errore: {str(e)}", 500


@app.route("/add-missing-images")
def add_missing_images():
    try:
        # Connessione al database
        db = get_db()
        cursor = db.cursor()
        
        # Percorso del file SQL per le immagini mancanti
        missing_images_path = os.path.join(os.path.dirname(__file__), "queries/add_missing_images.sql")
        
        # Leggi ed esegui il file SQL
        with open(missing_images_path, 'r') as f:
            sql_script = f.read()
        
        # Esegui lo script
        cursor.executescript(sql_script)
        
        # Commit dei cambiamenti
        db.commit()
        return "Immagini mancanti aggiunte con successo. <a href='/models'>Visualizza modelli</a>"
        
    except Exception as e:
        print(f"Errore nell'aggiunta delle immagini mancanti: {str(e)}")
        return f"Errore: {str(e)}", 500


@app.route("/fix-image-paths")
def fix_image_paths():
    try:
        # Connessione al database
        db = get_db()
        cursor = db.cursor()
        
        # Percorso del file SQL per correggere i percorsi delle immagini
        fix_images_path = os.path.join(os.path.dirname(__file__), "queries/fix_image_paths.sql")
        
        # Leggi ed esegui il file SQL
        with open(fix_images_path, 'r') as f:
            sql_script = f.read()
        
        # Esegui lo script
        cursor.executescript(sql_script)
        
        # Commit dei cambiamenti
        db.commit()
        
        # Ottieni tutte le immagini dopo la correzione
        cursor.execute("SELECT b.id, b.model, i.url FROM Bikes b LEFT JOIN Image i ON b.id = i.bike_id ORDER BY b.id")
        images = cursor.fetchall()
        
        result = "<h1>Image paths fixed</h1><table border='1'>"
        result += "<tr><th>Bike ID</th><th>Model</th><th>Image URL</th></tr>"
        for img in images:
            result += f"<tr><td>{img['id']}</td><td>{img['model']}</td><td>{img['url']}</td></tr>"
        result += "</table>"
        result += "<br><a href='/models'>View Models</a>"
        return result
    
    except Exception as e:
        print(f"Errore nella correzione dei percorsi delle immagini: {str(e)}")
        return f"Errore: {str(e)}", 500


@app.route("/update-image-paths")
def update_image_paths():
    try:
        # Connessione al database
        db = get_db()
        cursor = db.cursor()
        
        # Percorso del file SQL per aggiornare i percorsi delle immagini
        update_images_path = os.path.join(os.path.dirname(__file__), "queries/update_image_paths.sql")
        
        # Leggi ed esegui il file SQL
        with open(update_images_path, 'r') as f:
            sql_script = f.read()
        
        # Esegui lo script
        cursor.executescript(sql_script)
        
        # Commit dei cambiamenti
        db.commit()
        return "Percorsi delle immagini aggiornati con successo. <a href='/models'>Visualizza modelli</a>"
        
    except Exception as e:
        print(f"Errore nell'aggiornamento dei percorsi delle immagini: {str(e)}")
        return f"Errore: {str(e)}", 500


@app.route("/add-premium-images")
def add_premium_images():
    """Route per aggiungere le immagini mancanti delle moto premium"""
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Percorso del file SQL per le immagini premium
        premium_images_path = os.path.join(os.path.dirname(__file__), "queries/add_premium_images.sql")
        
        # Leggi ed esegui il file SQL
        with open(premium_images_path, 'r') as f:
            sql_script = f.read()
        
        # Esegui lo script
        cursor.executescript(sql_script)
        
        # Commit dei cambiamenti
        db.commit()
        
        # Esegui una query per verificare le immagini aggiornate
        cursor.execute("""
            SELECT b.id, b.model, i.url
            FROM Bikes b
            LEFT JOIN Image i ON b.id = i.bike_id
            WHERE b.id BETWEEN 8 AND 13
            ORDER BY b.id, i.id
        """)
        
        images = cursor.fetchall()
        
        # Crea una tabella HTML per visualizzare i risultati
        result = "<h1>Premium Bikes Images Added</h1><table border='1'>"
        result += "<tr><th>Bike ID</th><th>Model</th><th>Image URL</th></tr>"
        for img in images:
            result += f"<tr><td>{img['id']}</td><td>{img['model']}</td><td>{img['url']}</td></tr>"
        result += "</table>"
        result += "<br><a href='/models'>View All Models</a>"
        result += "<br><a href='/'>Return to Home</a>"
        
        return result
    
    except Exception as e:
        print(f"Errore nell'aggiunta delle immagini premium: {str(e)}")
        return f"Errore: {str(e)}", 500


@app.route("/update-mp4-priorities")
def update_mp4_priorities():
    """Aggiorna le priorità dei file MP4 per mostrarli come prima immagine"""
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Percorso del file SQL per aggiornare le priorità MP4
        update_path = os.path.join(os.path.dirname(__file__), "queries/update_mp4_priorities.sql")
        
        # Leggi ed esegui il file SQL
        with open(update_path, 'r') as f:
            sql_script = f.read()
        
        # Esegui lo script
        cursor.executescript(sql_script)
        
        # Commit dei cambiamenti
        db.commit()
        
        # Visualizza le immagini dopo l'aggiornamento
        cursor.execute("""
            SELECT b.id, b.model, i.id AS image_id, i.url, 
                   CASE WHEN i.url LIKE '%.mp4' THEN 'Video' ELSE 'Image' END AS type
            FROM Bikes b
            JOIN Image i ON b.id = i.bike_id
            ORDER BY b.id, i.id
        """)
        
        results = cursor.fetchall()
        
        html = "<h1>MP4 Video Priorities Updated</h1>"
        html += "<p>I video MP4 sono ora impostati come immagini principali (escluso l'S1000RR)</p>"
        html += "<table border='1' cellpadding='5'>"
        html += "<tr><th>Bike ID</th><th>Model</th><th>Image ID</th><th>Type</th><th>URL</th></tr>"
        
        for row in results:
            html += f"<tr>"
            html += f"<td>{row['id']}</td>"
            html += f"<td>{row['model']}</td>"
            html += f"<td>{row['image_id']}</td>"
            html += f"<td>{row['type']}</td>"
            html += f"<td>{row['url']}</td>"
            html += f"</tr>"
        
        html += "</table>"
        html += "<p><a href='/'>Torna alla home</a></p>"
        
        return html
    
    except Exception as e:
        print(f"Errore nell'aggiornamento delle priorità MP4: {str(e)}")
        return f"Errore: {str(e)}", 500


@app.route("/force-mp4")
def force_mp4():
    """Route per forzare la visibilità dei file MP4"""
    try:
        db = get_db()
        cursor = db.cursor()
        
        # Percorso del file SQL
        force_mp4_path = os.path.join(os.path.dirname(__file__), "queries/force_mp4_visibility.sql")
        
        # Leggi ed esegui il file SQL
        with open(force_mp4_path, 'r') as f:
            sql_script = f.read()
            
        # Esegui lo script
        cursor.executescript(sql_script)
        
        # Commit dei cambiamenti
        db.commit()
        
        # Recupera i risultati per visualizzare
        cursor.execute("""
            SELECT b.id, b.model, i.id AS image_id, i.url,
                   CASE WHEN i.url LIKE '%.mp4' THEN 'Video' ELSE 'Image' END AS type,
                   ROW_NUMBER() OVER (PARTITION BY b.id ORDER BY i.id) AS position
            FROM Bikes b
            JOIN Image i ON b.id = i.bike_id
            ORDER BY b.id, i.id
        """)
        results = cursor.fetchall()
        
        # Crea HTML per visualizzare i risultati
        html = "<h1>MP4 Files Visibility Forced</h1>"
        html += "<p>MP4 files should now appear as the main image for each bike (except S1000RR)</p>"
        html += "<table border='1' cellpadding='5'>"
        html += "<tr><th>Bike ID</th><th>Model</th><th>Image ID</th><th>Type</th><th>Position</th><th>URL</th></tr>"
        
        for row in results:
            html += f"<tr>"
            html += f"<td>{row['id']}</td>"
            html += f"<td>{row['model']}</td>"
            html += f"<td>{row['image_id']}</td>"
            html += f"<td>{row['type']}</td>"
            html += f"<td>{row['position']}</td>"
            html += f"<td>{row['url']}</td>"
            html += f"</tr>"
        
        html += "</table>"
        html += "<p><a href='/'>Torna alla home</a></p>"
        html += "<p><a href='/models'>Visualizza tutti i modelli</a></p>"
        
        return html
        
    except Exception as e:
        print(f"Errore nel forzare la visibilità degli MP4: {str(e)}")
        return f"Errore: {str(e)}", 500


@app.route("/configure")
def configure():
    """Route for the configuration page"""
    return render_template("configure.html")


@app.route("/account")
def account():
    """Route for the account page"""
    return render_template("account.html")


@app.route("/buy")
def buy():
    """Route for the buy page"""
    return render_template("buy.html")


@app.route("/service")
def service():
    """Route for the service page"""
    return render_template("service.html")


if __name__ == "__main__":
    app.run(debug=True)
