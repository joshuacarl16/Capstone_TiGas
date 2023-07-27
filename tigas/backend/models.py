from django.db import models

class Station(models.Model):
    updated = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)
    imagePath = models.CharField(max_length=255, blank=True)  # imagePath can be blank
    name = models.CharField(max_length=255, default='Unknown')  # renamed from 'brand' to 'name'
    address = models.CharField(max_length=255)  # renamed from 'vicinity'
    distance = models.FloatField(null=True)  # Assuming distance is a float type, else adjust as needed
    gasTypes = models.JSONField(null=True)  # JSONField for list of gas types
    gasTypeInfo = models.JSONField(null=True)  # JSONField for gas type info
    services = models.JSONField(null=True)  # JSONField for list of services

    # geometry/location
    latitude = models.FloatField(default=0.0)
    longitude = models.FloatField(default=0.0)
    
    # New fields
    place_id = models.CharField(max_length=255, default='Unknown')  # store the place_id
    opening_hours = models.JSONField(null=True)  # store the opening hours, can be null

    class Meta:
        ordering = ['-updated']

class Advertisement(models.Model):
    updated = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)
    image = models.ImageField(upload_to='advertisements/')
    caption = models.CharField(max_length=255)