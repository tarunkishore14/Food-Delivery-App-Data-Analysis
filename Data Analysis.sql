create database zomato_project;
use zomato_project;
ALTER TABLE cleanedzomato DROP COLUMN MyUnknownColumn;

#Task 1 - For a high-level overview of the hotels, provide us the top 5 most voted hotels in the delivery category.
select distinct name, votes, rnk as ranking
from (SELECT  name, max(votes) votes,
RANK() over(order by max(votes) desc) rnk
FROM cleanedzomato
WHERE type = 'Delivery'
group by name) as T
where rnk <=5;

/*Task 2 - The rating of a hotel is a key identifier in determining a restaurant’s performance. 
Hence for a particular location called Banashankari find out the top 5 highly rated hotels in the delivery category.*/

select distinct name, rating, rnk as ranking
from (SELECT name, avg(rating) rating,
RANK() over(order by avg(rating) desc) rnk
FROM cleanedzomato
WHERE location = 'Banashankari' and type = 'Delivery'
group by name) as T
where rnk <=5;

#Task 3 - Compare the ratings of the cheapest and most expensive hotels in Indiranagar.
Select 
(SELECT rating from cleanedzomato where location = 'Indiranagar' order by approx_cost asc limit 1) as lowest_rating,
(SELECT rating from cleanedzomato where location = 'Indiranagar' order by approx_cost desc limit 1) as highest_rating
FROM cleanedzomato
limit 1;


/*Task 4 - Online ordering of food has exponentially increased over time. 
Compare the total votes of restaurants that provide online ordering services and those that don’t provide online ordering services.*/
SELECT online_order, sum(votes) as total_votes
FROM cleanedzomato
group by online_order
order by total_votes desc;

/*Task 5 - Number of votes defines how much the customers are involved with the service provided by the restaurants.
For each Restaurant type, find out the number of restaurants, total votes, and average rating. 
Display the data with the highest votes on the top( if the first row of output is NA display the remaining rows).*/
SELECT type, count(id) as num_restaurants, sum(votes) as total_votes, round(avg(rating),2) as avg_rating
FROM cleanedzomato
where type != 'NA'
group by type
order by num_restaurants desc;

/*Task 6 - What is the most liked dish of the most-voted restaurant on Zomato
as the restaurant has a tie-up with Zomato, the restaurant compulsorily provides online ordering and delivery facilities.*/
select name, votes, dish_liked
from (SELECT name, votes, dish_liked, online_order, type,
RANK() over(order by votes desc) rnk
from cleanedzomato
where online_order = 'Yes' and type not in ('NA','Dine-out')
order by votes desc) as T
where rnk = 1;

/*Task 7 - To increase the maximum profit, Zomato is in need to expand its business. For doing so Zomato wants the list of the top 15 restaurants which have min 150 votes, 
have a rating greater than 3, and is currently not providing online ordering. Display the restaurants with the highest votes on the top.*/
SELECT name, votes, rating, rnk as 'rank'
from (SELECT name, votes, rating,
rank() over(order by votes desc) rnk
from cleanedzomato
where votes >= 150 and rating > 3 and online_order = 'No'
order by votes desc) as T
where rnk <= 15;
