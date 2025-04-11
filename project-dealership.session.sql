-- Create tables
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS admin (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS Bikes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    model TEXT NOT NULL,
    price REAL NOT NULL,
    year INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS Color (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    swatch TEXT NOT NULL,
    image TEXT NOT NULL,
    bike_id INTEGER NOT NULL,
    FOREIGN KEY (bike_id) REFERENCES Bikes(id)
);

CREATE TABLE IF NOT EXISTS Image (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    url TEXT NOT NULL,
    bike_id INTEGER NOT NULL,
    FOREIGN KEY (bike_id) REFERENCES Bikes(id)
);

CREATE TABLE IF NOT EXISTS Description (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL,
    text TEXT NOT NULL,
    bike_id INTEGER NOT NULL,
    FOREIGN KEY (bike_id) REFERENCES Bikes(id)
);

-- Insert default admin user
INSERT OR IGNORE INTO users (id, email, password) VALUES
    (1, 'admin@motodealer.com', 'admin123');

INSERT OR IGNORE INTO admin (id, user_id) VALUES
    (1, 1);

-- Inserimento delle moto - Sport/Liter Bikes
INSERT INTO Bikes (id, model, price, year) VALUES
    (1, 'S 1000 RR', 21450.00, 2025),
    (2, 'R1', 20699.00, 2025),
    (3, 'ZX-10R', 29990.00, 2025),
    (4, 'Panigale V4', 27790.00, 2025),
    (5, 'GSX-R1000', 17990.00, 2025),
    (6, 'CBR1000RR-R', 31490.00, 2025),
    (7, 'RSV4', 20999.00, 2025);

-- Inserimento delle moto - Premium/Super Sport
INSERT INTO Bikes (id, model, price, year) VALUES
    (8, 'R1-M', 32999.00, 2025),
    (9, 'F4 1000', 45000.00, 2005),
    (10, 'M 1000 RR', 39500.00, 2025),
    (11, 'H2R', 55000.00, 2025),
    (12, 'Superleggera V4', 100000.00, 2024),
    (13, 'Tricolore', 45999.00, 2025);

-- Inserimento delle moto - Naked
INSERT INTO Bikes (id, model, price, year) VALUES
    (14, 'MT-10', 15999.00, 2025),
    (15, 'Streetfighter V4', 24500.00, 2025),
    (16, 'KTM 1290 Super Duke R', 22999.00, 2025),
    (17, 'Z H2', 19999.00, 2025),
    (18, 'Tuono V4', 18999.00, 2025),
    (19, 'Hornet 1000', 16500.00, 2024),
    (20, 'Speed Triple 1200 RS', 19500.00, 2025);

-- Inserimento delle moto - Race
INSERT INTO Bikes (id, model, price, year) VALUES
    (21, 'RC 8C', 39999.00, 2024),
    (22, 'YZF-R6-GYTR', 22999.00, 2024);

-- Inserimento delle moto - A2 License
INSERT INTO Bikes (id, model, price, year) VALUES
    (23, 'RS457', 7199.00, 2024),
    (24, 'NINJA-400', 6999.00, 2023),
    (25, 'CBR500R', 7299.00, 2023),
    (26, 'NK450', 5490.00, 2023),
    (27, 'Z500', 5370.00, 2025),
    (28, 'KTM_390', 6780.00, 2024),
    (29, 'R3', 6799.00, 2024),
    (30, 'MT-03', 6499.00, 2025),
    (31, '450SR-S', 6690.00, 2024);

-- Inserimento dei colori
-- S 1000 RR colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (1, 'Black Storm Metallic', '#000000', 'static/favicon/bikes/liter_bikes/s1k_color_2.webp', 1),
    (2, 'Light White/M Motorsport', '{"color1":"#ffffff","color2":"#003578"}', 'static/favicon/bikes/liter_bikes/s1k_color.webp', 1),
    (3, 'Metallic Gray/Black', '{"color1":"#808080","color2":"#000000"}', 'static/favicon/bikes/liter_bikes/s1k_color_3.webp', 1);

-- R1 colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (4, 'Icon Blue', '#020aff', 'static/favicon/bikes/liter_bikes/r1_color.jpg', 2),
    (5, 'Midnight Black', '#000000', 'static/favicon/bikes/liter_bikes/r1_color_2.jpg', 2);

-- ZX-10R colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (6, 'Lime Green / Ebony (KRT Edition)', '{"color1":"#32CD32","color2":"#000000"}', 'static/favicon/bikes/liter_bikes/zx_color.png', 3);

-- Panigale V4 colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (7, 'Ducati Red', '#ff0000', 'static/favicon/bikes/liter_bikes/p_color.png', 4);

-- GSX-R1000 colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (8, 'Metallic Matte Sword Silver', '#c0c0c0', 'static/favicon/bikes/liter_bikes/gs_color.png', 5),
    (9, 'Candy Daring Red / Glass Sparkle Black', '{"color1":"#ff0000","color2":"#000000"}', 'static/favicon/bikes/liter_bikes/gs_color_2.png', 5);

-- CBR1000RR-R colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (10, 'Grand Prix Red', '#ff0000', 'static/favicon/bikes/liter_bikes/cb_color.png', 6),
    (11, 'Matte Gunpowder Black Metallic', '{"color1":"#3a3a3a","color2":"#000000"}', 'static/favicon/bikes/liter_bikes/cb_color_2.png', 6);

-- RSV4 colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (12, 'Sachsenring Black', '#000000', 'static/favicon/bikes/liter_bikes/rs_color.webp', 7),
    (13, 'Silverstone Grey', '#808080', 'static/favicon/bikes/liter_bikes/rs_color_2.webp', 7);

-- A2 Bikes Colors

-- RS457 colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (14, 'Racing Stripes', '#000000', 'static/favicon/bikes/A2/457_color.webp', 23),
    (15, 'Opalescent Light', '#ffffff', 'static/favicon/bikes/A2/457_color_2.webp', 23),
    (16, 'Prismatic Dark', '#444444', 'static/favicon/bikes/A2/457_color_3.webp', 23);

-- NINJA-400 colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (17, 'Lime Green / Ebony (KRT Edition)', '{"color1":"#32CD32","color2":"#000000"}', 'static/favicon/bikes/A2/ninja400_color.png', 24),
    (18, 'Metallic Carbon Gray / Metallic Flat Spark Black', '{"color1":"#808080","color2":"#000000"}', 'static/favicon/bikes/A2/ninja400_color_2.png', 24);

-- R3 colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (19, 'Icon Blue', '#020aff', 'static/favicon/bikes/A2/r3_color.jpg', 29),
    (20, 'Yamaha Black', '#000000', 'static/favicon/bikes/A2/r3_color_2.jpg', 29),
    (21, 'Midnight Cyan', '#02ffd5', 'static/favicon/bikes/A2/r3_color_3.jpg', 29);

-- CBR500R colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (22, 'Grand Prix Red', '#ff0000', 'static/favicon/bikes/A2/cb_color_2.jpg', 25),
    (23, 'Matte Gunpowder Black Metallic', '#3a3a3a', 'static/favicon/bikes/A2/cb_color.png', 25);

-- Z500 colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (24, 'Metallic Spark Black / Metallic Matte Graphenesteel Gray', '{"color1":"#000000","color2":"#808080"}', 'static/favicon/bikes/A2/z_color.png', 27);

-- NK450 colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (25, 'Nebula White', '#ffffff', 'static/favicon/bikes/A2/nk_color.png', 26);

-- KTM_390 colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (26, 'Orange', '#ff7f00', 'static/favicon/bikes/A2/390_color.png', 28),
    (27, 'Dark blue', '#00008b', 'static/favicon/bikes/A2/390_color_2.png', 28);

-- MT-03 colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (28, 'Ice Storm', '#c1c1c1', 'static/favicon/bikes/A2/mt_color.jpg', 30),
    (29, 'Icon Blue', '#020aff', 'static/favicon/bikes/A2/mt_color_2.jpg', 30),
    (30, 'Midnight Black', '#000000', 'static/favicon/bikes/A2/mt_color_3.jpg', 30);

-- 450SR-S colors
INSERT INTO Color (id, name, swatch, image, bike_id) VALUES
    (31, 'Zircon Black', '{"color1":"#000000","color2":"#3a0c0c"}', 'static/favicon/bikes/A2/450_color.png', 31);

-- Inserimento delle immagini principali per ogni moto
-- Sport/Liter Bikes
INSERT INTO Image (id, url, bike_id) VALUES
    (1, 'static/favicon/bikes/liter_bikes/s1000rr_2.png', 1),
    (2, 'static/favicon/bikes/liter_bikes/s1000rr_3.png', 1),
    (3, 'static/favicon/bikes/liter_bikes/s1000rr_4.mp4', 1),
    (4, 'static/favicon/bikes/liter_bikes/r1_2.jpg', 2),
    (5, 'static/favicon/bikes/liter_bikes/r1_4.png', 2),
    (6, 'static/favicon/bikes/liter_bikes/r1_3.jpg', 2),
    (7, 'static/favicon/bikes/liter_bikes/zx10r_2.png', 3),
    (8, 'static/favicon/bikes/liter_bikes/zx10r_3.png', 3),
    (9, 'static/favicon/bikes/liter_bikes/v4.mp4', 4),
    (10, 'static/favicon/bikes/liter_bikes/v4_3.webp', 4),
    (11, 'static/favicon/bikes/liter_bikes/v4_4.jpg', 4),
    (12, 'static/favicon/bikes/liter_bikes/GSX-R1000.jpg', 5),
    (13, 'static/favicon/bikes/liter_bikes/GSX-R1000_3.png', 5),
    (14, 'static/favicon/bikes/liter_bikes/fire.webp', 6),
    (15, 'static/favicon/bikes/liter_bikes/cb_7.PNG', 6),
    (16, 'static/favicon/bikes/liter_bikes/cb_1.jpg', 6),
    (17, 'static/favicon/bikes/liter_bikes/cb_2.jpg', 6),
    (18, 'static/favicon/bikes/liter_bikes/cb_3.jpg', 6),
    (19, 'static/favicon/bikes/liter_bikes/cb_4.jpg', 6),
    (20, 'static/favicon/bikes/liter_bikes/cb_5.jpg', 6),
    (21, 'static/favicon/bikes/liter_bikes/cb_6.jpg', 6),
    (22, 'static/favicon/bikes/liter_bikes/rsv4_2.avif', 7),
    (23, 'static/favicon/bikes/liter_bikes/rsv4_3.avif', 7);

-- A2 License Bikes
INSERT INTO Image (id, url, bike_id) VALUES
    (24, 'static/favicon/bikes/A2/457.mp4', 23),
    (25, 'static/favicon/bikes/A2/457_4.png', 23),
    (26, 'static/favicon/bikes/A2/ninja400.mp4', 24),
    (27, 'static/favicon/bikes/A2/ninja400.jpg', 24),
    (28, 'static/favicon/bikes/A2/cbr500.mp4', 25),
    (29, 'static/favicon/bikes/A2/cbr500_2.webp', 25),
    (30, 'static/favicon/bikes/A2/c5_1.jpg', 25),
    (31, 'static/favicon/bikes/A2/c5_2.jpg', 25),
    (32, 'static/favicon/bikes/A2/c5_3.jpg', 25),
    (33, 'static/favicon/bikes/A2/c5_4.jpg', 25),
    (34, 'static/favicon/bikes/A2/c5_5.jpg', 25),
    (35, 'static/favicon/bikes/A2/c5_6.jpg', 25),
    (36, 'static/favicon/bikes/A2/nk.png', 26),
    (37, 'static/favicon/bikes/A2/nk_1.png', 26),
    (38, 'static/favicon/bikes/A2/nk_2.png', 26),
    (39, 'static/favicon/bikes/A2/nk_3.png', 26),
    (40, 'static/favicon/bikes/A2/nk_4.png', 26),
    (41, 'static/favicon/bikes/A2/nk_5.png', 26),
    (42, 'static/favicon/bikes/A2/z500.mp4', 27),
    (43, 'static/favicon/bikes/A2/z_1.png', 27),
    (44, 'static/favicon/bikes/A2/390_1.jpg', 28),
    (45, 'static/favicon/bikes/A2/390.jpg', 28),
    (46, 'static/favicon/bikes/A2/ktm_1.png', 28),
    (47, 'static/favicon/bikes/A2/ktm_2.png', 28),
    (48, 'static/favicon/bikes/A2/ktm_3.png', 28),
    (49, 'static/favicon/bikes/A2/ktm_4.png', 28),
    (50, 'static/favicon/bikes/A2/ktm_5.png', 28),
    (51, 'static/favicon/bikes/A2/ktm_6.png', 28),
    (52, 'static/favicon/bikes/A2/ktm_7.png', 28),
    (53, 'static/favicon/bikes/A2/r3.mp4', 29),
    (54, 'static/favicon/bikes/A2/mt03.mp4', 30),
    (55, 'static/favicon/bikes/A2/mt03_1.webp', 30),
    (56, 'static/favicon/bikes/A2/mt_1.jpg', 30),
    (57, 'static/favicon/bikes/A2/mt_2.jpg', 30),
    (58, 'static/favicon/bikes/A2/mt_3.jpg', 30),
    (59, 'static/favicon/bikes/A2/mt_4.jpg', 30),
    (60, 'static/favicon/bikes/A2/mt_5.jpg', 30),
    (61, 'static/favicon/bikes/A2/mt_6.jpg', 30),
    (62, 'static/favicon/bikes/A2/mt_7.jpg', 30),
    (63, 'static/favicon/bikes/A2/mt_8.jpg', 30),
    (64, 'static/favicon/bikes/A2/mt_9.jpg', 30),
    (65, 'static/favicon/bikes/A2/mt_10.jpg', 30),
    (66, 'static/favicon/bikes/A2/450.jpg', 31),
    (67, 'static/favicon/bikes/A2/450_1.jpg', 31);

-- Inserimento delle descrizioni
-- S 1000 RR descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (1, 'main', 'Starting from €21,450. Discover the financial offers dedicated to this model in the BMW Financial Services section.', 1),
    (2, 'description_2', 'BMW S 1000 RR From 0 to 1000', 1),
    (3, 'description_3', 'Perfectly performance-oriented: the RR. Winning or losing is sometimes just a matter of millimeters. That''s why this Superbike is always innovating: from the new, more aerodynamic skin with winglets to the front fender with M Brake Ducts to performance-oriented details, such as the quick-acting throttle grip, which now makes the throttle travel 14 degrees shorter. With the Pro driving mode, now standard, you have every situation under control. The objective was and remains clear: new pole positions – #NeverStopChallenging.', 1),
    (4, 'description_4', 'The most aerodynamic front and side trims will allow you to beat all your records. The new winglets generate up to 50% more downforce on the road: 5.9 kg at 150 km/h, 10.6 kg at 200 km/h, 16.03 kg at 250 km/h and 23.10 kg at 300 km/h. This contrasts with the tendency to surge during acceleration.', 1);

-- R1 descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (5, 'main', 'Starting from €20.699,00.', 2),
    (6, 'description_2', '1000cc Sports Motorcycle', 2),
    (7, 'description_3', 'The R1 has consistently pushed the limits of Supersport technology since the original model changed the world of motorcycling over 25 years ago. Crafted without compromise, this exceptional competition machine is the most exciting Supersport of our time.', 2),
    (8, 'description_4', 'Every advanced technological component of the R1 has been developed based on the knowledge Yamaha has gathered from competing at the highest levels. The stunning 998cc Euro 5 4-cylinder crossplane engine is a direct descendant of the M1, while the aerodynamic bodywork takes inspiration from track designs.', 2),
    (9, 'description_5', 'But above all it is the incredible intelligent electronics of the R1 that make this bike so special. Equipped with everything possible, from ride-by-wire throttle to Launch Control System (LCS), Engine Brake Management (EBM), Brake Control (BC) and much more, the R1 is the definitive Yamaha Supersport, built to dominate the road and track. Available in a new generation of Icon Blue and Yamaha Black colors.', 2);

-- ZX-10R descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (10, 'main', 'Starting from €29.990,00.', 3),
    (11, 'description_2', 'The new Ninja ZX-10R', 3),
    (12, 'description_3', 'For those like you who accept any challenge, we have developed the bike it deserves a true champion. The new Ninja ZX-10R and Ninja ZX-10RR have what it takes to win: completely new aerodynamic fairing with integrated fins, small and light LED headlights, TFT color instruments and smartphone connectivity, as well as updates derived from experience World Superbike of the Kawasaki Racing Team.', 3),
    (13, 'description_4', 'Now that you have in hand the new Ninja you can face anyone, Face Yourself!', 3);

-- Panigale V4 descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (14, 'main', 'The new Panigale v4, starting from €27.790,00.', 4),
    (15, 'description_2', 'Wonder. Engineered.', 4),
    (16, 'description_3', 'The new Panigale V4 is the seventh generation in the Ducati supersport saga: a synthesis of design and technology. A motorcycle that is at the heart of Ducati''s mission: "to enrich people''s lives thanks to a combination of technologically advanced products from a sensual.', 4),
    (17, 'description_5', 'The new Panigale V4 is the seventh generation of an incredible saga: that of the Ducati superbikes and sports bikes that have made the history of modern and contemporary high-performance motorcycles.', 4);

-- GSX-R1000 descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (18, 'main', 'Starting from €17.990,00.', 5),
    (19, 'description_2', '2025 GSX-R1000', 5),
    (20, 'description_3', 'The 2025 GSX-R1000''s versatile engine provides class-leading power delivered smoothly and controllably across a broad rpm range. Like the original 2001 GSX-R1000, the 2025''s compact chassis delivers nimble handling with excellent suspension feel and braking control, ready to conquer a racetrack or cruise a country road. Advanced electronic rider aids such as traction control and a bi-directional quick shifter enhance the riding experience while the distinctive, aerodynamic GSX-R bodywork slices through the wind.', 5),
    (21, 'description_4', 'Equipped with a Showa® Big-piston Fork plus Brembo® T-drive rotors and Monobloc brake calipers the GSX-R1000 is ready for a ride through the twisties, on the street or through chicanes on a track day. And that is the point, as the GSX-R1000 is poised to Own the Racetrack, imagine how it performs on the street.', 5);

-- CBR1000RR-R descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (22, 'main', 'Starting from €31.490,00.', 6),
    (23, 'description_2', 'CBR1000RR-R Fireblade, Born to race', 6),
    (24, 'description_3', 'Crafted for those who strive for greatness, the CBR1000RR-R Fireblade brings MotoGP-proven technology to a street near you. And this year''s new 2025 model has it all: more midrange power, sleeker aerodynamics, a responsive engine, Akrapovič titanium muffler, and Öhlins electronic suspension. So, hop on and rule the roads.', 6),
    (25, 'description_4', 'The Fireblade is equipped with the most advanced electronic systems, including a 6-axis Inertial Measurement Unit (IMU), Throttle By Wire, and Honda Selectable Torque Control (HSTC). The result? A bike that''s as responsive as it is powerful. And with the new aerodynamic winglets, you''ll be cutting through the wind like never before.', 6),
    (26, 'description_6', '1000cc DOHC 4-cylinder in-line engine', 6),
    (27, 'description_7', 'Throttle By Wire with 2 actuators', 6),
    (28, 'description_8', 'New Aerodynamics Winglets', 6),
    (29, 'description_9', 'Inertial Power IMU with 6 axes', 6),
    (30, 'description_10', 'Aluminum swingarm derived from RC213V-S', 6),
    (31, 'description_11', 'Titanium Exhaust Terminal, Akrapovic', 6);

-- RSV4 descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (32, 'main', 'Starting from €20.999,00.', 7),
    (33, 'description_2', 'THE ULTIMATE SUPERBIKE', 7),
    (34, 'description_3', 'RSV4 is much more than two wheels between a powerful engine. It is the culmination of an ambitious project born from the Aprilia Racing Department. It is the result of the best technology available, now with integrated aerodynamic appendages and improved aerodynamic efficiency. It is a masterpiece created to leave you breathless from the first glance and to make your adrenaline rise every time you touch the accelerator.', 7),
    (35, 'description_4', 'Aprilia RSV4 is updated for 2025 with aerodynamics with MotoGP-derived winglets, new Brembo Hypure front calipers, a brand new predictive electronic control management system and a V4 E5+ engine boosted to 220 HP, which crowns it as the most powerful homologated production superbike in the world. Aprilia RSV4 Factory confirms itself at the absolute top thanks to semi-active Öhlins Smart EC 2.0 suspension with corner by corner function, Track Pack, Comfort Pack and Race Pack as standard.', 7);

-- A2 Bikes Descriptions

-- RS457 descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (36, 'main', 'Starting from €7.199,00.', 23),
    (37, 'description_2', 'WELCOME TO THE RACING SQUAD', 23),
    (38, 'description_3', 'Lightness, ease of riding and technological equipment are the strengths of the Aprilia RS 457, capable of exalting every motorcyclist both on the road and between the curbs of the track. The grit of the RS 457 is in fact that of the legendary RS range: the super sports bikes that made the history of motorcycling.', 23),
    (39, 'description_5', 'Revolutionary and sophisticated, the style of the RS 457 communicates elegance and aggression, thanks to unmistakably racing elements, such as the double front fairing and the 2-in-1 exhaust. The distinctive liveries celebrate the bold essence of the Racing Squad, thanks to the combination of bright shades and refined materials, offering an experience that evokes speed and prestige. Are you ready to get into the mood?', 23);

-- NINJA-400 descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (40, 'main', 'Starting from €6.999,00.', 24),
    (41, 'description_2', 'Ninja 400, the perfect balance', 24),
    (42, 'description_3', 'The Ninja 400, equipped with a 399 cm3 twin, offers respectable performance thanks to an even lighter frame. High-quality design, easy and undemanding riding, high stability and extraordinary handling make the Ninja 400 an extremely fun bike', 24);

-- CBR500R descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (43, 'main', 'Starting from €7.299,00.', 25),
    (44, 'description_2', '500cc Sports Bike', 25),
    (45, 'description_3', 'The know-how that the HRC Racing Department develops by participating in the most prestigious championships in the world is transferred to production models, just like the CBR500R: the A2 license supersport bike inspired by the Fireblade. Its high-performance twin-cylinder engine is combined with an optimised ECU, which maximises available torque and always delivers blistering acceleration. The 41 mm Showa SFF-BP fork, combined with the ultra-lightweight frame and the double front disc with radial-mount caliper, matches the sharp lines of the fairing that incorporates aerodynamic winglets, giving it a purely sporty nature. The new 5-inch TFT screen with Honda RoadSync connectivity and HSTC traction control complete the CBR500R''s premium equipment.', 25),
    (46, 'description_4', 'The CBR acronym identifies a long history of victories, as well as a pure racing DNA. Inspired by the Fireblade in design and with new decidedly aggressive colors, the CBR500R shares the same aerodynamic winglets that give it greater aerodynamics and stability when entering corners, especially at high speeds. The redesigned headlights give a sharper look and emit a wide and bright beam that perfectly illuminates the road, while the sculpted fairing and the comfortable but slim seat make the CBR500R a true reference in its category.', 25),
    (47, 'description_6', 'Bicylinder for A2 license', 25),
    (48, 'description_7', 'New TFT 5-inch display', 25),
    (49, 'description_8', 'Traction control HSTC', 25),
    (50, 'description_9', 'Supersport suspension and brakes', 25),
    (51, 'description_10', 'Honda RoadSync connectivity', 25),
    (52, 'description_11', 'Supersport design', 25);

-- NK450 descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (53, 'main', 'Starting from €5.490,00.', 26),
    (54, 'description_2', 'The bold and characterful Naked', 26),
    (55, 'description_3', 'The aesthetics are confirmed, as for the other Naked CFMOTO, elegant, but at the same time aggressive and modern, harmoniously mixing a sinuous shape with sporty details, such as the muscular 14-liter fuel tank and the radiator guards. The FULL LED light cluster, with a distinctive and innovative shape and the brilliant Nebula White color complete the overall layout of the vehicle making the shapes even more streamlined. What makes the 450NK unique is the inclusion of TCS traction control, a feature that is not taken for granted, but increasingly requested and essential to provide maximum safety in the saddle', 26),
    (56, 'description_3_5', 'EVERY DETAIL IS AN EMOTION', 26),
    (57, 'description_4', 'This Twin cylinder has a engine capacity of 450cc, with a maximum power of 46.9 Cv with a 10000 rpm. The 450NK is equipped with a 6-speed gearbox and a wet clutch. The frame is a tubular steel trellis, while the suspensions are entrusted to a 41mm upside-down fork and a rear monoshock with adjustable preload. The braking system is entrusted to a 300mm front disc with a four-piston caliper and a 245mm rear disc with a single-piston caliper. The 450NK is equipped with a 17-inch front wheel and a 15-inch rear wheel, both with 120/70 and 160/60 tires respectively. The 450NK has a 14-liter tank, which guarantees a range of over 400 km. The weight is 168 kg, which makes it very manageable and easy to handle. The seat height is adjustable from 780 to 800 mm, making it suitable for riders of all sizes.', 26),
    (58, 'description_5', 'The 450NK has a 14-liter tank, which guarantees a range of over 400 km. The weight is 168 kg, which makes it very manageable and easy to handle. The seat height is adjustable from 780 to 800 mm, making it suitable for riders of all sizes.', 26);

-- Z500 descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (59, 'main', 'Starting from €5.370,00.', 27),
    (60, 'description_2', 'Z500', 27),
    (61, 'description_3', 'All eyes will be on you as you ride the all-new Z500 ABS supernaked. With its distinctive bodywork and a powerful 451cc engine, this aggressively styled streetfighter is for those who aren''t afraid to get noticed.', 27),
    (62, 'description_3_5', 'Intense Design and Aggressive Look', 27),
    (63, 'description_4', 'From whatever angle you look at the Z500, its triple-headlight front end and aggressive lines make it clear that it is a member of the Z family, with an aggressive Supernaked look.', 27);

-- KTM_390 descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (64, 'main', 'Starting from €6.780,00.', 28),
    (65, 'description_2', 'THE CORNER ROCKET', 28),
    (66, 'description_3', 'With the all-new 2024 KTM 390 DUKE, the world around you becomes your own personal gymkhana. With exceptional agility, lightweight handling and punchy performance, this middleweight bike is ready to take on any corner. Equipped with cutting-edge rider aids, an all-new chassis, adjustable suspension and an aggressive new look, the 2024 KTM 390 DUKE is the king of the road when it comes to extreme lean angles. This bike was designed and developed in Austria and assembled in India.', 28),
    (67, 'description_4', 'The 2024 KTM 390 DUKE is equipped with a new TFT display that provides all the information you need at a glance. The display is easy to read and features a new design that enhances the bike''s sporty look. The bike also comes with a new LED headlight that provides excellent visibility in all conditions. The headlight is designed to be lightweight and durable, making it perfect for the rigors of everyday riding. Equipped with a one cylinder engine with a displacement of 373.2 cc, the 390 DUKE is capable of delivering a maximum power of 44 hp at 9,000 rpm and a maximum torque of 37 Nm at 7,000 rpm. The bike is equipped with a slipper clutch that allows for smooth gear changes and prevents rear wheel lock-up during downshifts.', 28),
    (68, 'description_6', 'Adjustability', 28),
    (69, 'description_7', 'TFT Display', 28),
    (70, 'description_8', 'Superstructures', 28),
    (71, 'description_9', 'Graphics and Chassis', 28),
    (72, 'description_10', 'Led Lighting', 28),
    (73, 'description_11', 'Swingarm', 28),
    (74, 'description_12', 'Forks', 28);

-- R3 descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (75, 'main', 'Starting from €6.799,00.', 29),
    (76, 'description_2', '320cc Sports Bike', 29),
    (77, 'description_3', 'The R-World is calling. And when you see how much the R3 has to offer, you''ll know this is the bike for you. Its high-output 321cc engine delivers outstanding acceleration, and its class-leading build quality, next-generation Icon Blue paint scheme and aggressive styling confirm the R3 as Yamaha''s ultimate lightweight supersport.', 29),
    (78, 'description_5', 'The R3''s slim, athletic body features a central air intake inspired by Yamaha''s iconic MotoGP® racing machine, the M1. Its extreme, sleek appearance, aerodynamic race bodywork and aggressive dual LED headlights underline the pure R-Series DNA, making this the most eye-catching 300 on the road and track.', 29),
    (79, 'description_6', 'A high-quality 37mm KYB upside-down front fork provides precise suspension feel and feedback. The combination of a low-slung fuel tank and handlebars allows the R3 to offer an ergonomic riding position with high levels of comfort and precise control. Now you''re ready to enter the world of R/World.', 29);

-- MT-03 descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (80, 'main', 'Starting from €6.499,00.', 30),
    (81, 'description_2', 'Naked Bikes 320cc', 30),
    (82, 'description_3', 'Yamaha''s Hyper Naked bikes are built to thrill. With their stripped-back styling and adrenaline-pumping performance, the MT models have stolen the hearts of riders across Europe. Now comes the latest MT-03, ready to dominate the city with its dark street presence and agile, precise handling.', 30),
    (83, 'description_3_5', 'Elegant in the dark', 30),
    (84, 'description_4', 'Inspired by Yamaha''s larger hyper naked bikes, the MT-03''s aggressive look comes straight from the Dark Side of Japan. The predatory twin-eye face projects an intense stare, while the new upside-down forks and large fuel tank underline the dynamic look of the MT family, making this the perfect 300. But what makes this lightweight Hyper Naked so attractive and desirable is that it''s built with pure MT DNA, which means every ride is an emotional and engaging experience. You''ll want to ride it every chance you get. Because this bike loves to be ridden.', 30),
    (85, 'description_6', 'Torque-rich 320cc two-cylinder EURO5+ engine', 30),
    (86, 'description_7', 'Aggressive MT family styling', 30),
    (87, 'description_8', 'Dual position lights and LED headlight', 30),
    (88, 'description_9', 'Dynamic mass-forward body design', 30),
    (89, 'description_10', 'Lightweight diamond frame', 30),
    (90, 'description_11', 'Ergonomic driving position', 30),
    (91, 'description_12', 'New LCD display with smartphone connectivity', 30),
    (92, 'description_13', 'New 37mm upside-down forks', 30),
    (93, 'description_14', 'Swingarm with adjustable preload', 30),
    (94, 'description_15', 'High quality MT look and feel', 30);

-- 450SR-S descriptions
INSERT INTO Description (id, type, text, bike_id) VALUES
    (95, 'main', 'Starting from €6.690,00.', 31),
    (96, 'description_2', 'ALL THE SPORTINESS YOU HAVE BEEN WAITING FOR', 31),
    (97, 'description_3', '450SR S is the advanced version of the first super sport bike by CFMOTO, with a single-sided swingarm that characterizes this new version. Available at our official dealers, the new Super Sport 450SR S awaits you. Don''t miss out, start this season off right!', 31),
    (98, 'description_4', 'The 450SR-S is equipped with a range of advanced features, including a digital display, LED lighting and a high-performance braking system. It also comes with a range of customizable options, allowing riders to personalize their bike to suit their individual style and preferences.', 31);
