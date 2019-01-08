/*1*/
INSERT COMPAGNIA(CodiceCompagnia, Nome, Nazione) VALUES('C1','CompagniaC1','Italia') ;

/*2*/
INSERT DIPENDENTE(CodiceFiscale, Nome, Cognome, Email, Telefono, Nazionalita, DataDiNascita) 
VALUES('RSIMROJ60M21G','Mario','Rossi',"mario.rossi@gmail.com","3458761213","italiana",STR_TO_DATE('07-25-1990','%m-%d-%y')) ;

/*3*/
INSERT COMANDANTE(Dipendente, Equipaggio, Compagnia, Formazione) 
VALUES('RSIMROJ60M21G','Marullo',"C1","PPL") ;

/*4*/
INSERT HOSTESS_STUART(Dipendente, Equipaggio, Compagnia) 
VALUES('BNCMROJ60M21G','Marullo',"C1","PPL") ;

/*5*/
INSERT EQUIPAGGIO(CodiceEquipaggio, Compagnia) 
VALUES('Marullo',"C1") ;

/*6*/
INSERT VELIVOLO(CodiceVelivolo, Compagnia, Stato, OreDiVolo, Carburante, AnnoDiCostruzione) 
VALUES('707','C1','disponibile',13,45,1995) ;

/*7*/
INSERT PASSEGGERO(CodiceFiscale, Nome, Cognome, Disabile, Email, Telefono, DataDiNascita, Nazionalita) 
VALUES('BNCALCJ60M21G','Alice',"Bianchi",0,"alice.bianchi@fastwebnet.it",3981144523,STR_TO_DATE('09-05-1997','%m-%d-%y'),"italiana") ;

/*8*/
INSERT BIGLIETTO(CodiceBiglietto, Costo, Posto, Bagagli, Check-in) 
VALUES('30C',90.0,22,0,0) ;

/*9*/
INSERT VOLO(CodiceVolo, Stato, Carburante) 
VALUES('1112','boarding',50) ;

/*10*/
SELECT v.CodiceVelivolo, v.Compagnia, v.Stato, v.OreDiVolo, v.Carburante, v.AnnoDiCostruzione
FROM VELIVOLO v, DISPOSIZIONE d, VOLO f
WHERE v.CodiceVelivolo = d.Velivolo AND d.Volo = f.Volo AND v.Carburante >= f.Carburante AND 
    (f.Stato = 'boarding' OR f.Stato = 'check-in' OR 'delayed')

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
SELECT *
FROM VOLO V, AEROPORTO A, PARTENZA P, 
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

/* 20 */
SELECT TIMEDIFF(P.ora, D.ora)
FROM VOLO V, DESTINAZIONE D, PARTENZA P
WHERE V.CodiceVolo = P.Volo AND V.CodiceVolo = D.Volo												   
