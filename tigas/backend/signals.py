# from django.db.models.signals import post_save
# from django.dispatch import receiver
# from .models import Prices, Station

# @receiver(post_save, sender=Prices)
# def update_station_gasTypeInfo(sender, instance, created, **kwargs):
#     if created: 
#         station = instance.station
#         new_gasTypeInfo = instance.gasTypeInfo

        
#         max_price_difference = 3.0
        
#         for gas_type, updated_price_str in new_gasTypeInfo.items():
#             current_price_str = station.gasTypeInfo.get(gas_type, '0.0')
#             try:
#                 updated_price = float(updated_price_str)
#                 current_price = float(current_price_str)
                
#                 if abs(updated_price - current_price) <= max_price_difference:
            
#                     station.gasTypeInfo[gas_type] = updated_price_str
#             except ValueError:

#                 print(f"Invalid price value for {gas_type}: {updated_price_str}")

#         station.save()

from collections import defaultdict
from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Prices

uploaded_prices_dict = defaultdict(lambda: defaultdict(list))

@receiver(post_save, sender=Prices)
def update_station_gasTypeInfo(sender, instance, created, **kwargs):
    if created:
        station_id = instance.station_id
        new_gasTypeInfo = instance.gasTypeInfo

        max_price_difference = 3.0

        # Store the uploaded price info in the dictionary
        for gas_type, updated_price_str in new_gasTypeInfo.items():
            try:
                updated_price = float(updated_price_str)
                uploaded_prices_dict[station_id][gas_type].append(updated_price)
            except ValueError:
                print(f"Invalid price value for {gas_type}: {updated_price_str}")

        if station_id in uploaded_prices_dict:
            station = instance.station
            for gas_type, prices in uploaded_prices_dict[station_id].items():
                if len(prices) >= 2:

                    latest_price = prices[-1]
                    previous_price = prices[-2]

                    current_price_str = station.gasTypeInfo.get(gas_type, '0.0')
                    try:
                        current_price = float(current_price_str)

                        diff_latest = abs(latest_price - current_price)
                        diff_previous = abs(previous_price - current_price)

                        if diff_latest <= max_price_difference or diff_previous <= max_price_difference:
                            # Determine which price is closer to the current price
                            if diff_latest < diff_previous:
                                station.gasTypeInfo[gas_type] = f"{latest_price:.2f}"
                            else:
                                station.gasTypeInfo[gas_type] = f"{previous_price:.2f}"

                            print(f"Previous price {current_price}")
                            print(f"Updated gasTypeInfo for {gas_type}: {station.gasTypeInfo[gas_type]}")

                    except ValueError:
                        print(f"Invalid current price value for {gas_type}: {current_price_str}")

            station.save()
