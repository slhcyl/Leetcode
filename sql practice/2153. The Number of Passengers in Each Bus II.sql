/* 
Code
Testcase
Testcase
Test Result
2153. The Number of Passengers in Each Bus II
Solved
Hard
Topics
SQL Schema
Pandas Schema
Table: Buses

+--------------+------+
| Column Name  | Type |
+--------------+------+
| bus_id       | int  |
| arrival_time | int  |
| capacity     | int  |
+--------------+------+
bus_id contains unique values.
Each row of this table contains information about the arrival time of a bus at the LeetCode station and its capacity (the number of empty seats it has).
No two buses will arrive at the same time and all bus capacities will be positive integers.
 

Table: Passengers

+--------------+------+
| Column Name  | Type |
+--------------+------+
| passenger_id | int  |
| arrival_time | int  |
+--------------+------+
passenger_id contains unique values.
Each row of this table contains information about the arrival time of a passenger at the LeetCode station.
 

Buses and passengers arrive at the LeetCode station. If a bus arrives at the station at a time tbus and a passenger arrived at a time tpassenger where tpassenger <= tbus and the passenger did not catch any bus, the passenger will use that bus. In addition, each bus has a capacity. If at the moment the bus arrives at the station there are more passengers waiting than its capacity capacity, only capacity passengers will use the bus.

Write a solution to report the number of users that used each bus.

Return the result table ordered by bus_id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Buses table:
+--------+--------------+----------+
| bus_id | arrival_time | capacity |
+--------+--------------+----------+
| 1      | 2            | 1        |
| 2      | 4            | 10       |
| 3      | 7            | 2        |
+--------+--------------+----------+
Passengers table:
+--------------+--------------+
| passenger_id | arrival_time |
+--------------+--------------+
| 11           | 1            |
| 12           | 1            |
| 13           | 5            |
| 14           | 6            |
| 15           | 7            |
+--------------+--------------+
Output: 
+--------+----------------+
| bus_id | passengers_cnt |
+--------+----------------+
| 1      | 1              |
| 2      | 1              |
| 3      | 2              |
+--------+----------------+
Explanation: 
- Passenger 11 arrives at time 1.
- Passenger 12 arrives at time 1.
- Bus 1 arrives at time 2 and collects passenger 11 as it has one empty seat.

- Bus 2 arrives at time 4 and collects passenger 12 as it has ten empty seats.

- Passenger 12 arrives at time 5.
- Passenger 13 arrives at time 6.
- Passenger 14 arrives at time 7.
- Bus 3 arrives at time 7 and collects passengers 12 and 13 as it has two empty seats. */

# Write your MySQL query statement below
WITH RECURSIVE
UpdatedBuses AS (
    SELECT
        B.bus_id,
        B.arrival_time,
        B.capacity,
        COALESCE(LAG(B.arrival_time) OVER (ORDER BY B.arrival_time), 0) AS previous_bus_arrival
    FROM Buses B
)

,PassengerArrivalCounts AS (
    SELECT
        B.bus_id,
        B.arrival_time,
        B.capacity,
        B.previous_bus_arrival,
        COUNT(P.passenger_id) AS new_passengers,
        ROW_NUMBER() OVER (ORDER BY B.arrival_time) AS bus_sequence_number
    FROM UpdatedBuses B
    LEFT JOIN Passengers P
        ON P.arrival_time <= B.arrival_time AND P.arrival_time > B.previous_bus_arrival
    GROUP BY B.bus_id, B.arrival_time, B.capacity
)

,BusBoardingDetails AS (
    SELECT
        bus_sequence_number,
        bus_id,
        LEAST(capacity, new_passengers) AS passengers_boarded,
        (new_passengers - LEAST(capacity, new_passengers)) AS passengers_remaining
    FROM PassengerArrivalCounts
    WHERE bus_sequence_number = 1

    UNION ALL

    SELECT
        PAC.bus_sequence_number,
        PAC.bus_id,
        LEAST(PAC.capacity, PAC.new_passengers + REC.passengers_remaining) AS passengers_boarded,
        (PAC.new_passengers + REC.passengers_remaining) - LEAST(PAC.capacity, PAC.new_passengers + REC.passengers_remaining) AS passengers_remaining
    FROM
        BusBoardingDetails REC,
        PassengerArrivalCounts PAC
    WHERE
        PAC.bus_sequence_number = REC.bus_sequence_number + 1
)

Select bus_id
, passengers_boarded as passengers_cnt 
From BusBoardingDetails
order by 1

/* approach 2 */
WITH OrderedBusArrivals AS (
  -- Joining buses with passengers who arrived on or before each bus's arrival.
  -- Counting the number of passengers eligible to board each bus.
  SELECT 
    bus_id, 
    b.arrival_time, 
    capacity, 
    COUNT(passenger_id) AS eligible_passengers 
  FROM 
    Buses b 
    LEFT JOIN Passengers p ON p.arrival_time <= b.arrival_time 
  WHERE 
    bus_id IS NOT NULL 
  GROUP BY 
    bus_id 
  ORDER BY 
    b.arrival_time
) 
SELECT 
  bus_id, 
  passengers_cnt 
FROM 
  (
    SELECT 
      bus_id, 
      capacity, 
      eligible_passengers, 
      -- Calculating the number of passengers that can board the bus.
      -- Limited by either the bus's capacity or the remaining passengers after previous buses.
      @boarded_passengers := LEAST(
        capacity, eligible_passengers - @accumulated_boarding
      ) AS passengers_cnt, 
      -- Updating the total number of passengers who have boarded buses so far.
      @accumulated_boarding := @accumulated_boarding + @boarded_passengers 
    FROM 
      OrderedBusArrivals, 
      (
        SELECT 
          @accumulated_boarding := 0, 
          @boarded_passengers := 0
      ) AS Initialization
  ) AS FinalResult 
ORDER BY 
  bus_id;