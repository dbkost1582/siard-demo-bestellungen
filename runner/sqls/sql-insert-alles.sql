

-- Kunden
INSERT INTO kunden (kunden_id, name, notizen) VALUES
(1, 'Müller', 'Stammkunde'),
(2, 'Meier', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam non lacus id tellus posuere pretium. Praesent non magna convallis enim eleifend convallis. In laoreet dui diam, eget mollis purus mattis sed. Pellentesque libero ipsum, ullamcorper non dapibus quis, suscipit eget felis. Pellentesque accumsan tortor a nunc facilisis hendrerit. Sed sed tortor in nibh pulvinar vestibulum eu id diam. Proin sit amet porttitor nulla, at dictum sem. Donec nec nunc a sapien malesuada semper vitae at risus. Fusce ultricies erat eget placerat placerat. Pellentesque massa urna, pellentesque et sem.'),
(3, 'Schmidt', 'VIP'),
(4, 'Huber', NULL),
(5, 'Keller', 'Stammkunde'),
(6, 'Weber', NULL),
(7, 'Fischer', 'VIP'),
(8, 'Schneider', NULL),
(9, 'Wagner', 'Stammkunde'),
(10, 'Becker', NULL);

-- Produkte
INSERT INTO produkte (produkt_id, bezeichnung, preis) VALUES
(1, 'Bleistift', 0.80),
(2, 'Kugelschreiber', 1.20),
(3, 'Notizblock A4', 3.50),
(4, 'Ordner DIN A4', 2.90),
(5, 'Locher', 4.50),
(6, 'Heftklammern', 1.10),
(7, 'Druckerpapier 500 Blatt', 5.90),
(8, 'USB-Stick 32GB', 12.50),
(9, 'Laptop', 899.00),
(10, 'Monitor 24 Zoll', 199.00),
(11, 'Tastatur', 29.90),
(12, 'Maus', 19.90),
(13, 'Bürostuhl', 159.00),
(14, 'Schreibtisch', 399.00),
(15, 'Regal', 79.00);

-- Bestellungen
INSERT INTO bestellungen (bestellung_id, kunden_id, datum, rabatt_prozent, gesamtbetrag, bemerkung, bezahlt) VALUES
(1, 1, '2023-01-12', 5.00, 102.50, 'Online', TRUE),
(2, 2, '2023-02-05', NULL, 45.90, 'Filiale', FALSE),
(3, 3, '2023-02-20', 10.00, 899.00, 'Telefonisch', TRUE),
(4, 4, '2023-03-01', NULL, 199.00, 'Online', TRUE),
(5, 5, '2023-03-15', 5.00, 29.90, 'Filiale', FALSE),
(6, 6, '2023-03-22', NULL, 399.00, 'Online', TRUE),
(7, 7, '2023-04-02', 10.00, 159.00, 'Filiale', TRUE),
(8, 8, '2023-04-12', NULL, 12.50, 'Online', FALSE),
(9, 9, '2024-05-03', NULL, 219.00, 'Telefonisch', TRUE),
(10, 10, '2024-05-20', 5.00, 45.00, 'Filiale', FALSE),
(11, 1, '2024-06-01', NULL, 5.90, 'Online', TRUE),
(12, 2, '2024-06-12', NULL, 899.00, 'Telefonisch', TRUE),
(13, 3, '2024-07-01', 10.00, 199.00, 'Filiale', FALSE),
(14, 4, '2025-07-15', NULL, 29.90, 'Online', TRUE),
(15, 5, '2025-08-01', 5.00, 79.00, 'Filiale', TRUE),
(16, 6, '2025-08-12', NULL, 19.90, 'Online', FALSE),
(17, 7, '2025-08-25', 10.00, 399.00, 'Telefonisch', TRUE),
(18, 8, '2025-09-01', NULL, 159.00, 'Online', TRUE),
(19, 9, '2025-09-05', 5.00, 12.50, 'Filiale', FALSE),
(20, 10, '2025-09-08', NULL, 3.50, 'Online', TRUE);

-- Bestellpositionen (Beispielhaft, ca. 50 Positionen)
INSERT INTO bestellpositionen (bestellung_id, produkt_id, menge) VALUES
(1, 1, 5), (1, 2, 3),
(2, 3, 2), (2, 4, 1),
(3, 9, 1),
(4, 10, 1),
(5, 11, 1),
(6, 14, 1),
(7, 13, 1),
(8, 8, 1),
(9, 10, 1), (9, 12, 1),
(10, 5, 2), (10, 6, 1),
(11, 7, 1),
(12, 9, 1),
(13, 10, 1),
(14, 11, 1), (14, 12, 1),
(15, 15, 1),
(16, 12, 2),
(17, 14, 1),
(18, 13, 1),
(19, 8, 1),
(20, 3, 1), (20, 1, 2);
