from django.contrib import admin
from .models import Review, Station, Advertisement
# Register your models here.
admin.site.register(Station)
admin.site.register(Advertisement)
admin.site.register(Review)