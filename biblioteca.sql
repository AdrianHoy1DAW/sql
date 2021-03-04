/* 1 . ¿Cuántos libros hay de los que se conozca el año de adquisición? */
select Count(ID_LIB) from libro where AÑO is not null;
/* 2 ¿Cuántos libros tienen más de una obra? Resolver este ejercicio utilizando el atributo
num_obras y sin utilizarlo. */
Select Count(*) from libro where VARIAS_OBRAS > 1;
Select Count(*) from libro l inner join esta_en e on e.ID_LIB
= l.ID_LIB group by e.ID_LIB having Count(e.ID_LIB) > 1;
/* 3 ¿Cuántos autores hay en la base de datos de los que no se tiene ninguna obra? */
select Count(*) from autor a left join escribir e 
on e.AUTOR_ID = a.AUTOR_ID group by e.AUTOR_ID
having Count(COD_OB) = 0;
/* 4 Obtener el nombre de esos autores. */
select a.nombre from autor a left join escribir e 
on e.AUTOR_ID = a.AUTOR_ID group by a.nombre
having Count(COD_OB) = 0;
/* 5 Obtener el título de las obras escritas sólo por un autor si éste es de nacionalidad “Francesa”
indicando también el nombre del autor. */
select distinct o.titulo, a.nombre from obra o inner join escribir e 
on e.COD_OB = o.COD_OB inner join autor a
on a.AUTOR_ID = e.AUTOR_ID where a.NACIONALIDAD = "Francesa" and
e.COD_OB not in (select COD_OB from escribir ee where AUTOR_ID <> e.AUTOR_ID);
/* 6 Obtener el título y el identificador de los libros que tengan titulo y más de dos obras, indicando
el número de obras. */
select l.ID_LIB, l.titulo, l.varias_obras from libro l 
where titulo is not null and varias_obras > 2;
/* 7 Obtener el nombre de los autores de nacionalidad “Española” que han escrito dos o más obras. */
select nombre from autor a inner join escribir e
on e.AUTOR_ID = a.AUTOR_ID where a.nacionalidad = "Española"
group by nombre having Count(COD_OB) >= 2;
/* 8 Obtener el nombre de los autores de nacionalidad “Española” que tienen obras en dos o más
libros. No resuelta */
select  a.nombre from autor a inner join escribir e
on e.AUTOR_ID = a.AUTOR_ID inner join obra o on
o.COD_OB = e.COD_OB inner join esta_en f
on f.COD_OB = o.COD_OB
where a.nacionalidad = "Española"
group by a.nombre
having Count(*) >= 2; 
/* 9 . Obtener el título y el código de las obras que tengan más de un autor. */
select o.COD_OB, o.titulo from obra o inner join escribir e
on e.COD_OB = o.COD_OB 
group by o.COD_OB, o.TITULO 
having count(e.AUTOR_ID) > 1;
/* 10 Obtener el título y el identificador de los libros que tengan título y que contengan sólo una obra. */
select l.ID_LIB, l.titulo from libro l inner join esta_en e
on e.ID_LIB = l.ID_LIB where titulo is not null
group by l.ID_LIB, l.TITULO 
having count(COD_OB) = 1;
/* 11 Como se concluye del resultado de la consulta anterior, los libros con una sola obra no tienen
título propio. Asumiendo en este caso que su título es el de la obra que contienen, obtener la
lista de todos los títulos de libros que hay en la base de datos tengan las obras que tengan.*/
select  l.titulo from libro l where titulo is not null union  select  o.titulo from obra o
inner join esta_en e on e.COD_OB = o.COD_OB inner join libro l on l.ID_LIB = e.ID_LIB
where l.VARIAS_OBRAS = 1;
/* 12 Obtener el nombre del autor (o autores) que más obras han escrito? */
select a.nombre from autor a
inner join escribir e on e.AUTOR_ID = a.AUTOR_ID
group by a.NOMBRE 
having Count(e.COD_OB) >= (select Count(COD_OB) from escribir
group by AUTOR_ID order by count(COD_OB) desc limit 1);
/* 13 Obtener la nacionalidad (o nacionalidades) menos frecuentes */
select nacionalidad, Count(AUTOR_ID) from autor a 
group by nacionalidad
having count(Autor_ID) = (select count(AUTOR_ID) from autor
group by nacionalidad order by Count(AUTOR_ID) limit 1)
;
/* 14 Obtener el nombre de los amigos que han leído alguna obra del autor de identificador ‘RUKI’.*/
select distinct a.nombre from amigo a inner join prestamo p
on p.num = a.num inner join libro l on l.ID_LIB = p.ID_LIB
inner join esta_en e on e.ID_LIB = l.ID_LIB 
inner join obra o on o.COD_OB = e.COD_OB
inner join escribir f on f.COD_OB = o.COD_OB
where f.AUTOR_ID = "RUKI";

/* 15 . Obtener el nombre de los amigos que han leído todas las obras del autor de identificador
‘RUKI’*/
select distinct a.nombre from amigo a inner join prestamo p
on p.num = a.num
inner join esta_en e on e.ID_LIB = p.ID_LIB 
inner join escribir f on f.COD_OB = e.COD_OB
where f.AUTOR_ID = "RUKI"
and  not exists(select nombre aa from amigo aa
inner join prestamo pp on aa.NUM = pp.NUM
inner join esta_en ee on ee.ID_LIB = pp.ID_LIB
inner join escribir ff on ff.COD_OB = ee.COD_OB
where ff.AUTOR_ID = "RUKI" and aa.NUM <> a.NUM
and p.ID_LIB <> pp.ID_LIB);

/* 16 Obtener el nombre de los amigos que han leído todas las obras del autor de identificador
‘JAGR’ */ 

select distinct a.nombre from amigo a inner join prestamo p
on p.num = a.num
inner join esta_en e on e.ID_LIB = p.ID_LIB 
inner join escribir f on f.COD_OB = e.COD_OB
where f.AUTOR_ID = "JAGR"
and  not exists(select nombre aa from amigo aa
inner join prestamo pp on aa.NUM = pp.NUM
inner join esta_en ee on ee.ID_LIB = pp.ID_LIB
inner join escribir ff on ff.COD_OB = ee.COD_OB
where ff.AUTOR_ID = "JAGR" and aa.NUM <> a.NUM
and p.ID_LIB <> pp.ID_LIB);

/* 17 Obtener el nombre de los amigos que han leído todas las obras de algún autor. */
select distinct a.nombre, au.nombre from amigo a inner join prestamo p
on p.num = a.num
inner join esta_en e on e.ID_LIB = p.ID_LIB 
inner join escribir f on f.COD_OB = e.COD_OB
inner join autor au on au.AUTOR_ID = f.AUTOR_ID
where  not exists(select nombre aa from amigo aa
inner join prestamo pp on aa.NUM = pp.NUM
inner join esta_en ee on ee.ID_LIB = pp.ID_LIB
inner join escribir ff on ff.COD_OB = ee.COD_OB
where ff.AUTOR_ID = f.AUTOR_ID
and aa.NUM <> a.NUM);

/* 19. Obtener el nombre de los amigos que han leído alguna obra del autor de identificador ‘CAMA’.  */
select distinct a.nombre from amigo a inner join prestamo p
on p.num = a.num
inner join esta_en e on e.ID_LIB = p.ID_LIB 
inner join escribir f on f.COD_OB = e.COD_OB
where f.AUTOR_ID = "CAMA";

/*20 Obtener el nombre de los amigos que solo han leído  obras del autor de identificador 'CAMA'. */
select distinct a.nombre from amigo a inner join prestamo p
on p.num = a.num
inner join esta_en e on e.ID_LIB = p.ID_LIB 
inner join escribir f on f.COD_OB = e.COD_OB
where f.AUTOR_ID = "CAMA" and not exists(select aa.nombre from amigo aa
inner join prestamo pp
on pp.num = aa.num
inner join esta_en ee on ee.ID_LIB = pp.ID_LIB 
inner join escribir ff on ff.COD_OB = ee.COD_OB
where ff.AUTOR_ID <> "CAMA" and aa.NUM = a.NUM);

/* 21 Obtener el nombre de los amigos que sólo han leído obras de un autor. */

select distinct a.nombre from amigo a inner join prestamo p
on p.num = a.num
inner join esta_en e on e.ID_LIB = p.ID_LIB 
inner join escribir f on f.COD_OB = e.COD_OB
where not exists(select aa.nombre from amigo aa
inner join prestamo pp
on pp.num = aa.num
inner join esta_en ee on ee.ID_LIB = pp.ID_LIB 
inner join escribir ff on ff.COD_OB = ee.COD_OB
where aa.NUM = a.NUM and ff.AUTOR_ID <> f.AUTOR_ID);

/* 22 Resolver la consulta anterior indicando también el nombre del autor.*/

select distinct a.nombre, au.NOMBRE from amigo a inner join prestamo p
on p.num = a.num
inner join esta_en e on e.ID_LIB = p.ID_LIB 
inner join escribir f on f.COD_OB = e.COD_OB
inner join autor au on au.AUTOR_ID = f.AUTOR_ID
where not exists(select aa.nombre from amigo aa
inner join prestamo pp
on pp.num = aa.num
inner join esta_en ee on ee.ID_LIB = pp.ID_LIB 
inner join escribir ff on ff.COD_OB = ee.COD_OB
where aa.NUM = a.NUM and ff.AUTOR_ID <> f.AUTOR_ID);

/* 23 Obtener el nombre de los amigos que han leído todas las obras de algún autor y no han leído
nada de ningún otro indicando también el nombre del autor.  */

select distinct a.nombre, au.nombre from amigo a inner join prestamo p
on p.num = a.num
inner join esta_en e on e.ID_LIB = p.ID_LIB 
inner join escribir f on f.COD_OB = e.COD_OB
inner join autor au on au.AUTOR_ID = f.AUTOR_ID
where  not exists(select aa.nombre from amigo aa
inner join prestamo pp
on pp.num = aa.num
inner join esta_en ee on ee.ID_LIB = pp.ID_LIB 
inner join escribir ff on ff.COD_OB = ee.COD_OB
where aa.NUM = a.NUM and ff.AUTOR_ID <> f.AUTOR_ID and not exists(select nombre aaa from amigo aaa
inner join prestamo ppp on aaa.NUM = ppp.NUM
inner join esta_en eee on eee.ID_LIB = ppp.ID_LIB
inner join escribir fff on fff.COD_OB = eee.COD_OB
where fff.AUTOR_ID = ff.AUTOR_ID
and aaa.NUM <> aa.NUM
))  ;
