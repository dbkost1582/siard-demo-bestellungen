
-- Kunden
CREATE TABLE kunden (
    kunden_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    notizen TEXT
);

COMMENT ON TABLE kunden IS 'Enthält essentielle Kundendaten aus dem CRM-System';
COMMENT ON COLUMN kunden.name IS 'Vollständiger Name des Kunden';
COMMENT on COLUMN kunden.notizen IS 'Kundenspezifische Notizen aus dem CRM-System initialisiert jedoch hier überschriebbar';


-- Produkte
CREATE TABLE produkte (
    produkt_id SERIAL PRIMARY KEY,
    bezeichnung VARCHAR(100) NOT NULL,
    preis DECIMAL(10,2) NOT NULL
);
COMMENT ON TABLE produkte IS 'Enthält ein Subset der Artikel aus dem Warenwirtschaftssystem';

-- Bestellungen
CREATE TABLE bestellungen (
    bestellung_id SERIAL PRIMARY KEY,
    kunden_id INT NOT NULL,
    datum DATE NOT NULL,
    rabatt_prozent DECIMAL(5,2),
    gesamtbetrag DECIMAL(12,2) NOT NULL,
    bemerkung VARCHAR(255),
    bezahlt BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (kunden_id) REFERENCES kunden(kunden_id)
);
COMMENT ON TABLE bestellungen IS 'Enthält die Köpfe der Bestellungen, wird täglich ins CRM Synchronisiert';

-- Bestellpositionen
CREATE TABLE bestellpositionen (
    bestellung_id INT NOT NULL,
    produkt_id INT NOT NULL,
    menge INT NOT NULL,
    PRIMARY KEY (bestellung_id, produkt_id),
    FOREIGN KEY (bestellung_id) REFERENCES bestellungen(bestellung_id),
    FOREIGN KEY (produkt_id) REFERENCES produkte(produkt_id)
);
COMMENT ON TABLE bestellpositionen IS 'Enthält die Artikel zu einer Bestllung';
