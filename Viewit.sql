
--Laskutus-näkymä (sihteerin sisäänkirjautuessa)
CREATE VIEW laskutus
AS SELECT Lasku.laskuid, Mainostaja.nimi 
FROM Lasku, Mainoskampanja, Mainostaja 
    WHERE Lasku.mainoskampanjaID = Mainoskampanja.kampanjaid AND 
    Mainostaja.vat_tunnus = Mainoskampanja.vat_tunnus; 

--Kuukausiraportti (näkymillä saadaan kuukausittaista dataa tulostettua raporttiin satistiikoista)
CREATE VIEW kuukausiraportti  
AS SELECT  
    Mainostaja.nimi AS mainostajan_nimi, 
    Mainoskampanja.kampanjanimi AS mainoskampanjan_nimi, 
    Mainos.mnimi AS mainoksen_nimi, COUNT(esitys) AS toistokerrat, 
    COUNT(esitys)*mainos.toistoaika AS toistoaika_yhteenlaskettuna, 
    mainos.toistoaika AS mainoksen_pituus, 
    mainoskampanja.sekuntihinta AS sekuntihinta, 
    COUNT(esitys)*mainos.toistoaika*mainoskampanja.sekuntihinta AS kokonaishinta, 
    esitys.esityspaiva AS esityspaiva, 
    laskutusosoite.katuosoite, 
    laskutusosoite.pnro 
FROM mainoskampanja, mainos, esitys, mainostaja, laskutusosoite, 
    lahetysaika, yhteyshenkilo 
WHERE 
    esitys.mainosid = mainos.mainosid AND 
    mainos.mainoskampanjaid = mainoskampanja.kampanjaid AND 
    mainostaja.vat_tunnus = mainoskampanja.vat_tunnus AND 
    mainoskampanja.vat_tunnus=yhteyshenkilo.vat_tunnus 
GROUP BY 
    mainostaja.nimi, mainoskampanja.kampanjanimi, mainos.mnimi, mainos.toistoaika, 
    mainoskampanja.sekuntihinta, esitys.esityspaiva,  
    laskutusosoite.katuosoite, laskutusosoite.pnro, 
    lahetysaika.alkuklo, lahetysaika.loppuklo, yhteyshenkilo.sposti 
; 

--Mainoseistysraportti (näkymä, jolla statistiikkaa mainoksen esityksistä)
CREATE VIEW mainosesitysraportti 
AS SELECT 
    mainos.mnimi, mainostaja.nimi AS mainostajanimi,kampanjanimi,mainos.mainosid, esitysid,  
    profiilikappale.profiiliid, alue.paikkakunta, alue.maa,  
    Esitys.esityspaiva, kuuntelija.spuoli, 
    Kuuntelija.ika, genreteos.genrennimi, kappale.nimi AS knimi, musiikintekija.nimi, yhteyshenkilo.sposti 
FROM esitys, alue, profiilikappale, mainos, mainoskampanja, kappale, 
    profiilimusiikintekija, mainostaja, yhteyshenkilo, kuuntelija, genreteos,
    musiikintekija
WHERE 
    profiilikappale.puid = esitys.puid AND 
    mainos.mainoskampanjaid=mainoskampanja.kampanjaid AND 
    mainoskampanja.vat_tunnus=mainostaja.vat_tunnus AND 
    profiilikappale.puid = kappale.puid AND 
    profiilikappale.profiiliid = profiilimusiikintekija.profiiliid AND 
    profiilimusiikintekija.mustekid = musiikintekija.mustekid AND 
    mainostaja.vat_tunnus=yhteyshenkilo.vat_tunnus
; 

--Luodaan rooli taloussihteerille
CREATE ROLE Taloussihteeri;

--Käyttäjäesimerkki
CREATE USER tsihteeri1 WITH PASSWORD 'tsihteeri' IN GROUP Taloussihteeri; 

--Myönnetään oikeudet
GRANT INSERT, SELECT, UPDATE, DELETE ON Lasku TO Taloussihteeri; 
GRANT INSERT, SELECT, UPDATE, DELETE ON Karhulasku TO Taloussihteeri; 
GRANT SELECT ON kuukausiraportti TO Taloussihteeri; 
GRANT SELECT ON mainosesitysraportti TO Taloussihteeri; 
GRANT SELECT ON laskutus TO Taloussihteeri; 