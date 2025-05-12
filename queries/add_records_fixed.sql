
-- Elimina i dati esistenti per evitare conflitti
DELETE FROM Description WHERE bike_id = 10;
DELETE FROM Image WHERE bike_id = 10;
DELETE FROM Color WHERE bike_id = 10;
DELETE FROM Bikes WHERE id = 10;

-- Inserimento della nuova moto
INSERT INTO Bikes (id, model, price, year, power, seat_height) VALUES
    (10, 'M 1000 RR', 37450, 2025, 218, 865);

-- Inserimento di colori per la moto
INSERT INTO Color (name, swatch, image, bike_id) VALUES
    ('Blackstorm Metallic/M Motorsport', '#000000' , 'static/favicon/bikes/super_sport/m1k_color.png', 10),
    ('Light white/M Motorsport', '#FFFFFF' , 'static/favicon/bikes/super_sport/m1k_color_2.png', 10);

-- Inserimento di immagini per la moto
INSERT INTO Image (url, bike_id) VALUES
    ('static/favicon/bikes/super_sport/m1k.png', 10),
    ('static/favicon/bikes/super_sport/m1k_1.png', 10),
    ('static/favicon/bikes/super_sport/m1k.mp4', 10);

-- Inserimento delle descrizioni 
INSERT INTO Description (type, text, bike_id) VALUES
    ('main', 'Starting from €37.450,00.', 10),
    ('description_2', 'The BMW M 1000 RR Racing like no other ', 10),
    ('description_3', 'For all those who make every millisecond count. The superbike that is homologated for racing has been aerodynamically optimized in a wind tunnel and further developed on the circuit. The M RR can attribute its maximum speed of 189 mph to its ShiftCam engine that offers 205 hp and the new trim panel with aerodynamic winglets. This bike stands for performance, motorsport, and exclusivity, right down to the last detail. The same goes for the BMW Motorrad Motorsport Race Support. Typically M – typically #NeverStopChallenging.', 10),
    ('description_3_5', 'Ride like you’re in a slipstream', 10),
    ('description_4', 'The redesigned front and side trim panels provide enhanced performance. Additionally, the optimized aerodynamics relieve strain on the rider by reducing the wind pressure they are subjected to: for endurance and fast, focused riding. The revised M Winglets Evolution 3.0, on the other hand, increase the pressure on the front wheel, even when in a lean angle, and generate up to 33% more downforce than the prior model, equating to up to 66 lbs. For even more confidence in low lean angles and high-speed bends.', 10);

DELETE FROM Image WHERE bike_id = 10;