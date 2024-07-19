--Presentar solo las columnas DisplayName, Location, Reputation de la tabla  Users 
--y ordenar la taba a presenta de mayor a menor ,haciendolo mediante el atributo reputacion    
SELECT TOP 200 DisplayName, Location, Reputation
FROM Users
ORDER BY Reputation DESC;

--Muestra los titulos de los libros junto con el nombre de quien los creo 
SELECT Posts.Title, Users.DisplayName
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id

--Calcula el puntaje promedio de las publicaciones por usuario y muestra el nombre del usuario
SELECT Users.DisplayName, AVG(Posts.Score) AS promedio_score
FROM Posts
INNER JOIN Users ON Users.Id = Posts.OwnerUserId
GROUP BY Posts.OwnerUserId, Users.DisplayName;

--Selecciona los primeros 200 nombres de usuarios que han hecho más de 100 comentarios
SELECT TOP 200 Users.DisplayName
FROM Users
WHERE Users.Id IN
(SELECT Comments.UserId
FROM Comments
GROUP BY Comments.UserId
HAVING COUNT (Comments.Id) > 100);

--Actualizamos la ubicación de los usuarios a 'Desconocido' si actualmente no tienen una ubicación definida
UPDATE Users SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = ' ';
PRINT 'La actualización se realizó correctamente.';



--Elimina los comentarios hechos por usuarios con una reputación menor a 100, guarda el número de comentarios eliminados en una variable, y luego imprime cuántos comentarios se eliminaron.
DECLARE @NumComentariosEliminados INT;
DELETE Comments 
FROM Comments 
INNER JOIN Users ON Comments.UserId = Users.Id 
WHERE Users.Reputation < 100; 
SET @NumComentariosEliminados = @@ROWCOUNT; 
PRINT 'Se eliminaron ' + CAST(@NumComentariosEliminados AS VARCHAR) + ' comentarios realizados por usuarios con menos de 100 de reputación.';



-- Presenta los resultados en una tabla mostrando el DisplayName del usuario junto con el total de
publicaciones, comentarios y medallas
SELECT TOP 200 Users.DisplayName,
COALESCE(P.Numero_de_Publicaciones, 0) AS Total_Posts, --si encuentra null convierte a 0
COALESCE(C.Numero_de_Comentarios, 0) AS Total_Comments,
COALESCE(B.Numero_de_Medallas, 0) AS Total_Badges
FROM Users
LEFT JOIN (SELECT OwnerUserId, COUNT(*) AS Numero_de_Publicaciones FROM Posts GROUP BY OwnerUserId) --numero total de veces que encontro un posteo con el mismo id
P ON Users.Id = P.OwnerUserId
LEFT JOIN (SELECT UserId, COUNT(*) AS Numero_de_Comentarios FROM Comments GROUP BY UserId) 
C ON Id = C.UserId
LEFT JOIN (SELECT UserId, COUNT(*) AS Numero_de_Medallas FROM Badges GROUP BY UserId) 
B ON Id = B.UserId;


--Muestra las 10 publicaciones más populares basadas en la puntuación (Score) de la tabla Posts.
SELECT TOP 10 Title, Score
FROM Posts
ORDER BY Score DESC;


--Muestra los 5 comentarios más recientes de la tabla Comments
SELECT TOP 5 Text, CreationDate
FROM Comments
ORDER BY CreationDate DESC;