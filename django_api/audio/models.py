from django.db import models

class AudioFile(models.Model):
    file = models.FileField(upload_to='audio/')
    uploaded_at = models.DateTimeField(auto_now_add=True)


class Person(models.Model):
    name = models.CharField(max_length=100)
    mesaj = models.CharField(max_length=255)
    time_start = models.CharField(max_length=100)
    time = models.CharField(max_length=100)
    time_end = models.CharField(max_length=100)
    happy = models.CharField(max_length=100)

    def __str__(self):
        return self.name