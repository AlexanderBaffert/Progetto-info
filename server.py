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
            "image_2": "static/favicon/bikes/liter_bikes/s1000rr_3.png",
            "image_3": "static/favicon/bikes/liter_bikes/s1000rr_4.mp4",
            "description": "Starting from €21,450. Discover the financial offers dedicated to this model in the BMW Financial Services section.",
            "description_2": "BMW S 1000 RR From 0 to 1000",
            "description_3": "Perfectly performance-oriented: the RR. Winning or losing is sometimes just a matter of millimeters. That's why this Superbike is always innovating: from the new, more aerodynamic skin with winglets to the front fender with M Brake Ducts to performance-oriented details, such as the quick-acting throttle grip, which now makes the throttle travel 14 degrees shorter. With the Pro driving mode, now standard, you have every situation under control. The objective was and remains clear: new pole positions – #NeverStopChallenging.",
            "description_4": "The most aerodynamic front and side trims will allow you to beat all your records. The new winglets generate up to 50% more downforce on the road: 5.9 kg at 150 km/h, 10.6 kg at 200 km/h, 16.03 kg at 250 km/h and 23.10 kg at 300 km/h. This contrasts with the tendency to surge during acceleration."
        },
        "r1": {
            "name": "R1",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/r1_2.jpg",
            "image_2": "static/favicon/bikes/liter_bikes/r1_4.png",
            "image_3": "static/favicon/bikes/liter_bikes/r1_3.jpg",
            "description": "Starting from €20.699,00.",
            "description_2": "1000cc Sports Motorcycle",
            "description_3": "The R1 has consistently pushed the limits of Supersport technology since the original model changed the world of motorcycling over 25 years ago. Crafted without compromise, this exceptional competition machine is the most exciting Supersport of our time.",
            "description_4": "Every advanced technological component of the R1 has been developed based on the knowledge Yamaha has gathered from competing at the highest levels. The stunning 998cc Euro 5 4-cylinder crossplane engine is a direct descendant of the M1, while the aerodynamic bodywork takes inspiration from track designs.",
            "description_5": "But above all it is the incredible intelligent electronics of the R1 that make this bike so special. Equipped with everything possible, from ride-by-wire throttle to Launch Control System (LCS), Engine Brake Management (EBM), Brake Control (BC) and much more, the R1 is the definitive Yamaha Supersport, built to dominate the road and track. Available in a new generation of Icon Blue and Yamaha Black colors."
        },
        "zx-10r": {
            "name": "ZX-10R",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/zx10r_2.png",
            "image_2": "static/favicon/bikes/liter_bikes/zx10r_3.png",
            "description": "Starting from €29.990,00.",
            "description_2": "You can beat all your opponents, but there is still a race to face, the one against you same.",
            "description_3": "For those like you who accept any challenge, we have developed the bike it deserves a true champion. The new Ninja ZX-10R and Ninja ZX-10RR have what it takes to win: completely new aerodynamic fairing with integrated fins, small and light LED headlights, TFT color instruments and smartphone connectivity, as well as updates derived from experience World Superbike of the Kawasaki Racing Team.",
            "description_4": "Now that you have in hand the new Ninja you can face anyone, Face Yourself!",  
        },

        "panigale-v4": {
            "name": "Panigale V4",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/v4.mp4",
            "image_2": "static/favicon/bikes/liter_bikes/v4_3.webp",
            "image_3": "static/favicon/bikes/liter_bikes/v4_4.jpg",
            "description": "The new Panigale v4, starting from €27.790,00. ",
            "description_2": "Wonder. Engineered. ",
            "description_3": "The new Panigale V4 is the seventh generation in the Ducati supersport saga: a synthesis of design and technology. A motorcycle that is at the heart of Ducati's mission: “to enrich people's lives thanks to a combination of technologically advanced products from a sensual.",
            "description_4": "The new Panigale V4 is the seventh generation of an incredible saga: that of the Ducati superbikes and sports bikes that have made the history of modern and contemporary high-performance motorcycles."
        },

        "gsx-r1000": {
            "name": "GSX-R1000",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/GSX-R1000.jpg",
            "image_2": "static/favicon/bikes/liter_bikes/GSX-R1000_3.png",
            "description": "Starting from €17.990,00.",
            "description_2": "2025 GSX-R1000",
            "description_3": "The 2025 GSX-R1000’s versatile engine provides class-leading power delivered smoothly and controllably across a broad rpm range. Like the original 2001 GSX-R1000, the 2025’s compact chassis delivers nimble handling with excellent suspension feel and braking control, ready to conquer a racetrack or cruise a country road. Advanced electronic rider aids such as traction control and a bi-directional quick shifter enhance the riding experience while the distinctive, aerodynamic GSX-R bodywork slices through the wind.",
            "description_4": "Equipped with a Showa® Big-piston Fork plus Brembo® T-drive rotors and Monobloc brake calipers the GSX-R1000 is ready for a ride through the twisties, on the street or through chicanes on a track day. And that is the point, as the GSX-R1000 is poised to Own the Racetrack, imagine how it performs on the street."
        },

        "cbr1000rr-r": {
            "name": "CBR1000RR-R",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/fire.webp",
            "image_4": "static/favicon/bikes/liter_bikes/cb_1.jpg",
            "image_5": "static/favicon/bikes/liter_bikes/cb_2.jpg",
            "image_6": "static/favicon/bikes/liter_bikes/cb_3.jpg",
            "image_7": "static/favicon/bikes/liter_bikes/cb_4.jpg",
            "description": "Starting from €31.490,00.",
            "description_6": "1000cc DOHC 4-cylinder in-line engine",
            "description_7": "Throttle By Wire with 2 actuators",
            "description_8": "New Aerodynamics Winglets",
            "description_9": "Inertial Power IMU with 6 axes",
            "description_10": "Aluminum swingarm derived from RC213V-S",
            "description_11": "Titanium Exhaust Terminal, Akrapovic",
        
        }
    }
    model = model_details.get(model_slug)
    if not model:
        return "Model not found", 404
    return render_template("model.html", model=model)

if __name__ == "__main__":
    app.run(debug=True)
