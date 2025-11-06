
-- view mit Bestellungen (join bestellungen - kunden)
CREATE OR REPLACE VIEW Bestellungsview
    AS
     SELECT 
		bestellungen.bestellung_id,
		kunden.name,
		bestellungen.datum,
		bestellungen.rabatt_prozent,
		bestellungen.gesamtbetrag
   FROM bestellungen
     JOIN kunden ON kunden.kunden_id = bestellungen.kunden_id
  ORDER BY bestellungen.datum desc;
  