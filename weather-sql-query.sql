

CREATE OR REPLACE STORAGE INTEGRATION weather_integ
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'my-id'
  STORAGE_ALLOWED_LOCATIONS = ('s3://weather-histroy-data/', 's3://daily-data-weather-api/',
  's3://forcast-history-data/')
  comment ='continue';

DESC INTEGRATION weather_integ;

CREATE or replace TABLE astro
(
sunrise varchar(100),
sunset varchar(100), 
moonrise varchar(100), 
moonset varchar(100), 
moon_phase varchar(100),
moon_illumination int,
is_moon_up int,
is_sun_up int

);
--forcast
CREATE or replace TABLE forcast(
time varchar(100), 
temp_c_forcaste float, 
is_day_forcaste float, 
wind_kph_forcaste float, 
wind_dir_forcaste varchar(100), 
pressure_mb_forcaste float,
precip_mm_forcaste float,
humidity_forcaste float, 
cloud_forcaste int, 
feelslike_c_forcaste float, 
dewpoint_c_forcaste float,
will_it_rain_forcaste int,
chance_of_rain_forcaste int,
vis_km_forcaste float,
uv_forcaste float, 
day_type varchar(100)

);

CREATE or replace TABLE forcast_history(
time varchar(100), 
temp_c_forcaste float, 
is_day_forcaste float, 
wind_kph_forcaste float, 
wind_dir_forcaste varchar(100), 
pressure_mb_forcaste float,
precip_mm_forcaste float,
humidity_forcaste float, 
cloud_forcaste int, 
feelslike_c_forcaste float, 
dewpoint_c_forcaste float,
will_it_rain_forcaste int,
chance_of_rain_forcaste int,
vis_km_forcaste float,
uv_forcaste float, 
day_type varchar(100)

);


CREATE TABLE history_data
(
time varchar(100),
temperature_2m float,
relative_humidity_2m float,
dewpoint_2m float,
apparent_temperature float,
surface_pressure float,
cloudcover int,
windspeed_10m float,
winddirection_10m float,
precipitation float,
WEATHER_TYPE varchar(100)
);

select * from forcast;

CREATE OR REPLACE STAGE current_data_stage
STORAGE_INTEGRATION = weather_integ
URL='s3://daily-data-weather-api/';



CREATE OR REPLACE STAGE history_data_stage
STORAGE_INTEGRATION = weather_integ
URL='s3://weather-histroy-data/';

CREATE OR REPLACE STAGE forcast_history_data_stage
STORAGE_INTEGRATION = weather_integ
URL='s3://forcast-history-data/';

COPY INTO forcast_history
FROM @forcast_history_data_stage/forcast_history.csv
FILE_FORMAT= (TYPE= CSV SKIP_HEADER=1);

COPY INTO history_data
FROM @history_data_stage
FILE_FORMAT= (TYPE= CSV SKIP_HEADER=1);


COPY INTO astro
FROM @current_data_stage/astro.csv
FILE_FORMAT= (TYPE= CSV SKIP_HEADER=1);

COPY INTO forcast
FROM @current_data_stage/forcast.csv
FILE_FORMAT= (TYPE= CSV SKIP_HEADER=1);


-- daily updation
CREATE OR REPLACE TASK daily_updation
  WAREHOUSE = ITC_WH
  SCHEDULE = 'USING CRON 30 0 * * * UTC'  
AS
BEGIN
  COPY INTO history_data
  FROM @history_data_stage
  FILE_FORMAT= (TYPE= CSV SKIP_HEADER=1);

  COPY INTO forecast
    FROM @current_data_stage/forecast.csv
    FILE_FORMAT = (TYPE= CSV SKIP_HEADER=1);

  COPY INTO astro
    FROM @current_data_stage/astro.csv
    FILE_FORMAT = (TYPE= CSV SKIP_HEADER=1);
END;

ALTER TASK daily_updation RESUME;

