#from django.shortcuts import render
#from rest_framework import status
#from rest_framework.views import APIView
#from rest_framework.response import Response
#from .models import PersonaRifa
#from .serializers import PersonaSerializer
from django.http import JsonResponse
import psycopg2
from django.conf import settings
import logging

# Configuración básica de logging para depuración
logger = logging.getLogger(__name__)

logger = logging.getLogger(__name__)


def obtener_fila_aleatoria(request, nombre):
    try:
        logger.info(f"Recibiendo el nombre: {nombre}")

        # Conexión a la base de datos de PostgreSQL usando los parámetros de Django settings
        connection = psycopg2.connect(
            dbname=settings.DATABASES['default']['NAME'],
            user=settings.DATABASES['default']['USER'],
            password=settings.DATABASES['default']['PASSWORD'],
            host=settings.DATABASES['default']['HOST'],
            port=settings.DATABASES['default']['PORT'],
        )
        connection.autocommit = True
        # Crear un cursor para ejecutar las consultas SQL
        cursor = connection.cursor()
        print(connection.autocommit)
        # Llamar a la función PL/pgSQL pasando el nombre como argumento
        cursor.execute("SELECT * FROM obtener_fila_aleatoria(%s)", [nombre])

        # Obtener el resultado de la consulta
        resultado = cursor.fetchone()

        # Si la función retorna un valor, lo enviamos en la respuesta
        if resultado:
            return JsonResponse({"nombre": resultado[0]})

        return JsonResponse({"mensaje": "No se obtuvo resultado"})

    except Exception as e:
        # En caso de error, logueamos el mensaje de error
        logger.error(f"Error al ejecutar la función: {str(e)}")
        return JsonResponse({"error": str(e)})

    finally:
        # Asegurarse de cerrar la conexión y el cursor
        if cursor:
            cursor.close()
        if connection:
            connection.close()
