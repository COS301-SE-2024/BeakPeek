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
