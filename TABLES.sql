CREATE TABLE IF NOT EXISTS VELIVOLO(
	CodiceVelivolo VARCHAR(10),
	Compagnia VARCHAR(30) REFERENCES COMPAGNIA(CodiceCompagnia)
	ON UPDATE CASCADE
	ON DELETE SET NULL,
	Stato VARCHAR(20),
	OreDiVolo INT,
	Carburante INT,
	AnnoDiCostruzione INT,
	PRIMARY KEY(CodiceVelivolo,Compagnia),
	CHECK (Stato LIKE "disponibile" OR "manutenzione")
);

CREATE TABLE IF NOT EXISTS COMPAGNIA(
	CodiceCompagnia CHAR(10) NOT NULL PRIMARY KEY,
	Nome CHAR(30) NOT NULL UNIQUE,
	Nazione CHAR(20)NOT NULL
);

CREATE TABLE IF NOT EXISTS EQUIPAGGIO(
	CodiceEquipaggio CHAR(10),
	Compagnia CHAR(30) REFERENCES COMPAGNIA(CodiceCompagnia)
	ON UPDATE CASCADE
	ON DELETE SET NULL,
	PRIMARY KEY(CodiceEquipaggio,Compagnia)
);

CREATE TABLE IF NOT EXISTS ASSEGNAZIONE(
	CodiceEquipaggio CHAR(10),
	Compagnia CHAR(30) REFERENCES COMPAGNIA(CodiceCompagnia),
	Volo VARCHAR(10) REFERENCES VOLO(CodiceVolo),
	PRIMARY KEY(CodiceEquipaggio,Compagnia,Volo)
);

CREATE TABLE IF NOT EXISTS DISPOSIZIONE(
	Velivolo VARCHAR(10) REFERENCES VELIVOLO(CodiceVelivolo),
	Compagnia CHAR(10) REFERENCES COMPAGNIA(CodiceCompagnia),
	Volo VARCHAR(10) REFERENCES VOLO(CodiceVolo),
	PRIMARY KEY(Velivolo,Compagnia,Volo)
);

/* Questa tabella non ha senso...
Un equipaggio di una compagnia non fa solo una tratta...
Però la stessa tratta può essere fatta da più equipaggi, corretto.*/
CREATE TABLE IF NOT EXISTS TRATTA(
	Equipaggio VARCHAR(10) REFERENCES EQUIPAGGIO(CodiceEquipaggio),
	Compagnia VARCHAR(10) REFERENCES COMPAGNIA(CodiceCompagnia),
	Nome VARCHAR(50) NOT NULL,
	CHECK (Nome LIKE "%-%"),
	PRIMARY KEY(Equipaggio,Compagnia)
);

CREATE TABLE IF NOT EXISTS COMANDANTE(
	Dipendente CHAR(16) REFERENCES DIPENDENTE(CodiceFiscale),
	Equipaggio VARCHAR(10) REFERENCES EQUIPAGGIO(CodiceEquipaggio),
	Compagnia VARCHAR(10) REFERENCES COMPAGNIA(CodiceCompagnia),
	Formazione CHAR(5),
	CHECK (Formazione LIKE "PPL" OR "CPL" OR "ATPL"),
	PRIMARY KEY(Dipendente,Equipaggio,Compagnia)
);

CREATE TABLE IF NOT EXISTS DIPENDENTE(
	CodiceFiscale CHAR(16) PRIMARY KEY,
	Nome CHAR(20) NOT NULL,
	Cognome CHAR(20) NOT NULL,
	Email VARCHAR(40),
	Telefono INT(10),
	Nazionalita CHAR(10),
	DataDiNascita TIME,
	Compagnia VARCHAR(10) REFERENCES COMPAGNIA(CodiceCompagnia)
);

CREATE TABLE IF NOT EXISTS HOSTESS_STUART(
	Dipendente CHAR(16) REFERENCES DIPENDENTE(CodiceFiscale),
	Equipaggio VARCHAR(10) REFERENCES EQUIPAGGIO(CodiceEquipaggio),
	Compagnia VARCHAR(10) REFERENCES COMPAGNIA(CodiceCompagnia),
	PRIMARY KEY(Dipendente,Equipaggio,Compagnia)
);

CREATE TABLE IF NOT EXISTS PASSEGGERO (
    CodiceFiscale CHAR(16) PRIMARY KEY,
    Nome CHAR(20) NOT NULL,
    Cognome CHAR(20) NOT NULL,
    Disabile BOOLEAN,
    Email VARCHAR(40),
    DataDiNascita TIME,
    Check_in BOOLEAN,
    Nazionalita CHAR(10),
    Bagagli INT
);

CREATE TABLE IF NOT EXISTS ACQUISTO (
    Biglietto CHAR(10) PRIMARY KEY REFERENCES BIGLIETTO (CodiceBiglietto),
    Volo CHAR(10) REFERENCES VOLO (CodiceVolo),
    Passeggero CHAR(16) REFERENCES PASSEGGERO (CodiceFiscale)
);

CREATE TABLE IF NOT EXISTS VOLO(
	CodiceVolo CHAR(10) PRIMARY KEY,
	Stato VARCHAR(10),
	Carburante INT,
	CHECK (Stato LIKE "check-in" OR "boarding" OR "canceled" OR "delayed" OR "departed")
);

CREATE TABLE IF NOT EXISTS BIGLIETTO(
	CodiceBiglietto CHAR(10) PRIMARY KEY,
	Costo FLOAT(2),
	Posto INT
);

CREATE TABLE IF NOT EXISTS PARTENZA(
	Volo CHAR(10) PRIMARY KEY,
	Data TIME,
	ORA TIME,
	Aeroporto CHAR(5) REFERENCES AEROPORTO(Sigla)
);

CREATE TABLE IF NOT EXISTS DESTINAZIONE(
	Volo CHAR(10) PRIMARY KEY,
	Data TIME,
	ORA TIME,
	Aeroporto CHAR(5) REFERENCES AEROPORTO(Sigla)
);

CREATE TABLE IF NOT EXISTS AEROPORTO (
    Sigla CHAR(10) PRIMARY KEY
);