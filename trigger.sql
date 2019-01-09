
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
DELIMITER//
CREATE TRIGGER seHostessNoPasseggero 
BEFORE INSERT ON AQUISTO
    FOR EACH ROW
        BEGIN 
            BEGIN IF NEW.Passeggero IN (SELECT H.Dipendente, C.Dipendente
                                        FROM HOSTESS_STUART H, COMANDANTE C, ASSEGNAZIONE A, EQUIPAGGIO E 
                                        WHERE  H.Equipaggio = E.CodiceEquipaggio AND
                                                C.Equipaggio = E.CodiceEquipaggio AND
                                                E.CodiceEquipaggio = A.Equipaggio AND
                                                A.Volo = NEW.Volo)
                   THEN
                       ....
      
             END IF;
        END;
 END;//
            


//evitare che l'aeroporto di partenza e destinazione di un volo siano uguali.

DELIMITER //
CREATE TRIGGER ControlloAeroportiPart
BEFORE INSERT ON PARTENZA
FOR EACH ROW
BEGIN 
    BEGIN IF NEW.Aeroporto = (SELECT Aeroporto FROM DESTINAZIONE D WHERE D.Volo = NEW.Volo) THEN
  //DELETE FROM PARTENZA WHERE Volo = NEW.Volo AND Aeroporto =NEW.Aeroporto; 
    END IF;
END;
END;//

DELIMITER //
CREATE TRIGGER ControlloAeroportiDest
BEFORE INSERT ON DESTINAZIONE
FOR EACH ROW
BEGIN 
    BEGIN IF NEW.Aeroporto= (SELECT Aeroporto FROM PARTENZA P WHERE P.Volo = NEW.Volo) THEN
  //DELETE FROM DESTINAZIONE WHERE Volo = NEW.Volo AND Aeroporto=NEW.Aeroporto; 
    END IF;
END;
END;//

//oppure

DELIMETER //
CREATE TRIGGER ControlloAeroporti AFTER INSERT ON PARTENZA
FOR EACH ROW
BEGIN 
  BEGIN IF NEW.Aeroporto= (SELECT Aeroporto FROM Destinazione D WHERE D.Volo = NEW.Volo) THEN
  DELETE FROM PARTENZA WHERE Volo = NEW.Volo AND Aeroporto=NEW.Aeroporto; 
END IF;
END;
END;//
