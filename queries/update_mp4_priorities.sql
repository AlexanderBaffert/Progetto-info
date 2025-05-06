-- Script per aggiornare le priorità dei file MP4 nelle immagini
-- Assicurandoci che i video appaiano come prima immagine, tranne per l'S1000RR (ID=1)

-- Aggiorniamo gli ID delle immagini per dare priorità ai video MP4 (eccetto S1000RR)
BEGIN TRANSACTION;

-- Prima salviamo le associazioni tra bike_id e MP4
CREATE TEMPORARY TABLE temp_mp4_images AS
SELECT id, bike_id, url FROM Image WHERE url LIKE '%.mp4' AND bike_id != 1;

-- Ora, per ogni moto con MP4, modifichiamo gli ID per assicurarci che il video sia primo
UPDATE Image SET id = id + 100 WHERE bike_id IN (SELECT bike_id FROM temp_mp4_images);

-- Aggiorniamo gli ID dei video MP4 per renderli i primi
UPDATE Image SET id = bike_id * 10 
WHERE id IN (SELECT id FROM temp_mp4_images);

-- Puliamo la tabella temporanea
DROP TABLE temp_mp4_images;

-- Verify results
SELECT b.id AS bike_id, b.model, i.id AS image_id, i.url
FROM Bikes b
JOIN Image i ON b.id = i.bike_id
ORDER BY b.id, i.id;

COMMIT;
