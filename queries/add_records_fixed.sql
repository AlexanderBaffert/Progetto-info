
-- Elimina i dati esistenti per evitare conflitti
DELETE FROM Description WHERE bike_id = 14;
DELETE FROM Image WHERE bike_id = 14;
DELETE FROM Color WHERE bike_id = 14;
DELETE FROM Bikes WHERE id = 14;

-- Inserimento della nuova moto
INSERT INTO Bikes (id, model, price, year, power, seat_height) VALUES
    (14, 'MT-10', 16299, 2025, 214, 845);

-- Inserimento di colori per la moto
INSERT INTO Color (name, swatch, image, bike_id) VALUES
    ('Midnight Cyan', '#a0c3b7' , 'static/favicon/bikes/naked/mt10_color.jpg', 14),
    ('Icon Blue', '#0038a8' , 'static/favicon/bikes/naked/mt10_color_2.jpg', 14),
    ('Tech Black', '#000000' , 'static/favicon/bikes/naked/mt10_color_3.jpg', 14);

-- Inserimento di immagini per la moto
INSERT INTO Image (url, bike_id) VALUES
    ('static/favicon/bikes/naked/mt10.webp', 14),
    ('static/favicon/bikes/naked/mt_1.jpg', 14),
    ('static/favicon/bikes/naked/mt_2.jpg', 14),
    ('static/favicon/bikes/naked/mt_3.jpg', 14),
    ('static/favicon/bikes/naked/mt_4.jpg', 14),
    ('static/favicon/bikes/naked/mt_5.jpg', 14),
    ('static/favicon/bikes/naked/mt_6.jpg', 14),
    ('static/favicon/bikes/naked/mt_7.jpg', 14),
    ('static/favicon/bikes/naked/mt_8.jpg', 14),
    ('static/favicon/bikes/naked/mt_9.jpg', 14),
    ('static/favicon/bikes/naked/mt_10.jpg', 14),
    ('static/favicon/bikes/naked/mt_11.jpg', 14),
    ('static/favicon/bikes/naked/mt_12.jpg', 14);

-- Inserimento delle descrizioni 
INSERT INTO Description (type, text, bike_id) VALUES
    ('main', 'Starting from €16.299,00.', 14),
    ('description_2', 'The Night Naked ', 14),
    ('description_3', 'Tuned to produce a sensational feeling of torque for the most thrilling experience, the MT-10 is the most powerful Hyper Naked ever built by Yamaha. Manufactured using cutting-edge engine and chassis technology from the R1, the MT-10 gives you power, agility and adrenaline.', 14),
    ('description_3_5', 'The Darkest Energy.', 14),
    ('description_4', 'The King of the MT line-up demands total respect, and the first thing that’s going to grab your attention is the compact headlight assembly and aggressive tank design that highlight the MT-10’s outstanding mechanical beauty. And the moment you hear the 998cc CP4 engine’s deep intake roar coming out of the air intakes, you’ll know that this bike is the one for you. Hidden deep in the lightweight Deltabox chassis is a sophisticated package of electronic rider aids, designed to give you the highest degree of controllability. With adjustable high-tech systems that control traction, slides, wheelies, engine braking and braking, you can make your MT-10 behave exactly the way you desire.', 14),
    ('description_6', '4.2’’ TFT Meter with Ride Mode selection', 14),
    ('description_7', 'Brembo Radial master cylinder', 14),
    ('description_8', 'Cruise Controll', 14), 
    ('description_9', 'Speed Limiter', 14),
    ('description_10', '988cc CP4 engine', 14),
    ('description_11', 'Aggressive MT design', 14),
    ('description_12', 'APSG Throttle with selectable PWR-modes', 14),
    ('description_13', 'Titanium Exhaust System', 14),
    ('description_14', 'Up and Down quickshifter', 14),
    ('description_15', '6-Axis IMU with full rider aids suite', 14),
    ('description_16', 'Bridgestones S22 Tyre', 14),
    ('description_17', '90 Wheel air-valves', 14);
