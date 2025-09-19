# CHENNAI-WEATHER-DATA-ANALYSIS-END-TO-END-PROJECT

## <u>Executive Summary</u>

Businesses in weather-dependent sectors often struggle with fragmented, outdated, and manually collected weather data, which hinders accurate forecasting and timely decision-making. This project addresses that challenge by implementing an automated cloud-based pipeline focused on Chennai. **It collects daily and historical weather data from WeatherAPI.com and Open-Meteo, stores it in Amazon S3 via AWS Lambda and Amazon EventBridge, processes and transforms it in Snowflake, and visualizes it through dynamic dashboards in Power BI**. This end-to-end solution reduces manual effort, ensures data accuracy, and enables faster, data-driven decision-making through real-time weather insights for Chennai.

## <u>Business Problem</u>

Weather data plays a crucial role in driving operational and strategic decisions across industries such as agriculture, logistics, energy, and retail. However, in Chennai, most organizations lack a unified system to collect and manage weather information effectively. Data is often scattered across multiple sources, updated manually, and not stored in a structured format, making it difficult to access, analyze, and derive insights in real time. This results in inaccurate local forecasts, slow decision-making, and missed opportunities to optimize business operations based on Chennai’s specific weather patterns.

## <u>Solution</u>

To address the challenge of fragmented and manually collected weather data in Chennai, this project implements a fully automated, cloud-based weather data analysis pipeline. The system collects daily **weather data from WeatherAPI.com and historical weather data from Open-Meteo** through Python scripts triggered automatically using **AWS Lambda** and scheduled with **Amazon EventBridge**. **The collected data is stored in organized Amazon S3 buckets** (separate buckets for daily data, historical data, and forecast history) to maintain structured and scalable storage. The stored data is then ingested into **Snowflake, where SQL-based ETL workflows clean, transform, and model the data for analysis**. Finally, the processed data is connected to **Power BI** to build interactive dashboards that provide real-time visual insights into weather patterns and trends in Chennai. This solution eliminates manual effort, ensures data accuracy, and enables faster data-driven decision-making.

## <u>Methodology</u>

### 1. <u>Data Acquisition</u>
 Identified WeatherAPI.com as the primary source for daily weather data and Open-Meteo as the source for historical data. Created Python scripts to call both APIs and fetch weather attributes specific to Chennai.

      url=f'http://api.weatherapi.com/v1/forecast.json?key={api}&q=chennai&dt={today}' #WEATHERAPI.COM
      data=r.get(url)
      data=data.json()


Implemented a **AWS Lambda function to run these scripts automatically** . Configured Amazon EventBridge to trigger the Lambda function every day, ensuring continuous data collection without manual effort.

### 2. <u>Cloud Storage Setup</u>

The data retrieved by Lambda functions was stored directly into three organized **Amazon S3 buckets**: one for historical data (initially fetched from Open-Meteo), one for daily data (fetched from WeatherAPI.com each day via the scheduled Lambda), and one for forecast history (which accumulates daily forecast snapshots to track changes over time). EventBridge ensured Lambda executed on schedule, eliminating any manual intervention. Each bucket used date-based folder structures for version control and easy traceability.

### 3.<u>Data Ingestion and Transformation</u>
Snowflake was connected to the S3 buckets using external stages, and COPY commands were used to ingest new data daily. Lambda and EventBridge also triggered data load tasks, ensuring fresh data flowed automatically from S3 into Snowflake. Within Snowflake, SQL-based ETL workflows were developed to clean and transform the data

### 4.<u>Data Visualization</u>

The curated data from Snowflake was connected to Power BI, where interactive dashboards were built to visualize temperature trends, rainfall patterns, and humidity variations for Chennai. Scheduled refresh in Power BI ensured dashboards remained up to date with the latest data ingested through the automated pipeline.

### <u>Skills</u>
+ Python
+ SQL
+ AWS Lambda
+ Amazon EventBridge
+ Amazon S3
+ Snowflake
+ Power BI

### <u>Results</u>
#### DASHBOARD 1
![dashboard-1](https://raw.githubusercontent.com/NaveenRoshan100/WEATHER-DATA-ANALYSIS-END-TO-END-PROJECT/refs/heads/main/DASHBOARDS/dashboard-1.png)


#### DASHBOARD 2

![dashboard-2](https://raw.githubusercontent.com/NaveenRoshan100/WEATHER-DATA-ANALYSIS-END-TO-END-PROJECT/refs/heads/main/DASHBOARDS/dashboard-2.png)

#### DASHBOARD 3

![dashboard-3](https://raw.githubusercontent.com/NaveenRoshan100/WEATHER-DATA-ANALYSIS-END-TO-END-PROJECT/refs/heads/main/DASHBOARDS/dashboard-3.png)

#### DASHBOARD 4

![dashboard-4](https://raw.githubusercontent.com/NaveenRoshan100/WEATHER-DATA-ANALYSIS-END-TO-END-PROJECT/refs/heads/main/DASHBOARDS/dashboard-4.png)

