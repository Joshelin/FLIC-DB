

DELIMITER //
CREATE TRIGGER SeHostessNonComandante
BEFORE INSERT ON HOSTESS_STUART
    FOR EACH ROW
        BEGIN
            BEGIN IF
                NEW.Dipendente = ANY (SELECT Dipendente FROM COMANDANTE) 
                    THEN
                    		SIGNAL SQLSTATE  VALUE '45000' SET MESSAGE_TEXT = 'Questa persona è già comandante';
            END IF;
        END;
    END;//
    
  DELIMITER //
CREATE TRIGGER SeComandanteNonHostess
BEFORE INSERT ON COMANDANTE
    FOR EACH ROW
        BEGIN
            BEGIN IF
                NEW.Dipendente = ANY (SELECT Dipendente FROM HOSTESS_STUART) 
                    THEN
                    		SIGNAL SQLSTATE  VALUE '45000' SET MESSAGE_TEXT = 'Questa persona è già hostess o stuart';
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
            




DELIMITER //
CREATE TRIGGER ControlloAeroportiPart
BEFORE INSERT ON PARTENZA
FOR EACH ROW
BEGIN 
    BEGIN IF NEW.Aeroporto = ANY (SELECT Aeroporto FROM DESTINAZIONE D WHERE D.Volo = NEW.Volo) THEN
		SIGNAL SQLSTATE  VALUE '45000' SET MESSAGE_TEXT = 'Incorrect airport';
    END IF;
END;
END;//

DELIMITER //
CREATE TRIGGER ControlloAeroportiDest
BEFORE INSERT ON DESTINAZIONE
FOR EACH ROW
BEGIN 
    BEGIN IF NEW.Aeroporto = ANY (SELECT Aeroporto FROM PARTENZA P WHERE P.Volo = NEW.Volo) THEN
        		SIGNAL SQLSTATE  VALUE '45000' SET MESSAGE_TEXT = 'Incorrect airport';
    END IF;
END;
END;//

