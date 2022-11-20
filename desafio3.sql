CREATE TABLE users(
  id SERIAL,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  rol VARCHAR
);

INSERT INTO users(email, name, last_name, rol) VALUES 
('juan@mail.com', 'juan', 'perez', 'administrador'),
('diego@mail.com', 'diego', 'munoz', 'usuario'),
('maria@mail.com', 'maria', 'meza', 'usuario'),
('roxana@mail.com','roxana', 'diaz', 'usuario'),
('pedro@mail.com', 'pedro', 'diaz', 'usuario');

CREATE TABLE posts(
  id SERIAL,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  outstanding BOOLEAN NOT NULL DEFAULT FALSE,
  user_id BIGINT
);

INSERT INTO posts (title, content, created_at,
updated_at, outstanding, user_id) VALUES 
('prueba', 'contenido prueba', '01/01/2021', '01/02/2021', true, 1),
('prueba2', 'contenido prueba2', '01/03/2021', '01/03/2021', true, 1),
('ejercicios', 'contenido ejercicios', '02/05/2021', '03/04/2021', true, 2),
('ejercicios2', 'contenido ejercicios2', '03/05/2021', '04/04/2021', false, 2),
('random', 'contenido random', '03/06/2021', '04/05/2021', false, null);

CREATE TABLE comments(
  id SERIAL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  user_id BIGINT,
  post_id BIGINT
);

INSERT INTO comments (content, created_at, user_id,
post_id) VALUES 
('comentario 1', '03/06/2021', 1, 1),
('comentario 2', '03/06/2021', 2, 1),
('comentario 3', '04/06/2021', 3, 1),
('comentario 4', '04/06/2021', 1, 2);

2-Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas.
nombre e email del usuario junto al título y contenido del post

SELECT users.name, users.email, posts.title, posts.content FROM users INNER JOIN posts ON users.id = posts.user_id;

3. Muestra el id, título y contenido de los posts de los administradores. El administrador
puede ser cualquier id y debe ser seleccionado dinámicamente. 

SELECT posts.id, posts.title, posts.content FROM posts INNER JOIN users ON posts.user_id = users.id WHERE users.rol = 'administrador';  

4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id y
email del usuario junto con la cantidad de posts de cada usuario

SELECT COUNT(posts), users.id, users.email FROM posts RIGHT JOIN users ON posts.user_id = users.id GROUP BY users.id, users.email ORDER BY users.id ASC;

5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene
un único registro y muestra solo el email.

SELECT users.email FROM posts JOIN users ON posts.user_id = users.id GROUP BY users.id, users.email ORDER BY COUNT(posts.id) DESC;


6. Muestra la fecha del último post de cada usuario.
SELECT users.name, MAX(posts.created_at) FROM users INNER JOIN posts ON users.id = posts.user_id GROUP BY users.name;

7. Muestra el título y contenido del post (artículo) con más comentarios
SELECT posts.title, posts.content, count(*) FROM posts INNER JOIN comments ON posts.id = comments.post_id GROUP BY posts.title, posts.content ORDER BY COUNT(*) DESC LIMIT 1;

8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
de cada comentario asociado a los posts mostrados, junto con el email del usuario
que lo escribió.
SELECT posts.title AS title_post, posts.content AS content_post, comments.content AS content_comments, users.email
FROM posts 
LEFT JOIN comments ON posts.id = comments.post_id
LEFT JOIN users ON comments.user_id = users.id;

9. Muestra el contenido del último comentario de cada usuario. 
SELECT comments.user_id, comments.content FROM comments
INNER JOIN
(SELECT max(comments.id) AS last_id FROM comments GROUP BY user_id) AS dt_last_reg
ON comments.id = dt_last_reg.last_id
ORDER BY comments.user_id;


10. Muestra los emails de los usuarios que no han escrito ningún comentario
SELECT users.email FROM users LEFT JOIN comments ON users.id = comments.user_id WHERE comments.content IS NULL;
