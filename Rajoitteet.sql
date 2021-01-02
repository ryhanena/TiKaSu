ALTER TABLE Yhteyshenkilo
ADD CONSTRAINT sposti
CHECK (sposti LIKE '_%@_%._%');

ALTER TABLE Kuuntelija
ADD CONSTRAINT sposti
CHECK (sposti LIKE '_%@_%._%');

ALTER TABLE Kuuntelija 
ADD CONSTRAINT spuoli
CHECK (spuoli IN ('M', 'N', 'W', '-'));

ALTER TABLE Kuuntelija
ADD CONSTRAINT ika
CHECK (ika > 0);

ALTER TABLE Kappale
ADD CONSTRAINT kesto
CHECK (kesto > 0);

ALTER TABLE Esitys
ADD CONSTRAINT esityskesto
CHECK (esityskesto > 0);

ALTER TABLE Profiili
ADD CONSTRAINT alaikaraja
CHECK (alaikaraja > 0 OR alaikaraja IS NULL);

ALTER TABLE Profiili
ADD CONSTRAINT ylaikaraja
CHECK ((ylaikaraja >= alaikaraja AND ylaikaraja > 0) OR ylaikaraja IS NULL);

ALTER TABLE Profiili
ADD CONSTRAINT spuoli
CHECK (spuoli IN ('M', 'N', 'W', '-'));

ALTER TABLE Mainoskampanja
ADD CONSTRAINT rahaajaljella
CHECK (rahaajaljella <= maararahat);

ALTER TABLE Mainoskampanja
ADD CONSTRAINT sekuntihinta
CHECK (sekuntihinta >= 0);

ALTER TABLE Lasku
ADD CONSTRAINT pos_summa
CHECK (summa >= 0);

ALTER TABLE Karhulasku
ADD CONSTRAINT pos_summa
CHECK (lisasumma >= 0);

-- Tarkistaa onko rahaa jäljellä
CREATE FUNCTION tarkistaRahat()
    RETURNS TRIGGER AS 
    $$ 
    BEGIN
        IF (NOT OLD.rahaajaljella = 0) AND NEW.rahaajaljella <= 0
        THEN
        NEW.tila := FALSE;
        NEW.rahaajaljella := 0;
        END IF;
    RETURN NEW;
    END
$$ LANGUAGE plpgsql;

-- Mainostakampanjaa päivitettäessä tarkastetaan rahat
CREATE TRIGGER mainosesitys 
    BEFORE UPDATE 
    ON mainoskampanja
    FOR EACH ROW   
    EXECUTE PROCEDURE tarkistaRahat();

CREATE FUNCTION mainostajaPoisto()
    RETURNS TRIGGER 
    AS $del$ 
    BEGIN
        IF (EXISTS(
            SELECT * FROM Mainoskampanja WHERE (vat_tunnus = OLD.vat_tunnus
                AND Mainoskampanja.tila = FALSE)
        ))
    THEN
        RAISE NOTICE 'Poistetaan triggerilla mainostaja %', OLD.name;
        DELETE FROM mainostaja WHERE vat_tunnus = OLD.vat_tunnus;
        END IF;
        RETURN NULL;
    END
    $del$ LANGUAGE plpgsql;

CREATE TRIGGER mainostajanPoisto
AFTER DELETE ON mainostaja
FOR EACH ROW EXECUTE PROCEDURE mainostajaPoisto();