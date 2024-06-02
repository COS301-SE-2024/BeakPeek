CREATE DATABASE BeakPeek;
GO
USE BeakPeek;
GO
DROP TABLE IF EXISTS GautengBirdSpecies;
GO
CREATE TABLE GautengBirdSpecies (
    Pentad VARCHAR(10),
    Spp INT,
    Common_group VARCHAR(50),
    Common_species VARCHAR(50),
    Genus VARCHAR(50),
    Species VARCHAR(50),
    Jan FLOAT,
    Feb FLOAT,
    Mar FLOAT,
    Apr FLOAT,
    May FLOAT,
    Jun FLOAT,
    Jul FLOAT,
    Aug FLOAT,
    Sep FLOAT,
    Oct FLOAT,
    Nov FLOAT,
    Dec FLOAT,
    Total_Records INT,
    Total_Cards INT,
    ReportingRate FLOAT
);
GO
