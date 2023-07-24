from django.db import models

class Station(models.Model):
    updated = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)
    imagePath = models.CharField(max_length=255)
    brand = models.CharField(max_length=50)
    address = models.CharField(max_length=255)
    distance = models.FloatField() # Assuming distance is a float type, else adjust as needed
    gasTypes = models.JSONField() # JSONField for list of gas types
    gasTypeInfo = models.JSONField() # JSONField for gas type info
    services = models.JSONField() # JSONField for list of services

    class Meta:
        ordering = ['-updated']