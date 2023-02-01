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
