from flask import Flask, request, render_template, redirect, url_for, flash, session
import mariadb

app = Flask(__name__)
app.secret_key = "supersecretkey"  # Necessario per usare flash messages

# Configurazione database
db_config = {
    "user": "fade",
    "password": "fade",
    "host": "127.0.0.1",
    "database": "dealership",
}

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

    conn = None  
    try:
        conn = mariadb.connect(**db_config)
        cursor = conn.cursor()
        # Check if email already exists
        cursor.execute("SELECT * FROM users WHERE email=?", (email,))
        if cursor.fetchone():
            error = "Email already registered. Please log in."
            return render_template("reg_page.html", error=error)
        # Insert new user
        cursor.execute("INSERT INTO users (email, password) VALUES (?, ?)", (email, password))
        conn.commit()
        flash("Register Complited", "success")
        return redirect(url_for("login"))
    except mariadb.Error as e:
        error = "Error: " + str(e)
        return render_template("reg_page.html", error=error)
    finally:
        if conn:
            conn.close()

@app.route("/login", methods=["GET", "POST"])
def login():
    return render_template("log_page.html")

@app.route("/log", methods=["POST"])
def log():
    email = request.form["email"]
    password = request.form["password"]

    conn = mariadb.connect(**db_config)
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM users WHERE email = ? AND password = ?", (email, password))
    user = cursor.fetchone()
    conn.close()

    if user:
        session["logged_in"] = True
        session["user_email"] = email
        return redirect(url_for("index"))  # Successful login returns to main page
    else:
        flash("No account found, try change the email or password", "error")
        return redirect(url_for("login"))

@app.route("/logout", methods=["POST"])
def logout():
    session.pop("logged_in", None)
    session.pop("user_email", None)
    return {"status": "ok"}

@app.route("/model/<model_slug>")
def model_detail(model_slug):
    # Dictionary mapping slugs to model details
    model_details = {
        "s-1000-rr": {
            "name": "S 1000 RR",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/s1000rr_2.png",
            "description": "Starting from €21,450. Discover the financial offers dedicated to this model in the BMW Financial Services section."
        },
        "r1": {
            "name": "R1",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/r1_2.jpg",
            "description": "Starting from €20.699,00. Discover the financial offers dedicated to this model in the Yamaha Financial Services section."
        },
        "zx-10r": {
            "name": "ZX-10R",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/zx10r_2.png",
            "description": "Starting from €29.990,00. Discover the financial offers dedicated to this model in the Kawasaki Financial Services section."
        },
    }
    model = model_details.get(model_slug)
    if not model:
        return "Model not found", 404
    return render_template("model.html", model=model)

if __name__ == "__main__":
    app.run(debug=True)
