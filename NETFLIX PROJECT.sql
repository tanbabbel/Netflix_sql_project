--Netflix Project

DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix(
   show_id	VARCHAR(6),
   type	    VARCHAR(10),
   title	VARCHAR(150),
   director VARCHAR(208),
   casts    VARCHAR(1000),
   country	VARCHAR(150),
   date_added VARCHAR(50),
   release_year INT,
   rating    VARCHAR(20),
   duration  VARCHAR(15),
   listed_in VARCHAR(100),
   description VARCHAR(300)
);

SELECT * FROM netflix;

SELECT COUNT(*) as total_count
FROM netflix;

SELECT DISTINCT type FROM netflix;

--Business Problems

--Q1. Count the number of movies vs tv shows
SELECT type ,
COUNT(*) as num_of_type
FROM netflix
GROUP BY type

--Q2. Find the most common rating for movies & TV Shows
SELECT type, MAX(rating)
FROM netflix
GROUP BY 1

--Q3. list all movies released in a specific year  (2020)
SELECT * FROM netflix
WHERE type = 'Movie'
AND
release_year = 2020

--Q4. Find the top 5 countries with the most content on netflix
SELECT 
UNNEST(STRING_TO_ARRAY (country,',')) as new_country,
COUNT (show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q5. Idetify the longest movie or tv show duration 
SELECT * FROM netflix
WHERE type = 'Movie' AND duration = (SELECT MAX(duration) FROM netflix)
LIMIT 2

--Q6. Find content added in last 5 years
SELECT * FROM netflix
WHERE TO_DATE(date_added,'Month DD , YYYY') >= CURRENT_DATE - INTERVAL '5 years'

--Q7. Find all the movies or tv shows by director 'Rajiv chilaka'
SELECT title , director FROM netflix
WHERE director = 'Rajiv Chilaka'

--Q8. List all the tv shows with more than 5 seasons
SELECT type , duration FROM netflix
WHERE type = 'TV Show'
AND
duration > '5 seasons'

--Q9. Count the no of content items in each genre
SELECT listed_in , show_id,
UNNEST (STRING_TO_ARRAY(listed_in , ','))
FROM netflix

--Q10. Find each year and the av numbers of content release by india on Netflix . return top 5 year with highest avg content release
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY'))as year, 
COUNT(*) as yearly_content,
ROUND(
COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India'):: numeric *100
,2) as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1

--Q11. list all the movies that are documentries
SELECT * FROM netflix
WHERE type = 'Movie' AND listed_in ILIKE '%documentaries%';

--Q12. FIND ALL THE CONTENT WITHOUT DIRECTOR
SELECT * FROM netflix
WHERE director IS NULL;

--Q13. Find how many movies actor 'Salman khan' appeared in cast 10 years
SELECT * FROM netflix
WHERE casts ILIKE '%Salman khan%'
AND 
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

--Q14. Find the top 10 actors who have appeared in highest no of movies produced in India
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--Q15. Categorise the content based on the presence of keywords 'kill' & 'violence' in the description field. 
--Label content containing these keywords as 'Bad' & all other content as 'Good'. 
--Count how many items fall into ech category.
SELECT 
    category,
    COUNT(*) AS total_content
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' 
            THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;


