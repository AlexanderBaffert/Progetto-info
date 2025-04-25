-- Script per controllare e correggere i percorsi delle immagini nel database

-- Visualizza tutte le immagini e i loro percorsi
SELECT b.id, b.model, i.id as image_id, i.url 
FROM Bikes b
LEFT JOIN Image i ON b.id = i.bike_id
ORDER BY b.id, i.id;

-- Aggiorna i percorsi delle immagini che potrebbero essere sbagliati
-- Assicura che tutte le immagini utilizzino lo stesso formato di percorso

-- Standardizza i percorsi delle immagini rimuovendo eventuali slash iniziali
UPDATE Image
SET url = SUBSTR(url, 2)
WHERE url LIKE '/%' AND url NOT LIKE '/static/%';

-- Aggiungi il prefisso 'static/favicon/bikes/' ai percorsi che non lo includono già
UPDATE Image
SET url = 'static/favicon/bikes/' || url
WHERE url NOT LIKE '%static/favicon/bikes/%' 
  AND url NOT LIKE 'static/favicon/%' 
  AND url NOT LIKE 'http%';

-- Per le moto che non hanno immagini, aggiungi immagini di fallback
INSERT INTO Image (bike_id, url)
SELECT b.id, 'static/favicon/bikes/no-image.jpg'
FROM Bikes b
LEFT JOIN Image i ON b.id = i.bike_id
WHERE i.id IS NULL;

-- Per le moto che hanno MP4 come prima immagine, assicurati di usare un'immagine JPG/PNG come priorità
UPDATE Image SET id = id + 1000 WHERE url LIKE '%.mp4';

-- Se un modello ha solo video, aggiungi un'immagine di fallback
INSERT INTO Image (bike_id, url)
SELECT DISTINCT i.bike_id, 'static/favicon/bikes/no-image.jpg'
FROM Image i
WHERE i.bike_id IN (
    SELECT bike_id 
    FROM Image
    GROUP BY bike_id
    HAVING COUNT(*) = SUM(CASE WHEN url LIKE '%.mp4' THEN 1 ELSE 0 END)
);

-- Sistemazioni specifiche per i modelli che hanno problemi con video
-- Tuono V4 (ID: 18)
UPDATE Image 
SET url = 'static/favicon/bikes/naked/tuono.jpg' 
WHERE bike_id = 18 AND url LIKE '%.mp4';

-- Aggiorna le immagini per alcune moto specifiche che potrebbero avere problemi
-- Tuono V4 (ID: 18)
UPDATE Image SET url = 'static/favicon/bikes/naked/tuono.jpg' WHERE bike_id = 18 AND url LIKE '%tuono.jpg';

-- Hornet 1000 (ID: 19)
UPDATE Image SET url = 'static/favicon/bikes/naked/hornet1000.jpg' WHERE bike_id = 19 AND url LIKE '%hornet%';

-- Speed Triple (ID: 20)
UPDATE Image SET url = 'static/favicon/bikes/naked/speedtriple.jpg' WHERE bike_id = 20 AND url LIKE '%speed%';

-- CBR500R (ID: 25)
UPDATE Image SET url = 'static/favicon/bikes/a2/cbr500r.jpg' WHERE bike_id = 25 AND url LIKE '%cbr500%';

-- Z500 (ID: 27)
UPDATE Image SET url = 'static/favicon/bikes/a2/z500.jpg' WHERE bike_id = 27 AND url LIKE '%z500%';

-- R3 (ID: 29)
UPDATE Image SET url = 'static/favicon/bikes/a2/r3.jpg' WHERE bike_id = 29 AND url LIKE '%r3%';

-- MT-03 (ID: 30)
UPDATE Image SET url = 'static/favicon/bikes/a2/mt03.jpg' WHERE bike_id = 30 AND url LIKE '%mt03%';
