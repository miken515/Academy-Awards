DROP TABLE IF EXISTS streaming_service_users;
DROP TABLE IF EXISTS streaming_service;
DROP TABLE IF EXISTS users_rating;
DROP PROCEDURE IF EXISTS add_users;
DROP PROCEDURE IF EXISTS update_user_email;
DROP PROCEDURE IF EXISTS update_user_password;
DROP PROCEDURE IF EXISTS delete_user;
DROP PROCEDURE IF EXISTS add_streaming_services;
DROP PROCEDURE IF EXISTS add_user_review;
DROP PROCEDURE IF EXISTS users_and_reviews;

-- tables
create table streaming_service_users (
	user_id int not null auto_increment,
	user_name varchar(100),
    first_name varchar(50),
    last_name varchar(50),
    user_email varchar(100),
    user_password varchar(100),
    constraint pk_stream_service_users primary key (user_id)
);

create table streaming_service (
	streaming_service_id int not null auto_increment,
    streaming_service_name varchar(50),
    constraint pk_streaming_service primary key(streaming_service_id)
);

create table users_rating (
	user_id int,
    rating int,
    movie_title varchar(300),
    user_description varchar(300)
);

-- PROCEDURES...
-- adding users
DELIMITER //
create procedure add_users (
	user_name varchar(100),
    first_name varchar(50),
    last_name varchar(50),
    user_email varchar(100),
    user_password varchar(100)
)
begin
insert into streaming_service_users (
	user_name, first_name, last_name, user_email, user_password
)
values (
	user_name, first_name, last_name, user_email, user_password
);
end;
//

-- updating users info 
drop procedure if exists update_user_email;
DELIMITER //
create procedure update_user_email (
	curr_email varchar(100),
	new_email varchar(100)
)
begin
update streaming_service_users
set user_email = new_email
where user_email = curr_email;
end;
//
status
-- updating users password
DELIMITER //
create procedure update_user_password (
	curr_password varchar(100),
	new_password varchar(100)
)
begin
update streaming_service_users
set user_password = new_password
where user_password = curr_password;
end;
//

-- deleting users account
DELIMITER //
create procedure delete_user (
	email varchar(100),
    password varchar(100)
)
begin
delete from streaming_service_users where user_email = email and user_password = password;
end;
//

/* !!! table 2 !!! */

-- adding streaming service
DELIMITER // 
create procedure add_streaming_services (
	service_name varchar(50)
)
begin
insert into streaming_service (streaming_service_name)
values (service_name);
end;
//

-- Updating streaming service
DELIMITER //
create procedure update_streaming_service (
	curr_service varchar(100),
    new_service varchar(100)
)
begin
update streaming_service
set curr_service = new_service
where user_password = curr_password;
end;
//

-- Deleting streaming service 
DELIMITER //
create procedure delete_user (
	curr_service varchar(100)
)
begin
delete from streaming_service where streaming_service_name = curr_service;
end;
//

/* !!! table 3 !!! */

-- adding users reviews
drop procedure if exists add_user_review;
DELIMITER //
create procedure add_user_review (
	uID int,
	uRating int,
    filmTitle varchar(100),
    uReview varchar(300)
)
begin 
insert into users_rating (
	user_id,
	rating,
    movie_title,
    user_description
)
values (uID, uRating, filmTitle, uReview);
end;
//

-- Updating user reviews
DELIMITER //
create procedure update_user_review (
	uID int,
	new_uRating int,
    new_filmTitle varchar(100),
    new_uReview varchar(300)
)
begin 
update users_rating
set rating = new_uRating, movie_title = new_filmTitle, user_description = new_uReview
where user_id = uID;
end;
//
-- Deleting user reviews
DELIMITER //
create procedure delete_user_review (
	uID int, 
    movieTitle varchar(100)
)
begin 
delete from users_rating
where user_id = uID and movie_title = movieTitle;
end;
//

-- Testing script to load all data into the tables
DELIMITER // 
create procedure users_and_reviews (
	fName varchar(50),
    lName varchar(50),
    uUserName varchar(100),
    uEmail varchar(100),
    uPassword varchar(100),
    streamingName varchar(50),
    mTitle varchar(100),
    uRating int,
    uReview varchar(300)
)
begin
if uRating is not null and uReview is not null then
	call add_users (uUserName, fName, lName, uEmail, uPassword);
    call add_streaming_services(streamingName);
    call add_user_review (uRating, mTitle, uReview);
end if;
end;
//

create view all_movie_reviews as
select 
m.title,
uv.rating,
uv.user_description
from movie m; 
full outer join user_rating uv on m.title = uv.movie_title
order by m.title;

create view avg_reviews
select
m.title,
sum(uv.rating) / count(m.title) avgReview,
from movie m
join user_rating uv on m.title = uv.movie_title





