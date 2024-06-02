USE BeakPeek;
GO
BULK INSERT GautengBirdSpecies
FROM '/tmp/province_gauteng_specieslist.csv'
WITH (
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
GO
ALTER TABLE GautengBirdSpecies ADD id INT IDENTITY(1,1) NOT NULL
GO
