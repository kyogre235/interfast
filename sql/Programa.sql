DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;



create table IF NOT exists PersonasRifa (
	Nombre varchar (50)
);

create table if not exists Rifaron (
	Nombre varchar (50)
);

create table IF NOT exists Participantes (
	Nombre varchar (50)
);
insert into PersonasRifa (Nombre) values
	('Emma'),
	('Joaquin'),
	('Raul'),
	('Comas'),
	('Marco'),
	('Isaac'),
	('Mike'),
	('Karla'),
	('Axel'),
	('Ale');

insert into Participantes (Nombre) values
	('Emma'),
	('Joaquin'),
	('Raul'),
	('Comas'),
	('Marco'),
	('Isaac'),
	('Mike'),
	('Karla'),
	('Axel')
	('Ale');

CREATE OR REPLACE FUNCTION obtener_fila_aleatoria(nombre_excluido VARCHAR)
RETURNS TABLE (nombre VARCHAR) AS $$
DECLARE
    fila PERSONASRIFA%ROWTYPE;  -- Variable para almacenar la fila seleccionada
BEGIN
    -- Verificamos si la persona ya está en la tabla Rifaron
    IF EXISTS (SELECT 1 FROM Rifaron r WHERE r.Nombre = nombre_excluido) THEN
        -- Si está en Rifaron, devolvemos el mensaje "ya escojiste"
        RETURN QUERY SELECT 'ya escojiste'::VARCHAR;
        RETURN;
    END IF;
	
	IF NOT EXISTS (SELECT 1 FROM Participantes p WHERE p.Nombre = nombre_excluido) THEN
        RETURN QUERY SELECT 'nombre no está registrado, debes de colocarlo iniciando con mayusculas'::VARCHAR;
		RETURN;
    END IF;

    -- Seleccionamos una fila aleatoria que no tenga el nombre excluido
    SELECT p.Nombre
    INTO fila  -- Guardamos el resultado en la variable fila
    FROM PersonasRifa p
    WHERE p.Nombre != nombre_excluido
    ORDER BY RANDOM()
    LIMIT 1;

    -- Verificamos si encontramos una fila
    IF FOUND THEN
        -- Eliminamos la fila seleccionada de la tabla PersonasRifa
        DELETE FROM PersonasRifa p WHERE p.Nombre = fila.Nombre;
        -- Insertamos la persona seleccionada en la tabla Rifaron
        INSERT INTO Rifaron (Nombre) VALUES (nombre_excluido);
        -- Retornamos el nombre de la fila eliminada
        RETURN QUERY SELECT fila.Nombre;
		--return QUERY SELECT 'ya escojiste'::VARCHAR;
    ELSE
        -- Si no se encuentra ninguna fila, retornamos NULL
        RETURN QUERY SELECT NULL::VARCHAR;
    END IF;
END;
$$ LANGUAGE plpgsql;
