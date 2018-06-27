use sakila;

-- 1a
select first_name as 'First Name', last_name as 'Last Name' from actor;

-- 1b
select concat(first_name, ' ', last_name) as 'Actor Name' from actor;

-- 2a
select actor_id, first_name as 'First Name', last_name as 'Last Name' from actor
where first_name = 'Joe';

-- 2b
select first_name as 'First Name', last_name as 'Last Name' from actor
where last_name like '%GEN%';

-- 2c
select last_name as 'Last Name', first_name as 'First Name' from actor
where last_name like '%LI%'
order by last_name, first_name;

-- 2d
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD COLUMN middle_name varchar(45) AFTER first_name;

-- 3b
ALTER TABLE actor
modify middle_name blob;

-- 3c
alter table actor
DROP COLUMN middle_name;

-- 4a
select last_name as 'Last Name', count(*) as 'Number of Actors'
from actor
group by last_name
order by count(*) desc, last_name asc;

-- 4b
select last_name as 'Last Name', count(*) as 'Number of Actors'
from actor
group by last_name
having count(*) > 1
order by count(*) desc, last_name asc;

-- 4c
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d
update actor
set first_name =
	case first_name
		when 'HARPO' then 'GROUCHO'
		else 'MUCHO GROUCHO'
	end
where actor_id in (
	select actor_id
	from actor
	where first_name in ('HARPO', 'GROUCHO')
		and last_name = 'WILLIAMS'
	);

-- 5a
SHOW CREATE TABLE address;

-- 6a
select s.first_name, s.last_name, a.address
from staff s inner join address a
	on s.address_id = a.address_id;

-- 6b
select *
from payment p inner join staff s
	on s.staff_id = p.staff_id
	where payment_date >= '2005-08-01' and payment_date < '2005-09-01';

-- 6c
select f.title, count(*)
from film f inner join film_actor fa on f.film_id = fa.film_id
group by f.title
order by f.title;

-- 6d
select count(*) as 'Number of Copies'
from inventory i inner join film f on f.film_id = i.film_id
where f.title = 'Hunchback Impossible';

-- 6e
select c.last_name, c.first_name, concat('$', format(sum(p.amount), 2))
from payment p inner join customer c on c.customer_id = p.customer_id
group by c.last_name, c.first_name
order by c.last_name, c.first_name

-- 7a
select f.title
from film f 
where language_id in (select language_id from language where name = 'English')
	and film_id in (select film_id from film where regexp_instr(title, '^[KQ].*'));

-- 7b
select a.last_name, a.first_name
from actor a
where exists (select 1
	from film_actor fa inner join film f on fa.film_id = f.film_id
	where fa.actor_id = a.actor_id
		and f.title = 'Alone Trip');

-- 7c
select cu.last_name, cu.first_name, cu.email
from customer cu inner join address a on a.address_id = cu.address_id
	inner join city ci on ci.city_id = a.city_id
	inner join country co on co.country_id = ci.country_id
	where country = 'Canada'
	order by 2, 1;

-- 7d
select f.title
from film f inner join film_category fc on fc.film_id = f.film_id
	inner join category c on c.category_id = fc.category_id
	where c.name = 'Family'
order by 1;

-- 7e
select f.title, count(*) as 'Rentals'
from rental r inner join inventory i on i.inventory_id = r.inventory_id
	inner join film f on f.film_id = i.film_id
group by f.title
order by 2 desc;

-- 7f
select store.store_id, concat('$', format(sum(p.amount), 2)) as 'Business ($)'
from payment p inner join staff s on s.staff_id = p.staff_id
	inner join store on store.store_id = s.store_id
group by store.store_id
order by 1;

-- 7g
select s.store_id, c.city, co.country
from store s inner join address a on a.address_id = s.address_id
	inner join city c on c.city_id = a.city_id
	inner join country co on co.country_id = c.country_id
order by 1;

-- 7h
select cat.name, sum(p.amount)
from category cat inner join film_category fc on fc.category_id = cat.category_id
 	inner join film f on f.film_id = fc.film_id
 	inner join inventory i on i.film_id = f.film_id
 	inner join rental r on r.inventory_id = i.inventory_id
 	inner join payment p on p.rental_id = r.rental_id
 group by f.title
 order by 2 desc
 limit 5;
 
-- 8a
 create view top_5_genres as (
 	select cat.name, sum(p.amount)
	from category cat inner join film_category fc on fc.category_id = cat.category_id
	 	inner join film f on f.film_id = fc.film_id
	 	inner join inventory i on i.film_id = f.film_id
	 	inner join rental r on r.inventory_id = i.inventory_id
	 	inner join payment p on p.rental_id = r.rental_id
	 group by f.title
	 order by 2 desc
	 limit 5
 );
 
-- 8b
 select * from top_5_genres;
 
-- 8c
 drop view top_5_genres;
