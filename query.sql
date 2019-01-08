1)
INSERT COMPAGNIA(CodiceCompagnia, Nome, Nazione) VALUES('C1','CompagniaC1','Italia') ;

2)
INSERT DIPENDENTE(CodiceFiscale, Nome, Cognome, Email, Telefono, Nazionalita, DataDiNascita) 
VALUES('RSIMROJ60M21G','Mario','Rossi',"mario.rossi@gmail.com","3458761213","italiana",1990-03-12) ;
/* 16 */
DELETE FROM PASSEGGERO
	WHERE CodiceFiscale = 'CodiceFiscale'

/* 17a */
SELECT Biglietto
FROM ACQUISTO
WHERE Passeggero = 'CodiceFiscale'

/* 17b */
SELECT BIGLIETTO
FROM ACQUISTO JOIN PASSEGGERO ON Passeggero = CodiceFiscale
WHERE Nome = 'Nome' AND Cognome = 'Cognome' AND CodiceFiscale = 'CodiceFiscale'

/* 18 */
DELETE FROM BIGLIETTO
	WHERE CodiceBiglietto = 'CodiceBiglietto'

/* 19 */ 
SELECT Stato
FROM VOLO
WHERE CodiceVolo = 'CodiceVolo'

/* 20 */
DELETE FROM VOLO
	WHERE CodiceVolo = 'CodiceVolo'

/* 21 */
SELECT Volo, Data, Ora
FROM PARTENZA
WHERE Volo = 'CodiceVolo'

/* 22 */
SELECT Volo, Data, Ora
FROM DESTINAZIONE
WHERE Volo = 'CodiceVolo'

/* 23 */
SELECT CodiceBiglietto, Costo
FROM BIGLIETTO
WHERE CodiceBiglietto = 'CodiceBiglietto'

/* 24 */
UPDATE DESTINAZIONE
	SET Ora = 'Ora'
	WHERE Volo = 'CodiceVolo'

/* 25 slot di tempo non esiste */

/* 26 slot di tempo non esiste */

/* 27 slot di tempo non esiste */

/* 28 */
SELECT Formazione
FROM COMANDANTE
WHERE Dipendente = 'CodiceFiscale'

/* 29 */
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
VALUES('RSIMROJ60M21G','Mario','Rossi',"mario.rossi@gmail.com","3458761213","italiana",STR_TO_DATE('07-25-1990','%m-%d-%y')) ;

3)
INSERT COMANDANTE(Dipendente, Equipaggio, Compagnia, Formazione) 
VALUES('RSIMROJ60M21G','Marullo',"C1","PPL") ;

4)
INSERT HOSTESS_STUART(Dipendente, Equipaggio, Compagnia) 
VALUES('BNCMROJ60M21G','Marullo',"C1","PPL") ;

5)
INSERT EQUIPAGGIO(CodiceEquipaggio, Compagnia) 
VALUES('Marullo',"C1") ;

6)
INSERT VELIVOLO(CodiceVelivolo, Compagnia, Stato, OreDiVolo, Carburante, AnnoDiCostruzione) 
VALUES('707','C1','disponibile',13,45,1995) ;

7)
INSERT PASSEGGERO(CodiceFiscale, Nome, Cognome, Disabile, Email, Telefono, DataDiNascita, Nazionalita) 
VALUES('BNCALCJ60M21G','Alice',"Bianchi",0,,"alice.bianchi@fastwebnet.it",3981144523,STR_TO_DATE('09-05-1997','%m-%d-%y'),"italiana") ;

8)
INSERT BIGLIETTO(CodiceBiglietto, Costo, Posto, Bagagli, Check-in) 
VALUES('30C',90.0,22,0,0) ;

9)
INSERT VOLO(CodiceVolo, Stato, Carburante) 
VALUES('1112','boarding',50) ;

10)
UPDATE VELIVOLO SET Stato = 'disponibile' WHERE Compagnia = 'C1'

11)
SELECT Stato
FROM VELIVOLO
WHERE OreDiVolo > 12

/*12*/
SELECT v.CodiceVelivolo, v.Compagnia, v.Stato, v.OreDiVolo, v.Carburante, v.AnnoDiCostruzione
FROM VELIVOLO v, DISPOSIZIONE d, VOLO f
WHERE v.CodiceVelivolo = d.Velivolo AND d.Volo = f.Volo AND v.Carburante >= f.Carburante 
