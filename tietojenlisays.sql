INSERT INTO Mainostaja VALUES('FI12245678', 'Mattoaitta Oy'); 
INSERT INTO Mainostaja VALUES('FI12325678', 'Takkatukku Oy'); 
INSERT INTO Mainostaja VALUES('FI12342678', 'Nauhatehdas Oy'); 

INSERT INTO Yhteyshenkilo VALUES('Maija Mainostaja', 'FI12245678', 'maija.mainostaja@mattoaitta.fi','+358400123456'); 
INSERT INTO Yhteyshenkilo VALUES('Mikko Mallikas', 'FI12325678', 'mikko.mallikas@takkatukku.fi', '+358401234567'); 
INSERT INTO Yhteyshenkilo VALUES('Vili Virtanen', 'FI12342678', 'vili.virtanen@nauhatehdas.fi', '+358501234567'); 

INSERT INTO Toimipaikka VALUES('33200', 'Tampere', 'Suomi');
INSERT INTO Toimipaikka VALUES('10020', 'Helsinki', 'Suomi');
INSERT INTO Toimipaikka VALUES('30190', 'PaikkaX', 'Suomi');

INSERT INTO Laskutusosoite VALUES(DEFAULT, 'FI12245678', 'Matonkutojankuja 12', '33200', 'Suomi'); 
INSERT INTO Laskutusosoite VALUES(DEFAULT, 'FI12325678', 'Takkatulenkatu 44', '10020', 'Suomi'); 
INSERT INTO Laskutusosoite VALUES(DEFAULT, 'FI12342678', 'Nauhatie 32', '30190', 'Suomi'); 

INSERT INTO Profiili VALUES(DEFAULT, 18, 70, 'M'); 
INSERT INTO Profiili VALUES(DEFAULT, 20, 70, 'N'); 

INSERT INTO Kayttaja VALUES('minnamyynti', 'salattu', '123456789');
INSERT INTO Kayttaja VALUES('sirkkasihteeri', 'salattu', '987654321');

INSERT INTO Mainosmyyja VALUES(DEFAULT, 'Minna Myynti', 'minnamyynti'); 

INSERT INTO Mainoskampanja VALUES(DEFAULT, 1, 1, 'FI12245678', 'Mattoaitan mega-ale', '2020-10-10', '2020-11-10', 5000.00, 5000.00, 0.20, DEFAULT); 
INSERT INTO Mainoskampanja VALUES(DEFAULT, 2, 1, 'FI12325678', 'Takkatukun hintarovio', '2020-03-10', '2020-04-20', 3000.00, 3000.00, 0.10, DEFAULT); 

INSERT INTO Mainos VALUES(DEFAULT, 1, 1, 'Aito matto', 10, 'Aidot matot –50%'); 
INSERT INTO Mainos VALUES(DEFAULT, 1, 1, 'Karvamatto', 8, 'Karvamatto ota 3 maksa 2'); 
INSERT INTO Mainos VALUES(DEFAULT, 1, 1, 'Villamatto', 8, 'Villamatot kaksi yhden hinnalla'); 
INSERT INTO Mainos VALUES(DEFAULT, 2, 2, 'Halkokori', 8, 'Takan ostajalle halkokori kaupan päälle'); 
INSERT INTO Mainos VALUES(DEFAULT, 2, 2, 'Takkaväline', 7, 'Takan ostajalle takkavälineet puoleen hintaan'); 
INSERT INTO Mainos VALUES(DEFAULT, 2, 2, 'Polttopuut', 7, 'Valmiiksi pilkotut polttopuut –20%'); 

INSERT INTO Taloussihteeri VALUES(DEFAULT, 'sirkkasihteeri', 'FI1234567890123412'); 

INSERT INTO Lasku VALUES(DEFAULT, 1, 1, 'avoinna', '2020-06-10', '1234', 5000.00, DEFAULT); 
INSERT INTO Lasku VALUES(DEFAULT, 2, 1, 'avoinna', '2020-01-20', '1235', 3000.00, DEFAULT); 

INSERT INTO Karhulasku VALUES(DEFAULT, 2, '2020-02-20', '1236', 20.50, DEFAULT); 

-- uutta settiä

INSERT INTO Maa VALUES('suomi');
INSERT INTO Maa VALUES('ruotsi');
INSERT INTO Maa VALUES('norja');

INSERT INTO Paikkakunta VALUES('pirkanmaa');
INSERT INTO Paikkakunta VALUES('pkseutu');
INSERT INTO Paikkakunta VALUES('tukholma');
INSERT INTO Paikkakunta VALUES('oslo');

INSERT INTO Alue VALUES(DEFAULT, 'pirkanmaa', 'suomi');

INSERT INTO genre VALUES('rap');
INSERT INTO genre VALUES('rock');
INSERT INTO genre VALUES('pop');
INSERT INTO genre VALUES('blues');

INSERT INTO Musiikintekija VALUES(DEFAULT, 'bandi1');
INSERT INTO Musiikintekija VALUES(DEFAULT, 'bandi2');
INSERT INTO Musiikintekija VALUES(DEFAULT, 'bandi3');

INSERT INTO Teos VALUES('raita1', 1800);
INSERT INTO Teos VALUES('raita2', 1700);
INSERT INTO Teos VALUES('raita3', 1000);

INSERT INTO Kappale VALUES(DEFAULT, 'raita1', 102);
INSERT INTO Kappale VALUES(DEFAULT, 'raita2', 106);
INSERT INTO Kappale VALUES(DEFAULT, 'raita3', 107);

INSERT INTO Lahetysaika VALUES(DEFAULT, '1000', '1200');
INSERT INTO Lahetysaika VALUES(DEFAULT, '1200', '1400');
INSERT INTO Lahetysaika VALUES(DEFAULT, '1400', '1600');
INSERT INTO Lahetysaika VALUES(DEFAULT, '1600', '1800');
INSERT INTO Lahetysaika VALUES(DEFAULT, '1800', '2000');

INSERT INTO Kuuntelija VALUES('oliivi', 1, 'oliivi@aija.fi', 'salassa', '-', 25);

INSERT INTO Esitys VALUES(DEFAULT, 'oliivi', 1, 1, '2020-01-01', 20);
INSERT INTO Esitys VALUES(DEFAULT, 'oliivi', NULL, 2, '2001-01-01', 21);
INSERT INTO Esitys VALUES(DEFAULT, 'oliivi', NULL, 3, '2002-01-01', 22);
INSERT INTO Esitys VALUES(DEFAULT, 'oliivi', NULL, 4, '2003-01-01', 21);
INSERT INTO Esitys VALUES(DEFAULT, 'oliivi', NULL, 5, '2004-01-01', 21);
INSERT INTO Esitys VALUES(DEFAULT, 'oliivi', NULL, 6, '1999-01-01', 19);
 
INSERT INTO profiilikappale VALUES(1, 1);
INSERT INTO profiilikappale VALUES(2, 2); --profid, puid
INSERT INTO profiilikappale VALUES(1, 3);

INSERT INTO profiilimusiikintekija VALUES(1, 1); --profid, mustekid
INSERT INTO profiilimusiikintekija VALUES(1, 2);
INSERT INTO profiilimusiikintekija VALUES(2, 3);

INSERT INTO genreteos VALUES('rap', 'raita1');-- genrenimi, nimi(teos)
INSERT INTO genreteos VALUES('rock', 'raita2');
INSERT INTO genreteos VALUES('pop', 'raita3');
--genreteos