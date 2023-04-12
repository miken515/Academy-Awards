-- RESETING TABLE IF CHANGES ARE NEEDED
DROP TABLE IF EXISTS movieNomination;
DROP TABLE IF EXISTS yearCeremony;
DROP TABLE IF EXISTS awardCategory;
DROP TABLE IF EXISTS nomineeName;
DROP TABLE IF EXISTS movieNomination;
DROP TABLE IF EXISTS Person_Nominations;
DROP TABLE IF EXISTS movies_and_nominations;
DROP TABLE IF EXISTS year_and_nominations;


/* !!! NORMALIZING DATA FROM CSV FILES !!! */ -- FIXME

create table movieNomination (
	
    filmID int auto_increment,
    filmName varchar(250),
    constraint pk_movieNomination primary key (filmID)
);

insert into movieNomination (filmName)
Select  distinct film
from academy_award;

-- YEAR CEREMONY TABLE _____________________________
create table yearCeremony (
	ceremony int,
	yearFilm varchar(20),
    constraint pk_yearCeremony primary key (ceremony)
);

insert into yearceremony (ceremony, yearFilm)
select distinct ceremony, SUBSTRING_INDEX(year,'/' ,1) AS year 
from academy_award;

-- AWARD CATEGORY TABLE _____________________________
create table awardCategory (
    categoryID int not null auto_increment,
    award_category varchar(300),
    constraint pk_award primary key (categoryID)
    );

insert into awardCategory (award_category)
select distinct award from academy_award;


-- NOMINEE NAMES TABLE ______________________________
create table nomineeName (
	nomineeNameID int not null auto_increment,
	personName varchar(200),
    constraint pk_names primary key (nomineeNameID)
);

insert into nomineeName (personName)
select
distinct name
from academy_award;


/* !!! MAKING THE NORMALIZED CSV FILES AND EXISTING DATA MODEL MERGE !!! */

-- FITTING PERSON TABLE TO FIT EXISTING DATA MODEL

create table  Person_Nominations(
	person_id int,
    nominee_name_id int,
    nominee_name varchar(200),
    constraint pk_person_nominations primary key (person_id, nominee_name_id)
);

insert into Person_Nominations (person_id, nominee_name_id, nominee_name)
Select p.person_id, nn.nomineeNameID, nn.personName
from person p
join nomineeName nn on p.person_name = nn.personName;

-- FITTING MOVIE TO EXISTING DATA MODEL..


create table movies_and_nominations(
	movie_id int,
    movie_title varchar(300),
    constraint pk_person_nominations primary key (movie_id)
);

insert into movies_and_nominations(movie_id, movie_title)
select m.movie_id, mn.filmName
from movie m 
join movieNomination mn on m.title = mn.filmName;


-- FITTING YEAR-CEREMONY TO EXISTING DATA MODEL...
create table year_and_nominations(
movie_id int, 
ceremony int, 
year_film varchar(20), 
constraint pk_year_nominations primary key (movie_id, ceremony)
);

insert into year_and_nominations(movie_id, ceremony, year_film)
select m.movie_id, yc.ceremony, yc.yearFilm
from movie m 
join yearCeremony yc on year(m.release_date) = yc.yearFilm;


-- ANALYZING EXISTING DATA MODEL..
select * from academy_award;
select * from movie;
select * from person;
select * from movie_cast;
select * from movie_crew;

-- TESTING NORMALIZED TABLES / ANALYZING NORMALIZED TABLE...
select * from movieNomination; 
select * from yearceremony; 
select * from awardcategory; 
select * from nomineename; 

-- TESTING IF EVERYTHING MATCHES UP WHEN IT COMES TO FITTING INTO EXISTING DATA MODEL
select * from person_nominations; 
select * from movies_and_nominations; 
select * from year_and_nominations;




