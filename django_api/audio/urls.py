from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import AudioFileUploadView, PersonViewSet

router = DefaultRouter()
router.register(r'persons', PersonViewSet)

urlpatterns = [
    path('upload/', AudioFileUploadView.as_view(), name='file-upload'),
    path('', include(router.urls)),
]