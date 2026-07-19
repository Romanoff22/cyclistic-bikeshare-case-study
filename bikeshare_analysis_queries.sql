-- 1. Row count check
SELECT COUNT(*) FROM `my-first-project-500206.divvy_tripdata_2025.all_trips`;

-- 2. Overall split
SELECT member_casual, COUNT(*) AS ride_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM `my-first-project-500206.divvy_tripdata_2025.all_trips`
GROUP BY member_casual;

-- 3. Duration stats
SELECT 
  member_casual,
  ROUND(AVG(ride_duration), 2) AS avg_minutes,
  APPROX_QUANTILES(ride_duration, 2)[OFFSET(1)] AS median_minutes,
  ROUND(MIN(ride_duration), 2) AS min_minutes,
  ROUND(MAX(ride_duration), 2) AS max_minutes,
  ROUND(STDDEV(ride_duration), 2) AS stddev_minutes
FROM `my-first-project-500206.divvy_tripdata_2025.all_trips`
GROUP BY member_casual;

-- 4. Weekly pattern
SELECT day_of_week, member_casual, COUNT(*) AS ride_count
FROM `my-first-project-500206.divvy_tripdata_2025.all_trips`
GROUP BY day_of_week, member_casual
ORDER BY
  CASE day_of_week
    WHEN 'Sunday' THEN 1 WHEN 'Monday' THEN 2 WHEN 'Tuesday' THEN 3
    WHEN 'Wednesday' THEN 4 WHEN 'Thursday' THEN 5 WHEN 'Friday' THEN 6
    WHEN 'Saturday' THEN 7 END, member_casual;

-- 5. Seasonality
SELECT month, member_casual, COUNT(*) AS ride_count
FROM `my-first-project-500206.divvy_tripdata_2025.all_trips`
GROUP BY month, member_casual
ORDER BY
  CASE month
    WHEN 'January' THEN 1 WHEN 'February' THEN 2 WHEN 'March' THEN 3
    WHEN 'April' THEN 4 WHEN 'May' THEN 5 WHEN 'June' THEN 6
    WHEN 'July' THEN 7 WHEN 'August' THEN 8 WHEN 'September' THEN 9
    WHEN 'October' THEN 10 WHEN 'November' THEN 11 WHEN 'December' THEN 12
  END, member_casual;

-- 6. Hourly pattern
SELECT hour, member_casual, COUNT(*) AS ride_count
FROM `my-first-project-500206.divvy_tripdata_2025.all_trips`
GROUP BY hour, member_casual
ORDER BY hour, member_casual;

-- 7. Time bucket, % within rider type
SELECT time_bucket, member_casual, COUNT(*) AS ride_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY member_casual), 2) AS pct_within_rider_type
FROM `my-first-project-500206.divvy_tripdata_2025.all_trips`
GROUP BY time_bucket, member_casual
ORDER BY member_casual, time_bucket;

-- 8. Time bucket, % of each bucket (the 81% stat)
SELECT time_bucket, member_casual, ride_count,
  ROUND(ride_count * 100.0 / SUM(ride_count) OVER (PARTITION BY time_bucket), 2) AS pct_of_this_bucket
FROM (
  SELECT time_bucket, member_casual, COUNT(*) AS ride_count
  FROM `my-first-project-500206.divvy_tripdata_2025.all_trips`
  GROUP BY time_bucket, member_casual
)
ORDER BY time_bucket, member_casual;

-- 9. Bike type
SELECT rideable_type, member_casual, COUNT(*) AS ride_count
FROM `my-first-project-500206.divvy_tripdata_2025.all_trips`
GROUP BY rideable_type, member_casual;