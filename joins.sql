-- Active: 1720901001567@@127.0.0.1@5432@desafio3_yarbet_yanac
CREATE DATABASE desafio3_yarbet_yanac;

CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL
);

CREATE TABLE Posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_actualizacion TIMESTAMP,
    destacado BOOLEAN,
    usuario_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
);

CREATE TABLE Comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    usuario_id BIGINT,
    post_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (post_id) REFERENCES Posts(id)
);

INSERT INTO Usuarios (email, nombre, apellido, rol) VALUES
('admin@example.com', 'Admin', 'One', 'administrador'),
('user1@example.com', 'User', 'One', 'usuario'),
('user2@example.com', 'User', 'Two', 'usuario'),
('user3@example.com', 'User', 'Three', 'usuario'),
('user4@example.com', 'User', 'Four', 'usuario');

INSERT INTO Posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Post 1', 'Contenido del Post 1', '2024-07-01 10:00:00', '2024-07-01 10:00:00', TRUE, 1),
('Post 2', 'Contenido del Post 2', '2024-07-02 10:00:00', '2024-07-02 10:00:00', TRUE, 1),
('Post 3', 'Contenido del Post 3', '2024-07-03 10:00:00', '2024-07-03 10:00:00', FALSE, 2),
('Post 4', 'Contenido del Post 4', '2024-07-04 10:00:00', '2024-07-04 10:00:00', FALSE, 3),
('Post 5', 'Contenido del Post 5', '2024-07-05 10:00:00', '2024-07-05 10:00:00', FALSE, NULL);

INSERT INTO Comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Comentario 1', '2024-07-01 11:00:00', 1, 1),
('Comentario 2', '2024-07-01 12:00:00', 2, 1),
('Comentario 3', '2024-07-01 13:00:00', 3, 1),
('Comentario 4', '2024-07-02 11:00:00', 1, 2),
('Comentario 5', '2024-07-02 12:00:00', 2, 2);

--1 Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post

SELECT U.nombre, U.email, P.titulo, P.contenido
FROM Usuarios U
JOIN Posts P ON U.id = P.usuario_id;

--2 Muestra el id, título y contenido de los posts de los administradores.

SELECT P.id, P.titulo, P.contenido
FROM Posts P
JOIN Usuarios U ON P.usuario_id = U.id
WHERE U.rol = 'administrador';

--3 Cuenta la cantidad de posts de cada usuario.

SELECT U.id, U.email, COUNT(P.id) AS cantidad_posts
FROM Usuarios U
LEFT JOIN Posts P ON U.id = P.usuario_id
GROUP BY U.id, U.email;

--4 Muestra el email del usuario que ha creado más posts.

SELECT U.email
FROM Usuarios U
JOIN Posts P ON U.id = P.usuario_id
GROUP BY U.email
ORDER BY COUNT(P.id) DESC
LIMIT 1;

--5 Muestra la fecha del último post de cada usuario.

SELECT U.nombre, MAX(P.fecha_creacion) AS ultima_fecha_post
FROM Usuarios U
JOIN Posts P ON U.id = P.usuario_id
GROUP BY U.nombre;

--6 Muestra el título y contenido del post (artículo) con más comentarios.

SELECT P.titulo, P.contenido
FROM Posts P
JOIN Comentarios C ON P.id = C.post_id
GROUP BY P.id
ORDER BY COUNT(C.id) DESC
LIMIT 1;

--7 Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.

SELECT P.titulo, P.contenido AS contenido_post, C.contenido AS contenido_comentario, U.email
FROM Posts P
JOIN Comentarios C ON P.id = C.post_id
JOIN Usuarios U ON C.usuario_id = U.id;

--8 Muestra el contenido del último comentario de cada usuario.

SELECT U.nombre, C.contenido
FROM Comentarios C
JOIN Usuarios U ON C.usuario_id = U.id
WHERE C.fecha_creacion = (SELECT MAX(fecha_creacion) FROM Comentarios WHERE usuario_id = U.id);

--9 Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT U.email
FROM Usuarios U
LEFT JOIN Comentarios C ON U.id = C.usuario_id
GROUP BY U.email
HAVING COUNT(C.id) = 0;
