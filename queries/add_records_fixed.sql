
-- Elimina i dati esistenti per evitare conflitti
DELETE FROM Description WHERE bike_id = 8;
DELETE FROM Image WHERE bike_id = 8;
DELETE FROM Color WHERE bike_id = 8;
DELETE FROM Bikes WHERE id = 8;

-- Inserimento della nuova moto
INSERT INTO Bikes (id, model, price, year, power, seat_height) VALUES
    (8, 'R1M', 29263, 2025, 200, 860);

-- Inserimento di colori per la moto
INSERT INTO Color (name, swatch, image, bike_id) VALUES
    ('Icon Performance', '#000000' , 'static/favicon/bikes/super_sport/r1m_color.jpg', 8);

-- Inserimento di immagini per la moto
INSERT INTO Image (url, bike_id) VALUES
    ('static/favicon/bikes/super_sport/r1m.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_1.webp', 8),
    ('static/favicon/bikes/super_sport/r1m_1.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_2.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_3.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_4.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_5.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_6.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_7.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_8.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_9.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_10.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_11.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_12.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_13.jpg', 8),
    ('static/favicon/bikes/super_sport/r1m_14.jpg', 8);

-- Inserimento delle descrizioni 
INSERT INTO Description (type, text, bike_id) VALUES
    ('main', 'Starting from €29.263,26.', 8),
    ('description_2', 'The Beast From Yamaha', 8),
    ('description_3', 'This is the most advanced production motorcycle for riders who are at the very top of their game. Equipped with the legendary 998cc crossplane engine and Yamahas lightweight Deltabox aluminium chassis, the R1M is the ultimate track machine. And with its next generation electronics, this no compromise motorcycle enables you to discover your true racetrack potential', 8),
    ('description_3_5', 'R history. Your future.', 8),
    ('description_4', 'Yamaha has created the race-focused R1M using some of the most sophisticated technology developed from the race-winning M1 MotoGP bike. Its state-of-the-art Öhlins Electronic Racing Suspension (ERS) with NPX anti-cavitation gas front forks bring out your best performance at every circuit – and the low frontal area carbon bodywork helps to shave your lap times. But what really makes the R1M such a game-changer are the high-tech rider aids including Brake Control, Engine Brake Management and Launch Control. Featuring full black rims, carbon body panels as well as black/silver tank colouring and latest graphics, the R1M is the ultimate R-Series delivering the most complete racetrack package.', 8);