from django.urls import path
from .views import obtener_fila_aleatoria


urlpatterns = [
    path('<str:nombre>/', obtener_fila_aleatoria),
]
