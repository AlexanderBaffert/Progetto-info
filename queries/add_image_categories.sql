-- Script per aggiungere categorie alle immagini come per le descrizioni

-- 1. Modifica della tabella Image per aggiungere il campo tipo
ALTER TABLE Image ADD COLUMN type TEXT DEFAULT 'main';

-- 2. Aggiornamento dei tipi per le immagini esistenti
-- Prima imposta tutte le immagini principali (la prima di ogni moto)
UPDATE Image SET type = 'main' WHERE id IN (
    SELECT MIN(id) FROM Image GROUP BY bike_id
);

-- 3. Aggiornamento dei tipi specifici per le immagini successive alla prima
-- Per ogni moto, prendi le immagini dopo la prima e assegna tipi in sequenza
UPDATE Image SET type = 'side' 
WHERE id IN (
    SELECT id FROM Image i
    WHERE i.id > (SELECT MIN(id) FROM Image WHERE bike_id = i.bike_id)
    AND i.id <= (SELECT MIN(id) FROM Image WHERE bike_id = i.bike_id) + 1
);

UPDATE Image SET type = 'rear' 
WHERE id IN (
    SELECT id FROM Image i
    WHERE i.id > (SELECT MIN(id) FROM Image WHERE bike_id = i.bike_id) + 1
    AND i.id <= (SELECT MIN(id) FROM Image WHERE bike_id = i.bike_id) + 2
);

UPDATE Image SET type = 'front' 
WHERE id IN (
    SELECT id FROM Image i
    WHERE i.id > (SELECT MIN(id) FROM Image WHERE bike_id = i.bike_id) + 2
    AND i.id <= (SELECT MIN(id) FROM Image WHERE bike_id = i.bike_id) + 3
);

UPDATE Image SET type = 'detail' 
WHERE id IN (
    SELECT id FROM Image i
    WHERE i.id > (SELECT MIN(id) FROM Image WHERE bike_id = i.bike_id) + 3
);

-- 4. Aggiorna i video MP4 con il tipo 'video'
UPDATE Image SET type = 'video' WHERE url LIKE '%.mp4';

-- 5. Per le moto premium (8-13) assegna le categorie corrette alle immagini aggiunte
UPDATE Image SET type = 'main' WHERE url LIKE '%static/favicon/bikes/super_sport/%';
