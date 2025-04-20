import json
from flask import Flask, g, jsonify, render_template, request, redirect, url_for, flash, session
import sqlite3
import os


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
            SELECT id, model, year, price 
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
            "price": float(bike['price'])
        }
        
        # Ottieni le immagini
        cursor.execute("SELECT url FROM Image WHERE bike_id = ? ORDER BY id", (bike_id,))
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
                    if swatch_value.startswith('{'):
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
        cursor.execute("SELECT id, model, year, price FROM Bikes ORDER BY model")
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
            SELECT b.id, b.model, b.year, b.price, i.url as img 
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
                "img": bike['img'] if bike['img'] else "static/favicon/bikes/no-image.jpg",
                "slug": bike['model'].lower().replace(' ', '-').replace('_', '-')
            })
        
        return jsonify(result)
    
    except Exception as e:
        print(f"Errore nell'API dei modelli: {str(e)}")
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


if __name__ == "__main__":
    app.run(debug=True)
