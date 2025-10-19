"""
Configuración del panel de administración para la app authentication.
"""

from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.utils.translation import gettext_lazy as _

from .models import Usuario


@admin.register(Usuario)
class UsuarioAdmin(UserAdmin):
    """
    Configuración del panel de administración para el modelo Usuario.
    """
    list_display = ('email', 'nombre_completo', 'rol', 'is_active', 'fecha_creacion')
    list_filter = ('rol', 'is_active', 'is_staff', 'fecha_creacion')
    search_fields = ('email', 'nombre_completo')
    ordering = ('email',)
    
    # Campos en el formulario de edición
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        (_('Información Personal'), {'fields': ('nombre_completo', 'rol')}),
        (_('Permisos'), {
            'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions'),
        }),
        (_('Fechas importantes'), {'fields': ('last_login',)}),
    )
    
    # Campos en el formulario de creación
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'nombre_completo', 'rol', 'password1', 'password2'),
        }),
    )