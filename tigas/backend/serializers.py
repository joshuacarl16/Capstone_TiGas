from rest_framework.serializers import ModelSerializer
from .models import Review, Station, Advertisement

class StationSerializer(ModelSerializer):
    class Meta:
        model = Station
        fields = '__all__'

class AdvertisementSerializer(ModelSerializer):
    class Meta:
        model = Advertisement
        fields = '__all__'

class ReviewSerializer(ModelSerializer):
    class Meta:
        model = Review
        fields = '__all__'