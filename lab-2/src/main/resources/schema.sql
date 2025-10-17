-- customers
create table customers
(
    id         uuid not null
        primary key,
    email      varchar(255),
    first_name varchar(255),
    last_name  varchar(255)
);
