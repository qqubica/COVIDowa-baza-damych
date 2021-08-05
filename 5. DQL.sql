--5 poleceñ SELECT z warunkiem WHERE

--1. Wypisz id, wyniki, daty testów które by przeprowadzne testem RT-PCR

SELECT IdTest, TestWynik, TestData
FROM TestNaCovid
WHERE IdRodzaj = (
                    Select IdRodzaj
                    From RodzajTestu
                    Where NazwaTestu Like '%RT-PCR%'
                );

--2. Wypisz imiona i nazwiska wszystkich osób z bazy które nie sa lekarzami.

SELECT Imie || ' ' || Nazwisko "Imie i Nazwisko"
FROM DaneOsobowe
WHERE IdOsoba NOT IN (
                        SELECT IdOsoba
                        FROM Lekarz
                    )
ORDER BY IMIE ASC;

--3. Wypisz id, wyniki i daty wszystkie pozytywne testy

SELECT IdTest "Id", TestWynik "Wynik", TestData "Data przeprowadzenia" FROM TestNaCovid
WHERE TestWynik = 1
ORDER BY TestData;

--4. wypisz szpitale w którch jest co najmniej 30 wolnych miejsc

SELECT IdSzpital, Nazwa, IloscLozek - (
                                    SELECT COUNT(1)
                                    FROM Zarazony
                                    WHERE ZARAZONY.IDSZPITAL = SZPITAL.IDSZPITAL
                                ) AS "Ilosc wolnych lozek"
FROM SZPITAL
WHERE iloscLozek - (
                                    SELECT COUNT(1)
                                    FROM zarazony
                                    WHERE ZARAZONY.IDSZPITAL = SZPITAL.IDSZPITAL
                                ) >= 30;
                    
--5. Wypisz imiê, nazwisko i date urodzenia osób zmarych

SELECT Imie || ' ' || Nazwisko "Imie i Nazwisko"
FROM daneosobowe
WHERE Idosoba in (
                    SELECT idosoba
                    FROM zmarly
                );
                

                
--5 poleceñ SELECT ze z³¹czeniem tabel          

--6. Wypisz Id, imiê i nazwisko, specjalizacje wszystkich lekarzy

SELECT Dane.IdOsoba "Id", Dane.Imie || ' ' || Dane.Nazwisko "Imie i Nazwisko", Spec.Specjalizacja
FROM DaneOsobowe Dane
JOIN Lekarz Lek ON Lek.IdOsoba = Dane.IdOsoba
JOIN Specjalizacja Spec ON Spec.IdSpecjalizacja = Lek.IdSpecjalizacja
ORDER BY Dane.IdOsoba;

--7.  Wyszpisz nazwy szpitali i ich adresy

Select Szpital.Nazwa, Adres.Ulica || ' ' || Adres.Nrbudynku "Adres", 'w ' || Miasto.Nazwamiasto || '(' || Wojewodztwo.Nazwawojewodztwo || ')' "miasto(województwo)" 
From Szpital
Join Adres On Adres.IdAdres = Szpital.IdAdres
Join Miasto On Miasto.IdMiasto = Adres.IdMiasto
Join Wojewodztwo On Wojewodztwo.IdWojewodztwo = Miasto.IdWojewodztwo;

--8. Wypisz imiona i nazwiska wszystkich z bazy i ich adresy

Select Imie, Nazwisko, Adres.Ulica || ' ' || Adres.NrBudynku "adres", 'w ' || Miasto.NazwaMiasto || '(' || Wojewodztwo.NazwaWojewodztwo || ')' "miasto(województwo)"
From DaneOsobowe
Join Adres On Adres.IdAdres = DaneOsobowe.IdAdres
Join Miasto On Miasto.IdMiasto = Adres.IdMiasto
Join Wojewodztwo On Wojewodztwo.IdWojewodztwo = Miasto.IdWojewodztwo;

--9. Wypisz imiona i nazwiska wszystkich ktorzy sa w szpitalu o id 1

Select Imie, Nazwisko
From DaneOsobowe
Join TestNaCovid On TestNaCovid.IdOsoba = DaneOsobowe.IdOsoba
Join Zarazony On Zarazony.IdTest = TestNaCovid.IdTest
Where Zarazony.IdSzpital = 1;

--10. Wypisz wszystkich ktorzy leza w szpitalach tymczasowych

Select Imie, Nazwisko
From DaneOsobowe
Join TestNaCovid On TestNaCovid.IdOsoba = DaneOsobowe.IdOsoba
Join Zarazony On Zarazony.IdTest = TestNaCovid.IdTest
Join Szpital On Szpital.IdSzpital = Zarazony.IdSzpital
Join SzpitalRodzaj On SzpitalRodzaj.IdRodzaj = Szpital.IdSzpitalRodzaj
Where SzpitalRodzaj.Rodzaj Like 'TYMCZASOWY';

--5 poleceñ SELECT z klauzul¹ GROUP BY, w tym co najmniej 2 z klauzul¹ HAVING.

--11 ile jest szpitali w kazdym z WOJEWÓDZTW

Select 'W ' || W.NazwaWojewodztwo || ' JEST ' || Count(1) || ' SZPITALI'
From Szpital
Join Adres A On A.IdAdres = Szpital.IdAdres
Join Miasto M On A.IdMiasto = M.IdMiasto
Join Wojewodztwo W On W.IdWojewodztwo = M.IdWojewodztwo
Group By W.IdWojewodztwo, W.NazwaWojewodztwo;

--12. wypisz imiê, nazwisko i date urodzenia najstarszego lekaza z kazdego ze szpitali

SELECT IMIE, NAZWISKO
FROM DANEOSOBOWE
GROUP BY IMIE, NAZWISKO, DATAURODZENIA
HAVING DATAURODZENIA = MAX(DATAURODZENIA)

Select Imie, Nazwisko, DataUrodzenia
From DaneOsobowe
Join Lekarz On Lekarz.IdOsoba = DaneOsobowe.IdOsoba
Group By Lekarz.IdSzpital, Imie, Nazwisko, DataUrodzenia
Having DataUrodzenia = MAX(DataUrodzenia);

--13. Wypisz imie, nazwisko, date urodzenia najmlodszego z pacjetów le¿acych w ka¿dym ze szpitali

Select Imie, Nazwisko, DataUrodzenia
From DaneOsobowe
Join TestNaCovid On TestNaCovid.IdOsoba = DaneOsobowe.IdOsoba
Join Zarazony On Zarazony.IdTest = TestNaCovid.IdTest
Group By Zarazony.IdSzpital, Imie, Nazwisko, DataUrodzenia
Having DataUrodzenia = Max(DataUrodzenia);

--14. WYPISZ IMIE, NAZWISKO, WIEK OSÓB KTORE WYZDROWIALY Z COVID i maja nie mnie niz 25 lat

Select Imie, Nazwisko, To_Char(Sysdate, 'YYYY') - To_Char(DataUrodzenia, 'YYYY') "Aktualny wiek"
From DaneOsobowe
Join TestNaCovid On TestNaCovid.IdOsoba = DaneOsobowe.IdOsoba
Where (
        Select Min(TestData)
        From TestNaCovid
        Where TestNaCovid.IdOsoba = DaneOsobowe.IdOsoba
            And TestWynik = 1) < (
                                    Select Max(TestData)
                                    From TestNaCovid
                                    Where TestNaCovid.IdOsoba = DaneOsobowe.IdOsoba
                                        And TestWynik = 0)
Group By DaneOsobowe.IdOsoba , Imie, Nazwisko, DataUrodzenia                               
Having To_Char(Sysdate, 'YYYY') - To_Char(Dataurodzenia, 'YYYY') > 25
Order By 3;

--15. Wypisz ile jest osób chorych na covid w kazdym z miast pod warunkiem ze jest w nim wiecej horych niz zdrowych

Select 'Wiecej chorych niz zdorwych jest w ' || M1.NazwaMiasto || '('|| Count(1) || ' chorych)' " "
From DaneOsobowe D1
Join TestNaCovid On TestNaCovid.IdOsoba = D1.IdOsoba
Join Adres On Adres.IdAdres = D1.IdAdres
Join Miasto M1 On M1.IdMiasto = Adres.IdMiasto
Where TestNaCovid.TestWynik = 1
    And TestNaCovid.TestData = (
                                    Select Max(TestData)
                                    From TestNaCovid
                                    Where TestNaCovid.IdOsoba = D1.IdOsoba
                                )
Group By M1.NazwaMiasto, M1.IdMiasto
Having Count(1) > (
                    Select Count(1)
                    From DaneOsobowe D2
                    Join TestNaCovid On TestNaCovid.IdOsoba = D2.IdOsoba
                    Join Adres On Adres.IdAdres = D2.IdAdres
                    Join Miasto M2 On M2.IdMiasto = Adres.IdMiasto
                    Where TestNaCovid.TestWynik = 0
                        And M2.IdMiasto = M1.IdMiasto
)
Order By Count(1);


