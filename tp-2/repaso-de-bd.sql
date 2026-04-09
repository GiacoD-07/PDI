//repaso de mer y sql
1:
alias u= campos/atributos que pertenecen a la tabla usuarios
alias p= campos/atributos que pertenecen a la tabla publicacion
select ---> (alias u) u.id, u.username, (alias p) p.descripcion
from usuarios u as (alias) u
join publicacion p on  u.id = p.id_user
where p.tema="educacion"

Limit 100,

2:
alias u= campos/atributos que pertenecen a la tabla usuarios
alias p= campos/atributos que pertenecen a la tabla publicacion
alias c= campos/atributos que pertenecen a la tabla comentario
select p.descripcion, p.id, u.id, c.contenido, c.id,u.username
from publicacion p as 
join comentario c  on  p.id = c.id_pub
join usuarios u    on  u.id = c.id_user
where u.email like (-->termine en:...) "%@yahoo.com"
Limit 100,

* Cuando la cardinalidad en una relacion (dos tablas, en este caso "usuarios y publicacion") es
N,M (de muchos a muchos) se crea uan tercera tabla con las claves primarias y se hacen foraneas 
(ids en este caso)
"tercera tabla": comentario
c.id_pub y c.id_user son las llaves/claves primarias de las tablas usuarios y publicacion que 
son foraneas en la tabla comentario.
 ___________________
| u.id  | p.id_pub  |
