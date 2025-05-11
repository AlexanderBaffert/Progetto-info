-- Script modificato per non mostrare automaticamente i video MP4 come immagini principali

-- Rimuove la manipolazione degli ID che faceva apparire i video per primi
-- DELETE FROM Image WHERE url LIKE '%.mp4'; -- Optional: rimuovere completamente i video

-- Se vuoi mantenere i video ma non farli apparire automaticamente, sostituisci gli INSERT con:
-- S1000RR (ID: 1)
INSERT OR IGNORE INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/liter_bikes/s1000rr.mp4', 1
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 1 AND url LIKE '%.mp4');

-- R1 (ID: 2)
INSERT OR IGNORE INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/liter_bikes/r1.mp4', 2
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 2 AND url LIKE '%.mp4');

-- ZX-10R (ID: 3)
INSERT OR IGNORE INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/liter_bikes/zx10r.mp4', 3
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 3 AND url LIKE '%.mp4');

-- Panigale V4 (ID: 4)
INSERT OR IGNORE INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/liter_bikes/v4.mp4', 4
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 4 AND url LIKE '%.mp4');

-- GSX-R1000 (ID: 5)
INSERT OR IGNORE INTO Image (url, bike_id)
SELECT 'static/favicon/bikes/liter_bikes/GSX-R1000.mp4', 5
WHERE NOT EXISTS (SELECT 1 FROM Image WHERE bike_id = 5 AND url LIKE '%.mp4');
