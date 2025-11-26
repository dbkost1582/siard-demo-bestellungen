
-- Kunden
CREATE TABLE kunden (
    kunden_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Prmiärschlüssel',
    name VARCHAR(100) NOT NULL COMMENT 'Vollständiger Name des Kunden',
    notizen LONGTEXT COMMENT 'Kundenspezifische Notizen aus dme CRM-System initialisiert jedoch hier überschriebbar'
) COMMENT = 'Enthält essentielle Kundendaten aus dem CRM-System';


-- Produkte
CREATE TABLE produkte (
    produkt_id INT AUTO_INCREMENT PRIMARY KEY,
    bezeichnung VARCHAR(100) NOT NULL,
    preis DECIMAL(10,2) NOT NULL
) COMMENT = 'Enthält ein Subset der Artikel aus dem Warenwirtschaftssystem';

CREATE UNIQUE INDEX product_preis_ukey ON produkte ((UPPER(bezeichnung)), preis);

-- Bestellungen
CREATE TABLE bestellungen (
    bestellung_id INT AUTO_INCREMENT PRIMARY KEY,
    kunden_id INT NOT NULL,
    datum DATE NOT NULL,
    rabatt_prozent DECIMAL(5,2),
    gesamtbetrag DECIMAL(12,2) NOT NULL,
    bemerkung VARCHAR(255),
    bezahlt TINYINT(1) DEFAULT 0,
    FOREIGN KEY (kunden_id) REFERENCES kunden(kunden_id)
) COMMENT = 'Enthält die Köpfe der Bestellungen, wird täglich ins CRM synchronisiert';

-- Bestellpositionen
CREATE TABLE bestellpositionen (
    bestellung_id INT NOT NULL,
    produkt_id INT NOT NULL,
    menge INT NOT NULL,
    PRIMARY KEY (bestellung_id, produkt_id),
    FOREIGN KEY (bestellung_id) REFERENCES bestellungen(bestellung_id),
    FOREIGN KEY (produkt_id) REFERENCES produkte(produkt_id)
) COMMENT = 'Enthält die Artikel zu einer Bestllung';
