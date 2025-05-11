
-- Elimina i dati esistenti per evitare conflitti
DELETE FROM Description WHERE bike_id = 15;
DELETE FROM Image WHERE bike_id = 15;
DELETE FROM Color WHERE bike_id = 15;
DELETE FROM Bikes WHERE id = 15;

-- Inserimento della nuova moto
INSERT INTO Bikes (id, model, price, year, power, seat_height) VALUES
    (15, 'Streetfigher V4', 24790.00, 2025, 214, 845);

-- Inserimento di colori per la moto
INSERT INTO Color (name, swatch, image, bike_id) VALUES
    ('Ducati Red', '#ff0000' , 'static/favicon/bikes/naked/street_v4_color.webp', 15);

-- Inserimento di immagini per la moto
INSERT INTO Image (url, bike_id) VALUES
    ('static/favicon/bikes/naked/street_v4.avif', 15),
    ('static/favicon/bikes/naked/street_v4_1.jpg', 15),
    ('static/favicon/bikes/naked/street_v4_2.jpg', 15),
    ('static/favicon/bikes/naked/street_1.jpg', 15),
    ('static/favicon/bikes/naked/street_2.jpg', 15),
    ('static/favicon/bikes/naked/street_3.jpg', 15),
    ('static/favicon/bikes/naked/street_4.jpg', 15);
-- Inserimento delle descrizioni 
INSERT INTO Description (type, text, bike_id) VALUES
    ('main', 'Starting from €24.790,00.', 15),
    ('description_2', 'The Fight Formula, applied to the Panigale V4.', 15),
    ('description_3', 'The new Streetfighter V4 is the ultimate expression of the Fight Formula, applied to the best ever Panigale. Like never before, the Streetfighter inherits all the innovation and performance of the Ducati superbike, while retaining its unmistakable character. Powerful and precise on track, exciting and enjoyable on the road, the Streetfighter V4 promises both feeling and control for an unparalleled riding experience.', 15),
    ('description_3_5', 'The most powerful Streetfighter of the category.', 15),
    ('description_4', 'As never before, the new Streetfighter V4 is the new Panigale V4 stripped of its fairings, a magical formula that blends new solutions in terms of its design, aerodynamics, ergonomics, chassis and electronics.', 15),
    ('description_6', 'Design', 15),
    ('description_7', 'Chassis and Ergonomics', 15),
    ('description_8', 'Electronics', 15), 
    ('description_9', 'Engine', 15);

DELETE FROM Bikes WHERE id = 17;