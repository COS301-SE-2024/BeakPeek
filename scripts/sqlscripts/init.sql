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
    Jan DECIMAL(5,2),
    Feb DECIMAL(5,2),
    Mar DECIMAL(5,2),
    Apr DECIMAL(5,2),
    May DECIMAL(5,2),
    Jun DECIMAL(5,2),
    Jul DECIMAL(5,2),
    Aug DECIMAL(5,2),
    Sep DECIMAL(5,2),
    Oct DECIMAL(5,2),
    Nov DECIMAL(5,2),
    Dec DECIMAL(5,2),
    Total_Records INT,
    Total_Cards INT,
    ReportingRate DECIMAL(5,2)
);
GO
-- LOAD DATA INFILE '../../res/species/province_gauteng_specieslist.csv'
-- INTO TABLE GautengBirdSpecies
-- FIELDS TERMINATED BY ';'
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (Pentad, Spp, Common_group, Common_species, Genus, Species, Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec, Total_Records, Total_Cards, ReportingRate);
