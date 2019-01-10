var mysql = require('mysql');
const express = require('express');
var app = express();

var path = __dirname + '/views/' ;


app.get("/",function(req,res,next){
    res.sendFile(path + "index.html");
});

app.get("/create",function(req,res,next){

    var pool  = mysql.createPool({
        connectionLimit : 100, //?
        host            : 'phpmyadmin.web.cs.unibo.it',
        user            : 'my1901',
        password        : '',
        database        : 'my1901'
    });
    
    
    pool.query(`CREATE TABLE IF NOT EXISTS COMPAGNIA (
        CodiceCompagnia VARCHAR(10) PRIMARY KEY,
        Nome VARCHAR(30) NOT NULL,
        Nazione VARCHAR(20) NOT NULL
    );`, function (err, results, fields) {
        if (err) console.log(err);
        else {
            console.log("Compagnia created");
            res.sendStatus(200);
        }
        
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
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS EQUIPAGGIO (
        CodiceEquipaggio VARCHAR(10),
        Compagnia VARCHAR(30),
        PRIMARY KEY (CodiceEquipaggio , Compagnia),
        FOREIGN KEY (Compagnia)
            REFERENCES COMPAGNIA (CodiceCompagnia)
            ON UPDATE CASCADE ON DELETE CASCADE
    );`, function (err, results, fields) {
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS TRATTA (
        Nome VARCHAR(50) PRIMARY KEY,
        CHECK (Nome LIKE '%-%')
    );`, function (err, results, fields) {
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS DIPENDENTE (
        CodiceFiscale VARCHAR(16) PRIMARY KEY,
        Nome VARCHAR(20) NOT NULL,
        Cognome VARCHAR(20) NOT NULL,
        Email VARCHAR(40),
        Telefono VARCHAR(15),
        Nazionalita VARCHAR(10),
        DataDiNascita DATE,
        Compagnia VARCHAR(10),
        FOREIGN KEY (Compagnia)
            REFERENCES COMPAGNIA (CodiceCompagnia)
            ON UPDATE CASCADE ON DELETE SET NULL
    );`, function (err, results, fields) {
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS COMANDANTE (
        Dipendente VARCHAR(16) PRIMARY KEY,
        Equipaggio VARCHAR(10),
        Compagnia VARCHAR(10),
        Formazione VARCHAR(5),
        CHECK (Formazione LIKE 'PPL' OR 'CPL' OR 'ATPL'),
        UNIQUE (Equipaggio , Compagnia),
        FOREIGN KEY (Equipaggio , Compagnia)
            REFERENCES EQUIPAGGIO (CodiceEquipaggio , Compagnia)
            ON UPDATE CASCADE ON DELETE SET NULL,
        FOREIGN KEY (Dipendente)
            REFERENCES DIPENDENTE (CodiceFiscale)
            ON UPDATE CASCADE ON DELETE CASCADE
    );`, function (err, results, fields) {
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS HOSTESS_STUART (
        Dipendente VARCHAR(16) PRIMARY KEY,
        Equipaggio VARCHAR(10),
        Compagnia VARCHAR(10) REFERENCES COMPAGNIA (CodiceCompagnia),
        FOREIGN KEY (Equipaggio , Compagnia)
            REFERENCES EQUIPAGGIO (CodiceEquipaggio , Compagnia)
            ON UPDATE CASCADE ON DELETE SET NULL,
        FOREIGN KEY (Dipendente)
            REFERENCES DIPENDENTE (CodiceFiscale)
            ON UPDATE CASCADE ON DELETE CASCADE
    );`, function (err, results, fields) {
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS PASSEGGERO (
        CodiceFiscale VARCHAR(16) PRIMARY KEY,
        Nome VARCHAR(20) NOT NULL,
        Cognome VARCHAR(20) NOT NULL,
        Disabile BOOLEAN,
        Email VARCHAR(40),
        Telefono VARCHAR(15),    
        DataDiNascita DATE,
        Nazionalita VARCHAR(10)
    );`, function (err, results, fields) {
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS VOLO (
        CodiceVolo VARCHAR(10) PRIMARY KEY,
        Stato VARCHAR(10),
        Carburante INT,
        CHECK (Stato LIKE 'check-in' OR 'boarding'
            OR 'canceled'
            OR 'delayed'
            OR 'departed')
    );`, function (err, results, fields) {
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS DISPOSIZIONE (
        Velivolo VARCHAR(10) NOT NULL,
        Compagnia VARCHAR(10) NOT NULL,
        Volo VARCHAR(10) PRIMARY KEY,
        FOREIGN KEY (Velivolo , Compagnia)
            REFERENCES VELIVOLO (CodiceVelivolo , Compagnia)
            ON UPDATE CASCADE ON DELETE CASCADE,
        FOREIGN KEY (Volo)
            REFERENCES VOLO (CodiceVolo)
            ON UPDATE CASCADE ON DELETE CASCADE
    );`, function (err, results, fields) {
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS ASSEGNAZIONE (
        Equipaggio VARCHAR(10) NOT NULL,
        Compagnia VARCHAR(30) NOT NULL,
        Volo VARCHAR(10) PRIMARY KEY,
        FOREIGN KEY (Equipaggio , Compagnia)
            REFERENCES EQUIPAGGIO (CodiceEquipaggio , Compagnia)
            ON UPDATE CASCADE ON DELETE CASCADE,
        FOREIGN KEY (Volo)
            REFERENCES VOLO (CodiceVolo)
            ON UPDATE CASCADE ON DELETE CASCADE
    );`, function (err, results, fields) {
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS BIGLIETTO (
        CodiceBiglietto VARCHAR(10) PRIMARY KEY,
        Costo FLOAT(2),
        Posto INT,
        Bagagli INT,
        Check_in BOOLEAN
    );`, function (err, results, fields) {
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS ACQUISTO (
        Biglietto VARCHAR(10) PRIMARY KEY,
        Volo VARCHAR(10),
        Passeggero VARCHAR(16),
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
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS AEROPORTO (
        Sigla VARCHAR(10) PRIMARY KEY
    );`, function (err, results, fields) {
        if (err) console.log(err);
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS PARTENZA (
        Volo VARCHAR(10) PRIMARY KEY,
        Data TIME,
        ORA TIME,
        Aeroporto VARCHAR(5),
        FOREIGN KEY (Volo)
            REFERENCES VOLO (CodiceVolo)
            ON UPDATE CASCADE ON DELETE CASCADE,
        FOREIGN KEY (Aeroporto)
            REFERENCES AEROPORTO (Sigla)
            ON UPDATE CASCADE ON DELETE CASCADE
    );`, function (err, results, fields) {
        if (err) console.log(err);
        else {
            console.log("Compagnia created");
            res.sendStatus(200);
        }
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS DESTINAZIONE (
        Volo VARCHAR(10) PRIMARY KEY,
        Data TIME,
        ORA TIME,
        Aeroporto VARCHAR(5),
        FOREIGN KEY (Volo)
            REFERENCES VOLO (CodiceVolo)
            ON UPDATE CASCADE ON DELETE CASCADE,
        FOREIGN KEY (Aeroporto)
            REFERENCES AEROPORTO (Sigla)
            ON UPDATE CASCADE ON DELETE CASCADE
    );`, function (err, results, fields) {
        if (err) console.log(err);
        else {
            console.log("Compagnia created");
            res.sendStatus(200);
        }
    });
    
    pool.query(`CREATE TABLE IF NOT EXISTS PERCORRENZA (
        Equipaggio VARCHAR(10),
        Compagnia VARCHAR(30),
        Tratta VARCHAR(50),
        FOREIGN KEY (Tratta)
            REFERENCES TRATTA (Nome)
            ON UPDATE CASCADE ON DELETE CASCADE,
        FOREIGN KEY (Equipaggio , Compagnia)
            REFERENCES EQUIPAGGIO (CodiceEquipaggio , Compagnia)
            ON UPDATE CASCADE ON DELETE CASCADE,
        PRIMARY KEY (Equipaggio , Compagnia , Tratta)
    );`,function(err,results,fields){
        if (err) console.log(err);
    });

    res.sendStatus(200);
})

app.get("/sql",function(req,res,next){

    var pool  = mysql.createPool({
        host            : 'phpmyadmin.web.cs.unibo.it',
        user            : 'my1901',
        password        : '',
        database        : 'my1901'
    });

    
        pool.query(req.query.q, 
            function(err,results,fields){
    
                if (err){
                    res.send({err : err});
                }
                else{
                    console.log(results);
                    res.send(results);
                }
        
            });
})

app.listen(8000, ()=>{
    console.log("listening on 8000");
});
/*
test per insert
pool.query(`SELECT * FROM COMPAGNIA ;`, function(err,results,fields){

    if (err) throw err;
    console.log("compagnia inserita");
    console.log(results);

});
*/

