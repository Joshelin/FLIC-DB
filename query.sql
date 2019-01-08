INSERT COMPAGNIA(CodiceCompagnia, Nome, Nazione) VALUES('C1','CompagniaC1','Italia') ;

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