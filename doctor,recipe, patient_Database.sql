-- 1. napraviti Bazu za projekat Bolnica Pancevo, nakon toga svaku tabelu napuniti sa dva primera, 
-- nakon toga prikazati najmanje 10 upita ukljucujuci upite nad jednom tabelom, ali i vise, prikazati 
-- upite sa MAX, MIN, AVG, SUM, COUNT, LIKE,  ORDER BY, GROUP BY, JOIN, BETWEEN, ZAGRADE, AND, OR, 
-- UPITE NA VISE TABELA, VISE KOMBNACIJA..

CREATE DATABASE IF NOT EXISTS Bolnica_Pancevo;

SELECT database();

SHOW databases;
USE Bolnica_Pancevo;

DROP TABLE IF EXISTS Lekar;
CREATE TABLE Lekar (
    IDlekara INT NOT NULL PRIMARY KEY,
    NazivLekara VARCHAR(255)
); 

DROP TABLE IF EXISTS Pacijent;
CREATE TABLE Pacijent (
    IDpacijenta INT NOT NULL PRIMARY KEY,
    NazivPacijenta VARCHAR(255),
    IDlekara INT,
    FOREIGN KEY (IDlekara)
        REFERENCES Lekar (IDlekara)
); 


DROP TABLE IF EXISTS Recept;

CREATE TABLE Recept (
    IDrecepta INT NOT NULL PRIMARY KEY,
    DatumRecepta DATE,
    IDpacijenta INT,
    FOREIGN KEY (IDpacijenta)
        REFERENCES Pacijent (IDpacijenta)
); 

DROP TABLE IF EXISTS Lekovi;
CREATE TABLE Lekovi (
    IDleka INT NOT NULL PRIMARY KEY,
    NazivLeka VARCHAR(255),
    VrstaLeka VARCHAR(255),
    Cena DECIMAL
); 

DROP TABLE IF EXISTS StavkaRecepta;
CREATE TABLE StavkaRecepta (
    IDstavke INT NOT NULL PRIMARY KEY,
    IDleka INT,
    IDrecepta INT,
    -- NazivLeka VARCHAR(255),
    FOREIGN KEY (IDleka)
        REFERENCES Lekovi (IDleka),
    FOREIGN KEY (IDrecepta)
        REFERENCES Recept (IDrecepta)
    -- FOREIGN KEY (NazivLeka)
        -- REFERENCES Lekovi (NazivLeka)
);     

SHOW tables;

INSERT INTO Lekar (IDlekara, NazivLekara) 
VALUES (10, 'Ivan Ivanovic'),
	(11, 'Uros Urosevic'),
    (12, 'Milos Milosevic');
    
     SELECT * FROM Lekar;
    
INSERT INTO Pacijent (IDpacijenta, NazivPacijenta, IDLekara)
VALUES (1, 'Marko Markovic', 10),
	(2, 'Janko Jankovc',10),
    (3, 'Branko Brankovic',11);
    
    SELECT * FROM Pacijent;
    
INSERT INTO Recept (IDrecepta, DatumRecepta, IDpacijenta) 
VALUES (101, '2020-02-01', 3),
	(102, '2021-03-01', 2),
    (103, '2022-04-01', 1),
    (104, '2022-07-01', 1),
	(105, '2023-01-01', 3),
    (106, '2023-07-01', 2);
SELECT * FROM recept;
     
INSERT INTO Lekovi (IDleka, NazivLeka, VrstaLeka, Cena)
VALUES (10001, 'lek1', 'antibiotik', 800),
	(10002, 'lek2', 'antihistaminik', 600),
    (10003, 'lek3', 'anelgetik', 700);

 SELECT * FROM Lekovi;
 
INSERT INTO StavkaRecepta (IDstavke, IDleka, IDrecepta)
VALUES (1001, 10001, 102),
	(1002, 10002, 101),
    (1003, 10002, 103),
    (1004, 10003, 102),
    (1005, 10003, 105),
    (1006, 10001, 101);     

    
-- ALTER TABLE Stavka_Recepta 
-- ADD COLUMN NazivLeka varchar(255);

/*select * from Stavka_Recepta;
UPDATE Stavka_Recepta 
SET 
    NazivLeka = 'lek1'
WHERE
    IDleka = 10001; 
    
UPDATE Stavka_Recepta 
SET 
    NazivLeka = 'lek2'
WHERE
    IDleka = 10002; */

-- NEISPRAVAN NACIN   ->  INSERT INTO Stavka_Recepta(NazivLeka) VALUES ('lek1','lek2','lek3');
-- ISPRAVAN NACIN  -> INSERT INTO Stavka_Recepta(NazivLeka) VALUES ('lek1'), ('lek2'), ('lek2');
    
 SELECT 
    *
FROM
    StavkaRecepta;   

/*PRIMERI SA ZADACIMA*/

-- 1.primer : 
-- izbaci sve recepte, sa datumom i nazivom pacijenta, koji sadrze lekove skuplje od 699 i jeftinije od 800 rsd 

SELECT 
    StavkaRecepta.IDrecepta, recept.DatumRecepta, recept.idpacijenta, pacijent.nazivpacijenta
FROM
    Lekovi
        JOIN
    StavkaRecepta ON Lekovi.IDleka = StavkaRecepta.IDleka
        JOIN
    Recept ON StavkaRecepta.IDrecepta = recept.IDrecepta
		JOIN
	Pacijent ON Pacijent.IDpacijenta = recept.IDpacijenta
WHERE
    Lekovi.Cena > 699 AND Lekovi.Cena < 800; 

-- 2.primer sa inner/nested query:  
-- izbaci sve pacijente gde im je lekar Ivan Ivanovic 

SELECT NazivPacijenta  FROM Pacijent
WHERE IDlekara IN
	(SELECT IDlekara FROM Lekar
	WHERE Lekar.NazivLekara = 'Ivan Ivanovic') ;

-- 3.primer sa inner/nested query
-- izabi sve pacijente gde im je lekar Uros Urosevic  

SELECT NazivPacijenta  FROM Pacijent
WHERE IDlekara IN
	(SELECT IDlekara FROM Lekar
	WHERE Lekar.NazivLekara = 'Uros Urosevic') ;

-- 3.Primer sa JOIN umesto nested query
-- izaciti nazive pacijenata za odredjenog lekara (Janko Jankvic)

SELECT 
    IDpacijenta, NazivPacijenta
FROM
    Pacijent
        JOIN
    Lekar ON Pacijent.IDlekara = Lekar.IDlekara
WHERE
    Lekar.NazivLekara = 'Ivan Ivanovic';
    
-- 4.Primer sa JOIN 
-- izbaci nazive lekova na odredjenom receptu 

SELECT 
    Lekovi.IDleka, NazivLeka
FROM
    Lekovi
        JOIN
    StavkaRecepta ON Lekovi.IDleka = StavkaRecepta.IDleka
        JOIN
    Recept ON Recept.IDrecepta = StavkaRecepta.IDrecepta
WHERE
    Recept.IDrecepta = 101;

-- 5. Primer sa JOIN
-- izbaci sve recepte koji imaju vise od 2 stavke   

SELECT 
    Recept.DatumRecepta,
    Recept.IDRecepta,
    COUNT(StavkaRecepta.IDstavke) AS broj_stavki_po_receptu
    #NazivLeka
FROM
    StavkaRecepta
        JOIN
    Recept ON StavkaRecepta.IDRecepta = Recept.IDRecepta
GROUP BY StavkaRecepta.IDrecepta
HAVING COUNT(StavkaRecepta.IDrecepta) >=2;

SELECT COUNT(IDRecepta) FROM StavkaRecepta;
SELECT COUNT(DISTINCT IDRecepta) FROM StavkaRecepta;

-- 6 . primer sa Group By
-- izbaci broj razlicitih recepata po pacijentu 

SELECT 
    IDPacijenta, 
    COUNT(IDRecepta) AS broj_recepata_po_pacijentu
FROM
    Recept
GROUP BY IDPacijenta;

-- 7. Primer sa JOIN
-- izbaci tabelu sa razlicitim lekovima koji idu na isti recept 
-- ovde probamo sa selfjoin da resimo 

SELECT
    t1.IDRecepta,
    t1.IDleka AS ID_prvog_leka,
    t2.IDleka AS ID_drugog_leka
FROM
    StavkaRecepta AS t1
        JOIN
    StavkaRecepta AS t2 ON t1.IDStavke <> t2.IDStavke
        AND t1.IDRecepta = t2.IDRecepta;

-- 8. Primer sa JOIN
-- izbaci naziv pacijenta za specifican lek koji mu je dodeljen, u ovom slucaju za lek1 i sortirati po nazivu pacijenta u rastucem red.

SELECT 
    p.NazivPacijenta,
    l.NazivLekara,
    count(r.IDrecepta) AS broj_recepata,
    r.DatumRecepta,
    Lekovi.NazivLeka
FROM
    Pacijent p
        JOIN
    Lekar l ON p.IDlekara = l.IDlekara
        JOIN
    Recept r ON p.IDpacijenta = r.IDpacijenta
        JOIN
    StavkaRecepta sr ON r.IDrecepta = sr.IDrecepta
		JOIN 
	Lekovi ON sr.IDleka = Lekovi.IDleka
WHERE
    Lekovi.NazivLeka = 'lek1'
ORDER BY 1 ASC;

-- 9 . primer sa Group By
-- izbaci broj pripadajucih pacijenata po lekarima  

SELECT 
	l.nazivlekara,
    COUNT(idpacijenta) AS broj_pacijenata
FROM
    pacijent p
        JOIN
    lekar l ON p.idlekara = l.idlekara
GROUP BY l.NazivLekara;

-- 10. primer
-- izbaci broj izdatih recepata po lekarima i sortirati u opadajucem red. po broju izdatih recepata

SELECT 
    COUNT(r.idrecepta) AS broj_izdatih_recepata,
    l.NazivLekara
FROM
    recept r
        JOIN
    pacijent p ON r.idpacijenta = p.IDpacijenta
        JOIN
    lekar l ON p.IDlekara = l.IDlekara
GROUP BY l.NazivLekara
ORDER BY 1 DESC;
