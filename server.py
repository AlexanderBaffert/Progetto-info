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
            "description_4": "The most aerodynamic front and side trims will allow you to beat all your records. The new winglets generate up to 50% more downforce on the road: 5.9 kg at 150 km/h, 10.6 kg at 200 km/h, 16.03 kg at 250 km/h and 23.10 kg at 300 km/h. This contrasts with the tendency to surge during acceleration.",
            "colors": [
                {
                    "name": "Black Storm Metallic",
                    "swatch": "#000000",
                    "image": "static/favicon/bikes/liter_bikes/s1k_color_2.webp"
                },
                {
                    "name": "Light White/M Motorsport", 
                    "swatch": {
                        "color1": "#ffffff",  
                        "color2": "#003578"   
                    },
                    "image": "static/favicon/bikes/liter_bikes/s1k_color.webp"
                },  
                {
                    "name": "Metallic Gray/Black", 
                    "swatch": {
                        "color1": "#808080",
                        "color2": "#000000"
                    },
                    "image": "static/favicon/bikes/liter_bikes/s1k_color_3.webp"
                }
            ]
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
            "description_5": "But above all it is the incredible intelligent electronics of the R1 that make this bike so special. Equipped with everything possible, from ride-by-wire throttle to Launch Control System (LCS), Engine Brake Management (EBM), Brake Control (BC) and much more, the R1 is the definitive Yamaha Supersport, built to dominate the road and track. Available in a new generation of Icon Blue and Yamaha Black colors.",
            "colors": [  # Changed from "color" to "colors"
                {
                    "name": "Icon Blue",
                    "swatch": "#020aff",
                    "image": "static/favicon/bikes/liter_bikes/r1_color.jpg"
                },
                {
                    "name": "Midnight Black",
                    "swatch": "#000000",
                    "image": "static/favicon/bikes/liter_bikes/r1_color_2.jpg"
                }
            ]
        },
        "zx-10r": {
            "name": "ZX-10R",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/zx10r_2.png",
            "image_2": "static/favicon/bikes/liter_bikes/zx10r_3.png",
            "description": "Starting from €29.990,00.",
            "description_2": "The new Ninja ZX-10R",
            "description_3": "For those like you who accept any challenge, we have developed the bike it deserves a true champion. The new Ninja ZX-10R and Ninja ZX-10RR have what it takes to win: completely new aerodynamic fairing with integrated fins, small and light LED headlights, TFT color instruments and smartphone connectivity, as well as updates derived from experience World Superbike of the Kawasaki Racing Team.",
            "description_4": "Now that you have in hand the new Ninja you can face anyone, Face Yourself!",  
            "colors": [  # Changed from "color" to "colors"
                {
                    "name": "Lime Green / Ebony (KRT Edition)",
                    "swatch": {
                        "color1": "#32CD32",
                        "color2": "#000000"
                    },
                    "image": "static/favicon/bikes/liter_bikes/zx_color.png"
                }
            ]
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
            "description_5": "The new Panigale V4 is the seventh generation of an incredible saga: that of the Ducati superbikes and sports bikes that have made the history of modern and contemporary high-performance motorcycles.",
            "colors": [
                {
                    "name": "Ducati Red",
                    "swatch": "#ff0000",
                    "image": "static/favicon/bikes/liter_bikes/p_color.png"
                }
            ]
        },

        "gsx-r1000": {
            "name": "GSX-R1000",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/GSX-R1000.jpg",
            "image_2": "static/favicon/bikes/liter_bikes/GSX-R1000_3.png",
            "description": "Starting from €17.990,00.",
            "description_2": "2025 GSX-R1000",
            "description_3": "The 2025 GSX-R1000’s versatile engine provides class-leading power delivered smoothly and controllably across a broad rpm range. Like the original 2001 GSX-R1000, the 2025’s compact chassis delivers nimble handling with excellent suspension feel and braking control, ready to conquer a racetrack or cruise a country road. Advanced electronic rider aids such as traction control and a bi-directional quick shifter enhance the riding experience while the distinctive, aerodynamic GSX-R bodywork slices through the wind.",
            "description_4": "Equipped with a Showa® Big-piston Fork plus Brembo® T-drive rotors and Monobloc brake calipers the GSX-R1000 is ready for a ride through the twisties, on the street or through chicanes on a track day. And that is the point, as the GSX-R1000 is poised to Own the Racetrack, imagine how it performs on the street.",
            "colors": [
                {
                    "name": "Metallic Matte Sword Silver",
                    "swatch": "#c0c0c0",
                    "image": "static/favicon/bikes/liter_bikes/gs_color.png"
                },
                {
                    "name": "Candy Daring Red / Glass Sparkle Black",
                    "swatch": {
                        "color1": "#ff0000",
                        "color2": "#000000"
                    },
                    "image": "static/favicon/bikes/liter_bikes/gs_color_2.png"
                }
            ]
        },

        "cbr1000rr-r": {
            "name": "CBR1000RR-R Fireblade",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/fire.webp",
            "image_2": "static/favicon/bikes/liter_bikes/cb_7.PNG",
            "image_4": "static/favicon/bikes/liter_bikes/cb_1.jpg",
            "image_5": "static/favicon/bikes/liter_bikes/cb_2.jpg",
            "image_6": "static/favicon/bikes/liter_bikes/cb_3.jpg",
            "image_7": "static/favicon/bikes/liter_bikes/cb_4.jpg",
            "image_8": "static/favicon/bikes/liter_bikes/cb_5.jpg",
            "image_9": "static/favicon/bikes/liter_bikes/cb_6.jpg",
            "description": "Starting from €31.490,00.",
            "description_2": "CBR1000RR-R Fireblade, Born to race",
            "description_3": "Crafted for those who strive for greatness, the CBR1000RR-R Fireblade brings MotoGP-proven technology to a street near you. And this year's new 2025 model has it all: more midrange power, sleeker aerodynamics, a responsive engine, Akrapovič titanium muffler, and Öhlins electronic suspension. So, hop on and rule the roads.",           
            "description_4": "The Fireblade is equipped with the most advanced electronic systems, including a 6-axis Inertial Measurement Unit (IMU), Throttle By Wire, and Honda Selectable Torque Control (HSTC). The result? A bike that's as responsive as it is powerful. And with the new aerodynamic winglets, you'll be cutting through the wind like never before.",
            "description_6": "1000cc DOHC 4-cylinder in-line engine",
            "description_7": "Throttle By Wire with 2 actuators",
            "description_8": "New Aerodynamics Winglets",
            "description_9": "Inertial Power IMU with 6 axes",
            "description_10": "Aluminum swingarm derived from RC213V-S",
            "description_11": "Titanium Exhaust Terminal, Akrapovic",
            "colors": [
                {
                    "name": "Grand Prix Red",
                    "swatch": "#ff0000",
                    "image": "static/favicon/bikes/liter_bikes/cb_color.png"
                },
                {
                    "name": "Matte Gunpowder Black Metallic",
                    "swatch": {
                        "color1": "#3a3a3a",
                        "color2": "#000000"
                    },
                    "image": "static/favicon/bikes/liter_bikes/cb_color_2.png"
                }
            ]
        
        },

        "rsv4": {
            "name": "RSV4",
            "year": "2025",
            "image": "static/favicon/bikes/liter_bikes/rsv4_2.avif",
            "image_2": "static/favicon/bikes/liter_bikes/rsv4_3.avif",
            "description": "Starting from €20.999,00.",
            "description_2": "THE ULTIMATE SUPERBIKE",
            "description_3": "RSV4 is much more than two wheels between a powerful engine. It is the culmination of an ambitious project born from the Aprilia Racing Department. It is the result of the best technology available, now with integrated aerodynamic appendages and improved aerodynamic efficiency. It is a masterpiece created to leave you breathless from the first glance and to make your adrenaline rise every time you touch the accelerator.",
            "description_4": "Aprilia RSV4 is updated for 2025 with aerodynamics with MotoGP-derived winglets, new Brembo Hypure front calipers, a brand new predictive electronic control management system and a V4 E5+ engine boosted to 220 HP, which crowns it as the most powerful homologated production superbike in the world. Aprilia RSV4 Factory confirms itself at the absolute top thanks to semi-active Öhlins Smart EC 2.0 suspension with corner by corner function, Track Pack, Comfort Pack and Race Pack as standard.",
            "colors": [
                {
                    "name": "Sachsenring Black",
                    "swatch": "#000000",
                    "image": "static/favicon/bikes/liter_bikes/rs_color.webp"
                },
                {
                    "name": "Silverstone Grey",
                    "swatch": "#808080",
                    "image": "static/favicon/bikes/liter_bikes/rs_color_2.webp"
                }
            ]
        },

        # A2 bikes

        "rs457": {
            "name": "RS 457",
            "year": "2024",
            "image": "static/favicon/bikes/A2/457.mp4",
            "image_2": "static/favicon/bikes/A2/457_4.png",
            "description": "Starting from €7.199,00.",
            "description_2": "WELCOME TO THE RACING SQUAD ",
            "description_3": "Lightness, ease of riding and technological equipment are the strengths of the Aprilia RS 457, capable of exalting every motorcyclist both on the road and between the curbs of the track. The grit of the RS 457 is in fact that of the legendary RS range: the super sports bikes that made the history of motorcycling.",
            "description_5": "Revolutionary and sophisticated, the style of the RS 457 communicates elegance and aggression, thanks to unmistakably racing elements, such as the double front fairing and the 2-in-1 exhaust. The distinctive liveries celebrate the bold essence of the Racing Squad, thanks to the combination of bright shades and refined materials, offering an experience that evokes speed and prestige. Are you ready to get into the mood?",
            "colors": [
                {
                    "name": "Racing Stripes",
                    "swatch": "black",
                    "image": "static/favicon/bikes/A2/457_color.webp"
                },
                {
                    "name": "Opalescent Light",
                    "swatch": "white",
                    "image": "static/favicon/bikes/A2/457_color_2.webp"
                },
                {
                    "name": "Prismatic Dark",
                    "swatch": "darkgrey",
                    "image": "static/favicon/bikes/A2/457_color_3.webp"
                }
            ]
        },

        "ninja-400": {
            "name": "Ninja 400",
            "year": "2023",
            "image": "static/favicon/bikes/A2/ninja400.mp4",
            "image_2": "static/favicon/bikes/A2/ninja400.jpg",
            "description": "Starting from €6.999,00.",
            "description_2": "Ninja 400, the perfect balance",
            "description_3": "The Ninja 400, equipped with a 399 cm3 twin, offers respectable performance thanks to an even lighter frame. High-quality design, easy and undemanding riding, high stability and extraordinary handling make the Ninja 400 an extremely fun bike",
            "colors": [
                {
                    "name": "Lime Green / Ebony (KRT Edition)",
                    "swatch": {
                        "color1": "#32CD32",
                        "color2": "#000000"
                    },
                    "image": "static/favicon/bikes/A2/ninja400_color.png"
                },
                {
                    "name": "Metallic Carbon Gray / Metallic Flat Spark Black",
                    "swatch": {
                        "color1": "#808080",
                        "color2": "#000000"
                    },
                    "image": "static/favicon/bikes/A2/ninja400_color_2.png"
                }
            ]
        },

        "r3": {
            "name": "R3",
            "year": "2024",
            "image": "static/favicon/bikes/A2/r3.mp4",
            "description": "Starting from €6.799,00.",
            "description_2": "320cc Sports Bike",
            "description_3": "The R-World is calling. And when you see how much the R3 has to offer, you’ll know this is the bike for you. Its high-output 321cc engine delivers outstanding acceleration, and its class-leading build quality, next-generation Icon Blue paint scheme and aggressive styling confirm the R3 as Yamaha’s ultimate lightweight supersport.",
            "colors": [
                {
                    "name": "Icon Blue",
                    "swatch": "#020aff",
                    "image": "static/favicon/bikes/A2/r3_color.jpg"
                },
                {
                    "name": "Yamaha Black",
                    "swatch": "#000000",
                    "image": "static/favicon/bikes/A2/r3_color_2.jpg"
                },
                {
                    "name": "Midnight Cyan",
                    "swatch": "#02ffd5",
                    "image": "static/favicon/bikes/A2/r3_color_3.jpg"
                }
            ],
            "description_5": "The R3's slim, athletic body features a central air intake inspired by Yamaha's iconic MotoGP® racing machine, the M1. Its extreme, sleek appearance, aerodynamic race bodywork and aggressive dual LED headlights underline the pure R-Series DNA, making this the most eye-catching 300 on the road and track.",
            "description_6": "A high-quality 37mm KYB upside-down front fork provides precise suspension feel and feedback. The combination of a low-slung fuel tank and handlebars allows the R3 to offer an ergonomic riding position with high levels of comfort and precise control. Now you're ready to enter the world of R/World."
        },

        "cbr500r": {
            "name": "CBR500R",
            "year": "2024",
            "image": "static/favicon/bikes/A2/cbr500.mp4",
            "image_2": "static/favicon/bikes/A2/cbr500_2.webp",
            "image_4": "static/favicon/bikes/A2/c5_1.jpg",
            "image_5": "static/favicon/bikes/A2/c5_2.jpg",
            "image_6": "static/favicon/bikes/A2/c5_3.jpg",
            "image_7": "static/favicon/bikes/A2/c5_4.jpg",
            "image_8": "static/favicon/bikes/A2/c5_5.jpg",
            "image_9": "static/favicon/bikes/A2/c5_6.jpg",
            "description": "Starting from €7.299,00.",
            "description_2": "500cc Sports Bike",
            "description_3": "The know-how that the HRC Racing Department develops by participating in the most prestigious championships in the world is transferred to production models, just like the CBR500R: the A2 license supersport bike inspired by the Fireblade. Its high-performance twin-cylinder engine is combined with an optimised ECU, which maximises available torque and always delivers blistering acceleration. The 41 mm Showa SFF-BP fork, combined with the ultra-lightweight frame and the double front disc with radial-mount caliper, matches the sharp lines of the fairing that incorporates aerodynamic winglets, giving it a purely sporty nature. The new 5-inch TFT screen with Honda RoadSync connectivity and HSTC traction control complete the CBR500R's premium equipment.",
            "description_4": "The CBR acronym identifies a long history of victories, as well as a pure racing DNA. Inspired by the Fireblade in design and with new decidedly aggressive colors, the CBR500R shares the same aerodynamic winglets that give it greater aerodynamics and stability when entering corners, especially at high speeds. The redesigned headlights give a sharper look and emit a wide and bright beam that perfectly illuminates the road, while the sculpted fairing and the comfortable but slim seat make the CBR500R a true reference in its category.",
            "description_6": "Bicylinder for A2 license",
            "description_7": "New TFT 5-inch display",
            "description_8": "Traction control HSTC",
            "description_9": "Supersport suspension and brakes",
            "description_10": "Honda RoadSync connectivity",
            "description_11": "Supersport design",
            "colors": [
                {
                    "name": "Grand Prix Red",
                    "swatch": "#ff0000",
                    "image": "static/favicon/bikes/A2/cb_color_2.jpg"
                },
                {
                    "name": "Matte Gunpowder Black Metallic",
                    "swatch": "#3a3a3a",
                    "image": "static/favicon/bikes/A2/cb_color.png"
                }
            ],
           
        },

        "z500": {
            "name": "Z 500",
            "year": "2025",
            "image": "static/favicon/bikes/A2/z500.mp4",
            "image_2": "static/favicon/bikes/A2/z_1.png",
            "description": "Starting from €5.370,00.",
            "description_2": "Z500",
            "description_3": "All eyes will be on you as you ride the all-new Z500 ABS supernaked. With its distinctive bodywork and a powerful 451cc engine, this aggressively styled streetfighter is for those who aren’t afraid to get noticed.",
            "description_3_5": "Intense Design and Aggressive Look",
            "description_4": "From whatever angle you look at the Z500, its triple-headlight front end and aggressive lines make it clear that it is a member of the Z family, with an aggressive Supernaked look.",
            "colors": [
                {
                    "name": "Metallic Spark Black / Metallic Matte Graphenesteel Gray",
                    "swatch": {
                        "color1": "#000000",
                        "color2": "#808080"
                    },
                    "image": "static/favicon/bikes/A2/z_color.png"
                },
            ]
        },

        "nk450": {
            "name": "NK 450",
            "year": "2023",
            "image": "static/favicon/bikes/A2/nk.png",
            "image_4": "static/favicon/bikes/A2/nk_1.png",
            "image_5": "static/favicon/bikes/A2/nk_2.png",
            "image_6": "static/favicon/bikes/A2/nk_3.png",
            "image_7": "static/favicon/bikes/A2/nk_4.png",
            "image_8": "static/favicon/bikes/A2/nk_5.png",
            "description": "Starting from €5.490,00.",
            "description_2": "The bold and characterful Naked",
            "description_3": "The aesthetics are confirmed, as for the other Naked CFMOTO, elegant, but at the same time aggressive and modern, harmoniously mixing a sinuous shape with sporty details, such as the muscular 14-liter fuel tank and the radiator guards. The FULL LED light cluster, with a distinctive and innovative shape and the brilliant Nebula White color complete the overall layout of the vehicle making the shapes even more streamlined. What makes the 450NK unique is the inclusion of TCS traction control, a feature that is not taken for granted, but increasingly requested and essential to provide maximum safety in the saddle",
            "description_3_5": "EVERY DETAIL IS AN EMOTION",    
            "description_4": "This Twin cylinder has a engine capacity of 450cc, with a maximum power of 46.9 Cv with a 10000 rpm. The 450NK is equipped with a 6-speed gearbox and a wet clutch. The frame is a tubular steel trellis, while the suspensions are entrusted to a 41mm upside-down fork and a rear monoshock with adjustable preload. The braking system is entrusted to a 300mm front disc with a four-piston caliper and a 245mm rear disc with a single-piston caliper. The 450NK is equipped with a 17-inch front wheel and a 15-inch rear wheel, both with 120/70 and 160/60 tires respectively. The 450NK has a 14-liter tank, which guarantees a range of over 400 km. The weight is 168 kg, which makes it very manageable and easy to handle. The seat height is adjustable from 780 to 800 mm, making it suitable for riders of all sizes. ",
            "description_5": "The 450NK has a 14-liter tank, which guarantees a range of over 400 km. The weight is 168 kg, which makes it very manageable and easy to handle. The seat height is adjustable from 780 to 800 mm, making it suitable for riders of all sizes.",
            "colors": [  # Changed from "color" to "colors"
                {
                    "name": "Nebula White",
                    "swatch": "#ffffff",
                    "image": "static/favicon/bikes/A2/nk_color.png"
                }
            ]

        },

        "ktm-390": {  # Changed from "ktm_390" to "ktm-390" to match URL format
            "name": "KTM 390",
            "year": "2024",
            "image": "static/favicon/bikes/A2/390_1.jpg",
            "image_2": "static/favicon/bikes/A2/390.jpg",
            "image_4": "static/favicon/bikes/A2/ktm_1.png",
            "image_5": "static/favicon/bikes/A2/ktm_2.png",
            "image_6": "static/favicon/bikes/A2/ktm_3.png",
            "image_7": "static/favicon/bikes/A2/ktm_4.png",
            "image_8": "static/favicon/bikes/A2/ktm_5.png",
            "image_9": "static/favicon/bikes/A2/ktm_6.png",
            "image_10": "static/favicon/bikes/A2/ktm_7.png",
            "description": "Starting from €6.780,00.",
            "description_2": "THE CORNER ROCKET",
            "description_3": "With the all-new 2024 KTM 390 DUKE, the world around you becomes your own personal gymkhana. With exceptional agility, lightweight handling and punchy performance, this middleweight bike is ready to take on any corner. Equipped with cutting-edge rider aids, an all-new chassis, adjustable suspension and an aggressive new look, the 2024 KTM 390 DUKE is the king of the road when it comes to extreme lean angles. This bike was designed and developed in Austria and assembled in India.",
            "description_4": "The 2024 KTM 390 DUKE is equipped with a new TFT display that provides all the information you need at a glance. The display is easy to read and features a new design that enhances the bike's sporty look. The bike also comes with a new LED headlight that provides excellent visibility in all conditions. The headlight is designed to be lightweight and durable, making it perfect for the rigors of everyday riding. Equipped with a one cylinder engine with a displacement of 373.2 cc, the 390 DUKE is capable of delivering a maximum power of 44 hp at 9,000 rpm and a maximum torque of 37 Nm at 7,000 rpm. The bike is equipped with a slipper clutch that allows for smooth gear changes and prevents rear wheel lock-up during downshifts.",
            "description_6": "Adjustability",
            "description_7": "TFT Display",
            "description_8": "Superstructures",
            "description_9": "Graphics and Chassis",
            "description_10": "Led Lighting",
            "description_11": "Swingarm",
            "description_12": "Forks",
            "colors": [
                {
                    "name": "Orange",
                    "swatch": "#ff7f00",
                    "image": "static/favicon/bikes/A2/390_color.png"
                },
                {
                    "name": "Dark blue",
                    "swatch": "#00008b",
                    "image": "static/favicon/bikes/A2/390_color_2.png"
                }
            ]
        },

        "mt-03": {  
            "name": "MT-03",
            "year": "2025",
            "image": "static/favicon/bikes/A2/mt03.mp4",
            "description": "Starting from €6.499,00.",
            "colors": [
                {
                    "name": "Ice Storm",
                    "swatch": "#c1c1c1",
                    "image": "static/favicon/bikes/A2/mt_color.jpg"
                },
                {
                    "name": "Icon Blue",
                    "swatch": "#020aff",
                    "image": "static/favicon/bikes/A2/mt_color_2.jpg"
                },
                {
                    "name": "Midnight Black",
                    "swatch": "#000000",
                    "image": "static/favicon/bikes/A2/mt_color_3.jpg"
                }
            ]

        }

    }
    model = model_details.get(model_slug)
    if not model:
        return "Model not found", 404
    return render_template("model.html", model=model)

if __name__ == "__main__":
    app.run(debug=True)
