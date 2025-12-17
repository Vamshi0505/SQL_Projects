-- Music DataBase 

-- Easy Level Question:

--1.Find the most senior employee based on job title.
SELECT * FROM Employee 
	ORDER BY Level DESC LIMIT 1;

--2.Determine which countrys have th most invoice
SELECT billingcountry,COUNT(invoiceid) FROM invoice 
	GROUP BY billingcountry
	ORDER BY COUNT(INVOICEID) DESC; 
--USA WITH 131

--3.Identify the top 3 invoice totals.
SELECT * FROM Invoice 
	ORDER BY Total DESC LIMIT 3;

--4. Find the city with the highest total invoice amount to determine the best location for a promotional event
SELECT c.City, SUM(i.total) FROM customer c 
	JOIN invoice i ON c.customerid=i.customerid 
	GROUP BY C.CITY ORDER BY SUM(i.total) DESC;
-- best location is 'Prague'

--5.identify the customer who spent the most money.
SELECT c.customerid, SUM(i.total) FROM customer c 
	JOIN invoice i ON C.CUSTOMERID=i.customerid 
	GROUP BY c.customerid ORDER BY SUM(i.total) DESC;
--Customerid 5 has spent most money 144.54

--Moderate Level Questioins:

--1.Find the email,firstname and lastname of customers who listen to Rock music.
SELECT email, firstname, lastname, g.name FROM customer c 
	JOIN invoice i ON c.customerid=i.customerid 
	JOIN invoiceline ivl ON  i.invoiceid=ivl.invoiceid
	JOIN track t ON ivl.trackid=t.trackid 
	JOIN genre g ON t.genreid=g.genreid where g.name='Rock';

SELECT * FROM track;

--2.identify the top 10 rock artists based on track count.
SELECT ar.artistid, ar.name, COUNT(tr.name) AS total_tracks FROM artist ar 
	JOIN album al ON ar.artistid=al.artistid 
	JOIN track tr ON al.albumid=tr.albumid 
	JOIN genre g ON tr.genreid=g.genreid 
	WHERE g.name='Rock' GROUP BY ar.artistid,ar.name 
	ORDER BY COUNT(tr.name) DESC;

--3.Find the avg length and compare each track's length to this average.
SELECT tr.name, LENGTH(tr.name) FROM track tr 
	WHERE LENGTH(tr.name)> (SELECT AVG(LENGTH(tr.name)) FROM track tr) 
	ORDER BY LENGTH(tr.name) DESC;

SELECT tr.name, LENGTH(tr.name) FROM track tr 
	ORDER BY LENGTH(tr.name) ASC;

SELECT COUNT(*) FROM track;

-- Advanced level Questions:

--1. Calculate how much each customer has spent on each artist.
WITH artist_revenue AS (
    SELECT
        ar.artistid,
        ar.name AS artist_name,
        i.customerid,
        il.unitprice * il.quantity AS line_total
    FROM invoiceline il
    JOIN track t ON il.trackid = t.trackid
    JOIN album al ON t.albumid = al.albumid
    JOIN artist ar ON al.artistid = ar.artistid
    JOIN invoice i ON il.invoiceid = i.invoiceid
)
SELECT
    c.customerid,
    c.firstname || ' ' || c.lastname AS customer_name,
    ar.artist_name,
    ROUND(SUM(ar.line_total), 2) AS total_spent
FROM artist_revenue ar
JOIN customer c ON ar.customerid = c.customerid
GROUP BY c.customerid, customer_name, ar.artist_name
ORDER BY customer_name, total_spent DESC;

--2.Determine the most popular music genre for each country based on purchasses
WITH genre_sales AS (
    SELECT
        c.country,
        g.genreid,
        g.name AS genre_name,
        COUNT(il.invoicelineid) AS purchase_count
    FROM invoiceline il
    JOIN track t ON il.trackid = t.trackid
    JOIN genre g ON t.genreid = g.genreid
    JOIN invoice i ON il.invoiceid = i.invoiceid
    JOIN customer c ON i.customerid = c.customerid
    GROUP BY c.country, g.genreid, g.name
),
ranked_genres AS (
    SELECT
        country,
        genre_name,
        purchase_count,
        RANK() OVER (PARTITION BY country ORDER BY purchase_count DESC) AS genre_rank
    FROM genre_sales
)
SELECT
    country,
    genre_name,
    purchase_count
FROM ranked_genres
WHERE genre_rank = 1
ORDER BY country;

--3.Identify the top-spending customer for each country.

WITH customer_spending AS (
    SELECT
        c.customerid,
        c.firstname || ' ' || c.lastname AS customer_name,
        c.country,
        SUM(il.unitprice * il.quantity) AS total_spent
    FROM invoiceline il
    JOIN invoice i ON il.invoiceid = i.invoiceid
    JOIN customer c ON i.customerid = c.customerid
    GROUP BY c.customerid, customer_name, c.country
),
ranked_customers AS (
    SELECT
        customerid,
        customer_name,
        country,
        total_spent,
        RANK() OVER (PARTITION BY country ORDER BY total_spent DESC) AS spend_rank
    FROM customer_spending
)
SELECT
    country,
    customer_name,
    ROUND(total_spent, 2) AS total_spent
FROM ranked_customers
WHERE spend_rank = 1
ORDER BY country;
















































