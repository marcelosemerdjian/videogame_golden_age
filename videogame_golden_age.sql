-- Step 1: Select the top 10 selling games by ordering them
SELECT *
FROM game_sales
ORDER BY games_sold DESC
LIMIT 10;

-- Step 2: Find missing value and check if the null values are going to affect the analysis.
-- In this case, 31 from 400 video games had null values when it comes to critic score.
SELECT count(game_sales.game)
FROM game_sales
LEFT JOIN reviews
USING(game)
WHERE user_score IS NULL AND critic_score IS NULL;

-- Step 3: Find the average critic score by year and then order by the best score descending, grouped by year.
SELECT year, round(avg(critic_score), 2) AS avg_critic_score
FROM game_sales
INNER JOIN reviews
USING(game)
GROUP BY year
ORDER BY avg_critic_score DESC
LIMIT 10;

-- Step 4: Based on the results, some of the average looked a little bit suspicious. A value of '9.00' was found, for example.
-- To avoid that, I filtered for games where the count of reviews was greater than 4.
SELECT year, round(avg(critic_score), 2) AS avg_critic_score, count(game_sales.game) AS num_games
FROM game_sales
INNER JOIN reviews
USING(game)
GROUP BY year
HAVING count(reviews.game) > 4
ORDER BY avg_critic_score DESC
LIMIT 10;

-- Step 5: Find the year that the count of reviews were fewer than 4 and calculate the average critic score for these years.
SELECT year, avg_critic_score
FROM top_critic_years
WHERE year NOT IN 
            (SELECT year
             FROM top_critic_years_more_than_four_games)
ORDER BY avg_critic_score DESC;


-- Step 6: For each year, find the average user score and a count of games released. Filter only the years with more than four reviewed games.
-- Finally, order the results by user score descending
SELECT year, round(avg(user_score), 2) AS avg_user_score, count(game_sales.game) AS num_games
FROM game_sales
INNER JOIN reviews
USING(game)
GROUP BY year
HAVING count(reviews.game) > 4
ORDER BY avg_user_score DESC
LIMIT 10;

-- Step 7: Select year for games that were reviewed by the critic and by the users.
SELECT year
FROM top_critic_years_more_than_four_games
WHERE year IN (SELECT year FROM top_user_years_more_than_four_games)

-- Step 8: From the previous task, only 3 years had reviews from critic and user and also more than 4 reviews per year.
-- Based on the results I calculated the total revenue from each year and found that 2008 was the year with the biggest revenue.
SELECT year, sum(games_sold) AS total_games_sold
FROM game_sales
WHERE year IN 
        (SELECT year
         FROM top_critic_years_more_than_four_games
         WHERE year IN (SELECT year FROM top_user_years_more_than_four_games))
GROUP BY year
ORDER BY total_games_sold DESC;
