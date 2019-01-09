
//evitare che lo stesso dipendente possa essere Comandante e Hostess dello stesso equipaggio.

DELIMITER //
CREATE TRIGGER SeHostessNonComandante
AFTER INSERT ON HOSTESS_STUART
    FOR EACH ROW
        BEGIN
            BEGIN IF
                NEW.Dipendente IN (SELECT Dipendente FROM COMANDANTE) 
                    THEN
                DELETE FROM 
                    HOSTESS_STUART 
                        WHERE
                    Dipendente = NEW.Dipendente;
            END IF;
        END;
    END;//
    
  DELIMITER //
CREATE TRIGGER SeComandanteNonHostess
AFTER INSERT ON COMANDANTE
    FOR EACH ROW
        BEGIN
            BEGIN IF
                NEW.Dipendente IN (SELECT Dipendente FROM HOSTESS_STUART) 
                    THEN
                DELETE FROM 
                    DIPENDENTE
                        WHERE
                    Dipendente = NEW.Dipendente;
            END IF;
        END;
    END;//

//evitare che un dipendente possa essere passeggero di un volo assegnato al suo equipaggio.



//evitare che l'aeroporto di partenza e destinazione di un volo siano uguali.

DELIMETER //
CREATE TRIGGER ControlloAeroporti BEFORE INSERT ON PARTENZA
FOR EACH ROW
BEGIN 
  BEGIN IF( NEW.Sigla= (SELECT Sigla FROM Destinazione D WHERE D.Volo = NEW.Volo)) THEN
  //DELETE FROM PARTENZA WHERE Volo = NEW.Volo AND Sigla=NEW.Sigla; 
END IF;
END;
END;//

DELIMETER //
CREATE TRIGGER ControlloAeroporti BEFORE INSERT ON DESTINAZIONE
FOR EACH ROW
BEGIN 
  BEGIN IF( NEW.Sigla= (SELECT Sigla FROM PARTENZA P WHERE P.Volo = NEW.Volo)) THEN
  //DELETE FROM DESTINAZIONE WHERE Volo = NEW.Volo AND Sigla=NEW.Sigla; 
END IF;
END;
END;//

//oppure

DELIMETER //
CREATE TRIGGER ControlloAeroporti AFTER INSERT ON PARTENZA
FOR EACH ROW
BEGIN 
  BEGIN IF( NEW.Sigla= (SELECT Sigla FROM Destinazione D WHERE D.Volo = NEW.Volo)) THEN
  DELETE FROM PARTENZA WHERE Volo = NEW.Volo AND Sigla=NEW.Sigla; 
END IF;
END;
END;//
