CREATE TABLE VELIVOLO(
	CodiceVelivolo VARCHAR(10),
	Compagnia VARCHAR(30) REFERENCES COMPAGNIA(CodiceCompagnia)
	ON UPDATE CASCADE
	ON DELETE SET NULL,
	Stato VARCHAR(20),
	OreDiVolo INT,
	Carburante INT,
	AnnoDiCostruzione INT,
	PRIMARY KEY(CodiceVelivolo,Compagnia)
	CHECK (Stato LIKE "disponibile" OR "manutenzione")
)

CREATE TABLE COMPAGNIA(
	CodiceCompagnia CHAR(10) NOT NULL PRIMARY KEY,
	Nome CHAR(30) NOT NULL UNIQUE,
	Nazione CHAR(20)NOT NULL
)

CREATE TABLE EQUIPAGGIO(
	CodiceEquipaggio CHAR(10),
	Compagnia CHAR(30) REFERENCES COMPAGNIA(CodiceCompagnia)
	ON UPDATE CASCADE
	ON DELETE SET NULL,
	PRIMARY KEY(CodiceEquipaggio,Compagnia)
)

CREATE TABLE ASSEGNAZIONE(
	CodiceEquipaggio CHAR(10),
	Compagnia CHAR(30) REFERENCES COMPAGNIA(CodiceCompagnia),
	Volo VARCHAR(10) REFERENCES VOLO(CodiceVolo),
	PRIMARY KEY(CodiceEquipaggio,CodiceCompagnia,CodiceVolo)
)

CREATE TABLE DISPOSIZIONE(
	Velivolo VARCHAR(10) REFERENCES VELIVOLO(CodiceVelivolo),
	Compagnia CHAR(10) REFERENCES COMPAGNIA(CodiceCompagnia),
	Volo VARCHAR(10) REFERENCES VOLO(CodiceVolo),
	PRIMARY KEY(Velivolo,Compagnia,Volo)
)

/* Questa tabella non ha senso...
Un equipaggio di una compagnia non fa solo una tratta...
Però la stessa tratta può essere fatta da più equipaggi, corretto.*/
CREATE TABLE TRATTA(
	Equipaggio VARCHAR(10) REFERENCES EQUIPAGGIO(CodiceEquipaggio),
	Compagnia VARCHAR(10) REFERENCES COMPAGNIA(CodiceCompagnia),
	Nome VARCHAR(50) NOT NULL,
	CHECK (Nome LIKE "%-%"),
	PRIMARY KEY(Equipaggio,Compagnia)
)

CREATE TABLE COMANDANTE(
	Dipendente CHAR(16) REFERENCES DIPENDENTE(CodiceFiscale),
	Equipaggio VARCHAR(10) REFERENCES EQUIPAGGIO(CodiceEquipaggio),
	Compagnia VARCHAR(10) REFERENCES COMPAGNIA(CodiceCompagnia),
	Formazione CHAR(5),
	CHECK (Formazione LIKE "PPL" OR "CPL" OR "ATPL"),
	PRIMARY KEY(Dipendente,Equipaggio,Compagnia)
)

CREATE TABLE DIPENDENTE(
	CodiceFiscale CHAR(16) PRIMARY KEY,
	Nome CHAR(20) NOT NULL,
	Cognome CHAR(20) NOT NULL,
	Email VARCHAR(40),
	Telefono INT(10),
	Nazionalita CHAR(10),
	DataDiNascita TIME,
	Compagnia VARCHAR(10) REFERENCES COMPAGNIA(CodiceCompagnia)
)

CREATE TABLE HOSTESS_STUART(
	Dipendente CHAR(16) REFERENCES DIPENDENTE(CodiceFiscale),
	Equipaggio VARCHAR(10) REFERENCES EQUIPAGGIO(CodiceEquipaggio),
	Compagnia VARCHAR(10) REFERENCES COMPAGNIA(CodiceCompagnia),
	PRIMARY KEY(Dipendente,Equipaggio,Compagnia)
)

CREATE TABLE PASSEGGERO(
	CodiceFiscale CHAR(16) PRIMARY KEY,
	Nome CHAR(20) NOT NULL,
	Cognome CHAR(20) NOT NULL,
	Disabile BOOLEAN,
	Email VARCHAR(40),
	DataDiNascita TIME,
	Check-in BOOLEAN,
	Nazionalita CHAR(10),
	Bagagli INT,
)

CREATE TABLE ACQUISTO(
	Biglietto CHAR(10) REFERENCES BIGLIETTO(CodiceBiglietto) PRIMARY KEY,
	Volo CHAR(10) REFERENCES VOLO(CodiceVolo),
	Passeggero CHAR(16) REFERENCES PASSEGGERO(CodiceFiscale),
)

CREATE TABLE VOLO(
	CodiceVolo CHAR(10) PRIMARY KEY,
	Stato VARCHAR(10),
	Carburante INT,
	CHECK (Stato LIKE "check-in" OR "boarding" OR "canceled" OR "delayed" OR "departed")
)

CREATE TABLE BIGLIETTO