"""
URL configuration for tigas project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import path, include
from django.contrib import admin
from rest_framework.routers import DefaultRouter
from backend import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('stations/', views.getStations),
    path('stations/create/', views.createStation),
    path('stations/<str:pk>/update/', views.updateStation),
    path('stations/<str:pk>/delete/', views.deleteStation),
    path('stations/<str:pk>/', views.getStation)
]
