from django.db import models

class PersonaRifa (models.Model):
    persona = models.TextField()
    class Meta:
        db_table = 'personaRifa'
        ordering = ['persona']
# Create your models here.

def __str__ (self):
    return self.name