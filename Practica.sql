-- ORDER Y GROUP BY

-- 👉 1. Mostrar estudiantes ordenados por FechaNacimiento (más viejo primero)

Select studentId, Nombre + ' ' + Apellido as NombreCompleto, DATEDIFF(YEAR, FechaNacimiento, GETDATE()) as Edad, Genero, Clase, Punto
from Estudiantes
order by FechaNacimiento asc

-- 👉 2. Mostrar cantidad de préstamos por libro (bookId)

select l.bookId, count(p.borrowId) as cantidad
from Libros l
INNER join Prestamos p on l.bookId = p.bookId
group by l.bookId 

-- 👉 3. Mostrar cantidad de préstamos por libro, ordenados de mayor a menor


select l.bookId, count(p.borrowId) as cantidad
from Libros l
INNER join Prestamos p on l.bookId = p.bookId
group by l.bookId 
order by cantidad desc

-- FUNCIONES AGREGADAS

-- 👉 1 Mostrar la cantidad de estudiantes por género

select Genero, count(Genero)
from Estudiantes
group by Genero

-- 👉 2 Mostrar el promedio de puntos por clase

select Clase, AVG(Punto) as PromPuntos
from Estudiantes
group by clase
order by PromPuntos desc

-- 👉 3 Mostrar las clases que tienen promedio de puntos mayor a 600

select Clase, AVG(Punto) as PromPuntos
from Estudiantes
group by Clase
Having AVG(Punto) > 600

-- 👉 4 (clave parcial) Mostrar los libros que fueron prestados más de 2 veces

select l.NombreLibro, count(l.bookId)
from Libros l
inner join Prestamos p on l.bookId = p.bookId
Group by l.NombreLibro
having count(l.bookId) > 2

-- SUBCONSULTAS

-- 👉 1 Mostrar estudiantes con puntos mayores al promedio general

-- 👉 2 Mostrar libros que nunca fueron prestados

-- 👉 3 Mostrar el/los estudiante(s) con más puntos

-- 👉 4 (clave parcial) Mostrar estudiantes que hicieron préstamos (sin repetir estudiantes)

-- CTE

-- 👉 1 Crear una CTE que tenga estudiantes con sus puntos, y luego mostrar los que tienen más de 700

With ctEstudiantes As (
Select studentId, Punto
from Estudiantes)
select *
from ctEstudiantes
where Punto > 700

-- 👉 2 Crear una CTE con cantidad de préstamos por libro, y mostrar los que tienen más de 3

with ctePrestamo as (
select l.NombreLibro, count(p.borrowId) as VecesPrestado
from Libros l
inner join Prestamos p on l.bookId = p.bookId
group by l.NombreLibro
)
select *
from ctePrestamo
where VecesPrestado > 3

-- 👉 3 (clave) Crear una CTE con el promedio de puntos por clase, y mostrar solo las clases con promedio mayor a 600

with ctePromedioPuntos as (
select Clase, avg(Punto) as PromPuntos
from Estudiantes
group by Clase
)
select *
from ctePromedioPuntos
where PromPuntos > 600

-- FUNCIONES VENTANA

-- 👉 1 Mostrar estudiantes con su posición por puntos dentro de su clase

-- 👉 2 Mostrar cada estudiante con el promedio de puntos de su clase

-- 👉 3 (clave parcial) Mostrar el estudiante con mayor puntaje por cada clase

-- VISTAS (View)

-- 👉 1 Crear una VIEW que muestre estudiantes con su edad

CREATE VIEW EstudianteEdad AS
select studentId, Nombre + ' ' + Apellido as NombreCompleto, DATEDIFF(YEAR, FechaNacimiento, GETDATE() ) as Edad, Genero, Clase, Punto
from Estudiantes

select *
from EstudianteEdad

-- 👉 2 Crear una VIEW con libros y la cantidad de veces que fueron prestados

CREATE VIEW LibrosPrestados as
select l.NombreLibro, count(p.borrowId) as VecesPrestado
from Libros l
inner join Prestamos p on l.bookId = p.bookId
group by l.NombreLibro 

select *
from LibrosPrestados

-- 👉 3 (clave) Crear una VIEW con estudiantes y la cantidad de préstamos que hicieron

create view PrestamosEstudiantes as
select e.studentId, count(p.borrowId) as CantidadPrestamos 
from Estudiantes e
inner join Prestamos p on e.studentId = p.studentId
group by e.studentId

select *
from PrestamosEstudiantes

-- Procedimientos Almacenados

-- 👉 1 Crear un procedimiento que reciba un género y devuelva la cantidad de estudiantes

CREATE PROCEDURE CantEstudiantes
@Genero varchar(10)
as
begin
	select Genero, count(genero) as cantidad
	from Estudiantes
	where Genero = @Genero
	group by Genero
end

execute CantEstudiantes 'm'

-- 👉 2 Crear un procedimiento que reciba una clase y devuelva el promedio de puntos

CREATE procedure sp_promPuntos
@clasee varchar(10)
as
begin
	select Clase, avg(Punto) as PromedioPuntos
	from Estudiantes
	where Clase = @clasee
	group by Clase
end

execute sp_promPuntos '10E'

-- 👉 3 (clave) Crear un procedimiento que diga qué género tiene más estudiantes (usando IF)

no se como hacerlo

-- 👉 4 (nivel pro) Crear un procedimiento que reciba un bookId y diga cuántas veces fue prestado

create procedure sp_vecesPrestado
@idLibro int
as
begin
	select l.bookId,l.NombreLibro , count(p.borrowId) as VecesPrestado
	from Libros l
	inner join Prestamos p on l.bookId = p.bookId
	where l.bookId = @idLibro
	group by l.bookId, l.NombreLibro
end

execute sp_vecesPrestado 10