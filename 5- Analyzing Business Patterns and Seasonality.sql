-- Main Objective (1): Analyzing Seasonality

-- Task: An Email was sent on January 02-2013 from the CEO: Cindy Sharp and it includes the following:

-- 2012 was a great year for us. As we continue to grow,
--  we should take a look at 2012’s monthly and weekly volume patterns , to see if we can find any seasonal trends we should plan for in 2013.
-- If you can pull session volume and order volume , that would be excellent.

-- -----------------------------------------------------------------------------------------------------------------------------

-- Solution Starts:

SELECT
Year(website_sessions.created_at),
Month(website_sessions.created_at),
min(date(website_sessions.created_at)) AS Start_of_Week, -- For Weekly Volume patterns
COUNT(DISTINCT website_sessions.website_session_id) as Number_of_Sessions,
COUNT(DISTINCT orders.order_id) as Number_of_orders
FROM website_sessions
LEFT JOIN orders
on website_sessions.website_session_id=orders.website_session_id
WHERE website_sessions.created_at < '2013-01-01'
GROUP BY 1,2, YEARWEEK(website_sessions.created_at); -- For Weekly Volume patterns

-- Conlcusion to question(1):
-- The weeks of 18th & 25th of November had a huge surge in the number of sessions due to Black Friday and Cyber Monday
-- The number of orders have doubled between the weeks of the 11th and 18th of November
-- -----------------------------------------------------------------------------------------------------------------------------

-- Main Objective (2): Analyzing Business Patterns

-- Task: An Email was sent on January 05-2013 from the CEO: Cindy Sharp and it includes the following:

-- We’re considering adding live chat support to the website to improve our customer experience.
-- Could you analyze the average website session volume, by hour of day and by day week so that we can staff appropriately?
-- Let’s avoid the holiday time period and use a date range of Sep 15 Nov 15, 2012
-- -----------------------------------------------------------------------------------------------------------------------------

-- Solution Starts:
SELECT
hr,
ROUND(AVG(CASE WHEN day_of_the_week=0 THEN number_of_sessions ELSE NULL END),1) AS MON,
ROUND(AVG(CASE WHEN day_of_the_week=1 THEN number_of_sessions ELSE NULL END),1) AS TUE,
ROUND(AVG(CASE WHEN day_of_the_week=2 THEN number_of_sessions ELSE NULL END),1) AS WED,
ROUND(AVG(CASE WHEN day_of_the_week=3 THEN number_of_sessions ELSE NULL END),1) AS THU,
ROUND(AVG(CASE WHEN day_of_the_week=4 THEN number_of_sessions ELSE NULL END),1) AS FRI,
ROUND(AVG(CASE WHEN day_of_the_week=5 THEN number_of_sessions ELSE NULL END),1) AS SAT,
ROUND(AVG(CASE WHEN day_of_the_week=6 THEN number_of_sessions ELSE NULL END),1) AS SUN
FROM(
SELECT -- Start of Subquery
DATE(created_at) as date,
HOUR(created_at) as hr,
WEEKDAY(created_at) as day_of_the_week,
COUNT(DISTINCT website_session_id) as number_of_sessions
FROM Website_sessions
WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY 1,2,3) as daily_hourly_sessions -- End of Subquery
GROUP BY hr;

-- Conlcusion to question(2):
-- The highest traffic is from (8 to 20) 8 AM to 8 PM
-- The traffic is lighter on the Weekend (Staurday & Sunday)
-- -----------------------------------------------------------------------------------------------------------------------------