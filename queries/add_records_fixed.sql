-- File per inserire nuovi record senza rieseguire l'intero script di inizializzazione

-- Elimina i dati esistenti per evitare conflitti
DELETE FROM Description WHERE bike_id = 18;
DELETE FROM Image WHERE bike_id = 18;
DELETE FROM Color WHERE bike_id = 18;
DELETE FROM Bikes WHERE id = 18;

-- Add new columns to Bikes table if they don't exist
ALTER TABLE Bikes ADD COLUMN power INTEGER;
ALTER TABLE Bikes ADD COLUMN seat_height INTEGER;

-- Inserimento della nuova moto
INSERT INTO Bikes (id, model, price, year, power, seat_height) VALUES
    (18, 'Tuono V4', 17999.00, 2025, 175, 820);

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

-- Update existing bikes with power (in HP) and seat height (in mm) values
-- Sport bikes
UPDATE Bikes SET power = 210, seat_height = 825 WHERE id = 1; -- S 1000 RR
UPDATE Bikes SET power = 200, seat_height = 835 WHERE id = 2; -- R1
UPDATE Bikes SET power = 203, seat_height = 830 WHERE id = 3; -- ZX-10R
UPDATE Bikes SET power = 215, seat_height = 830 WHERE id = 4; -- Panigale V4
UPDATE Bikes SET power = 190, seat_height = 835 WHERE id = 5; -- GSX-R1000
UPDATE Bikes SET power = 217, seat_height = 830 WHERE id = 6; -- CBR1000RR-R
UPDATE Bikes SET power = 217, seat_height = 840 WHERE id = 7; -- RSV4

-- Premium bikes
UPDATE Bikes SET power = 200, seat_height = 835 WHERE id = 8; -- R1-M
UPDATE Bikes SET power = 185, seat_height = 830 WHERE id = 9; -- F4 1000
UPDATE Bikes SET power = 212, seat_height = 825 WHERE id = 10; -- M 1000 RR
UPDATE Bikes SET power = 310, seat_height = 830 WHERE id = 11; -- H2R
UPDATE Bikes SET power = 234, seat_height = 835 WHERE id = 12; -- Superleggera V4
UPDATE Bikes SET power = 208, seat_height = 840 WHERE id = 13; -- Tricolore

-- Naked bikes
UPDATE Bikes SET power = 165, seat_height = 825 WHERE id = 14; -- MT-10
UPDATE Bikes SET power = 208, seat_height = 845 WHERE id = 15; -- Streetfighter V4
UPDATE Bikes SET power = 180, seat_height = 835 WHERE id = 16; -- KTM 1290 Super Duke R
UPDATE Bikes SET power = 200, seat_height = 830 WHERE id = 17; -- Z H2
UPDATE Bikes SET power = 175, seat_height = 820 WHERE id = 18; -- Tuono V4 (already set in INSERT)
UPDATE Bikes SET power = 155, seat_height = 820 WHERE id = 19; -- Hornet 1000
UPDATE Bikes SET power = 178, seat_height = 830 WHERE id = 20; -- Speed Triple 1200 RS

-- Race bikes
UPDATE Bikes SET power = 140, seat_height = 850 WHERE id = 21; -- RC 8C
UPDATE Bikes SET power = 118, seat_height = 850 WHERE id = 22; -- YZF-R6-GYTR

-- A2 bikes
UPDATE Bikes SET power = 47, seat_height = 810 WHERE id = 23; -- RS457
UPDATE Bikes SET power = 45, seat_height = 785 WHERE id = 24; -- NINJA-400
UPDATE Bikes SET power = 47, seat_height = 790 WHERE id = 25; -- CBR500R
UPDATE Bikes SET power = 45, seat_height = 795 WHERE id = 26; -- NK450
UPDATE Bikes SET power = 47, seat_height = 800 WHERE id = 27; -- Z500
UPDATE Bikes SET power = 45, seat_height = 830 WHERE id = 28; -- KTM_390
UPDATE Bikes SET power = 42, seat_height = 780 WHERE id = 29; -- R3
UPDATE Bikes SET power = 42, seat_height = 780 WHERE id = 30; -- MT-03
UPDATE Bikes SET power = 45, seat_height = 795 WHERE id = 31; -- 450SR-S