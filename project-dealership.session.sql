CREATE TABLE User (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);


CREATE TABLE Admin (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(id)
);


CREATE TABLE Bikes (
    id INT PRIMARY KEY,
    model VARCHAR(255) NOT NULL,
    price FLOAT NOT NULL,
    year INT NOT NULL,
    power FLOAT NOT NULL,
    seat_height FLOAT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(id)
);


CREATE TABLE Color (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    bike_id INT NOT NULL,
    FOREIGN KEY (bike_id) REFERENCES Bikes(id)
);


CREATE TABLE Image (
    id INT PRIMARY KEY,
    url VARCHAR(255) NOT NULL,
    bike_id INT NOT NULL,
    FOREIGN KEY (bike_id) REFERENCES Bikes(id)
);


CREATE TABLE Description (
    id INT PRIMARY KEY,
    text TEXT NOT NULL,
    bike_id INT NOT NULL,
    FOREIGN KEY (bike_id) REFERENCES Bikes(id)
);

(1, 'S 1000 RR', 21450.00, 2025, 210, 832, 1),
(2, 'R1', 20699.00, 2025, 200, 855, 2),
(3, 'ZX-10R', 29990.00, 2025, 203, 835, 1),
(4, 'Panigale V4', 27790.00, 2025, 215, 830, 2),
(5, 'GSX-R1000', 17990.00, 2025, 199, 825, 1),
(6, 'CBR1000RR-R', 31490.00, 2025, 217, 831, 2),
(7, 'RSV4', 20999.00, 2025, 220, 840, 1),
-- (8, 'R1-M', 32999.00, 2025, 205, 855, 2),
-- (9, 'F4 1000', 45000.00, 2005, 190, 820, 1),
-- (10, 'M 1000 RR', 39500.00, 2025, 212, 832, 2),
-- (11, 'H2R', 55000.00, 2025, 310, 830, 1),
-- (12, 'Superleggera V4', 100000.00, 2024, 234, 835, 2),
-- (13, 'Tricolore', 45999.00, 2025, 220, 830, 1),
-- (14, 'MT-10', 15999.00, 2025, 165, 825, 2),
-- (15, 'Streetfighter V4', 24500.00, 2025, 208, 845, 1),
-- (16, 'KTM 1290 Super Duke R', 22999.00, 2025, 180, 835, 2),
-- (17, 'Z H2', 19999.00, 2025, 200, 830, 1),
-- (18, 'Tuono V4', 18999.00, 2025, 175, 825, 2),
-- (19, 'Hornet 1000', 16500.00, 2024, 150, 820, 1),
-- (20, 'Speed Triple 1200 RS', 19500.00, 2025, 178, 830, 2),
-- (21, 'RC 8C', 39999.00, 2024, 170, 835, 1),
-- (22, 'YZF-R6-GYTR', 22999.00, 2024, 120, 850, 2),
(23, 'RS 457', 7199.00, 2024, 47, 790, 1),
(24, 'NINJA-400', 6999.00, 2023, 45, 785, 2),
(25, 'CBR500R', 7299.00, 2023, 47, 790, 1),
(26, 'NK450', 5490.00, 2023, 46, 780, 2),
(27, 'Z500', 5370.00, 2025, 45, 780, 1),
(28, 'KTM 390', 6780.00, 2024, 44, 830, 2),
(29, 'R3', 6799.00, 2024, 42, 780, 1),
(30, 'MT-03', 6499.00, 2025, 42, 780, 2),
(31, '450SR-S', 6690.00, 2024, 45, 795, 1);