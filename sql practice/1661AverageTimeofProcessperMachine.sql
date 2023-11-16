/*  */
/* Approach 1: Transform Values with CASE WHEN and then Calculate
Algorithm
To calculate the time to complete a process, we need to know the difference between the 'start' timestamp and the 'end' timestamp for each machine and process. 
If we set all the 'start' timestamp to its negative value, we can get the time difference by using SUM(), since (-start) + end is equal to end - start, 
which is the time difference.
To do this, we use CASE WHEN to multiply all the start timestamp by -1, so the aggregated total of timestamp becomes the time to complete a process for each machine. */
SELECT 
    machine_id,
    ROUND(SUM(CASE WHEN activity_type='start' THEN timestamp*-1 ELSE timestamp END)*1.0
    / (SELECT COUNT(DISTINCT process_id)),3) AS processing_time
FROM 
    Activity
GROUP BY machine_id

/* Approach 2: Calling the original Table twice and Calculate as two columns
Algorithm
For this approach, we are calling the original table twice, once as the table that stores the start timestamps and once as the table that stores the end timestamps. 
To create the table alias, we give the original table Activity two different names, and filter each table by the activity_type. 
We also make sure the two tables are joined on the machine_id and process_id, 
so the output will have the start timestamp and end timestamp stored in two different columns for each machine and process. */
SELECT a.machine_id, 
       ROUND(AVG(b.timestamp - a.timestamp), 3) AS processing_time
FROM Activity a, 
     Activity b
WHERE 
    a.machine_id = b.machine_id
AND 
    a.process_id = b.process_id
AND 
    a.activity_type = 'start'
AND 
    b.activity_type = 'end'
GROUP BY machine_id

/* Approach 1: Update Values with lambda and then Calculate
Algorithm
To calculate the time to complete a process, we need to know the difference between the 'start' timestamp and the 'end' timestamp for each machine and process. 
If we set all the 'start' timestamp to its negative value, we can get the time difference by using SUM(), since (-start) + end is equal to end - start, 
which is the time difference.

We use apply() and lambda to transform the timestamp for all rows that have an activity_type equals to 'start'. 
To convert the timestamp to negative, we have the timestamp multiplied by -1. We pass the parameter 'axis=1' so the calculation will be applied across rows. */
import pandas as pd

def get_average_time(activity: pd.DataFrame) -> pd.DataFrame:
    activity['timestamp'] = activity.apply(lambda x: x.timestamp * -1 if x.activity_type == 'start' else x.timestamp, axis=1)

    sum_machine_process = activity.groupby(['machine_id', 'process_id'], as_index=False)['timestamp'].sum()

    mean_machine = sum_machine_process.groupby(['machine_id'], as_index=False)['timestamp'].mean().round(3).rename(columns = {'timestamp': 'processing_time'})
    
    return mean_machine