-- C1. Crear el modelo en una base de datos llamada biblioteca, considerando las tablas definidas y sus atributos. (2 puntos).
create database biblioteca;
\c biblioteca

create table socio(
    rut varchar(10) primary key,
    nombre varchar(25) not null,
    apellido varchar(25) not null,
    direccion varchar(50) not null,
    telefono int not null
);

create table libro(
    isbn varchar(15) primary key,
    titulo varchar(50) not null,
    numero_paginas int not null
);

create table autor(
    codigo_autor int primary key,
    nombre varchar(25) not null,
    apellido varchar(25) not null,
    ano_nacimiento int not null,
    ano_muerte int,
    tipo varchar(10) not null
);

create table autor_libro(
    fk_isbn_libro varchar(15) not null references libro(isbn),
    fk_codigo_autor int not null references autor(codigo_autor)
);

create table prestamo(
    prestamo_id serial primary key,
    fk_isbn_libro varchar(15) not null references libro(isbn),
    fk_rut_socio varchar(10) not null references socio(rut),
    fecha_inicio date not null,
    fecha_esperada_devolucion date not null,
    fecha_real_devolucion date not null
);

--2. Se deben insertar los registros en las tablas correspondientes (1 punto).
insert into socio(rut, nombre, apellido, direccion, telefono)
values ('1111111-1', 'JUAN', 'SOTO', 'AVENIDA 1, SANTIAGO', 911111111),
('2222222-2', 'ANA', 'PEREZ', 'PASAJE 2, SANTIAGO', 922222222),
('3333333-3', 'SANDRA', 'AGUILAR', 'AVENIDA 2, SANTIAGO', 933333333),
('4444444-4', 'ESTEBAN', 'JEREZ', 'AVENIDA 3, SANTIAGO', 944444444),
('5555555-5', 'SILVANA', 'MUÑOZ', 'PASAJE 3, SANTIAGO', 955555555);

insert into libro(isbn, titulo, numero_paginas)
values ('111-1111111-111', 'CUENTOS DE TERROR', 344),
('222-2222222-222', 'POESIAS CONTEMPORANEAS', 167),
('333-333333-333', 'HISTORIA DE ASIA', 511),
('444-4444444-444', 'MANUAL DE MECANICA', 298);

insert into autor(codigo_autor, nombre, apellido, ano_nacimiento, ano_muerte, tipo)
values (1, 'ANDRES', 'ULLOA', 1982, null, 'PRINCIPAL'),
(2, 'SERGIO', 'MARDONES', 1950, 2012, 'PRINCIPAL'),
(3, 'JOSE', 'SALGADO', 1968, 2020, 'PRINCIPAL'),
(4, 'ANA', 'SALGADO', 1972, null, 'COAUTOR'),
(5, 'MARTIN', 'PORTA', 1976, null, 'PRINCIPAL');

insert into autor_libro(fk_isbn_libro, fk_codigo_autor)
values ('111-1111111-111', 3),
('111-1111111-111', 4),
('222-2222222-222', 1),
('333-333333-333', 2),
('444-4444444-444', 5);

insert into prestamo(fk_isbn_libro, fk_rut_socio, fecha_inicio, fecha_esperada_devolucion, fecha_real_devolucion)
values ('111-1111111-111', '1111111-1', '20-01-2020', '27-01-2020', '27-01-2020'),
('222-2222222-222', '5555555-5', '20-01-2020', '27-01-2020', '30-01-2020'),
('333-333333-333', '3333333-3', '22-01-2020', '29-01-2020', '30-01-2020'),
('444-4444444-444', '4444444-4', '23-01-2020', '30-01-2020', '30-01-2020'),
('111-1111111-111', '2222222-2', '27-01-2020', '03-02-2020', '04-02-2020'),
('444-4444444-444', '1111111-1', '31-01-2020', '07-02-2020', '12-02-2020'),
('222-2222222-222', '3333333-3', '31-01-2020', '07-02-2020', '12-02-2020');

-- 3. Realizar las siguientes consultas:
-- a. Mostrar todos los libros que posean menos de 300 páginas. (0.5 puntos)
select * from libro
where numero_paginas < 300;

-- b. Mostrar todos los autores que hayan nacido después del 01-01-1970.(0.5 puntos)
select * from autor
where ano_nacimiento > 1969;

-- c. ¿Cuál es el libro más solicitado? (0.5 puntos).

-- Son 3 libros los más solicitados. Puedo Averiguar eso así:
select libro.titulo as libro, prestamo.fk_isbn_libro as codigo_libro, count(prestamo.fk_isbn_libro) as cantidad_prestamos 
from prestamo inner join libro
on prestamo.fk_isbn_libro = libro.isbn
group by prestamo.fk_isbn_libro, libro.titulo
order by cantidad_prestamos desc;

-- O, si quiero que sólo me muestre el que figure primero como el más solicitado, puedo agregar un limit:
select libro.titulo as libro, prestamo.fk_isbn_libro as codigo_libro, count(prestamo.fk_isbn_libro) as cantidad_prestamos 
from prestamo inner join libro
on prestamo.fk_isbn_libro = libro.isbn
group by prestamo.fk_isbn_libro, libro.titulo
order by cantidad_prestamos desc
limit 1;

-- d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días. (0.5 puntos)
select fk_rut_socio, (fecha_real_devolucion - fecha_esperada_devolucion) as dias_atraso, ((fecha_real_devolucion - fecha_esperada_devolucion) * 100) as deuda
from prestamo
where fecha_real_devolucion - fecha_esperada_devolucion > 0
order by fk_rut_socio;
