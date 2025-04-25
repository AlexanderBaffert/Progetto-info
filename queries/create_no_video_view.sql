-- Crea una vista che esclude i video dalle immagini principali per i filtri

-- Create a view to select non-video images for each bike
CREATE VIEW IF NOT EXISTS BikeImages AS
SELECT 
    b.id as bike_id,
    b.model,
    b.year,
    b.price,
    b.power,
    b.seat_height,
    (
        SELECT i.url 
        FROM Image i 
        WHERE i.bike_id = b.id AND i.url NOT LIKE '%.mp4' 
        ORDER BY i.id
        LIMIT 1
    ) as img_url
FROM 
    Bikes b;

-- Use it with: SELECT * FROM BikeImages;
