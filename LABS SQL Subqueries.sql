-- LAB | SQL Subqueries

-- Write SQL queries to perform the following tasks using the Sakila database:

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT f.title, SUM(i.inventory_id) as title_count
FROM film f
LEFT JOIN inventory i ON i.film_id = f.film_id
WHERE f.title = 'ACADEMY DINOSAUR'
GROUP BY f.title, i.inventory_id;

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.

SELECT film.length FROM sakila.film
WHERE length > 129
ORDER BY length DESC;

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT a.first_name, a.last_name, f.title
FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
LEFT JOIN film f ON f.film_id = fa.film_id
WHERE f.title = 'Alone Trip'
ORDER BY a.first_name,a.last_name, f.title;

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films. 

SELECT rating FROM sakila.film;

SELECT title, rating
FROM sakila.film
WHERE rating = 'PG' OR rating = 'G'
GROUP BY film.title, film.rating;

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT c.first_name, c.last_name, c.email, co.country
FROM customer c
LEFT JOIN address a ON c.address_id = c.address_id
LEFT JOIN city ci ON ci.city_id = a.city_id
JOIN country co ON co.country_id = ci.country_id
WHERE co.country = 'Canada'
GROUP BY c.first_name, c.last_name, c.email, co.country;


-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT actor_id, COUNT(film_id) AS film_count
FROM film_actor
GROUP BY actor_id
ORDER BY film_count DESC
LIMIT 1;

SELECT a.actor_id, a.first_name, a.last_name, f.title
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE a.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
)
ORDER BY a.actor_id, f.title;


-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

select *
from film
where film_id in
(
select distinct film_id
from inventory
where inventory_id in
(
select inventory_id
from rental
where customer_id =
(select customer_id
from payment
group by customer_id
order by sum(amount)
desc
limit 1)));

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

select customer_id, sum(amount) as total_amount_spent
from payment
group by customer_id
having sum(amount) >
(
select avg(total_spent)
from (select sum(amount) as total_spent
from payment
group by customer_id
order by sum(amount))
as subquery
)
order by total_amount_spent
desc
;

(
select avg(total_spent)
from (select sum(amount) as total_spent
from payment
group by customer_id
order by sum(amount))
as subquery
)
;