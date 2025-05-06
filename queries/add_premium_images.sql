-- Script per aggiungere le immagini mancanti per le moto premium (ID 8-13)
-- e assicurarsi che vengano mostrate nel filtro

-- 1. Prima assicuriamoci che non ci siano già immagini di queste moto
DELETE FROM Image WHERE bike_id IN (8, 9, 10, 11, 12, 13) AND url = 'static/favicon/bikes/no-image.jpg';

-- 2. Aggiungiamo le immagini principali (o sostituiamole se esistono già)
-- R1-M (ID: 8)
INSERT OR REPLACE INTO Image (id, url, bike_id)
SELECT (SELECT COALESCE(MIN(id), (SELECT MAX(id) + 1 FROM Image)) FROM Image WHERE bike_id = 8), 'static/favicon/bikes/super_sport/r1m.jpg', 8
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 8 AND url = 'static/favicon/bikes/super_sport/r1m.jpg');

-- F4 1000 (ID: 9)
INSERT OR REPLACE INTO Image (id, url, bike_id)
SELECT (SELECT COALESCE(MIN(id), (SELECT MAX(id) + 1 FROM Image)) FROM Image WHERE bike_id = 9), 'static/favicon/bikes/super_sport/f4_1000.webp', 9
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 9 AND url = 'static/favicon/bikes/super_sport/f4_1000.webp');

-- M 1000 RR (ID: 10)
INSERT OR REPLACE INTO Image (id, url, bike_id)
SELECT (SELECT COALESCE(MIN(id), (SELECT MAX(id) + 1 FROM Image)) FROM Image WHERE bike_id = 10), 'static/favicon/bikes/super_sport/m1000rr.jpg', 10
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 10 AND url = 'static/favicon/bikes/super_sport/m1000rr.jpg');

-- H2R (ID: 11)
INSERT OR REPLACE INTO Image (id, url, bike_id)
SELECT (SELECT COALESCE(MIN(id), (SELECT MAX(id) + 1 FROM Image)) FROM Image WHERE bike_id = 11), 'static/favicon/bikes/super_sport/h2r.webp', 11
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 11 AND url = 'static/favicon/bikes/super_sport/h2r.webp');

-- Superleggera V4 (ID: 12)
INSERT OR REPLACE INTO Image (id, url, bike_id)
SELECT (SELECT COALESCE(MIN(id), (SELECT MAX(id) + 1 FROM Image)) FROM Image WHERE bike_id = 12), 'static/favicon/bikes/super_sport/superleggera.jpg', 12
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 12 AND url = 'static/favicon/bikes/super_sport/superleggera.jpg');

-- Tricolore (ID: 13)
INSERT OR REPLACE INTO Image (id, url, bike_id)
SELECT (SELECT COALESCE(MIN(id), (SELECT MAX(id) + 1 FROM Image)) FROM Image WHERE bike_id = 13), 'static/favicon/bikes/super_sport/tricolore.avif', 13
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 13 AND url = 'static/favicon/bikes/super_sport/tricolore.avif');

-- 3. Aggiorniamo i descrittori del filtro per mostrare questi modelli
-- Nel filtro vengono visualizzate tutte le moto che hanno immagini valide e non MP4
-- Verifichiamo e correggiamo le entry premium
SELECT b.id, b.model, i.url
FROM Bikes b
LEFT JOIN Image i ON b.id = i.bike_id
WHERE b.id BETWEEN 8 AND 13;
