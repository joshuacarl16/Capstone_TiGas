from django.db import models
from django.core.validators import MaxValueValidator, MinValueValidator

class Station(models.Model):
    updated = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)
    imagePath = models.CharField(max_length=255, blank=True)
    name = models.CharField(max_length=255, default='Unknown')
    address = models.CharField(max_length=255) 
    distance = models.FloatField(null=True)  
    gasTypes = models.JSONField(null=True) 
    gasTypeInfo = models.JSONField(null=True)  
    services = models.JSONField(null=True) 

  
    latitude = models.FloatField(default=0.0)
    longitude = models.FloatField(default=0.0)
    
    
    place_id = models.CharField(max_length=255, default='Unknown') 
    opening_hours = models.JSONField(null=True)

    class Meta:
        ordering = ['-updated']

class Advertisement(models.Model):
    updated = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)
    image = models.ImageField(upload_to='advertisements/')
    caption = models.CharField(max_length=255)
    valid_until = models.DateTimeField(null=True)
    posted_by = models.CharField(max_length=255, default='Unknown')
    
    class Meta:
        ordering = ['-updated']

class Review(models.Model):
    updated = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)
    station = models.ForeignKey(Station, on_delete=models.CASCADE)
    posted_by = models.CharField(max_length=255, default='Unknown')
    rating = models.PositiveIntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    review = models.JSONField(null=True)
    comments = models.TextField(null=True)

class Prices(models.Model):
    station = models.ForeignKey(Station, on_delete=models.CASCADE, related_name='prices')
    uploaded_by = models.CharField(max_length=255)
    gasTypeInfo = models.JSONField(null=True)  
    updated = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-updated']

    def __str__(self):
        return f'Price {self.price} uploaded by {self.uploaded_by} for station {self.station.name}'