import json
import os
import boto3
import pandas as pd
from pandas import json_normalize
from io import StringIO
from datetime import datetime
import requests as r

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    bucket_name = 'forcast-history-data'
    file_name = 'forcast_history.csv'
    bucket_name2 = 'daily-data-weather-api'
    file_name2 = ['forcast.csv', 'astro.csv']

    # --- Read old history data
    response = s3.get_object(Bucket=bucket_name, Key=file_name)
    data = response['Body'].read().decode('utf-8')
    old_data = pd.read_csv(StringIO(data))

    # --- Read old forecast data
    response2 = s3.get_object(Bucket=bucket_name2, Key=file_name2[0])
    data2 = response2['Body'].read().decode('utf-8')
    forcast_recent_old_data = pd.read_csv(StringIO(data2))

    # --- Get new forecast from API
    api = os.environ['weather_api']
    today = datetime.today().strftime("%Y-%m-%d")
    today_1 = datetime.today().strftime("%d-%m-%y")

    url = f'http://api.weatherapi.com/v1/forecast.json?key={api}&q=chennai&dt={today}'
    res = r.get(url).json()

    forcast = json_normalize(res['forecast']['forecastday'][0]['hour'], sep='.')
    astro = json_normalize(res['forecast']['forecastday'][0]['astro'], sep='.')

    # --- Merge old and recent forecast (stack vertically)
    if forcast_recent_old_data['time'][0][:10]!=today_1:
        merged_data = pd.concat([forcast_recent_old_data, old_data], axis=0, ignore_index=True)
        merged_data = merged_data.drop_duplicates(subset=["time"], keep="last")
        csv_buffer1 = StringIO()
        merged_data.to_csv(csv_buffer1, index=False)
        s3.put_object(Bucket=bucket_name, Key=file_name, Body=csv_buffer1.getvalue())
        for file_key in file_name2:
            s3.delete_object(Bucket=bucket_name2, Key=file_key)
        csv_buffer2 = StringIO()
        csv_buffer3 = StringIO()
        forcast = forcast.drop_duplicates(subset=["time"], keep="last")
        forcast.to_csv(csv_buffer2, index=False)
        astro.to_csv(csv_buffer3, index=False)
        s3.put_object(Bucket=bucket_name2, Key='forcast.csv', Body=csv_buffer2.getvalue())
        s3.put_object(Bucket=bucket_name2, Key='astro.csv', Body=csv_buffer3.getvalue())
        return {
        'statusCode': 200,
        'body': json.dumps('Forecast updated successfully')}
    else:
        return {
        'statusCode': 200,
        'body': json.dumps('already updated')}
