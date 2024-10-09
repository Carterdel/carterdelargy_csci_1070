-- question 1
select *
from payment
where amount >= 9.99;


-- question 2
select max(amount)
from payment;
-- max is 11.99

select *
from rental r
left join payment p
on r.rental_id = p.rental_id
left join Inventory i
on r.inventory_id = i.inventory_id
left join film f
on i.film_id = f.film_id
where amount = '11.99';

-- question 3

select first_name, last_name, email, address, city, country
from staff s
left join address a
on s.address_id = a.address_id
left join city
on a.city_id = city.city_id
left join country
on city.country_id = country.country_id

-- question 4
 -- I'm not totally sure on what I'm interested
 -- in working in yet. I have been finding
 -- what we've been doing in this class very interesting
 -- though, and I can see myself going into something
 -- with data. I'm also really thinking about minoring
 -- in GIS so I could do something related to that.
 -- That relies on a large amount of data.

-- question 5
-- crows feet notation is used to show the relationship
-- between different tables in dvdrental. This exists so you
-- can see when tables have columns that link them.
-- For example, between city and country, country is linked to
-- city in a one-to-many connection. This is because
-- the country_id would be linked to the city_id and city, and
-- one country_id can have several cities.


