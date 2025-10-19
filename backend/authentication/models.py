"""
Modelos para la autenticación y gestión de usuarios.
"""

from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.db import models
from django.utils.translation import gettext_lazy as _


class UsuarioManager(BaseUserManager):
    """
    Manager personalizado para el modelo Usuario.
    Proporciona métodos para crear usuarios y superusuarios.
    """
    
    def create_user(self, email, password=None, **extra_fields):
        """
        Crea y guarda un Usuario con el email y contraseña dados.
        """
        if not email:
            raise ValueError(_('El email es obligatorio'))
        
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        """
        Crea y guarda un SuperUsuario con el email y contraseña dados.
        """
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_active', True)
        extra_fields.setdefault('rol', Usuario.Roles.ADMIN)

        if extra_fields.get('is_staff') is not True:
            raise ValueError(_('Superuser debe tener is_staff=True.'))
        if extra_fields.get('is_superuser') is not True:
            raise ValueError(_('Superuser debe tener is_superuser=True.'))

        return self.create_user(email, password, **extra_fields)


class Usuario(AbstractUser):
    """
    Modelo personalizado de Usuario para Mundo Cartas.
    
    Utiliza email en lugar de username y agrega campos específicos
    para la gestión de la tienda.
    """

    class Roles(models.TextChoices):
        """Roles disponibles en el sistema."""
        ADMIN = 'ADMIN', _('Administrador')
        VENDEDOR = 'VENDEDOR', _('Vendedor')

    # Campos principales
    username = None  # Deshabilitar username
    email = models.EmailField(
        _('correo electrónico'),
        unique=True,
        error_messages={
            'unique': _('Ya existe un usuario con este correo electrónico.'),
        }
    )
    nombre_completo = models.CharField(
        _('nombre completo'),
        max_length=255,
        help_text=_('Nombre completo del usuario')
    )
    rol = models.CharField(
        _('rol'),
        max_length=10,
        choices=Roles.choices,
        default=Roles.VENDEDOR,
        help_text=_('Rol que determina los permisos del usuario')
    )
    
    # Campos de auditoría
    fecha_creacion = models.DateTimeField(
        _('fecha de creación'),
        auto_now_add=True,
        help_text=_('Fecha y hora de creación del usuario')
    )
    fecha_modificacion = models.DateTimeField(
        _('fecha de modificación'),
        auto_now=True,
        help_text=_('Fecha y hora de última modificación')
    )
    activo = models.BooleanField(
        _('activo'),
        default=True,
        help_text=_('Indica si el usuario está activo. Desmarca esto en vez de borrar.')
    )

    # Configuración
    objects = UsuarioManager()
    EMAIL_FIELD = 'email'
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['nombre_completo', 'rol']

    class Meta:
        verbose_name = _('usuario')
        verbose_name_plural = _('usuarios')
        ordering = ['email']
        indexes = [
            models.Index(fields=['email']),
            models.Index(fields=['rol']),
        ]

    def __str__(self):
        """Representación en string del usuario."""
        return f'{self.email} ({self.get_rol_display()})'

    def get_nombre_completo(self):
        """Retorna el nombre completo del usuario."""
        return self.nombre_completo

    @property
    def is_admin(self):
        """¿El usuario es administrador?"""
        return self.rol == self.Roles.ADMIN

    @property
    def is_vendedor(self):
        """¿El usuario es vendedor?"""
        return self.rol == self.Roles.VENDEDOR