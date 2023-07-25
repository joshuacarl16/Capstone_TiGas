from rest_framework.serializers import ModelSerializer
from .models import Station, Advertisement

class StationSerializer(ModelSerializer):
    class Meta:
        model = Station
        fields = '__all__'  # serializes all fields of Station model

class AdvertisementSerializer(ModelSerializer):
    class Meta:
        model = Advertisement
        fields = '__all__'