-- File per inserire nuovi record senza rieseguire l'intero script di inizializzazione

-- Elimina i dati esistenti per evitare conflitti
DELETE FROM Description WHERE bike_id = 18;
DELETE FROM Image WHERE bike_id = 18;
DELETE FROM Color WHERE bike_id = 18;
DELETE FROM Bikes WHERE id = 18;

-- Inserimento della nuova moto
INSERT INTO Bikes (id, model, price, year) VALUES
    (18, 'Tuono V4', 17999.00, 2025);

-- Inserimento di colori per la moto
INSERT INTO Color (name, swatch, image, bike_id) VALUES
    ('Scorpion Yellow', '#F6E02D', 'static/favicon/bikes/naked/tuono_color.avif', 18),
    ('Shark Grey', '#A7A8AA', 'static/favicon/bikes/naked/tuono_color_2.avif', 18);

-- Inserimento di immagini per la moto
INSERT INTO Image (url, bike_id) VALUES
    ('static/favicon/bikes/naked/tuono.mp4', 18),
    ('static/favicon/bikes/naked/tuono.jpg', 18),
    ('static/favicon/bikes/naked/tuono_1.png', 18);

-- Inserimento delle descrizioni 
INSERT INTO Description (type, text, bike_id) VALUES
    ('main', 'Starting from €17.999,00.', 18),
    ('description_2', 'ADRENALINE STORM', 18),
    ('description_3', 'Aprilia Tuono V4 is the inimitable hypernaked: the machine that transforms racing performance into pure adrenaline. Brazen on the road and unbeatable on the track. Aggressive design, 180 HP E5+ V4 engine, aerodynamic appendages to improve stability and an a-PRC electronics package with predictive logic, capable of anticipating your riding style for an experience without compromises.', 18),
    ('description_3_5', 'Its not just a naked, its a Tuono', 18),
    ('description_4', 'Tuono V4 dominates the asphalt with an aggressive look that leaves no room for interpretation. The compact aesthetics of the semi-fairing fixed to the frame, essential for a front end free from weight, is combined with aerodynamics with overlapping winglets, designed to increase aerodynamic load and precision when cornering. The exceptional ergonomics of Tuono V4 are optimised in terms of protection from the air and heat dissipation, which is effectively diverted from the legs. The position is both comfortable thanks to the handlebars and reactive thanks to the tank shaped to give you the maximum feeling even in sporty riding.', 18);
