-- Script per aggiungere le immagini mancanti per le moto premium (ID 8-13)

-- R1-M (ID: 8)
DELETE FROM Image WHERE bike_id = 8 AND url = 'static/favicon/bikes/no-image.jpg';
INSERT OR REPLACE INTO Image (url, bike_id) VALUES ('static/favicon/bikes/super_sport/r1m.jpg', 8);

-- F4 1000 (ID: 9)
DELETE FROM Image WHERE bike_id = 9 AND url = 'static/favicon/bikes/no-image.jpg';
INSERT OR REPLACE INTO Image (url, bike_id) VALUES ('static/favicon/bikes/super_sport/f4_1000.webp', 9);

-- M 1000 RR (ID: 10)
DELETE FROM Image WHERE bike_id = 10 AND url = 'static/favicon/bikes/no-image.jpg';
INSERT OR REPLACE INTO Image (url, bike_id) VALUES ('static/favicon/bikes/super_sport/m1000rr.jpg', 10);

-- H2R (ID: 11)
DELETE FROM Image WHERE bike_id = 11 AND url = 'static/favicon/bikes/no-image.jpg';
INSERT OR REPLACE INTO Image (url, bike_id) VALUES ('static/favicon/bikes/super_sport/h2r.webp', 11);

-- Superleggera V4 (ID: 12)
DELETE FROM Image WHERE bike_id = 12 AND url = 'static/favicon/bikes/no-image.jpg';
INSERT OR REPLACE INTO Image (url, bike_id) VALUES ('static/favicon/bikes/super_sport/superleggera.jpg', 12);

-- Tricolore (ID: 13)
DELETE FROM Image WHERE bike_id = 13 AND url = 'static/favicon/bikes/no-image.jpg';
INSERT OR REPLACE INTO Image (url, bike_id) VALUES ('static/favicon/bikes/super_sport/tricolore.avif', 13);
