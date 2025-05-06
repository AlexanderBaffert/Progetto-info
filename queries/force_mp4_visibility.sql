-- Script per assicurare che i video MP4 vengano visualizzati correttamente
-- ad eccezione dell'S1000RR (ID=1)

BEGIN TRANSACTION;

-- 1. Prima recuperiamo tutti i file MP4 nel database e controlliamo se esistono
SELECT b.id, b.model, i.id AS image_id, i.url 
FROM Bikes b
JOIN Image i ON b.id = i.bike_id
WHERE i.url LIKE '%.mp4';

-- 2. Eliminiamo gli ID vecchi per le immagini con MP4 (tranne S1000RR)
-- Assegniamo ID molto bassi ai MP4 (per renderli primi nella vista)
UPDATE Image
SET id = (bike_id * 10) - 9
WHERE url LIKE '%.mp4' AND bike_id != 1;

-- 3. Incrementiamo gli ID di tutte le altre immagini per renderle secondarie
UPDATE Image
SET id = id + 1000
WHERE url NOT LIKE '%.mp4' AND bike_id IN (
    SELECT DISTINCT bike_id FROM Image WHERE url LIKE '%.mp4' AND bike_id != 1
);

-- 4. Verifichiamo il risultato - le immagini MP4 dovrebbero apparire prime nel risultato
SELECT b.id, b.model, i.id AS image_id, i.url, 
       CASE WHEN i.url LIKE '%.mp4' THEN 'Video' ELSE 'Image' END AS type,
       ROW_NUMBER() OVER (PARTITION BY b.id ORDER BY i.id) AS position
FROM Bikes b
JOIN Image i ON b.id = i.bike_id
ORDER BY b.id, i.id;

COMMIT;
