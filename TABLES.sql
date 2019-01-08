CREATE TABLE IF NOT EXISTS COMPAGNIA (
    CodiceCompagnia CHAR(10) PRIMARY KEY,
    Nome CHAR(30) NOT NULL,
    Nazione CHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS VELIVOLO (
    CodiceVelivolo VARCHAR(10),
    Compagnia VARCHAR(30),
    Stato VARCHAR(20),
    OreDiVolo INT,
    Carburante INT,
    AnnoDiCostruzione INT,
    PRIMARY KEY (CodiceVelivolo , Compagnia),
    FOREIGN KEY (Compagnia)
        REFERENCES COMPAGNIA (CodiceCompagnia)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    CHECK (Stato LIKE 'disponibile'
        OR 'manutenzione')
);

CREATE TABLE IF NOT EXISTS EQUIPAGGIO (
    CodiceEquipaggio CHAR(10),
    Compagnia CHAR(30),
    PRIMARY KEY (CodiceEquipaggio , Compagnia),
    FOREIGN KEY (Compagnia)
        REFERENCES COMPAGNIA (CodiceCompagnia)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS TRATTA (
    Nome VARCHAR(50) PRIMARY KEY,
    CHECK (Nome LIKE '%-%'),
);

CREATE TABLE IF NOT EXISTS DIPENDENTE (
    CodiceFiscale CHAR(16) PRIMARY KEY,
    Nome CHAR(20) NOT NULL,
    Cognome CHAR(20) NOT NULL,
    Email VARCHAR(40),
    Telefono INT(10),
    Nazionalita CHAR(10),
    DataDiNascita TIME,
    Compagnia VARCHAR(10),
    FOREIGN KEY (Compagnia)
        REFERENCES COMPAGNIA (CodiceCompagnia)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS COMANDANTE (
    Dipendente CHAR(16) PRIMARY KEY,
    Equipaggio VARCHAR(10),
    Compagnia VARCHAR(10),
    Formazione CHAR(5),
    CHECK (Formazione LIKE 'PPL' OR 'CPL' OR 'ATPL'),
    UNIQUE (Equipaggio , Compagnia),
    FOREIGN KEY (Equipaggio , Compagnia)
        REFERENCES EQUIPAGGIO (CodiceEquipaggio , Compagnia)
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (Dipendente)
        REFERENCES DIPENDENTE (CodiceFiscale)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS HOSTESS_STUART (
    Dipendente CHAR(16) PRIMARY KEY,
    Equipaggio VARCHAR(10),
    Compagnia VARCHAR(10) REFERENCES COMPAGNIA (CodiceCompagnia),
    FOREIGN KEY (Equipaggio , Compagnia)
        REFERENCES EQUIPAGGIO (CodiceEquipaggio , Compagnia)
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (Dipendente)
        REFERENCES DIPENDENTE (CodiceFiscale)
        ON UPDATE CASCADE ON DELETE CASCADE
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

CREATE TABLE IF NOT EXISTS VOLO (
    CodiceVolo CHAR(10) PRIMARY KEY,
    Stato VARCHAR(10),
    Carburante INT,
    CHECK (Stato LIKE 'check-in' OR 'boarding'
        OR 'canceled'
        OR 'delayed'
        OR 'departed')
);

CREATE TABLE IF NOT EXISTS DISPOSIZIONE (
    Velivolo VARCHAR(10) NOT NULL,
    Compagnia CHAR(10) NOT NULL,
    Volo VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (Velivolo , Compagnia)
        REFERENCES VELIVOLO (CodiceVelivolo , Compagnia)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Volo)
        REFERENCES VOLO (CodiceVolo)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ASSEGNAZIONE (
    Equipaggio CHAR(10) NOT NULL,
    Compagnia CHAR(30) NOT NULL,
    Volo VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (Equipaggio , Compagnia)
        REFERENCES EQUIPAGGIO (CodiceEquipaggio , Compagnia)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Volo)
        REFERENCES VOLO (CodiceVolo)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS BIGLIETTO (
    CodiceBiglietto CHAR(10) PRIMARY KEY,
    Costo FLOAT(2),
    Posto INT
);

CREATE TABLE IF NOT EXISTS ACQUISTO (
    Biglietto CHAR(10) PRIMARY KEY,
    Volo CHAR(10),
    Passeggero CHAR(16),
    FOREIGN KEY (Biglietto)
        REFERENCES BIGLIETTO (CodiceBiglietto)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Volo)
        REFERENCES VOLO (CodiceVolo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Passeggero)
        REFERENCES PASSEGGERO (CodiceFiscale)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS AEROPORTO (
    Sigla CHAR(10) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS PARTENZA (
    Volo CHAR(10) PRIMARY KEY,
    Data TIME,
    ORA TIME,
    Aeroporto CHAR(5),
    FOREIGN KEY (Volo)
        REFERENCES VOLO (CodiceVolo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Aeroporto)
        REFERENCES AEROPORTO (Sigla)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS DESTINAZIONE (
    Volo CHAR(10) PRIMARY KEY,
    Data TIME,
    ORA TIME,
    Aeroporto CHAR(5),
    FOREIGN KEY (Volo)
        REFERENCES VOLO (CodiceVolo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Aeroporto)
        REFERENCES AEROPORTO (Sigla)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS PERCORRENZA (
    Equipaggio CHAR(10),
    Compagnia CHAR(30),
    Tratta VARCHAR(50),
    FOREIGN KEY (Tratta)
        REFERENCES TRATTA (Nome)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Equipaggio , Compagnia)
        REFERENCES EQUIPAGGIO (CodiceEquipaggio , Compagnia)
        ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (Equipaggio , Compagnia , Tratta)
);