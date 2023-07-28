from django.db import models

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
    
    class Meta:
        ordering = ['-updated']