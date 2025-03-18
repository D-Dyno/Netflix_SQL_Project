--Netflix project

drop table if exists netflix;
Create Table netflix 
(
	show_id	 VARCHAR(10),
	type	 VARCHAR(10),
	title	 VARCHAR(104),
	director VARCHAR(208),	
	casts	 VARCHAR(800),
	country	 VARCHAR(208),	
	date_added VARCHAR(50),
	release_year	int,
	rating	VARCHAR(10),
	duration	VARCHAR(15),
	listed_in	VARCHAR(105),
	description VARCHAR(300)
); 

Select * from netflix

Select Count(*) as total_content from netflix;

Select Distinct type  from netflix ;

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
Select * from netflix

Select type, COUNT(*) as total_content from netflix group by type ;


-- 2. Find the most common rating for movies and TV shows
Select * from netflix

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

--3. List all movies released in a specific year (e.g., 2020)
Select * from netflix
where 
	type = 'Movie'
	And release_year = 2020
	

-- 4. Find the top 5 countries with the most content on Netflix
Select 
	unnest(string_to_array(country,',')) as new_country,
	count(show_id) as total_contrnt
from netflix
Group by 1
order by 2 desc
limit 5


-- 5. Identify the longest movie
Select * from netflix
Where
	type = 'Movie'
	and 
	duration = (select max(duration) from netflix)


-- 6. Find content added in the last 5 years
select 
	*
from netflix
where
	to_date(date_added, 'Month DD, YYYY' ) >=current_date - interval '5 years'


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
Select * from netflix                -- XXXXX not correct we are not getting records of movies 
where director =  'Rajiv Chilaka'    -- who have multiple directors

Select * from netflix                
where director ILike  '%Rajiv Chilaka%'  --Added ILike instead of like as Like is case sensitive. 


-- 8. List all TV shows with more than 5 seasons
Select * from netflix  
Where 
	type ='TV Show'
	and 
	Split_part(duration,' ', 1)::numeric>5


-- 9. Count the number of content items in each genre
Select
	unnest(string_to_array(listed_in,',')) as genre,
	count (show_id) as total_content
from netflix
Group by 1


-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!
Select * from netflix  


Select 
	Extract(year from To_date(date_added, 'Month DD, YYYY')) as year,
	count(*) as yearly_content,
	round(
	count(*):: numeric/(select count(*) from netflix where country	= 'India')::numeric * 100
	,2) as avg_content_per_year
from netflix
where country = 'India'
Group by 1


-- 11. List all movies that are documentaries
Select * from netflix  
                
where listed_in ILike  '%Documentaries%'

-- 12. Find all content without a director
Select * from netflix  
                
where director is null


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
Select * from netflix                
where casts ILike  '%Salman khan%'
	and
	release_year >Extract (year from current_date) - 10


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
where country ilike '%india'
group by 1
order by 2 DESC
limit 10


-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

With new_table
as(
select *,
	case
	when 
		description  ilike '%kill%' or 
		description  ilike '%violence%' then 'Bad_content'
		else 'Good_content'
	End category
from netflix
)
select 
	category,
	count (*) as total_content
from new_table
Group by 1







