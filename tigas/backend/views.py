from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status
from .models import Review, Station, Advertisement
from .serializers import ReviewSerializer, StationSerializer, AdvertisementSerializer

@api_view(['GET'])
def getStations(request):
    stations = Station.objects.all()
    serializer = StationSerializer(stations, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getStation(request, pk):
    station = Station.objects.get(id=pk)
    serializer = StationSerializer(station, many=False)
    return Response(serializer.data)

@api_view(['POST'])
def createStation(request):
    data = request.data

    station = Station.objects.create(
        imagePath=data['imagePath'],
        name=data['name'],
        address=data['address'],
        distance=data['distance'],
        gasTypes=data['gasTypes'],
        gasTypeInfo=data['gasTypeInfo'],
        services=data['services'],
        place_id=data['place_id'],
        latitude=data['latitude'],
        longitude=data['longitude'],
        opening_hours=data['opening_hours'],
    )
    serializer = StationSerializer(station, many=False)
    return Response(serializer.data)


@api_view(['PATCH'])
def updateStation(request, pk):
    try:
        station = Station.objects.get(id=pk)
    except Station.DoesNotExist:
        return Response({'error': 'Station does not exist'}, status=404)

    serializer = StationSerializer(station, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)

    return Response(serializer.errors, status=400)

@api_view(['PATCH'])
def updateStation(request, pk):
    try:
        station = Station.objects.get(id=pk)
    except Station.DoesNotExist:
        return Response({'error': 'Station does not exist'}, status=404)

    serializer = StationSerializer(station, data=request.data, partial=True) # Note `partial=True`
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)

    return Response(serializer.errors, status=400)

@api_view(['DELETE'])
def deleteStation(request, pk):
    station = Station.objects.get(id=pk)
    station.delete()
    return Response('Station deleted')

@api_view(['POST'])
def uploadImage(request):
    parser_classes = (MultiPartParser, FormParser,)
    serializer = AdvertisementSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    else:
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
@api_view(['GET'])
def getImages(request):
    advertisements = Advertisement.objects.all()
    serializer = AdvertisementSerializer(advertisements, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getImage(request, pk):
    try:
        advertisement = Advertisement.objects.get(id=pk)
        serializer = AdvertisementSerializer(advertisement, many=False)
        return Response(serializer.data)
    except Advertisement.DoesNotExist:
        return Response({'error': 'Advertisement does not exist'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['DELETE'])
def deleteImage(request, pk):
    try:
        advertisement = Advertisement.objects.get(id=pk)
        advertisement.delete()
        return Response({'message': 'Advertisement deleted successfully'}, status=status.HTTP_200_OK)
    except Advertisement.DoesNotExist:
        return Response({'error': 'Advertisement does not exist'}, status=status.HTTP_404_NOT_FOUND)
    
@api_view(['GET'])
def getReviews(request):
    reviews = Review.objects.all()
    serializer = ReviewSerializer(reviews, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getReview(request, pk):
    try:
        review = Review.objects.get(id=pk)
        serializer = ReviewSerializer(review, many=False)
        return Response(serializer.data)
    except Review.DoesNotExist:
        return Response({'error': 'Review does not exist'}, status=status.HTTP_404_NOT_FOUND)
    
@api_view(['GET'])
def getStationReviews(request, station_id):
    try:
        reviews = Review.objects.filter(station__id=station_id)
        serializer = ReviewSerializer(reviews, many=True)
        return Response(serializer.data)
    except Station.DoesNotExist:
        return Response({'error': 'Station does not exist'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
def createReview(request):
    serializer = ReviewSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    else:
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
def deleteReview(request, pk):
    try:
        review = Review.objects.get(id=pk)
        review.delete()
        return Response({'message': 'Review deleted successfully'}, status=status.HTTP_200_OK)
    except Review.DoesNotExist:
        return Response({'error': 'Review does not exist'}, status=status.HTTP_404_NOT_FOUND)
    
