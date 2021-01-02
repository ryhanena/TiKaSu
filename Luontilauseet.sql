-- Joidenkin taulujen oleelliseen yksilöimiseen käytetty SERIAL-tietotyyppiä

CREATE TABLE Toimipaikka (
    pnro VARCHAR (20) NOT NULL,
    ptoimipaikka VARCHAR (40) NOT NULL,
    maa VARCHAR (20) NOT NULL,
    PRIMARY KEY (pnro, maa)
);

CREATE TABLE Mainostaja (
    vat_tunnus VARCHAR (11) NOT NULL,
    nimi VARCHAR (30) NOT NULL,
    PRIMARY KEY (vat_tunnus)
);

CREATE TABLE Laskutusosoite (
    laskutus_id SERIAL PRIMARY KEY,
    vat_tunnus VARCHAR (11) REFERENCES Mainostaja(vat_tunnus)
                ON UPDATE CASCADE
                ON DELETE CASCADE,
    katuosoite VARCHAR (40) NOT NULL,
    pnro VARCHAR (20) NOT NULL,
    maa VARCHAR (20) NOT NULL, 
    FOREIGN KEY (pnro, maa) REFERENCES Toimipaikka (pnro, maa)
);

CREATE TABLE Yhteyshenkilo (
    ynimi VARCHAR(40) NOT NULL PRIMARY KEY,
    vat_tunnus VARCHAR (11) REFERENCES Mainostaja(vat_tunnus)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
    sposti VARCHAR(60),
    puhnumero VARCHAR (20)
);

CREATE TABLE Kayttaja (
    knimi VARCHAR (40) NOT NULL,
    salasana VARCHAR (50),
    pnro VARCHAR (10),
    PRIMARY KEY (knimi)
);

CREATE TABLE Taloussihteeri (
    sihteeriID SERIAL PRIMARY KEY,
    knimi VARCHAR (40) NOT NULL REFERENCES Kayttaja(knimi)
                ON UPDATE CASCADE
                ON DELETE NO ACTION,
    tilinro VARCHAR (40)
);

CREATE TABLE Mainosmyyja (
    myyjaID SERIAL NOT NULL PRIMARY KEY,
    mnimi VARCHAR (40) NOT NULL,
    knimi VARCHAR (40) NOT NULL REFERENCES Kayttaja(knimi)
                ON UPDATE CASCADE
                ON DELETE NO ACTION
);

CREATE TABLE Maa (
    maa VARCHAR(20) NOT NULL PRIMARY KEY
);

CREATE TABLE Paikkakunta (
    paikkakunta VARCHAR(40) NOT NULL PRIMARY KEY
);

CREATE TABLE Alue (
    alueID SERIAL PRIMARY KEY,
    paikkakunta VARCHAR(40) REFERENCES Paikkakunta(paikkakunta)
                ON UPDATE CASCADE
                ON DELETE SET NULL,
    maa VARCHAR(20) REFERENCES Maa(maa)
                ON UPDATE CASCADE
                ON DELETE SET NULL
);

CREATE TABLE Genre (
    gnimi VARCHAR(40) NOT NULL,
    PRIMARY KEY (gnimi)
);

CREATE TABLE Lahetysaika (
    laikaid SERIAL,
    alkuklo TIME NOT NULL,
    loppuklo TIME NOT NULL,
    PRIMARY KEY (laikaid)
);

CREATE TABLE Musiikintekija (
	mustekid SERIAL,
	nimi VARCHAR(40) NOT NULL,
	PRIMARY KEY (mustekid)
);

CREATE TABLE Rooli (
	roolinimi VARCHAR(20) NOT NULL,
	PRIMARY KEY (roolinimi)
);

CREATE TABLE Teos (
	nimi VARCHAR(40) NOT NULL,
	julkaisuvuosi INTEGER NOT NULL,
	PRIMARY KEY (nimi)
);

CREATE TABLE Teosroolimusiikintekija (
	nimi VARCHAR(40) NOT NULL REFERENCES Teos(nimi)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	roolinimi VARCHAR(20) NOT NULL REFERENCES Rooli(roolinimi)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	mustekid INT NOT NULL REFERENCES Musiikintekija(mustekid)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	PRIMARY KEY(nimi, roolinimi, mustekid)
);

CREATE TABLE Genreteos (
	genrennimi VARCHAR(30) NOT NULL REFERENCES Genre(gnimi)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	nimi VARCHAR(30) NOT NULL REFERENCES Teos(nimi)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	PRIMARY KEY (genrennimi, nimi)
);

CREATE TABLE Kuuntelija (
	nimimerkki VARCHAR(30) NOT NULL,
	alueid INT NOT NULL REFERENCES Alue(alueid)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	sposti VARCHAR(40) NOT NULL,
	salasana VARCHAR(50) NOT NULL,
	spuoli CHAR(1) NOT NULL,
	ika INT NOT NULL,
	PRIMARY KEY (nimimerkki)
);

CREATE TABLE Soittolista (
	nimi VARCHAR(30) NOT NULL,
	nimimerkki VARCHAR(30) NOT NULL REFERENCES Kuuntelija(nimimerkki)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	PRIMARY KEY (nimi)
);

CREATE TABLE Teossoittolista (
	tnimi VARCHAR(30) NOT NULL REFERENCES Teos(nimi)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	snimi VARCHAR(30) NOT NULL REFERENCES Soittolista(nimi)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	PRIMARY KEY (tnimi, snimi)
);

CREATE TABLE Kappale (
	puid SERIAL,
	nimi VARCHAR(40) REFERENCES Teos(nimi)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	kesto INTEGER NOT NULL,
	-- äänitiedosto SQL_VARIANT NOT NULL, (miten saa?)
	PRIMARY KEY (puid)
);

CREATE TABLE Kokoelma (
	nimi VARCHAR(40) NOT NULL,
	jvuosi INTEGER,
	PRIMARY KEY (nimi)
);

CREATE TABLE Kappalekokoelma (
	puid INT REFERENCES Kappale(puid)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	nimi VARCHAR(40) REFERENCES Kokoelma(nimi)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	PRIMARY KEY (puid, nimi)
);

CREATE TABLE Profiili (
	profiiliID SERIAL PRIMARY KEY,
	alaikaraja INTEGER,
	ylaikaraja INTEGER,
	spuoli CHAR(1)
);

CREATE TABLE Profiiligenre (
    profiiliID INTEGER NOT NULL REFERENCES Profiili(profiiliID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    gnimi VARCHAR(40) REFERENCES Genre(gnimi)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (profiiliID, gnimi)
);

CREATE TABLE Profiilikappale (
    profiiliID INTEGER NOT NULL REFERENCES Profiili(profiiliID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    puid INTEGER NOT NULL REFERENCES Kappale(puid)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (profiiliID, puid)
);

CREATE TABLE Profiilimusiikintekija (
    profiiliID INTEGER NOT NULL REFERENCES Profiili(profiiliID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    mustekid INTEGER NOT NULL REFERENCES Musiikintekija(mustekid)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    PRIMARY KEY (profiiliID, mustekid)
);

CREATE TABLE Mainoskampanja (
    kampanjaid SERIAL,
    profiiliID INTEGER NOT NULL REFERENCES Profiili(profiiliID)
            ON UPDATE CASCADE
            ON DELETE NO ACTION,
    myyjaID INTEGER NOT NULL REFERENCES Mainosmyyja(myyjaID)
            ON UPDATE CASCADE
            ON DELETE NO ACTION,
    vat_tunnus CHAR(11) NOT NULL REFERENCES Mainostaja(vat_tunnus)
            ON UPDATE CASCADE
            ON DELETE NO ACTION,
    kampanjanimi VARCHAR (40),
    alkupvm DATE NOT NULL,
    loppupvm DATE NOT NULL,
    maararahat NUMERIC (10,2) NOT NULL,
    rahaajaljella NUMERIC (10,2) NOT NULL,
    sekuntihinta NUMERIC (4,2) NOT NULL,
    tila BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (kampanjaid)
);

CREATE TABLE Mainos (
    mainosID SERIAL PRIMARY KEY,
    profiiliID INTEGER NOT NULL REFERENCES Profiili(profiiliID)
                ON UPDATE CASCADE
                ON DELETE NO ACTION,
    mainoskampanjaID INTEGER NOT NULL REFERENCES 
                Mainoskampanja(kampanjaid)
                ON UPDATE CASCADE
                ON DELETE NO ACTION,
    mnimi VARCHAR(40),
    toistoaika INTEGER,
    kuvaus VARCHAR (100)
    -- jingle
);

CREATE TABLE Esitys (
	esitysid SERIAL,
	nimimerkki VARCHAR(30) REFERENCES Kuuntelija(nimimerkki)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	puid INTEGER REFERENCES Kappale(puid),
    mainosID INTEGER NOT NULL REFERENCES Mainos(mainosID), --lisatty, virhe viewissa
	esityspaiva DATE NOT NULL,
	esityskesto INTEGER NOT NULL,
	PRIMARY KEY (esitysid)
);
 
CREATE TABLE Lasku (
    laskuid SERIAL PRIMARY KEY,
    mainoskampanjaID INTEGER NOT NULL REFERENCES Mainoskampanja(kampanjaid)
            ON UPDATE CASCADE
            ON DELETE NO ACTION,
    sihteeriID INTEGER NOT NULL REFERENCES Taloussihteeri(sihteeriID)
            ON UPDATE CASCADE
            ON DELETE NO ACTION,
    tila VARCHAR (20),
    erapvm DATE NOT NULL,
    viitenro VARCHAR(30),
    summa NUMERIC(10,2) NOT NULL,
    maksettu BOOLEAN DEFAULT FALSE
);

CREATE TABLE Karhulasku (
    karhulaskuid SERIAL PRIMARY KEY,
    laskuid INTEGER NOT NULL REFERENCES Lasku(laskuid)
            ON UPDATE CASCADE
            ON DELETE NO ACTION,
    erapvm DATE NOT NULL,
    viitenro VARCHAR(30),
    lisaSumma NUMERIC(10,2) NOT NULL,
    maksettu BOOLEAN DEFAULT FALSE
);