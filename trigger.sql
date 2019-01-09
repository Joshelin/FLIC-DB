
//evitare che lo stesso dipendente possa essere Comandante e Hostess dello stesso equipaggio.


//evitare che un dipendente possa essere passeggero di un volo assegnato al suo equipaggio.



//evitare che l'aeroporto di partenza e destinazione di un volo siano uguali.

DELIMETER //
CREATE TRIGGER ControlloAeroporti BEFOR INSERT ON PARTENZA
FOR EACH ROW
BEGIN 
  BEGIN IF( NEW.Sigla= (SELECT Sigla FROM Destinazione D WHERE D.Volo = NEW.Volo)) THEN
  DELETE FROM PARTENZA WHERE Volo = NEW.Volo AND Sigla=NEW.Sigla; 
END IF;
END;
END;//

