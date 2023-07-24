from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import viewsets
from .models import Station
from .serializers import StationSerializer

# class StationViewSet(viewsets.ModelViewSet):
#     queryset = Station.objects.all()
#     serializer_class = StationSerializer

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
        brand=data['brand'],
        address=data['address'],
        distance=data['distance'],
        gasTypes=data['gasTypes'],
        gasTypeInfo=data['gasTypeInfo'],
        services=data['services']
    )
    serializer = StationSerializer(station, many=False)
    return Response(serializer.data)

@api_view(['PUT'])
def updateStation(request, pk):
    data = request.data

    station = Station.objects.get(id=pk)

    serializer = StationSerializer(station, data=request.data)
    if serializer.is_valid():
        serializer.save()

    return Response(serializer.data)

@api_view(['DELETE'])
def deleteStation(request, pk):
    station = Station.objects.get(id=pk)
    station.delete()
    return Response('Station deleted')