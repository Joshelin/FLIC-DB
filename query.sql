/*1*/
INSERT COMPAGNIA(CodiceCompagnia, Nome, Nazione) VALUES('C1','CompagniaC1','Italia') ;

/*2*/
INSERT DIPENDENTE(CodiceFiscale, Nome, Cognome, Email, Telefono, Nazionalita, DataDiNascita, Compagnia) 
VALUES('RSIMROJ60M21G','Mario','Rossi','mario.rossi@gmail.com','3458761213','italiana','1990-06-15','C1') ;

/*5*/
INSERT EQUIPAGGIO(CodiceEquipaggio, Compagnia) 
VALUES('Marullo',"C1") ;    

/*3*/
INSERT COMANDANTE(Dipendente, Equipaggio, Compagnia, Formazione) 
VALUES('RSIMROJ60M21G','Marullo',"C1","PPL") ;

/*4*/
INSERT HOSTESS_STUART(Dipendente, Equipaggio, Compagnia) 
VALUES('AAA','Marullo',"C1") ;

/*6*/
INSERT VELIVOLO(CodiceVelivolo, Compagnia, Stato, OreDiVolo, Carburante, AnnoDiCostruzione) 
VALUES('707','C1','disponibile',13,55,1995) ;

/*7*/
INSERT PASSEGGERO(CodiceFiscale, Nome, Cognome, Disabile, Email, Telefono, DataDiNascita, Nazionalita) 
VALUES('BNCALCJ60M21G','Alice',"Bianchi",0,"alice.bianchi@fastwebnet.it",'3981144523','1997-09-05','italiana') ;

/*8*/
INSERT BIGLIETTO(CodiceBiglietto, Costo, Posto, Bagagli, Check_in) 
VALUES('30C',90.0,22,0,0) ;

/*9*/
INSERT VOLO(CodiceVolo, Stato, Carburante) 
VALUES('1112','boarding',50) ;

/* Extra for other queries */
INSERT DISPOSIZIONE(Velivolo, Compagnia, Volo) VALUES('707', 'C1', '1113');
INSERT AEROPORTO(Sigla) VALUES ('BLQ');
INSERT AEROPORTO(Sigla) VALUES ('MXP');
INSERT DESTINAZIONE(Volo, Data, ORA, Aeroporto) VALUES('1112', '2019-01-09', '08:00:00', 'MXP')
INSERT PARTENZA(Volo, Data, ORA, Aeroporto) VALUES('1112', '2019-01-09', '07:00:00', 'BLQ')
INSERT ACQUISTO(Biglietto, Volo, Passeggero) VALUES('30C', '1112','BNCALCJ60M21G')
UPDATE BIGLIETTO
	SET Check_in = TRUE
	WHERE CodiceBiglietto = '30C'

/*10*/
SELECT 
    f.CodiceVolo,
    v.CodiceVelivolo,
    v.Compagnia,
    v.Stato,
    v.OreDiVolo,
    v.Carburante,
    v.AnnoDiCostruzione
FROM
    VELIVOLO v,
    DISPOSIZIONE d,
    VOLO f
WHERE
    v.CodiceVelivolo = d.Velivolo
        AND d.Volo = f.CodiceVolo
        AND v.Carburante <= f.Carburante
        AND (f.Stato = 'boarding'
        OR f.Stato = 'check-in'
        OR f.Stato = 'delayed')

/* 
DELETE FROM PASSEGGERO
	WHERE CodiceFiscale = 'CodiceFiscale'


SELECT Biglietto
FROM ACQUISTO
WHERE Passeggero = 'CodiceFiscale'

/*
SELECT BIGLIETTO
FROM ACQUISTO JOIN PASSEGGERO ON Passeggero = CodiceFiscale
WHERE Nome = 'Nome' AND Cognome = 'Cognome' AND CodiceFiscale = 'CodiceFiscale'

DELETE FROM BIGLIETTO
	WHERE CodiceBiglietto = 'CodiceBiglietto'


SELECT Stato
FROM VOLO
WHERE CodiceVolo = 'CodiceVolo'


DELETE FROM VOLO
	WHERE CodiceVolo = 'CodiceVolo'


SELECT Volo, Data, Ora
FROM PARTENZA
WHERE Volo = 'CodiceVolo'


SELECT Volo, Data, Ora
FROM DESTINAZIONE
WHERE Volo = 'CodiceVolo'


SELECT CodiceBiglietto, Costo
FROM BIGLIETTO
WHERE CodiceBiglietto = 'CodiceBiglietto'

/* 11 */
UPDATE DESTINAZIONE
	SET Ora = 'Ora'
	WHERE Volo = 'CodiceVolo'

/* 12 slot di tempo non esiste */

/* 13 slot di tempo non esiste */

/* 14 slot di tempo non esiste */

/* 15 */
SELECT 
    CodiceFiscale, Nome, Cognome
FROM
    DIPENDENTE D
        JOIN
    COMANDANTE C ON D.CodiceFiscale = C.Dipendente
        JOIN
    EQUIPAGGIO E ON C.Equipaggio = E.CodiceEquipaggio
        AND C.Compagnia = E.Compagnia
WHERE
    E.CodiceEquipaggio = 'CodiceEquipaggio' 
UNION SELECT 
    CodiceFiscale, Nome, Cognome
FROM
    DIPENDENTE D
        JOIN
    HOSTESS_STUART HS ON D.CodiceFiscale = HS.Dipendente
        JOIN
    EQUIPAGGIO E ON HS.Equipaggio = E.CodiceEquipaggio
        AND HS.Compagnia = E.Compagnia
WHERE
    E.CodiceEquipaggio = 'CodiceEquipaggio'

/* 16 */
SELECT CodiceVolo
FROM VOLO V, AEROPORTO A, PARTENZA P
WHERE V.CodiceVolo= P.Volo AND  A.Sigla= P.Aeroporto AND A.Sigla='sigla'										   

/* 17 */
SELECT Volo, Count(DISTINCT Passeggero)
FROM ACQUISTO JOIN BIGLIETTO ON Biglietto = CodiceBiglietto
WHERE Volo = 'CodiceVolo' AND Check_in = TRUE
GROUP BY Volo

/* 18 */
SELECT Biglietto
FROM ACQUISTO
WHERE Passeggero = 'CodiceFiscale'

/* 19 */												   
SELECT SUM(B.Bagagli)
FROM
    BIGLIETTO B
        JOIN
    ACQUISTO A ON B.CodiceBiglietto = A.Biglietto
        JOIN
    VOLO V ON V.CodiceVolo = A.Volo
WHERE V.CodiceVolo = 'CodiceVolo'									   

/* 20 */
SELECT TIMEDIFF(P.ora, D.ora)
FROM VOLO V, DESTINAZIONE D, PARTENZA P
WHERE V.CodiceVolo = P.Volo AND V.CodiceVolo = D.Volo AND V.CodiceVolo = 'CodiceVolo'