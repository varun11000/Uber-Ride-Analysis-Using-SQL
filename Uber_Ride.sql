use datascience;

select * from drivers_csv;
select * from passangers_csv;
select * from rides_csv;

#first create a schema & import all the 3 files namely, Rides, Drivers & Passangers.


use uber;


#Basic Level-->

#Q1: What are & how many unique pickup locations are there in the dataset?
SELECT DISTINCT pickup_location 
FROM rides_csv rc ;

SELECT COUNT(DISTINCT pickup_location) 
FROM rides_csv rc ;


#Q2: What is the total number of rides in the dataset?
SELECT COUNT(*) 
FROM rides_csv rc ;

#Q3: Calculate the average ride duration.
SELECT AVG(ride_duration) 
FROM rides_csv rc ;

#Q4: List the top 5 drivers based on their total earnings.
SELECT driver_id, SUM(earnings) AS total_earnings 
FROM drivers_csv
GROUP BY driver_id 
ORDER BY total_earnings DESC LIMIT 5;

#Q5: Calculate the total number of rides for each payment method.
SELECT payment_method, COUNT(*) AS ride_count 
FROM rides_csv rc 
GROUP BY payment_method;

#Q6: Retrieve rides with a fare amount greater than 20.
SELECT * 
FROM rides_csv rc 
WHERE fare_amount > 20;

#Q7: Identify the most common pickup location.
SELECT pickup_location, COUNT(*) AS ride_count 
FROM rides_csv rc 
GROUP BY pickup_location 
ORDER BY ride_count DESC LIMIT 1;

#Q8: Calculate the average fare amount.
SELECT AVG(fare_amount)
FROM rides_csv rc ;

#Q9: List the top 10 drivers with the highest average ratings.
SELECT driver_id, avg(rating) as avg_rating 
FROM drivers_csv dc 
GROUP BY driver_id 
order by avg_rating DESC LIMIT 10;

#Q10: Calculate the total earnings for all drivers.
SELECT SUM(earnings) 
FROM drivers_csv dc ;

#Q11: How many rides were paid using the "Cash" payment method?
SELECT COUNT(*) 
FROM rides_csv rc 
WHERE payment_method = 'Cash';

#Q12: Calculate the number of rides & average ride distance for rides originating from the 'Dhanbad' pickup location.
SELECT pickup_location ,count(*), AVG(ride_distance) 
FROM rides_csv rc 
WHERE pickup_location = 'Dhanbad';

#Q13: Retrieve rides with a ride duration less than 10 minutes.
SELECT * 
FROM rides_csv rc 
WHERE ride_duration < 10;

#Q14: List the passengers who have taken the most number of rides.
SELECT passenger_id, COUNT(*) AS ride_count 
FROM rides_csv rc GROUP BY passenger_id 
ORDER BY ride_count DESC LIMIT 1;

#Q15: Calculate the total number of rides for each driver in descending order.
SELECT driver_id, COUNT(*) AS ride_count 
FROM rides_csv rc 
GROUP BY driver_id 
ORDER BY ride_count DESC;

#Q16: Identify the payment methods used by passengers who took rides from the 'Gandhinagar' pickup location.
SELECT DISTINCT payment_method 
FROM rides_csv rc 
WHERE pickup_location = 'Gandhinagar';

#Q17: Calculate the average fare amount for rides with a ride distance greater than 10.
SELECT AVG(fare_amount) 
FROM rides_csv rc 
WHERE ride_distance > 10;

#Q18: List the drivers in descending order accordinh to their total number of rides.
SELECT driver_id, total_rides
FROM drivers_csv dc 
order by total_rides DESC;

#Q19: Calculate the percentage distribution of rides for each pickup location.
SELECT pickup_location, COUNT(*) AS ride_count, ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM rides_csv rc), 2) AS percentage 
FROM rides_csv rc 
GROUP BY pickup_location
order by percentage desc;


select pickup_location, count(pickup_location) from rides_csv rc group by pickup_location;
select pickup_location, count(*) as ride_count from rides_csv rc group by pickup_location ;

select count(pickup_location) from rides_csv rc;

#Q20: Retrieve rides where both pickup and dropoff locations are the same.
SELECT * 
FROM rides_csv rc 
WHERE pickup_location = dropoff_location;

#Intermediate Level-->

#Q1: List the passengers who have taken rides from at least 300 different pickup locations.
SELECT passenger_id, COUNT(DISTINCT pickup_location) AS distinct_locations
FROM rides_csv rc 
GROUP BY passenger_id
HAVING distinct_locations >= 300;

#Q2: Calculate the average fare amount for rides taken on weekdays.
SELECT AVG(fare_amount)
FROM rides_csv rc 
WHERE DAYOFWEEK(STR_TO_DATE(ride_timestamp, '%m/%d/%Y %H:%i'))>5;

select ride_timestamp, (STR_TO_DATE(ride_timestamp)) from rides_csv rc;

SELECT DATE_FORMAT("2017-06-15", "%M %d %Y");
SELECT DATE_FORMAT("2017-06-15", "%W %M %e %Y");




#Q3: Identify the drivers who have taken rides with distances greater than 19.
select * from rides_csv rc ;
SELECT DISTINCT driver_id, ride_distance 
from rides_csv
WHERE ride_distance > 19;

#Q4: Calculate the total earnings for drivers who have completed more than 100 rides.
SELECT driver_id, SUM(earnings) AS total_earnings
FROM drivers_csv 
WHERE driver_id IN (SELECT driver_id FROM rides_csv rc GROUP BY driver_id HAVING COUNT(*) > 100)
GROUP BY driver_id;

select * from drivers_csv dc2;

select rides_csv.ride_id ,drivers_csv.driver_id, count(drivers_csv.driver_id), sum(drivers_csv.earnings) as total_earning
from drivers_csv inner join rides_csv 
on drivers_csv.driver_id = rides_csv.driver_id
group by drivers_csv.driver_id
having count(drivers_csv.driver_id)>100;

#Q5: Retrieve rides where the fare amount is less than the average fare amount.
SELECT * 
FROM rides_csv rc 
WHERE fare_amount < (SELECT AVG(fare_amount) FROM rides_csv );


SELECT AVG(fare_amount) FROM rides_csv;

#Q6: Calculate the average rating of drivers who have driven rides with both 'Credit Card' and 'Cash' payment methods.
SELECT driver_id, AVG(rating) AS avg_rating
FROM drivers
WHERE driver_id IN (SELECT driver_id FROM Rides WHERE payment_method IN ('Credit Card', 'Cash') GROUP BY driver_id HAVING COUNT(DISTINCT payment_method) = 2)
GROUP BY driver_id;


select * from rides_csv rc;

select * from drivers_csv dc;

select * from passangers_csv pc;

select dc.driver_id, avg(rating) as avg_rating 
from drivers_csv dc inner join rides_csv rc
on dc.driver_id = rc.driver_id 
where rc.payment_method in ("Cash", "Credit Card")
group by dc.driver_id
having count(distinct rc.payment_method)=2;





#Q7: List the top 3 passengers with the highest total spending.
SELECT p.passenger_id, p.passenger_name, SUM(r.fare_amount) AS total_spending
FROM Passangers p
JOIN Rides r ON p.passenger_id = r.passenger_id
GROUP BY p.passenger_id, p.passenger_name
ORDER BY total_spending DESC
LIMIT 3;

select pc.passenger_id, pc.passenger_name, sum(rc.fare_amount) as total_fare
from passangers_csv pc inner join rides_csv rc 
on pc.passenger_id = rc.passenger_id 
group by pc.passenger_id 
order by total_fare desc
limit 3;

#Q8: Calculate the average fare amount for rides taken during different months of the year.
SELECT MONTH(STR_TO_DATE(ride_timestamp, '%m/%d/%Y %H:%i')) AS month_of_year, AVG(fare_amount) AS avg_fare
FROM Rides
GROUP BY month_of_year;

create table new_rides select * from rides_csv rc;

select * from new_rides;

SELECT MONTH(ride_timestamp) AS month_of_year, AVG(fare_amount) AS avg_fare
FROM rides_date_csv rdc 
GROUP BY month_of_year;




select ride_timestamp, monthname(STR_TO_DATE(ride_timestamp, '%m/%d/%Y %H:%i')) as new_date  from rides_csv rc ;

select ride_timestamp, monthname(STR_TO_DATE(ride_timestamp, '%m/%d/%Y')) as new_date  from rides_csv rc ;



(STR_TO_DATE(ride_timestamp, '%m/%d/%Y %H:%i') as ride_date from new_rides;

select * from rides_date_csv;




#Q9: Identify the most common pair of pickup and dropoff locations.
SELECT pickup_location, dropoff_location, COUNT(*) AS ride_count
FROM rides_date_csv rc
GROUP BY pickup_location, dropoff_location;


SELECT pickup_location, dropoff_location, COUNT(*) AS ride_count
FROM rides_date_csv rc
GROUP BY pickup_location, dropoff_location
ORDER BY ride_count DESC
LIMIT 1;

#Q10: Calculate the total earnings for each driver and order them by earnings in descending order.
SELECT driver_id, SUM(earnings) AS total_earnings
FROM drivers_csv dc 
GROUP BY driver_id
ORDER BY total_earnings DESC;

#Q11: List the passengers who have taken rides on their signup date.
SELECT p.passenger_id, p.passenger_name
FROM Passangers p
JOIN Rides r ON p.passenger_id = r.passenger_id
WHERE DATE(p.signup_date) = DATE(r.ride_timestamp);

#Q12: Calculate the average earnings for each driver and order them by earnings in descending order.
SELECT driver_id, avg(earnings) AS average_earnings
FROM drivers_csv dc 
GROUP BY driver_id
ORDER BY average_earnings DESC;

#Q13: Retrieve rides with distances less than the average ride distance.
SELECT ride_id, avg(ride_distance)
FROM rides_csv rc 
WHERE ride_distance < (SELECT AVG(ride_distance) FROM rides_csv)
group by ride_id;

SELECT AVG(ride_distance) FROM rides_csv;

#Q14: List the drivers who have completed the least number of rides.
SELECT driver_name,  COUNT(driver_id) AS ride_count
FROM drivers_csv dc 
GROUP BY driver_id
ORDER BY ride_count ASC;


select * from rides_csv;

select * from drivers_csv;

#Q15: Calculate the average fare amount for rides taken by passengers who have taken at least 20 rides.
SELECT AVG(fare_amount)
FROM rides_csv rc 
WHERE passenger_id IN (SELECT passenger_id FROM rides_csv rc2 GROUP BY passenger_id HAVING COUNT(*) >= 20);

#Q16: Identify the pickup location with the highest average fare amount.
SELECT pickup_location, AVG(fare_amount) AS avg_fare
FROM rides_csv rc 
GROUP BY pickup_location
ORDER BY avg_fare desc
LIMIT 1;

#Q17: Calculate the average rating of drivers who completed at least 100 rides.
SELECT AVG(rating) FROM drivers_csv dc WHERE driver_id IN 
(SELECT driver_id FROM rides_csv rc GROUP BY driver_id  HAVING COUNT(*) >= 100
);

select dc.driver_id, avg(rating) as Avg_Rating
from drivers_csv dc inner join rides_date_csv rdc 
on dc.driver_id = rdc.driver_id 
group by dc.driver_id 
having avg(rating)<100;



#Q18: List the passengers who have taken rides from at least 5 different pickup locations.
SELECT passenger_id,pickup_location, COUNT(DISTINCT pickup_location) AS distinct_locations
FROM rides_csv rc 
GROUP BY passenger_id
HAVING distinct_locations >= 300;

#Q19: Calculate the average fare amount for rides taken by passengers with ratings above 4.
SELECT AVG(fare_amount) FROM rides_csv rc WHERE passenger_id in
(SELECT passenger_id FROM passangers_csv pc WHERE rating > 4);

#Q20: Retrieve rides with the shortest ride duration in each pickup location.
SELECT r1.* FROM rides_csv rc r1
JOIN (
    SELECT pickup_location, MIN(ride_duration) AS min_duration
    FROM rides_date_csv r1
    GROUP BY pickup_location
) r2 ON r1.pickup_location = r2.pickup_location AND r1.ride_duration = r2.min_duration;

select rides_csv.* from rides_csv rc2 
inner join 
(select pickup_location, min(ride_duration) as min_duration from rides_csv rc group by pickup_location);

select distinct pickup_location from rides_date_csv rdc where ride_id = (select ride_id from rides_date_csv rdc2 where ride_duration=
(select min(ride_duration) from rides_date_csv));

select * from rides_date_csv rdc;

#solution

select ride_id, ride_duration, pickup_location from rides_date_csv rdc2 where ride_duration=
(select min(ride_duration) from rides_date_csv);


select pickup_location, MIN(ride_duration) AS min_duration FROM rides_date_csv rdc GROUP BY pickup_location);


select *  from rides_date_csv rdc where ride_id = (select ride_id, pickup_location, MIN(ride_duration) AS min_duration FROM rides_date_csv rdc GROUP BY pickup_location);

SELECT r1.* FROM rides_date_csv rdc1 
inner join 
(select pickup_location, min(ride_duration) from rides_date_csv rdc group by pickup_location)
rdc2 on rdc1.pickup_location = rdc2.pickup_location;



#Advanced Level-->

#Q1: List the drivers who have driven rides in all pickup locations.
SELECT driver_id
FROM Drivers
WHERE driver_id NOT IN (
    SELECT DISTINCT driver_id
    FROM Rides
    WHERE pickup_location NOT IN (
        SELECT DISTINCT pickup_location
        FROM Rides
    )
);


select driver_id from drivers_csv dc where driver_id not in (


select distinct driver_id from rides_csv rc where pickup_location not in 
(select distinct pickup_loacation from rides_date_csv rdc));

#solution
select * from rides_date_csv rdc;

select distinct driver_id,pickup_location from rides_date_csv rdc where pickup_location in (select distinct pickup_location from rides_date_csv rdc);

select distinct pickup_location from rides_date_csv rdc;


#Q2: Calculate the average fare amount for rides taken by passengers who have spent more than 300 in total.
#solution
SELECT AVG(fare_amount)
FROM rides_date_csv rdc 
WHERE passenger_id IN (SELECT passenger_id FROM passangers_csv pc WHERE total_spent > 300);

#Q3: List the bottom 5 drivers based on their average earnings.
SELECT driver_id, avg(earnings) AS avg_earnings 
FROM drivers_csv dc 
GROUP BY driver_id 
ORDER BY avg_earnings asc LIMIT 5;

#Q4: Calculate the sum fare amount for rides taken by passengers who have taken rides in different payment methods.

#solution
SELECT SUM(fare_amount)
FROM rides_date_csv rdc2 
WHERE passenger_id IN (SELECT passenger_id FROM rides_date_csv rdc GROUP BY passenger_id
HAVING COUNT(DISTINCT payment_method) > 1
);

SELECT passenger_id, payment_method FROM rides_date_csv rdc GROUP BY passenger_id
HAVING COUNT(DISTINCT payment_method) > 1;

select COUNT(DISTINCT payment_method) from rides_date_csv rdc;


#Q5: Retrieve rides where the fare amount is significantly above the average fare amount.
SELECT *
FROM rides_date_csv rdc 
WHERE fare_amount > (SELECT AVG(fare_amount) from rides_date_csv);

SELECT AVG(fare_amount) from rides_date_csv;

#Q6: List the drivers who have completed rides on the same day they joined.
SELECT dc.driver_id, dc.driver_name
FROM drivers_csv dc JOIN rides_date_csv rdc
ON dc.driver_id = rdc.driver_id
WHERE dc.join_date = rdc.ride_timestamp;


select join_date from drivers_csv dc;

select ride_timestamp from rides_date_csv rdc;

#Q7: Calculate the average fare amount for rides taken by passengers who have taken rides in different payment methods.
SELECT AVG(fare_amount)
FROM rides_date_csv rdc 
WHERE passenger_id IN (
    SELECT passenger_id
    FROM  rides_date_csv rdc 
    GROUP BY passenger_id
    HAVING COUNT(DISTINCT payment_method) > 1
);

#Q8: Identify the pickup location with the highest percentage increase in average fare amount compared to the overall average fare.
SELECT pickup_location, AVG(fare_amount) AS avg_fare,
       (AVG(fare_amount) - (SELECT AVG(fare_amount) from rides_date_csv rdc2)) * 100.0 / (SELECT AVG(fare_amount) FROM rides_date_csv rdc3) AS percentage_increase
FROM rides_date_csv rdc 
GROUP BY pickup_location
ORDER BY percentage_increase desc;
LIMIT 1;

#Q9: Retrieve rides where the dropoff location is the same as the pickup location.
SELECT *
FROM rides_date_csv rdc 
WHERE pickup_location = dropoff_location;

#Q10: Calculate the average rating of drivers who have driven rides with varying pickup locations.
SELECT AVG(rating) FROM drivers_csv dc WHERE driver_id IN (SELECT DISTINCT driver_id FROM rides_date_csv rdc 
    GROUP BY driver_id
    HAVING COUNT(DISTINCT pickup_location) > 1
);



