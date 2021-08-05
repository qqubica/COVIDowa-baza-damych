DROP TABLE LEKARZ;

DROP TABLE ZARAZONY;

DROP TABLE ZMARLY;

DROP TABLE SZPITAL;

DROP TABLE TESTNACOVID;

DROP TABLE SZPITALRODZAJ;

DROP TABLE SPECJALIZACJA;

DROP TABLE RODZAJTESTU;

DROP TABLE DANEOSOBOWE;

DROP TABLE ADRES;

DROP TABLE MIASTO;

DROP TABLE WOJEWODZTWO;

COMMIT;

-- tables

-- Table: Adres
CREATE TABLE Adres (
    IdAdres integer  NOT NULL,
    IdMiasto integer  NOT NULL,
    Ulica varchar2(50)  NOT NULL,
    NrBudynku varchar2(50)  NOT NULL,
    NrLokalu varchar2(10)  NULL,
    CONSTRAINT Adres_pk PRIMARY KEY (IdAdres)
) ;

-- Table: DaneOsobowe
CREATE TABLE DaneOsobowe (
    IdOsoba integer  NOT NULL,
    Imie varchar2(50)  NOT NULL,
    Nazwisko varchar2(50)  NOT NULL,
    IdAdres integer  NOT NULL,
    DataUrodzenia date  NOT NULL,
    Plec char(1)  NOT NULL,
    CONSTRAINT DaneOsobowe_pk PRIMARY KEY (IdOsoba)
) ;

-- Table: Lekarz
CREATE TABLE Lekarz (
    IdOsoba integer  NOT NULL,
    IdSpecjalizacja integer  NOT NULL,
    IdSzpital integer  NOT NULL,
    CONSTRAINT Lekarz_pk PRIMARY KEY (IdOsoba)
) ;

-- Table: Miasto
CREATE TABLE Miasto (
    IdMiasto integer  NOT NULL,
    IdWojewodztwo integer  NOT NULL,
    NazwaMiasto varchar2(50)  NOT NULL,
    CONSTRAINT Miasto_pk PRIMARY KEY (IdMiasto)
) ;

-- Table: RodzajTestu
CREATE TABLE RodzajTestu (
    IdRodzaj integer  NOT NULL,
    NazwaTestu varchar2(50)  NOT NULL,
    CONSTRAINT RodzajTestu_pk PRIMARY KEY (IdRodzaj)
) ;

-- Table: Specjalizacja
CREATE TABLE Specjalizacja (
    IdSpecjalizacja integer  NOT NULL,
    Specjalizacja varchar2(50)  NOT NULL,
    CONSTRAINT Specjalizacja_pk PRIMARY KEY (IdSpecjalizacja)
) ;

-- Table: Szpital
CREATE TABLE Szpital (
    IdSzpital integer  NOT NULL,
    Nazwa varchar2(50)  NOT NULL,
    IdAdres integer  NOT NULL,
    IloscLozek integer  NOT NULL,
    IdSpecjalizacja integer  NULL,
    IdSzpitalRodzaj integer  NOT NULL,
    CONSTRAINT Szpital_pk PRIMARY KEY (IdSzpital)
) ;

-- Table: SzpitalRodzaj
CREATE TABLE SzpitalRodzaj (
    IdRodzaj integer  NOT NULL,
    Rodzaj varchar2(50)  NOT NULL,
    CONSTRAINT SzpitalRodzaj_pk PRIMARY KEY (IdRodzaj)
) ;

-- Table: TestNaCovid
CREATE TABLE TestNaCovid (
    IdTest integer  NOT NULL,
    IdOsoba integer  NOT NULL,
    TestWynik char(1)  NOT NULL,
    TestData date  NOT NULL,
    IdRodzaj integer  NOT NULL,
    CONSTRAINT TestNaCovid_pk PRIMARY KEY (IdTest)
) ;

-- Table: Wojewodztwo
CREATE TABLE Wojewodztwo (
    IdWojewodztwo integer  NOT NULL,
    NazwaWojewodztwo varchar2(50)  NOT NULL,
    CONSTRAINT Wojewodztwo_pk PRIMARY KEY (IdWojewodztwo)
) ;

-- Table: Zarazony
CREATE TABLE Zarazony (
    IdZarazony integer  NOT NULL,
    IdTest integer  NOT NULL,
    IdSzpital integer  NOT NULL,
    CONSTRAINT Zarazony_pk PRIMARY KEY (IdZarazony)
) ;

-- Table: Zmarly
CREATE TABLE Zmarly (
    IdZmarly integer  NOT NULL,
    DataSmierci date  NOT NULL,
    IdOsoba integer  NOT NULL,
    CONSTRAINT Zmarly_pk PRIMARY KEY (IdZmarly)
) ;

-- foreign keys
-- Reference: Adres_Miasta (table: Adres)
ALTER TABLE Adres ADD CONSTRAINT Adres_Miasta
    FOREIGN KEY (IdMiasto)
    REFERENCES Miasto (IdMiasto);

-- Reference: Dane_osobowe_Adres (table: DaneOsobowe)
ALTER TABLE DaneOsobowe ADD CONSTRAINT Dane_osobowe_Adres
    FOREIGN KEY (IdAdres)
    REFERENCES Adres (IdAdres);

-- Reference: Lekarz_Dane_osobowe (table: Lekarz)
ALTER TABLE Lekarz ADD CONSTRAINT Lekarz_Dane_osobowe
    FOREIGN KEY (IdOsoba)
    REFERENCES DaneOsobowe (IdOsoba);

-- Reference: Lekarz_Specjalizacja_szpitala (table: Lekarz)
ALTER TABLE Lekarz ADD CONSTRAINT Lekarz_Specjalizacja_szpitala
    FOREIGN KEY (IdSpecjalizacja)
    REFERENCES Specjalizacja (IdSpecjalizacja);

-- Reference: Lekarz_Szpital (table: Lekarz)
ALTER TABLE Lekarz ADD CONSTRAINT Lekarz_Szpital
    FOREIGN KEY (IdSzpital)
    REFERENCES Szpital (IdSzpital);

-- Reference: Miasto_Wojewodztwo (table: Miasto)
ALTER TABLE Miasto ADD CONSTRAINT Miasto_Wojewodztwo
    FOREIGN KEY (IdWojewodztwo)
    REFERENCES Wojewodztwo (IdWojewodztwo);

-- Reference: Specjalizacja_szpitala (table: Szpital)
ALTER TABLE Szpital ADD CONSTRAINT Specjalizacja_szpitala
    FOREIGN KEY (IdSpecjalizacja)
    REFERENCES Specjalizacja (IdSpecjalizacja);

-- Reference: Szpitale_Adres (table: Szpital)
ALTER TABLE Szpital ADD CONSTRAINT Szpitale_Adres
    FOREIGN KEY (IdAdres)
    REFERENCES Adres (IdAdres);

-- Reference: Szpitale_Rodzaj_szpitala (table: Szpital)
ALTER TABLE Szpital ADD CONSTRAINT Szpitale_Rodzaj_szpitala
    FOREIGN KEY (IdSzpitalRodzaj)
    REFERENCES SzpitalRodzaj (IdRodzaj);

-- Reference: Testy_na_covid_Dane_osobowe (table: TestNaCovid)
ALTER TABLE TestNaCovid ADD CONSTRAINT Testy_na_covid_Dane_osobowe
    FOREIGN KEY (IdOsoba)
    REFERENCES DaneOsobowe (IdOsoba);

-- Reference: Testy_na_covid_Rodzaje_testow (table: TestNaCovid)
ALTER TABLE TestNaCovid ADD CONSTRAINT Testy_na_covid_Rodzaje_testow
    FOREIGN KEY (IdRodzaj)
    REFERENCES RodzajTestu (IdRodzaj);

-- Reference: Zarazeni_Covid_Testy_na_covid (table: Zarazony)
ALTER TABLE Zarazony ADD CONSTRAINT Zarazeni_Covid_Testy_na_covid
    FOREIGN KEY (IdTest)
    REFERENCES TestNaCovid (IdTest);

-- Reference: Zarazony_Covid_Szpital (table: Zarazony)
ALTER TABLE Zarazony ADD CONSTRAINT Zarazony_Covid_Szpital
    FOREIGN KEY (IdSzpital)
    REFERENCES Szpital (IdSzpital);

-- Reference: Zmarly_DaneOsobowe (table: Zmarly)
ALTER TABLE Zmarly ADD CONSTRAINT Zmarly_DaneOsobowe
    FOREIGN KEY (IdOsoba)
    REFERENCES DaneOsobowe (IdOsoba);

COMMIT;
-- End of file.