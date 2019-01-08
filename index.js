var mysql = require('mysql');

var connection = mysql.createConnection({
    host: "localhost",
    user: "nodeuser",
    password: "1234",
    //debug: true
});

connection.connect(function(err) {
    if (err) {
    	console.error('error connecting: ' + err.stack);
    	return
    }
    connection.query("CREATE DATABASE if not exists FLIC", function (err, result) {
        if (err) throw err;
        console.log("Database created");
    });
    console.log("Connected as id: " + connection.threadId);
    /*
    connection.end(function(err) {
        // The connection is terminated now
    });
    */
});

var pool  = mysql.createPool({
    connectionLimit : 100, //?
    host            : 'localhost',
    user            : 'nodeuser',
    password        : '1234',
    database        : 'FLIC'
});


pool.query(`CREATE TABLE IF NOT EXISTS COMPAGNIA (
    CodiceCompagnia CHAR(10) PRIMARY KEY,
    Nome CHAR(30) NOT NULL,
    Nazione CHAR(20) NOT NULL
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Compagnia created");
});

pool.query(`CREATE TABLE IF NOT EXISTS VELIVOLO (
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
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Velivolo created");
});

pool.query(`CREATE TABLE IF NOT EXISTS EQUIPAGGIO (
    CodiceEquipaggio CHAR(10),
    Compagnia CHAR(30),
    PRIMARY KEY (CodiceEquipaggio , Compagnia),
    FOREIGN KEY (Compagnia)
        REFERENCES COMPAGNIA (CodiceCompagnia)
        ON UPDATE CASCADE ON DELETE CASCADE
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Equipaggio created");
});

pool.query(`CREATE TABLE IF NOT EXISTS TRATTA (
    Nome VARCHAR(50) PRIMARY KEY,
    CHECK (Nome LIKE '%-%'),
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Tratta created");
});

pool.query(`CREATE TABLE IF NOT EXISTS DIPENDENTE (
    CodiceFiscale CHAR(16) PRIMARY KEY,
    Nome CHAR(20) NOT NULL,
    Cognome CHAR(20) NOT NULL,
    Email VARCHAR(40),
    Telefono VARCHAR(15),
    Nazionalita CHAR(10),
    DataDiNascita DATE,
    Compagnia VARCHAR(10),
    FOREIGN KEY (Compagnia)
        REFERENCES COMPAGNIA (CodiceCompagnia)
        ON UPDATE CASCADE ON DELETE SET NULL
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Dipendente created");
});
pool.query(`CREATE TABLE IF NOT EXISTS COMANDANTE (
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
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Comandante created");
});

pool.query(`CREATE TABLE IF NOT EXISTS HOSTESS_STUART (
    Dipendente CHAR(16) PRIMARY KEY,
    Equipaggio VARCHAR(10),
    Compagnia VARCHAR(10) REFERENCES COMPAGNIA (CodiceCompagnia),
    FOREIGN KEY (Equipaggio , Compagnia)
        REFERENCES EQUIPAGGIO (CodiceEquipaggio , Compagnia)
        ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (Dipendente)
        REFERENCES DIPENDENTE (CodiceFiscale)
        ON UPDATE CASCADE ON DELETE CASCADE
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Hostess_stuart created");
});

pool.query(`CREATE TABLE IF NOT EXISTS PASSEGGERO (
    CodiceFiscale CHAR(16) PRIMARY KEY,
    Nome CHAR(20) NOT NULL,
    Cognome CHAR(20) NOT NULL,
    Disabile BOOLEAN,
    Email VARCHAR(40),
    Telefono VARCHAR(15),
    DataDiNascita DATE,
    Check_in BOOLEAN,
    Nazionalita CHAR(10),
    Bagagli INT
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Passeggero created");
});

pool.query(`CREATE TABLE IF NOT EXISTS VOLO (
    CodiceVolo CHAR(10) PRIMARY KEY,
    Stato VARCHAR(10),
    Carburante INT,
    CHECK (Stato LIKE 'check-in' OR 'boarding'
        OR 'canceled'
        OR 'delayed'
        OR 'departed')
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Volo created");
});

pool.query(`CREATE TABLE IF NOT EXISTS DISPOSIZIONE (
    Velivolo VARCHAR(10) NOT NULL,
    Compagnia CHAR(10) NOT NULL,
    Volo VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (Velivolo , Compagnia)
        REFERENCES VELIVOLO (CodiceVelivolo , Compagnia)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Volo)
        REFERENCES VOLO (CodiceVolo)
        ON UPDATE CASCADE ON DELETE CASCADE
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Disposizione created");
});

pool.query(`CREATE TABLE IF NOT EXISTS ASSEGNAZIONE (
    Equipaggio CHAR(10) NOT NULL,
    Compagnia CHAR(30) NOT NULL,
    Volo VARCHAR(10) PRIMARY KEY,
    FOREIGN KEY (Equipaggio , Compagnia)
        REFERENCES EQUIPAGGIO (CodiceEquipaggio , Compagnia)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Volo)
        REFERENCES VOLO (CodiceVolo)
        ON UPDATE CASCADE ON DELETE CASCADE
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Assegnazione created");
});

pool.query(`CREATE TABLE IF NOT EXISTS BIGLIETTO (
    CodiceBiglietto CHAR(10) PRIMARY KEY,
    Costo FLOAT(2),
    Posto INT
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Biglietto created");
});

pool.query(`CREATE TABLE IF NOT EXISTS ACQUISTO (
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
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Acquisto created");
});

pool.query(`CREATE TABLE IF NOT EXISTS AEROPORTO (
    Sigla CHAR(10) PRIMARY KEY
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Aeroporto created");
});

pool.query(`CREATE TABLE IF NOT EXISTS PARTENZA (
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
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("Partenza created");
});

pool.query(`CREATE TABLE IF NOT EXISTS DESTINAZIONE (
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
);`, function (err, results, fields) {
    if (err) throw err;
    console.log("destinazione created");
});

pool.query(`CREATE TABLE IF NOT EXISTS PERCORRENZA (
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
);`,function(err,results,fields){
    if (err) throw err;
    console.log("percorrenza created");
});
/*
pool.query(`INSERT COMPAGNIA(CodiceCompagnia, Nome, Nazione) 
    VALUES('C1','CompagniaC1','Italia') ;`, function(err,results,fields){

        if (err) throw err;
        console.log("compagnia inserita");
    
    });

test per insert
pool.query(`SELECT * FROM COMPAGNIA ;`, function(err,results,fields){

    if (err) throw err;
    console.log("compagnia inserita");
    console.log(results);

});
*/

pool.query(`INSERT DIPENDENTE(CodiceFiscale, Nome, Cognome, Email, Telefono, Nazionalita, DataDiNascita) 
VALUES('RSIMROJ60M21G','Mario','Rossi',"mario.rossi@gmail.com",
"3458761213","italiana",1990-03-12) ;`, function(err,results,fields){
    if (err) throw err;
    console.log("dipendente inserita");
})
