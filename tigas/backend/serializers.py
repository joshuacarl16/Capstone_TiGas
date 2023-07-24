from rest_framework.serializers import ModelSerializer
from .models import Station

class StationSerializer(ModelSerializer):
    class Meta:
        model = Station
        fields = '__all__'  # serializes all fields of Station model
