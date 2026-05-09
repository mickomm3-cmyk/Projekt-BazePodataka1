DROP DATABASE IF EXISTS sustav_za_upravljanje_restoranom;
CREATE DATABASE sustav_za_upravljanje_restoranom;
USE sustav_za_upravljanje_restoranom;
-- ---Korado Brajuha----------------------------
CREATE TABLE Zaposlenik (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    ime VARCHAR(30) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    datum_zaposlenja DATE NOT NULL,
    pozicija_zaposlenika VARCHAR(50) NOT NULL,
    placa_zaposlenika DECIMAL(6, 2) NOT NULL
);

CREATE TABLE Stol (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    broj_stola INT NOT NULL UNIQUE,
    kapacitet_stola INT NOT NULL,
    trenutna_zauzetost_stola BOOL NOT NULL
);

CREATE TABLE Jelovnik (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    naziv_kategorije VARCHAR(40) NOT NULL
);

CREATE TABLE Jelo (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    naziv_jela VARCHAR(50) NOT NULL UNIQUE,
    cijena_jela DECIMAL(5, 2) NOT NULL,
    Trosak_pripravka_jela DECIMAL(5, 2) NOT NULL,
    Jelovnik_id INTEGER NOT NULL,
    FOREIGN KEY (Jelovnik_id) REFERENCES Jelovnik (id)
);

create table Specijalna_ponuda (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    Jelo_id INTEGER NOT NULL,
    FOREIGN KEY (Jelo_id) REFERENCES Jelo (id),
    ponuden_popust DECIMAL(5, 2) NOT NULL,
    pridodana_svojstva VARCHAR(40) NOT NULL
);
-- ---Antonio Đusti----------------------------
CREATE TABLE VIP_gosti (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    mjesecni_popust DECIMAL(4, 2) NOT NULL,
    Specijalna_ponuda_id INTEGER NOT NULL,
    FOREIGN KEY (Specijalna_ponuda_id) REFERENCES Specijalna_ponuda (id)
);

CREATE TABLE Kupac (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    ime VARCHAR(30) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    VIP_gosti_id INTEGER NULL,
    FOREIGN KEY (VIP_gosti_id) REFERENCES VIP_gosti (id)
);

CREATE TABLE Rezervacije (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    Stol_id INTEGER NOT NULL,
    FOREIGN KEY (Stol_id) REFERENCES Stol (id),
    vrijeme_rezervacije DATETIME NOT NULL,
    Kupac_id INTEGER NOT NULL,
    FOREIGN KEY (Kupac_id) REFERENCES Kupac (id)
);
 --ivor---
CREATE TABLE Narudzbe (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    vrijeme_narudzbe DATETIME NOT NULL,
    Stol_id INTEGER NOT NULL,
    FOREIGN KEY (Stol_id) REFERENCES Stol (id),
    Rezervacije_id INTEGER NULL,
    FOREIGN KEY (Rezervacije_id) REFERENCES Rezervacije (id),
    Kupac_id INTEGER NOT NULL,
    FOREIGN KEY (Kupac_id) REFERENCES Kupac (id),
    Zaposlenik_id INTEGER NOT NULL,
    FOREIGN KEY (Zaposlenik_id) REFERENCES Zaposlenik (id)
);
 --ivor---
CREATE TABLE Stavka_Narudzbe (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    Narudzbe_id INTEGER NOT NULL,
    FOREIGN KEY (Narudzbe_id) REFERENCES Narudzbe (id),
    Jelo_id INTEGER NOT NULL,
    FOREIGN KEY (Jelo_id) REFERENCES Jelo (id),
    kolicina INTEGER NOT NULL
);
 --ivor---
CREATE TABLE Placanje (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    Narudzbe_id INTEGER NOT NULL,
    FOREIGN KEY (Narudzbe_id) REFERENCES Narudzbe (id),
    iznos DECIMAL(5, 2) NOT NULL,
    nacin_placanja VARCHAR(50) NOT NULL
);
-- ---Antonio Đusti----------------------------
CREATE TABLE Dostava (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    Kupac_id INTEGER NOT NULL,
    FOREIGN KEY (Kupac_id) REFERENCES Kupac (id),
    Zaposlenik_id INTEGER NOT NULL,
    FOREIGN KEY (Zaposlenik_id) REFERENCES Zaposlenik (id),
    Narudzbe_id INTEGER  NOT NULL,
    FOREIGN KEY (Narudzbe_id) REFERENCES Narudzbe (id),
    vrijeme_dostave DATETIME NOT NULL
);
 --ivor---
CREATE TABLE Racuni_prihodi (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    iznos_racuna DECIMAL(6,2) NOT NULL,
    vrijeme_izdavanja_racuna DATETIME NOT NULL,
    status_racuna VARCHAR(20) NOT NULL,
    Placanje_id INTEGER NOT NULL,
    FOREIGN KEY (Placanje_id) REFERENCES Placanje (id)
);
-- ---Alex Mihatović----------------------------
CREATE TABLE Resursi (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(50) NOT NULL,
    kolicina_resursa INT NOT NULL,
    vrijednost_resursa DECIMAL(6, 2) NOT NULL
);

CREATE TABLE Nabava_resursi (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    Resursi_id INTEGER NOT NULL,
    FOREIGN KEY (Resursi_id) REFERENCES Resursi (id),
    cijena DECIMAL(6, 2) NOT NULL,
    kolicina INTEGER NOT NULL,
    datum_nabave DATE NOT NULL
);

CREATE TABLE Racuni_rashodi (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    vrsta_rashoda VARCHAR(50) NOT NULL,
    vrijeme_izdavanja_racuna DATETIME NOT NULL,
    Nabava_resursi_id INTEGER NOT NULL,
    FOREIGN KEY (Nabava_resursi_id) REFERENCES Nabava_resursi (id),
    iznos DECIMAL(6,2) NOT NULL,
    status_racuna VARCHAR(20) NOT NULL
);

CREATE TABLE Obracun_prihoda_i_rashoda (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    Racuni_prihodi_id INTEGER NOT NULL,
    FOREIGN KEY (Racuni_prihodi_id) REFERENCES Racuni_prihodi (id),
    Racuni_rashodi_id INTEGER NOT NULL,
    FOREIGN KEY (Racuni_rashodi_id) REFERENCES Racuni_rashodi (id),
    konacni_iznos DECIMAL(6,2) NOT NULL
);
-- ---Korado Brajuha----------------------------
CREATE TABLE Bilanca (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	Obracun_prihoda_i_rashoda_id INTEGER NOT NULL,
    FOREIGN KEY (Obracun_prihoda_i_rashoda_id) REFERENCES Obracun_prihoda_i_rashoda (ID),
	Resursi_id INTEGER NOT NULL,
    FOREIGN KEY (Resursi_id) REFERENCES Resursi (id),
    stanje_prije DECIMAL(8,2) NOT NULL,
    stanje_poslije DECIMAL(8,2) NOT NULL,
    datum_bilance DATE NOT NULL
);
