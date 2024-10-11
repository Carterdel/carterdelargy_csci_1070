-- question 1
select *
from customer
where last_name like 'T%'
order by first_name;

-- question 2
select * from rental
where return_date between '2005-05-28 00:00:00' 
and '2005-06-01 23:59:59'
order by return_date;

-- question 3

-- count is what you want to use because you want to find the amount
select count(rental_id) as amount_rented, title
from rental r
left join inventory i
on r.inventory_id = i.inventory_id
left join film f
on i.film_id = f.film_id
group by title
order by amount_rented desc
limit 10;
-- this counts how many rental id's for each film
-- and displays how many of them next to the movie title

-- question 4
select count(amount) as Total_Amount, first_name, last_name
from film f
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id
left join customer c
on r.customer_id = c.customer_id
left join payment p
on c.customer_id = p.customer_id
group by first_name, last_name
order by count(amount);
-- joins to get the names with the total amount of payment

-- question 5
select concat(first_name, ' ', last_name) as Actor_name, count(title) as Amount_of_Movies
from actor a
left join film_actor fa
on a.actor_id = fa.actor_id
left join film f
on fa.film_id = f.film_id
where release_year = '2006'
group by first_name, last_name
order by count(title) desc;
-- Susan Davis was in the most movies in 2006

-- question 6

explain analyze select count(amount) as Total_Amount, 
first_name, last_name
from film f
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id
left join customer c
on r.customer_id = c.customer_id
left join payment p
on c.customer_id = p.customer_id
group by first_name, last_name
order by count(amount);
-- here, the query plan has 29 lines.
-- First, it sorts the data, taking 234.379 miliseconds
-- it then has hashaggregate where it groups them, with the group key being by first name and last name
-- It then goes through the four joins, with an estimated time for each of them
-- towards the end, it does a seq scan on payment, which is where it goes through all of the data to find what's needed
-- At the end, it shows that the planning time was .778 and it only took 234.86 miliseconds to do all of this

explain analyze select first_name, last_name, count(title) as Amount_of_Movies
from actor a
left join film_actor fa
on a.actor_id = fa.actor_id
left join film f
on fa.film_id = f.film_id
where release_year = '2006'
group by first_name, last_name
order by count(title) desc;
-- Here first it sorts in under 5 miliseocnds 
-- it shows that the sort method is by title desc, which is "order by"
-- it then has hashaggregate followed by a group key
-- this group key is how it's grouped by with the count for amount of movies
-- towards the end thre's a seq scan where it goes through the film table and filters by a release year of 2006
-- we see that it took .591 ms of planning time and 4.622 ms of actual time to perform this

-- question 7
select avg(rental_rate), name
from film f
left join film_category fc
on f.film_id = fc.film_id
left join category c
on fc.category_id = c.category_id
group by name;
-- displays the avg rental rate for each genre

-- question 8
select name, count(r.inventory_id) as Amount_Of_Rentals
, sum(amount) as Total_Sales
from category c
left join film_category fc
on c.category_id = fc.category_id
left join film f
on fc.film_id = f.film_id
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id
left join payment p
on r.rental_id = p.rental_id
group by name
order by amount_of_rentals desc
limit 5;
-- this shows the genres, listed by the 1-5 most rented
-- also displays the total amount spent to rent them

-- extra credit
select extract(month from rental_date) as rental_month
, name, count(rental_id) as total_rentals
from rental r
left join inventory i
on r.inventory_id = i.inventory_id
left join film f
on i.film_id = f.film_id
left join film_category fc
on f.film_id = fc.film_id
left join category c
on fc.category_id = c.category_id
group by rental_month, name
order by rental_month, name;
-- this shows each month and for what genre, the total amount of rentals made








