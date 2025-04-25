-- File per aggiungere le immagini mancanti per alcuni modelli

-- Controlla se le immagini esistono già per evitare duplicati
-- Tuono V4 (ID: 18) - Le immagini sono già state aggiunte in add_records_fixed.sql

-- Hornet 1000 (ID: 19)
INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/naked/hornet1000.jpg', 19
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 19);

INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/naked/hornet1000_1.jpg', 19
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 19 AND url = 'static/favicon/bikes/naked/hornet1000_1.jpg');

-- Speed Triple 1200 RS (ID: 20)
INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/naked/speedtriple.jpg', 20
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 20);

INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/naked/speedtriple_1.jpg', 20
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 20 AND url = 'static/favicon/bikes/naked/speedtriple_1.jpg');

-- CBR500R (ID: 25)
INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/a2/cbr500r.jpg', 25
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 25);

INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/a2/cbr500r_1.jpg', 25
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 25 AND url = 'static/favicon/bikes/a2/cbr500r_1.jpg');

-- Z500 (ID: 27)
INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/a2/z500.jpg', 27
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 27);

INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/a2/z500_1.jpg', 27
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 27 AND url = 'static/favicon/bikes/a2/z500_1.jpg');

-- R3 (ID: 29)
INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/a2/r3.jpg', 29
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 29);

INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/a2/r3_1.jpg', 29
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 29 AND url = 'static/favicon/bikes/a2/r3_1.jpg');

-- MT-03 (ID: 30)
INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/a2/mt03.jpg', 30
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 30);

INSERT INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/a2/mt03_1.jpg', 30
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 30 AND url = 'static/favicon/bikes/a2/mt03_1.jpg');

-- Add some colors for the models as well
-- Hornet 1000
INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Grand Prix Red', '#FF0000', 'static/favicon/bikes/naked/hornet1000_red.jpg', 19
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 19);

INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Pearl Black', '#000000', 'static/favicon/bikes/naked/hornet1000_black.jpg', 19
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 19 AND name = 'Pearl Black');

-- Speed Triple
INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Carnival Red', '#C8102E', 'static/favicon/bikes/naked/speedtriple_red.jpg', 20
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 20);

INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Sapphire Black', '#0A0A0A', 'static/favicon/bikes/naked/speedtriple_black.jpg', 20
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 20 AND name = 'Sapphire Black');

-- CBR500R
INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Grand Prix Red', '#FF0000', 'static/favicon/bikes/a2/cbr500r_red.jpg', 25
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 25);

INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Matt Gunpowder Black', '#333333', 'static/favicon/bikes/a2/cbr500r_black.jpg', 25
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 25 AND name = 'Matt Gunpowder Black');

-- Z500
INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Metallic Spark Black', '#0A0A0A', 'static/favicon/bikes/a2/z500_black.jpg', 27
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 27);

INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Candy Lime Green', '#32CD32', 'static/favicon/bikes/a2/z500_green.jpg', 27
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 27 AND name = 'Candy Lime Green');

-- R3
INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Team Yamaha Blue', '#0066CC', 'static/favicon/bikes/a2/r3_blue.jpg', 29
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 29);

INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Midnight Black', '#000000', 'static/favicon/bikes/a2/r3_black.jpg', 29
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 29 AND name = 'Midnight Black');

-- MT-03
INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Cyan Storm', '#00BFFF', 'static/favicon/bikes/a2/mt03_blue.jpg', 30
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 30);

INSERT INTO Color (name, swatch, image, bike_id)
SELECT 'Midnight Black', '#000000', 'static/favicon/bikes/a2/mt03_black.jpg', 30
WHERE NOT EXISTS (SELECT 1 FROM Color WHERE bike_id = 30 AND name = 'Midnight Black');
