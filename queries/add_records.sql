-- File alternativo per inserire nuovi record senza aggiornare quelli esistenti

-- Elimina i dati esistenti per evitare conflitti
DELETE FROM Description WHERE bike_id = 19;
DELETE FROM Image WHERE bike_id = 19;
DELETE FROM Color WHERE bike_id = 19;
DELETE FROM Bikes WHERE id = 19;

-- Inserimento della nuova moto
INSERT INTO Bikes (id, model, price, year) VALUES
    (19, 'Hornet 1000', 10350.00, 2024);

-- Inserimento di colori per la moto
INSERT INTO Color (name, swatch, image, bike_id) VALUES
    ('Grand Prix Red', '#ff0000', 'static/favicon/bikes/naked/hornet_color_2', 19),
    ('Pearl Glare White', '#ffffff', 'static/favicon/bikes/naked/hornet_color_3', 19),
    ('Matte Ballistic Black Metallic (SP) ', '#000000', 'static/favicon/bikes/naked/hornet_color_4', 19);

-- Inserimento di immagini per la moto
INSERT INTO Image (url, bike_id) VALUES
    ('static/favicon/bikes/naked/hornet_1000.mp4', 19),
    ('static/favicon/bikes/naked/hornet_1000_1.jpg', 19),
    ('static/favicon/bikes/naked/hornet_1000_2.webp', 19),
    ('static/favicon/bikes/naked/hornet_1.jpg', 19),
    ('static/favicon/bikes/naked/hornet_2.jpg', 19),
    ('static/favicon/bikes/naked/hornet_3.jpg', 19),
    ('static/favicon/bikes/naked/hornet_4.jpg', 19),
    ('static/favicon/bikes/naked/hornet_5.jpg', 19);

-- Inserimento delle descrizioni
INSERT INTO Description (type, text, bike_id) VALUES
    ('main', 'Starting from €10.350,00.', 19),
    ('description_2', 'CB1000 Hornet, Stingier than ever.', 19),
    ('description_3', 'The Hornet family is complete, and the queen of the hive is here, ready to sting. The new CB1000 Hornet features a four-cylinder engine designed to shred the tarmac, with class-leading naked power. Throttle By Wire ensures precise control, while the chassis features adjustable 41mm Showa SFF-BP USD forks and a Pro-Link rear shock absorber. Pure streetfighter aggression is outlined by crisp twin LED headlights. A 5-inch full-colour TFT screen and Honda RoadSync connectivity ensure it''s smart. Ready to rock?', 19),
    ('description_3_5', 'Total Attack', 19),
    ('description_4', 'Nothing is done for looks alone. This is the bike in its rawest, most clearly defined form. Stripped down for action, the CB1000 Hornet has uncompromising streetfighter style, highlighted by the piercing light of super-compact twin LED headlights, wrapped in a discreet front fairing. The partially hidden frame is a strong element of the agile design, while also emphasising the lines, as does the rear trellis subframe. To add even more menace, the engine, wheels and swingarm are also finished in black. The Hornet''s signature wide-slung fuel tank, which tapers dramatically towards the rear, highlights the raw performance.', 19),
    ('description_6', 'Penetrating LED lighting', 19),
    ('description_7', '5 inch premium color TFT display', 19),
    ('description_8', 'Driving modes with adjustable traction control HSTC', 19),
    ('description_9', 'Precise driving agility', 19),
    ('description_10', 'Amazing inline four-cylinder engine', 19);