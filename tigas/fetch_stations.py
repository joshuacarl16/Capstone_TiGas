import os
import requests
import django
import time

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "tigas.settings")
django.setup()

from backend.models import Station

def fetch_gas_stations(lat, lng, radius):
    API_KEY = 'AIzaSyCvx_bpq17DFPNuW9yNU4EvAo_oXFybnfo'
    url = f'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location={lat},{lng}&radius={radius}&type=gas_station&key={API_KEY}'
    stationCount = 0
    maxStations = 30

    while url and stationCount < maxStations:
        response = requests.get(url)
        data = response.json()
        results = data.get('results', [])
        
        for result in results:
            if stationCount >= maxStations:
                break

            place_id = result.get('place_id', '')
            fetch_and_create_station(place_id)

            stationCount += 1

        # wait for 2 seconds before fetching the next page
        time.sleep(2)

        # get the next page url
        next_page_token = data.get('next_page_token', '')
        url = f'https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken={next_page_token}&key={API_KEY}' if next_page_token else ''

def fetch_and_create_station(place_id):
    API_KEY = 'AIzaSyCvx_bpq17DFPNuW9yNU4EvAo_oXFybnfo'
    url = f'https://maps.googleapis.com/maps/api/place/details/json?place_id={place_id}&fields=name,vicinity,geometry,opening_hours&key={API_KEY}'
    response = requests.get(url)
    data = response.json()

    if 'result' in data:
        result = data['result']
        name = result.get('name', '')
        address = result.get('vicinity', '')
        latitude = result.get('geometry', {}).get('location', {}).get('lat', 0.0)
        longitude = result.get('geometry', {}).get('location', {}).get('lng', 0.0)
        opening_hours = result.get('opening_hours', {})

        station = Station.objects.create(
            name=name,
            address=address,
            place_id=place_id,
            latitude=latitude,
            longitude=longitude,
            opening_hours=opening_hours,
        )

        print(f'Successfully created Station: {station.name}')
    else:
        print('Failed to fetch data from Places API')

# Call the function with latitude, longitude, and radius
fetch_gas_stations(10.3156992, 123.88543660000005, 15000)
