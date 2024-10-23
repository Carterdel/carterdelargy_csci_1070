-- question 1
select rental_date, return_date,
rental_duration,
case when return_date > (rental_date + rental_duration * INTERVAL '1 day') 
then 'Late'
when return_date = (rental_date + rental_duration * interval '1 day')
then 'On time'
else 'Early'
end as status
from rental r
left join inventory i
on r.inventory_id = i.inventory_id
left join film f
on i.film_id = f.film_id;

-- question 2
select first_name, last_name, city, count(amount) as total_payment from payment p
left join customer c
on p.customer_id = c.customer_id
left join address a
on c.address_id = a.address_id
left join city
on a.city_id = city.city_id
where city = 'Kansas City' or city = 'Saint Louis'
group by city, first_name, last_name;

-- question 3
select name as category_name, 
count(fc.category_id) as amount from film f
left join film_category fc
on f.film_id = fc.film_id
left join category cat
on fc.category_id = cat.category_id
group by name;

-- question 4

-- there's a table for category and one for film
-- category because it helps organize the table more.
-- there's a one to many relation from the film category

-- question 5
select f.film_id, title, length, return_date from film f
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id
where return_date between
'2005-05-15 00:00:00' and '2005-05-31 23:59:59'
order by return_date;

-- question 6
select title, rental_rate from film
where rental_rate < (select avg(rental_rate) from film);

-- question 7
select 
count(case when return_date > (rental_date + rental_duration * interval '1 day') 
then 1 end) as late,
count(case when return_date = (rental_date + rental_duration * interval '1 day')
then 1 end) as on_time,
count(case when return_date < (rental_date + rental_duration * interval '1 day')
then 1 end) as early
from rental r
left join inventory i
on r.inventory_id = i.inventory_id
left join film f
on i.film_id = f.film_id;
-- this shows new columns counting how many were late,
-- on time, or early

-- question 8
select title, length,
percent_rank() over (order by length) as percentile
from film;
-- shows the percentile for the length of each film

-- question 9
explain analyze select title, length,
percent_rank() over (order by length) as percentile
from film;
-- here, it window aggregates and sorts it by length.
-- it uses quicksort, and scans film with seq scan. seq scan
-- is where it reads the rows from the table in order.
-- it took .033 ms to plan and .395 ms to do all of this. The numbers differ
-- each time, but not by all too much.
explain analyze select 
count(case when return_date > (rental_date + rental_duration * interval '1 day') 
then 1 end) as late,
count(case when return_date = (rental_date + rental_duration * interval '1 day')
then 1 end) as on_time,
count(case when return_date < (rental_date + rental_duration * interval '1 day')
then 1 end) as early
from rental r
left join inventory i
on r.inventory_id = i.inventory_id
left join film f
on i.film_id = f.film_id;
-- this query has much more going on than the previous one.
-- it aggregates, but normally this time, not window.
-- it then goes through all of the different left joins, performing seq scans
-- on rental, inventory, and film.
-- here, because of everything going on, the planning time
-- is around .200 ms and the execution time is geting between 10-40 ms, much more
-- than the other query.

-- extra credit 2

-- Set-based programming is where you tell a program what you want it to do. 
-- You don’t tell it how to perform it. This is what SQL is, 
-- because you can perform actions over thousands of rows just by giving requirements, 
-- like showing all of the films that have a length below a certain amount. 
-- On the other hand, Python is procedural based programming because you’re putting in 
-- what you want to do and how you want it to happen.
-- This means you go through it all and it should act exactly like how you want it to.
