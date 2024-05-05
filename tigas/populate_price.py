import os
import django

# Set DJANGO_SETTINGS_MODULE environment variable
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'tigas.settings')

# Initialize Django
django.setup()

from datetime import datetime
from backend.models import Station, Prices



def populate_prices():
    # Retrieve all stations with gasTypeInfo defined
    stations_with_gas_info = Station.objects.exclude(gasTypeInfo=None)

    for station in stations_with_gas_info:
        # Extract gasTypeInfo from the station
        gas_type_info = station.gasTypeInfo

        # Prepare a dictionary to accumulate all gas types and prices
        accumulated_gas_info = {}

        # Loop through each gas type and price in gasTypeInfo
        for gas_type, price_str in gas_type_info.items():
            try:
                price_value = float(price_str)  # Convert price string to float
                formatted_price_str = f"{price_value:.2f}"  # Format price to two decimal places as string
                accumulated_gas_info[gas_type] = formatted_price_str  # Add to accumulated gas info
            except ValueError:
                continue  # Skip if price_str is not a valid float

        # Create a single Prices instance for the station with accumulated gasTypeInfo
        if accumulated_gas_info:
            Prices.objects.create(
                station=station,
                uploaded_by='System',  # Set uploaded_by as desired
                gasTypeInfo=accumulated_gas_info,  # Store accumulated gas type and price info
                updated=datetime.now()  # Set updated timestamp
            )

    print("Prices populated successfully.")

if __name__ == '__main__':
    populate_prices()


# def delete_populated_prices():
#     # Filter Prices entries created by the population script (e.g., uploaded by 'System')
#         populated_prices = Prices.objects.filter(uploaded_by='lrac')

#         if populated_prices.exists():
#         # Get count of populated prices for logging purposes
#             populated_count = populated_prices.count()

#         # Delete populated Prices entries
#             populated_prices.delete()

#             print(f"Deleted {populated_count} populated Prices entries.")
#         else:
#             print("No populated Prices entries found.")

# if __name__ == '__main__':
#     delete_populated_prices()
