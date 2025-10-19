# TAREAS DETALLADAS — SPRINT 1: CONFIGURACIÓN Y AUTENTICACIÓN

**Fechas:** 20-26 de octubre de 2025  
**Meta:** Establecer base técnica y login funcional con JWT

---

## TAREA 1.1: Crear estructura Django + React + PostgreSQL

**Historia de Usuario:** US-001 (Login de usuario)  
**Responsable:** Backend + Frontend  
**Duración estimada:** 4 horas  
**Día sugerido:** Domingo 19 de octubre  
**Prioridad:** 🔴 Crítica

## Descripción

Configurar los entornos de desarrollo locales para Django REST Framework (backend) y React (frontend), y establecer la conexión con la base de datos PostgreSQL.

## Pasos Detallados

## Backend (Angel - 2 horas)

1. **Instalar Python 3.11+ y crear entorno virtual**

   bash

   `python -m venv venv source venv/bin/activate  # En Windows: venv\Scripts\activate`

2. **Instalar Django y dependencias iniciales**

   bash

   `pip install django==4.2.7 djangorestframework==3.14.0 psycopg2-binary==2.9.9 djangorestframework-simplejwt==5.3.0 django-cors-headers==4.3.1 pip freeze > requirements.txt`

3. **Crear proyecto Django**

   bash

   `django-admin startproject mundo_cartas_backend . python manage.py startapp authentication python manage.py startapp inventory python manage.py startapp sales`

4. **Configurar `settings.py`**

   - Agregar apps instaladas: `rest_framework`, `rest_framework_simplejwt`, `corsheaders`, `authentication`, `inventory`, `sales`

   - Configurar base de datos PostgreSQL:

     python

     `DATABASES = {     'default': {         'ENGINE': 'django.db.backends.postgresql',         'NAME': 'mundo_cartas_db',         'USER': 'postgres',         'PASSWORD': 'tu_password',         'HOST': 'localhost',         'PORT': '5432',     } }`

   - Configurar CORS para permitir requests desde React ([http://localhost:3000](http://localhost:3000/))

   - Configurar JWT en `REST_FRAMEWORK`

5. **Crear base de datos PostgreSQL**

   bash

   `psql -U postgres CREATE DATABASE mundo_cartas_db; \q`

6. **Ejecutar migraciones iniciales**

   bash

   `python manage.py migrate`

## Frontend (Alejandro - 2 horas)

1. **Instalar Node.js 18+ y crear proyecto React**

   bash

   `npx create-react-app mundo-cartas-frontend cd mundo-cartas-frontend`

2. **Instalar dependencias iniciales**

   bash

   `npm install axios react-router-dom@6`

3. **Crear estructura de carpetas**

   text

   `src/ ├── components/ ├── pages/ ├── services/ ├── utils/ └── App.js`

4. **Configurar archivo `.env` para URLs del backend**

   text

   `REACT_APP_API_URL=http://localhost:8000/api`

5. **Configurar `axios` base para requests HTTP**

   - Crear `src/services/api.js` con instancia de axios configurada

## Entregables

- ✅ Proyecto Django inicializado con apps creadas

- ✅ Base de datos PostgreSQL creada y conectada

- ✅ Proyecto React inicializado con dependencias instaladas

- ✅ Estructura de carpetas base creada en ambos proyectos

- ✅ README.md con instrucciones de instalación

## Validación

- Django dev server corre sin errores: `python manage.py runserver`

- React dev server corre sin errores: `npm start`

- Conexión a PostgreSQL exitosa (verificar con `python manage.py dbshell`)

## Recursos de Aprendizaje

- **Django:** [Writing your first Django app, part 1 | Django documentation | Django](https://docs.djangoproject.com/en/4.2/intro/tutorial01/)

- **React:** https://react.dev/learn

- **PostgreSQL:** [PostgreSQL: Documentation: 15: Chapter 1. Getting Started](https://www.postgresql.org/docs/15/tutorial-start.html)

---

## TAREA 1.2: Configurar autenticación JWT en Django

**Historia de Usuario:** US-001  
**Responsable:** Backend (Angel)  
**Duración estimada:** 4 horas  
**Día sugerido:** Lunes 21 de octubre  
**Prioridad:** 🔴 Crítica

## Descripción

Implementar autenticación basada en JSON Web Tokens (JWT) usando `djangorestframework-simplejwt`.

## Pasos Detallados

1. **Agregar configuración JWT a `settings.py`**

   python

   `from datetime import timedelta SIMPLE_JWT = {     'ACCESS_TOKEN_LIFETIME': timedelta(hours=5),     'REFRESH_TOKEN_LIFETIME': timedelta(days=1),     'ROTATE_REFRESH_TOKENS': False,     'BLACKLIST_AFTER_ROTATION': True,     'UPDATE_LAST_LOGIN': False,     'ALGORITHM': 'HS256',     'AUTH_HEADER_TYPES': ('Bearer',),     'USER_ID_FIELD': 'id',     'USER_ID_CLAIM': 'user_id', }`

2. **Configurar REST Framework para usar JWT**

   python

   `REST_FRAMEWORK = {     'DEFAULT_AUTHENTICATION_CLASSES': (         'rest_framework_simplejwt.authentication.JWTAuthentication',     ),     'DEFAULT_PERMISSION_CLASSES': (         'rest_framework.permissions.IsAuthenticated',     ), }`

3. **Crear `urls.py` en `authentication/`**

   python

   `from django.urls import path from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView urlpatterns = [     path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),     path('refresh/', TokenRefreshView.as_view(), name='token_refresh'), ]`

4. **Incluir URLs en `urls.py` principal**

   python

   `from django.urls import path, include urlpatterns = [     path('admin/', admin.site.urls),     path('api/auth/', include('authentication.urls')), ]`

5. **Probar endpoint de login con Postman/Thunder Client**

   - POST `http://localhost:8000/api/auth/login/`

   - Body (JSON):

     json

     `{   "username": "admin",   "password": "admin123" }`

   - Respuesta esperada: `{ "access": "...", "refresh": "..." }`

## Entregables

- ✅ JWT configurado en `settings.py`

- ✅ Endpoint `/api/auth/login/` funcional

- ✅ Endpoint `/api/auth/refresh/` funcional

- ✅ Tokens generados correctamente

## Validación

- Llamar endpoint login con credenciales válidas retorna tokens

- Token `access` es válido durante 5 horas

- Requests con token en header `Authorization: Bearer <token>` son autenticadas

## Recursos de Aprendizaje

- **Simple JWT:** [https://django-rest-framework-simplejwt.readthedocs.io/](https://django-rest-framework-simplejwt.readthedocs.io/)

---

## TAREA 1.3: Diseñar modelo Usuario con roles

**Historia de Usuario:** US-001  
**Responsable:** Backend (Angel)  
**Duración estimada:** 3 horas  
**Día sugerido:** Lunes 21 de octubre  
**Prioridad:** 🔴 Crítica

## Descripción

Crear modelo personalizado de Usuario que extienda `AbstractUser` de Django, agregando roles (Administrador/Vendedor) y campos adicionales.

## Pasos Detallados

1. **Crear modelo `Usuario` en `authentication/models.py`**

   python

   `from django.contrib.auth.models import AbstractUser from django.db import models class Usuario(AbstractUser):     ROLES = (         ('administrador', 'Administrador'),         ('vendedor', 'Vendedor'),     )          rol = models.CharField(max_length=20, choices=ROLES, default='vendedor')     telefono = models.CharField(max_length=15, blank=True, null=True)     activo = models.BooleanField(default=True)     fecha_creacion = models.DateTimeField(auto_now_add=True)     ultima_modificacion = models.DateTimeField(auto_now=True)     class Meta:         verbose_name = 'Usuario'         verbose_name_plural = 'Usuarios'     def __str__(self):         return f"{self.username} ({self.get_rol_display()})"`

2. **Configurar modelo personalizado en `settings.py`**

   python

   `AUTH_USER_MODEL = 'authentication.Usuario'`

3. **Registrar modelo en `authentication/admin.py`**

   python

   `from django.contrib import admin from .models import Usuario @admin.register(Usuario) class UsuarioAdmin(admin.ModelAdmin):     list_display = ('username', 'email', 'rol', 'activo', 'fecha_creacion')     list_filter = ('rol', 'activo')     search_fields = ('username', 'email')`

4. **Crear y ejecutar migraciones**

   bash

   `python manage.py makemigrations python manage.py migrate`

5. **Crear superusuario para pruebas**

   bash

   `python manage.py createsuperuser # Ingresar username, email, password`

6. **Asignar rol "administrador" manualmente desde Django Admin**

   - Acceder a http://localhost:8000/admin/

   - Editar usuario creado y cambiar rol

## Entregables

- ✅ Modelo `Usuario` creado con campos adicionales

- ✅ Migraciones ejecutadas exitosamente

- ✅ Usuario administrador de prueba creado

- ✅ Modelo registrado en Django Admin

## Validación

- Acceder a Django Admin y ver lista de usuarios

- Crear usuario nuevo desde admin con rol "vendedor"

- Verificar que campo `activo` funciona correctamente

## Recursos de Aprendizaje

- **Custom User Model:** [Customizing authentication in Django | Django documentation | Django](https://docs.djangoproject.com/en/4.2/topics/auth/customizing/#substituting-a-custom-user-model)

---

## TAREA 1.4: Implementar endpoint POST `/api/auth/login/`

**Historia de Usuario:** US-001  
**Responsable:** Backend (Angel)  
**Duración estimada:** 3 horas  
**Día sugerido:** Martes 22 de octubre  
**Prioridad:** 🔴 Crítica

## Descripción

Personalizar endpoint de login para incluir información del usuario (nombre, rol) junto con los tokens JWT.

## Pasos Detallados

1. **Crear serializer personalizado en `authentication/serializers.py`**

   python

   `from rest_framework_simplejwt.serializers import TokenObtainPairSerializer class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):     @classmethod     def get_token(cls, user):         token = super().get_token(user)                  # Agregar información personalizada al token         token['username'] = user.username         token['rol'] = user.rol                  return token     def validate(self, attrs):         data = super().validate(attrs)                  # Agregar información del usuario a la respuesta         data['user'] = {             'id': self.user.id,             'username': self.user.username,             'email': self.user.email,             'rol': self.user.rol,             'activo': self.user.activo,         }                  return data`

2. **Crear vista personalizada en `authentication/views.py`**

   python

   `from rest_framework_simplejwt.views import TokenObtainPairView from .serializers import CustomTokenObtainPairSerializer class CustomTokenObtainPairView(TokenObtainPairView):     serializer_class = CustomTokenObtainPairSerializer`

3. **Actualizar `authentication/urls.py`**

   python

   `from django.urls import path from .views import CustomTokenObtainPairView from rest_framework_simplejwt.views import TokenRefreshView urlpatterns = [     path('login/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),     path('refresh/', TokenRefreshView.as_view(), name='token_refresh'), ]`

4. **Probar endpoint con Postman/Thunder Client**

   - POST `http://localhost:8000/api/auth/login/`

   - Body:

     json

     `{   "username": "admin",   "password": "admin123" }`

   - Verificar respuesta incluye `access`, `refresh` y `user`

## Entregables

- ✅ Serializer personalizado creado

- ✅ Vista personalizada implementada

- ✅ Endpoint retorna datos de usuario junto con tokens

- ✅ Documentación de endpoint en README

## Validación

- Login exitoso retorna tokens + información de usuario

- Login con credenciales incorrectas retorna error 401

- Usuario inactivo no puede hacer login

---

## TAREA 2.1: Crear endpoint POST `/api/auth/logout/`

**Historia de Usuario:** US-002 (Logout de usuario)  
**Responsable:** Backend (Angel)  
**Duración estimada:** 2 horas  
**Día sugerido:** Miércoles 23 de octubre  
**Prioridad:** 🔴 Crítica

## Descripción

Implementar endpoint para invalidar refresh token al cerrar sesión.

## Pasos Detallados

1. **Agregar `rest_framework_simplejwt.token_blacklist` a INSTALLED_APPS**

   python

   `INSTALLED_APPS = [     # ...     'rest_framework_simplejwt.token_blacklist', ]`

2. **Ejecutar migraciones de blacklist**

   bash

   `python manage.py migrate`

3. **Crear vista de logout en `authentication/views.py`**

   python

   `from rest_framework.views import APIView from rest_framework.response import Response from rest_framework import status from rest_framework.permissions import IsAuthenticated from rest_framework_simplejwt.tokens import RefreshToken class LogoutView(APIView):     permission_classes = (IsAuthenticated,)     def post(self, request):         try:             refresh_token = request.data["refresh"]             token = RefreshToken(refresh_token)             token.blacklist()             return Response({"message": "Sesión cerrada exitosamente"}, status=status.HTTP_205_RESET_CONTENT)         except Exception as e:             return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)`

4. **Agregar ruta en `authentication/urls.py`**

   python

   `from .views import CustomTokenObtainPairView, LogoutView urlpatterns = [     path('login/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),     path('logout/', LogoutView.as_view(), name='logout'),     path('refresh/', TokenRefreshView.as_view(), name='token_refresh'), ]`

5. **Probar endpoint**

   - POST `http://localhost:8000/api/auth/logout/`

   - Headers: `Authorization: Bearer <access_token>`

   - Body:

     json

     `{   "refresh": "<refresh_token>" }`

## Entregables

- ✅ Token blacklist configurado

- ✅ Endpoint `/api/auth/logout/` funcional

- ✅ Refresh tokens invalidados correctamente

## Validación

- Logout exitoso retorna código 205

- Token en blacklist no puede usarse para refrescar

- Access token sigue funcionando hasta expiración (comportamiento esperado)

---

## TAREA 1.5: Crear componente `LoginPage.jsx`

**Historia de Usuario:** US-001  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 4 horas  
**Día sugerido:** Jueves 24 de octubre  
**Prioridad:** 🔴 Crítica

## Descripción

Crear página de login en React con formulario de usuario/contraseña y manejo de estados.

## Pasos Detallados

1. **Crear archivo `src/pages/LoginPage.jsx`**

   jsx

   `import React, { useState } from 'react'; import axios from 'axios'; const LoginPage = () => {   const [username, setUsername] = useState('');   const [password, setPassword] = useState('');   const [error, setError] = useState('');   const [loading, setLoading] = useState(false);   const handleSubmit = async (e) => {     e.preventDefault();     setLoading(true);     setError('');     try {       const response = await axios.post('http://localhost:8000/api/auth/login/', {         username,         password       });       // Guardar tokens en localStorage       localStorage.setItem('access_token', response.data.access);       localStorage.setItem('refresh_token', response.data.refresh);       localStorage.setItem('user', JSON.stringify(response.data.user));       // Redirigir a dashboard       window.location.href = '/dashboard';     } catch (err) {       setError('Credenciales incorrectas. Por favor intente nuevamente.');     } finally {       setLoading(false);     }   };   return (     <div style={{ maxWidth: '400px', margin: '100px auto', padding: '20px' }}>       <h2>Mundo Cartas - Login</h2>       <form onSubmit={handleSubmit}>         <div style={{ marginBottom: '15px' }}>           <label>Usuario:</label>           <input             type="text"             value={username}             onChange={(e) => setUsername(e.target.value)}             required             style={{ width: '100%', padding: '8px' }}           />         </div>         <div style={{ marginBottom: '15px' }}>           <label>Contraseña:</label>           <input             type="password"             value={password}             onChange={(e) => setPassword(e.target.value)}             required             style={{ width: '100%', padding: '8px' }}           />         </div>         {error && <p style={{ color: 'red' }}>{error}</p>}         <button type="submit" disabled={loading} style={{ width: '100%', padding: '10px' }}>           {loading ? 'Cargando...' : 'Ingresar'}         </button>       </form>     </div>   ); }; export default LoginPage;`

2. **Configurar rutas en `src/App.js`**

   jsx

   `import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'; import LoginPage from './pages/LoginPage'; function App() {   return (     <Router>       <Routes>         <Route path="/" element={<LoginPage />} />       </Routes>     </Router>   ); } export default App;`

3. **Crear archivo de servicio `src/services/authService.js`**

   javascript

   `` import axios from 'axios'; const API_URL = 'http://localhost:8000/api/auth/'; export const login = async (username, password) => {   const response = await axios.post(`${API_URL}login/`, { username, password });   return response.data; }; export const logout = async (refreshToken) => {   const response = await axios.post(`${API_URL}logout/`, { refresh: refreshToken });   return response.data; }; ``

## Entregables

- ✅ Componente LoginPage creado

- ✅ Formulario funcional con validaciones

- ✅ Manejo de errores implementado

- ✅ Tokens guardados en localStorage

## Validación

- Formulario se renderiza correctamente

- Inputs capturan valores

- Error se muestra si credenciales incorrectas

- Tokens se guardan en localStorage tras login exitoso

---

Continúo con las siguientes tareas del Sprint 1...

## TAREA 1.6: Conectar React con backend (login funcional)

**Historia de Usuario:** US-001  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 3 horas  
**Día sugerido:** Jueves 24 de octubre  
**Prioridad:** 🔴 Crítica

## Descripción

Integrar completamente el componente LoginPage con el backend Django, manejando estados de autenticación y redirección.

## Pasos Detallados

1. **Refactorizar `LoginPage.jsx` para usar authService**

   jsx

   `import React, { useState } from 'react'; import { useNavigate } from 'react-router-dom'; import { login } from '../services/authService'; const LoginPage = () => {   const [username, setUsername] = useState('');   const [password, setPassword] = useState('');   const [error, setError] = useState('');   const [loading, setLoading] = useState(false);   const navigate = useNavigate();   const handleSubmit = async (e) => {     e.preventDefault();     setLoading(true);     setError('');     try {       const data = await login(username, password);              localStorage.setItem('access_token', data.access);       localStorage.setItem('refresh_token', data.refresh);       localStorage.setItem('user', JSON.stringify(data.user));       navigate('/dashboard');     } catch (err) {       setError(err.response?.data?.detail || 'Error al iniciar sesión');     } finally {       setLoading(false);     }   };   return (     // ... mismo JSX anterior   ); }; export default LoginPage;`

2. **Crear contexto de autenticación `src/context/AuthContext.jsx`**

   jsx

   `import React, { createContext, useState, useContext, useEffect } from 'react'; const AuthContext = createContext(); export const useAuth = () => useContext(AuthContext); export const AuthProvider = ({ children }) => {   const [user, setUser] = useState(null);   const [loading, setLoading] = useState(true);   useEffect(() => {     const storedUser = localStorage.getItem('user');     if (storedUser) {       setUser(JSON.parse(storedUser));     }     setLoading(false);   }, []);   const login = (userData) => {     setUser(userData);     localStorage.setItem('user', JSON.stringify(userData));   };   const logout = () => {     setUser(null);     localStorage.removeItem('access_token');     localStorage.removeItem('refresh_token');     localStorage.removeItem('user');   };   return (     <AuthContext.Provider value={{ user, login, logout, loading }}>       {children}     </AuthContext.Provider>   ); };`

3. **Envolver App en AuthProvider en `src/index.js`**

   jsx

   `import { AuthProvider } from './context/AuthContext'; root.render(   <React.StrictMode>     <AuthProvider>       <App />     </AuthProvider>   </React.StrictMode> );`

## Entregables

- ✅ AuthContext creado y funcional

- ✅ Login completo con redirección

- ✅ Estado de autenticación persistente

## Validación

- Login exitoso redirige a /dashboard

- Usuario permanece logueado tras refrescar página

- Logout limpia correctamente el estado

---

## TAREA 1.7: Crear vista protegida inicial (Dashboard vacío)

**Historia de Usuario:** US-003  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 3 horas  
**Día sugerido:** Viernes 25 de octubre  
**Prioridad:** 🔴 Crítica

## Descripción

Crear componente Dashboard básico que será la landing page tras login exitoso.

## Pasos Detallados

1. **Crear `src/pages/DashboardPage.jsx`**

   jsx

   `import React from 'react'; import { useAuth } from '../context/AuthContext'; const DashboardPage = () => {   const { user, logout } = useAuth();   const handleLogout = () => {     logout();     window.location.href = '/';   };   return (     <div style={{ padding: '20px' }}>       <h1>Bienvenido, {user?.username}!</h1>       <p>Rol: {user?.rol}</p>       <button onClick={handleLogout}>Cerrar Sesión</button>              <div style={{ marginTop: '40px' }}>         <h2>Dashboard de Mundo Cartas</h2>         <p>Contenido próximamente...</p>       </div>     </div>   ); }; export default DashboardPage;`

2. **Agregar ruta en `App.js`**

   jsx

   `import DashboardPage from './pages/DashboardPage'; <Routes>   <Route path="/" element={<LoginPage />} />   <Route path="/dashboard" element={<DashboardPage />} /> </Routes>`

## Entregables

- ✅ Componente Dashboard creado

- ✅ Muestra información del usuario logueado

- ✅ Botón de logout funcional

## Validación

- Dashboard accesible tras login

- Muestra nombre y rol del usuario

- Logout redirige a página de login

---

## TAREA 1.8: Implementar validación de token y protección de rutas

**Historia de Usuario:** US-003  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 2 horas  
**Día sugerido:** Viernes 25 de octubre  
**Prioridad:** 🔴 Crítica

## Descripción

Crear componente PrivateRoute que valide autenticación antes de permitir acceso a rutas protegidas.

## Pasos Detallados

1. **Crear `src/components/PrivateRoute.jsx`**

   jsx

   `import React from 'react'; import { Navigate } from 'react-router-dom'; import { useAuth } from '../context/AuthContext'; const PrivateRoute = ({ children }) => {   const { user, loading } = useAuth();   if (loading) {     return <div>Cargando...</div>;   }   return user ? children : <Navigate to="/" />; }; export default PrivateRoute;`

2. **Actualizar rutas en `App.js`**

   jsx

   `import PrivateRoute from './components/PrivateRoute'; <Routes>   <Route path="/" element={<LoginPage />} />   <Route      path="/dashboard"      element={       <PrivateRoute>         <DashboardPage />       </PrivateRoute>     }    /> </Routes>`

3. **Crear interceptor de axios para tokens en `src/services/api.js`**

   javascript

   `` import axios from 'axios'; const api = axios.create({   baseURL: 'http://localhost:8000/api', }); api.interceptors.request.use(   (config) => {     const token = localStorage.getItem('access_token');     if (token) {       config.headers.Authorization = `Bearer ${token}`;     }     return config;   },   (error) => Promise.reject(error) ); export default api; ``

## Entregables

- ✅ PrivateRoute creado

- ✅ Rutas protegidas implementadas

- ✅ Interceptor de axios configurado

## Validación

- Intentar acceder a /dashboard sin login redirige a /

- Token se envía automáticamente en todas las peticiones

---

## TAREA 3.1: Definir permisos y roles base en `permissions.py`

**Historia de Usuario:** US-003  
**Responsable:** Backend (Angel)  
**Duración estimada:** 2 horas  
**Día sugerido:** Sábado 26 de octubre  
**Prioridad:** 🔴 Crítica

## Descripción

Crear sistema de permisos personalizados basado en roles para controlar acceso a endpoints.

## Pasos Detallados

1. **Crear `authentication/permissions.py`**

   python

   `from rest_framework import permissions class IsAdministrador(permissions.BasePermission):     """     Permiso que solo permite acceso a usuarios con rol 'administrador'    """     def has_permission(self, request, view):         return request.user and request.user.is_authenticated and request.user.rol == 'administrador' class IsVendedor(permissions.BasePermission):     """     Permiso que permite acceso a vendedores y administradores    """     def has_permission(self, request, view):         return request.user and request.user.is_authenticated and request.user.rol in ['vendedor', 'administrador'] class IsOwnerOrAdmin(permissions.BasePermission):     """     Permiso que permite acceso solo al propietario del objeto o a administradores    """     def has_object_permission(self, request, view, obj):         if request.user.rol == 'administrador':             return True         return obj.usuario == request.user`

2. **Crear vista de ejemplo protegida en `authentication/views.py`**

   python

   `from rest_framework.views import APIView from rest_framework.response import Response from rest_framework.permissions import IsAuthenticated from .permissions import IsAdministrador class AdminOnlyView(APIView):     permission_classes = [IsAuthenticated, IsAdministrador]     def get(self, request):         return Response({"message": "Solo administradores pueden ver esto"})`

3. **Documentar permisos en README**

   - Crear sección "Sistema de Permisos"

   - Documentar cada clase de permiso

   - Proveer ejemplos de uso

## Entregables

- ✅ Permisos personalizados creados

- ✅ Vista de ejemplo implementada

- ✅ Documentación de permisos en README

## Validación

- Vendedor no puede acceder a endpoints de admin

- Administrador puede acceder a todos los endpoints

- Permisos de objeto funcionan correctamente

---

## Definition of Done - Sprint 1

## Funcionalidad

- ✅ Usuario puede iniciar sesión con credenciales válidas

- ✅ Usuario puede cerrar sesión

- ✅ Tokens JWT se generan y validan correctamente

- ✅ Dashboard accesible solo tras autenticación

- ✅ Rutas protegidas redirigen a login si no autenticado

## Seguridad

- ✅ Contraseñas nunca expuestas en logs o respuestas

- ✅ Tokens en blacklist no pueden reutilizarse

- ✅ Permisos basados en roles implementados

- ✅ CORS configurado correctamente

## Experiencia de Usuario

- ✅ Mensajes de error claros en formulario login

- ✅ Loading states durante autenticación

- ✅ Redirección automática tras login exitoso

## Testing

- ✅ Endpoints probados manualmente con Postman

- ✅ Flujo completo de login/logout validado

- ✅ Protección de rutas verificada

## Documentación

- ✅ README actualizado con instrucciones de instalación

- ✅ Endpoints documentados

- ✅ Sistema de permisos documentado

---

## 📌 Indicación de Documentación

**Añadir este contenido completo al archivo `Backlog.docx` en la sección correspondiente a "Sprint 1 - Tareas Detalladas".**

Esto cubre todas las tareas del Sprint 1 con profundidad y detalle. ¿Quieres que continúe con los **Sprints 2, 3, 4, 5, 6 y 7** de la misma manera?

Perfecto, Angel. Gracias por tu paciencia y visión estratégica. Voy a entregarte el **Sprint 2 completamente re-planificado** con gestión de categorías dinámicas desde el inicio. Esto garantizará un desarrollo fluido y sin re-trabajo.

---

# TAREAS DETALLADAS — SPRINT 2: INVENTARIO ESENCIAL (VERSIÓN FINAL)

**Fechas:** 27 de octubre - 2 de noviembre de 2025  
**Duración:** 7 días (domingo a domingo)  
**Responsables:** Angel (Backend) + Alejandro (Frontend)

## Meta del Sprint

Implementar gestión completa de categorías dinámicas y CRUD de productos con búsqueda, filtros y ajustes de stock con trazabilidad. Este sprint establece la **base del inventario** que será consumida por ventas, reservas y reportes en sprints posteriores.

---

## RESUMEN EJECUTIVO DE TAREAS SPRINT 2

| ID   | Tarea                                                     | Responsable | Duración | Día    | Prioridad  |
| ---- | --------------------------------------------------------- | ----------- | -------- | ------ | ---------- |
| 7.0  | Implementar modelo Categoria y relación con Producto      | Backend     | 2h       | Dom 27 | 🔴 Crítica |
| 7.1  | Crear endpoints REST para Categorías (GET/POST)           | Backend     | 2h       | Dom 27 | 🔴 Crítica |
| 7.2  | Componente React CategoriaSelect con modal crear          | Frontend    | 3h       | Lun 28 | 🔴 Crítica |
| 7.3  | Crear endpoint GET `/api/inventario/` con filtros         | Backend     | 3h       | Lun 28 | 🔴 Crítica |
| 7.4  | Vista InventoryPage con tabla y filtros dinámicos         | Frontend    | 5h       | Mar 29 | 🔴 Crítica |
| 8.1  | Crear endpoint POST `/api/inventario/` (crear producto)   | Backend     | 3h       | Mar 29 | 🔴 Crítica |
| 8.2  | Modal ProductoModal para crear productos                  | Frontend    | 5h       | Mié 30 | 🔴 Crítica |
| 9.1  | Crear endpoint PATCH `/api/inventario/:id/` (editar)      | Backend     | 3h       | Mié 30 | 🔴 Crítica |
| 9.2  | Adaptar ProductoModal para edición                        | Frontend    | 4h       | Jue 31 | 🔴 Crítica |
| 10.1 | Crear endpoint POST ajuste-stock con MovimientoInventario | Backend     | 4h       | Vie 1  | 🔴 Crítica |
| 10.2 | Modal AjusteStockModal con preview                        | Frontend    | 4h       | Sáb 2  | 🔴 Crítica |

**Total estimado:** 38 horas

---

## TAREA 7.0: Implementar Modelo Categoria y Relación con Producto

**Historia de Usuario:** US-007A (Gestionar categorías dinámicamente)  
**Responsable:** Backend (Angel)  
**Duración estimada:** 2 horas  
**Día sugerido:** Domingo 27 de octubre - PRIMERA TAREA del sprint  
**Prioridad:** 🔴 CRÍTICA (bloquea todo el sprint)

## Descripción

Crear modelo Categoria como entidad independiente y establecer relación ForeignKey con Producto desde el inicio, evitando migraciones destructivas posteriores.

## Pasos Detallados

## 1. Crear modelo Categoria en `inventory/models.py`

python

`from django.db import models from django.core.validators import MinValueValidator from decimal import Decimal class Categoria(models.Model):     """     Categorías dinámicas para productos.    Permite que Claudio cree categorías según las necesidades del negocio.    """     nombre = models.CharField(         max_length=100,          unique=True,         help_text='Nombre único de la categoría (ej: TCG Pokémon)'     )     descripcion = models.TextField(         blank=True,          null=True,         help_text='Descripción opcional de la categoría'     )     activo = models.BooleanField(         default=True,         help_text='Solo categorías activas aparecen en el sistema'     )     fecha_creacion = models.DateTimeField(auto_now_add=True)          class Meta:         verbose_name = 'Categoría'         verbose_name_plural = 'Categorías'         ordering = ['nombre']         indexes = [             models.Index(fields=['activo', 'nombre']),         ]          def __str__(self):         return self.nombre          @property     def cantidad_productos(self):         """Cuenta productos activos en esta categoría"""         return self.productos.filter(activo=True).count()`

## 2. Crear modelo Producto con ForeignKey a Categoria

python

`class Producto(models.Model):     """     Modelo principal de productos del inventario.    Cada producto pertenece a una categoría dinámica.    """     # Campos básicos     sku = models.CharField(         max_length=50,          unique=True,          verbose_name='SKU',         help_text='Código único del producto (ej: PKM-001)'     )     nombre = models.CharField(         max_length=200,          verbose_name='Nombre del Producto'     )     descripcion = models.TextField(         blank=True,          null=True,          verbose_name='Descripción'     )          # Relación con Categoria (NUEVA IMPLEMENTACIÓN)     categoria = models.ForeignKey(         Categoria,         on_delete=models.PROTECT,  # No permitir eliminar categoría con productos         related_name='productos',         verbose_name='Categoría',         help_text='Categoría a la que pertenece el producto'     )          # Precios     precio_compra = models.DecimalField(         max_digits=10,          decimal_places=2,          validators=[MinValueValidator(Decimal('0.01'))],         verbose_name='Precio de Compra',         help_text='Precio al que se compró el producto'     )     precio_venta = models.DecimalField(         max_digits=10,          decimal_places=2,          validators=[MinValueValidator(Decimal('0.01'))],         verbose_name='Precio de Venta',         help_text='Precio público de venta'     )          # Stock     stock_disponible = models.IntegerField(         default=0,          validators=[MinValueValidator(0)],         verbose_name='Stock Disponible',         help_text='Unidades disponibles para venta inmediata'     )     stock_reservado = models.IntegerField(         default=0,          validators=[MinValueValidator(0)],         verbose_name='Stock Reservado',         help_text='Unidades reservadas por clientes'     )     stock_minimo = models.IntegerField(         default=5,          validators=[MinValueValidator(0)],         verbose_name='Stock Mínimo',         help_text='Nivel que dispara alerta de reabastecimiento'     )          # Estado     ESTADOS = (         ('disponible', 'Disponible'),         ('agotado', 'Agotado'),         ('descontinuado', 'Descontinuado'),     )     estado = models.CharField(         max_length=20,          choices=ESTADOS,          default='disponible'     )     activo = models.BooleanField(         default=True,          verbose_name='Activo',         help_text='Productos inactivos no aparecen en ventas'     )          # Metadatos     fecha_creacion = models.DateTimeField(auto_now_add=True)     ultima_modificacion = models.DateTimeField(auto_now=True)          class Meta:         verbose_name = 'Producto'         verbose_name_plural = 'Productos'         ordering = ['nombre']         indexes = [             models.Index(fields=['sku']),             models.Index(fields=['categoria', 'activo']),             models.Index(fields=['estado']),         ]          def __str__(self):         return f"{self.sku} - {self.nombre}"          @property     def stock_total(self):         """Stock total = disponible + reservado"""         return self.stock_disponible + self.stock_reservado          @property     def necesita_reabastecimiento(self):         """Verifica si el stock disponible está por debajo del mínimo"""         return self.stock_disponible <= self.stock_minimo          def clean(self):         """Validaciones a nivel de modelo"""         from django.core.exceptions import ValidationError                 if self.precio_venta and self.precio_compra:             if self.precio_venta <= self.precio_compra:                 raise ValidationError({                     'precio_venta': 'El precio de venta debe ser mayor al precio de compra'                 })`

## 3. Crear y ejecutar migraciones

bash

`python manage.py makemigrations inventory python manage.py migrate inventory`

## 4. Crear comando para poblar categorías base

python

`# inventory/management/commands/seed_categorias.py from django.core.management.base import BaseCommand from inventory.models import Categoria class Command(BaseCommand):     help = 'Crea las categorías base del sistema Mundo Cartas'     def handle(self, *args, **kwargs):         categorias_base = [             {                 'nombre': 'TCG Pokémon',                 'descripcion': 'Trading Card Game de Pokémon: sobres, cartas sueltas, productos sellados'             },             {                 'nombre': 'TCG Yu-Gi-Oh!',                 'descripcion': 'Trading Card Game de Yu-Gi-Oh!: sobres, structure decks, cartas sueltas'             },             {                 'nombre': 'TCG Magic',                 'descripcion': 'Magic: The Gathering - sobres, mazos preconstruidos, singles'             },             {                 'nombre': 'TCG One Piece',                 'descripcion': 'Trading Card Game de One Piece - últimas expansiones y cartas populares'             },             {                 'nombre': 'TCG Digimon',                 'descripcion': 'Digimon Card Game - sobres y starter decks'             },             {                 'nombre': 'Juegos de Mesa',                 'descripcion': 'Board games, juegos de estrategia, party games'             },             {                 'nombre': 'Accesorios',                 'descripcion': 'Sleeves, deck boxes, binders, playmats, dados'             },             {                 'nombre': 'Otros',                 'descripcion': 'Productos diversos que no encajan en otras categorías'             },         ]                  creadas = 0         existentes = 0                  for cat_data in categorias_base:             categoria, created = Categoria.objects.get_or_create(                 nombre=cat_data['nombre'],                 defaults={'descripcion': cat_data['descripcion']}             )                          if created:                 creadas += 1                 self.stdout.write(self.style.SUCCESS(f'  ✓ Creada: {categoria.nombre}'))             else:                 existentes += 1                 self.stdout.write(f'  → Ya existe: {categoria.nombre}')                  self.stdout.write('')         self.stdout.write(self.style.SUCCESS(f'Resumen:'))         self.stdout.write(f'  - {creadas} categorías nuevas creadas')         self.stdout.write(f'  - {existentes} categorías ya existían')`

## 5. Ejecutar comando

bash

`python manage.py seed_categorias`

**Salida esperada:**

text

`✓ Creada: TCG Pokémon  ✓ Creada: TCG Yu-Gi-Oh!  ✓ Creada: TCG Magic  ✓ Creada: TCG One Piece  ✓ Creada: TCG Digimon  ✓ Creada: Juegos de Mesa  ✓ Creada: Accesorios  ✓ Creada: Otros Resumen:   - 8 categorías nuevas creadas  - 0 categorías ya existían`

## 6. Registrar modelos en Django Admin

python

`# inventory/admin.py from django.contrib import admin from .models import Categoria, Producto @admin.register(Categoria) class CategoriaAdmin(admin.ModelAdmin):     list_display = ('nombre', 'activo', 'get_cantidad_productos', 'fecha_creacion')     list_filter = ('activo',)     search_fields = ('nombre', 'descripcion')     readonly_fields = ('fecha_creacion',)          def get_cantidad_productos(self, obj):         return obj.cantidad_productos     get_cantidad_productos.short_description = 'Productos Activos' @admin.register(Producto) class ProductoAdmin(admin.ModelAdmin):     list_display = (         'sku', 'nombre', 'categoria', 'precio_venta',          'stock_disponible', 'stock_reservado', 'estado', 'activo'     )     list_filter = ('categoria', 'estado', 'activo')     search_fields = ('sku', 'nombre', 'descripcion')     readonly_fields = ('fecha_creacion', 'ultima_modificacion', 'stock_total', 'necesita_reabastecimiento')          fieldsets = (         ('Información Básica', {             'fields': ('sku', 'nombre', 'descripcion', 'categoria')         }),         ('Precios', {             'fields': ('precio_compra', 'precio_venta')         }),         ('Stock', {             'fields': (                 'stock_disponible', 'stock_reservado', 'stock_total',                 'stock_minimo', 'necesita_reabastecimiento'             )         }),         ('Estado', {             'fields': ('estado', 'activo')         }),         ('Metadatos', {             'fields': ('fecha_creacion', 'ultima_modificacion'),             'classes': ('collapse',)         }),     )`

## Entregables

- ✅ Modelo Categoria creado y migrado

- ✅ Modelo Producto con ForeignKey a Categoria

- ✅ 8 categorías base creadas automáticamente

- ✅ Comando seed_categorias funcionando

- ✅ Admin configurado para ambos modelos

- ✅ Validaciones a nivel de modelo implementadas

## Validación

- Acceder a Django Admin → Ver lista de categorías (8 categorías)

- Intentar eliminar categoría desde admin (debe estar bloqueado si hay productos)

- Crear producto manualmente y verificar relación con categoría

- Confirmar que `producto.categoria.nombre` retorna el nombre correcto

- Verificar que `categoria.productos.count()` funciona

## Recursos de Aprendizaje

- **Django ForeignKey:** [Model field reference | Django documentation | Django](https://docs.djangoproject.com/en/4.2/ref/models/fields/#foreignkey)

- **Django on_delete:** [Model field reference | Django documentation | Django](https://docs.djangoproject.com/en/4.2/ref/models/fields/#django.db.models.ForeignKey.on_delete)

- **Model Properties:** [Model instance reference | Django documentation | Django](https://docs.djangoproject.com/en/4.2/ref/models/instances/#django.db.models.Model)

---

## TAREA 7.1: Crear Endpoints REST para Categorías (GET/POST)

**Historia de Usuario:** US-007A  
**Responsable:** Backend (Angel)  
**Duración estimada:** 2 horas  
**Día sugerido:** Domingo 27 de octubre (después de 7.0)  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Implementar endpoints REST para listar todas las categorías activas (todos los usuarios) y crear nuevas categorías (solo administradores).

## Pasos Detallados

## 1. Crear serializer en `inventory/serializers.py`

python

`from rest_framework import serializers from .models import Categoria, Producto class CategoriaSerializer(serializers.ModelSerializer):     """     Serializer para el modelo Categoria.    Incluye propiedad calculada de cantidad de productos.    """     cantidad_productos = serializers.ReadOnlyField()          class Meta:         model = Categoria        fields = [             'id', 'nombre', 'descripcion', 'activo',              'cantidad_productos', 'fecha_creacion'         ]         read_only_fields = ['id', 'fecha_creacion', 'cantidad_productos']          def validate_nombre(self, value):         """         Validar que el nombre:        1. Tenga al menos 3 caracteres        2. Sea único (case-insensitive)        """         # Normalizar espacios         value = value.strip()                  if len(value) < 3:             raise serializers.ValidationError(                 'El nombre debe tener al menos 3 caracteres'             )                  # Verificar unicidad case-insensitive         qs = Categoria.objects.filter(nombre__iexact=value)                  # Si estamos editando, excluir la instancia actual         if self.instance:             qs = qs.exclude(pk=self.instance.pk)                  if qs.exists():             raise serializers.ValidationError(                 f'Ya existe una categoría con el nombre "{value}"'             )                  return value`

## 2. Crear vistas en `inventory/views.py`

python

`from rest_framework import generics, permissions, status from rest_framework.response import Response from .models import Categoria, Producto from .serializers import CategoriaSerializer from authentication.permissions import IsAdministrador class CategoriaListCreateView(generics.ListCreateAPIView):     """     GET /api/categorias/    Lista todas las categorías activas (cualquier usuario autenticado)         POST /api/categorias/    Crea una nueva categoría (solo administradores)         Ejemplos de uso:         GET:    - Listar todas: /api/categorias/    - Buscar por nombre: /api/categorias/?search=Pokemon         POST (solo admin):    {        "nombre": "TCG Flesh and Blood",        "descripcion": "Nuevo TCG en tendencia"    }    """     serializer_class = CategoriaSerializer         def get_queryset(self):         """         Solo mostrar categorías activas.        Ordenadas alfabéticamente por nombre.        """         return Categoria.objects.filter(activo=True).order_by('nombre')          def get_permissions(self):         """         GET: Cualquier usuario autenticado puede listar        POST: Solo administradores pueden crear        """         if self.request.method == 'POST':             return [permissions.IsAuthenticated(), IsAdministrador()]         return [permissions.IsAuthenticated()]          def create(self, request, *args, **kwargs):         """         Crear nueva categoría con validaciones y respuesta personalizada        """         serializer = self.get_serializer(data=request.data)                  if serializer.is_valid():             categoria = serializer.save()                          return Response(                 {                     'message': f'Categoría "{categoria.nombre}" creada exitosamente',                     'categoria': CategoriaSerializer(categoria).data                 },                 status=status.HTTP_201_CREATED             )                  return Response(             {                 'message': 'Error al crear categoría',                 'errors': serializer.errors             },             status=status.HTTP_400_BAD_REQUEST         )`

## 3. Crear URLs en `inventory/urls.py`

python

`from django.urls import path from .views import CategoriaListCreateView app_name = 'inventory' urlpatterns = [     path('categorias/', CategoriaListCreateView.as_view(), name='categoria-list-create'), ]`

## 4. Incluir URLs en `urls.py` principal del proyecto

python

`# mundo_cartas_backend/urls.py from django.contrib import admin from django.urls import path, include urlpatterns = [     path('admin/', admin.site.urls),     path('api/auth/', include('authentication.urls')),     path('api/', include('inventory.urls')),  # Nueva línea ]`

## 5. Probar endpoints con Postman/Thunder Client

**GET - Listar categorías (cualquier usuario autenticado):**

text

`GET http://localhost:8000/api/categorias/ Headers:   Authorization: Bearer <vendedor_o_admin_token> Respuesta esperada (200): [   {    "id": 1,    "nombre": "TCG Pokémon",    "descripcion": "Trading Card Game de Pokémon: sobres, cartas sueltas, productos sellados",    "activo": true,    "cantidad_productos": 0,    "fecha_creacion": "2025-10-27T12:00:00.000Z"  },  {    "id": 2,    "nombre": "TCG Yu-Gi-Oh!",    "descripcion": "Trading Card Game de Yu-Gi-Oh!: sobres, structure decks, cartas sueltas",    "activo": true,    "cantidad_productos": 0,    "fecha_creacion": "2025-10-27T12:00:01.000Z"  },  ... ]`

**POST - Crear categoría (solo administrador):**

text

`POST http://localhost:8000/api/categorias/ Headers:   Authorization: Bearer <admin_token>  Content-Type: application/json Body: {   "nombre": "TCG Flesh and Blood",  "descripcion": "Nuevo trading card game con mecánicas innovadoras" } Respuesta esperada (201): {   "message": "Categoría \"TCG Flesh and Blood\" creada exitosamente",  "categoria": {    "id": 9,    "nombre": "TCG Flesh and Blood",    "descripcion": "Nuevo trading card game con mecánicas innovadoras",    "activo": true,    "cantidad_productos": 0,    "fecha_creacion": "2025-10-27T14:30:00.000Z"  } }`

**POST - Intento de vendedor (debe fallar):**

text

`POST http://localhost:8000/api/categorias/ Headers:   Authorization: Bearer <vendedor_token>  Content-Type: application/json Body: {   "nombre": "Test Categoria" } Respuesta esperada (403): {   "detail": "No tiene permiso para realizar esta acción." }`

**POST - Nombre duplicado (debe fallar):**

text

`POST http://localhost:8000/api/categorias/ Headers:   Authorization: Bearer <admin_token>  Content-Type: application/json Body: {   "nombre": "TCG Pokémon" } Respuesta esperada (400): {   "message": "Error al crear categoría",  "errors": {    "nombre": [      "Ya existe una categoría con el nombre \"TCG Pokémon\""    ]  } }`

## Entregables

- ✅ Serializer CategoriaSerializer con validaciones

- ✅ Endpoint GET `/api/categorias/` funcional para todos

- ✅ Endpoint POST `/api/categorias/` funcional solo para admins

- ✅ Validación de nombre único case-insensitive

- ✅ Respuestas personalizadas con mensajes claros

- ✅ Permisos correctamente diferenciados

## Validación

- Vendedor puede listar categorías (200)

- Vendedor NO puede crear categorías (403)

- Administrador puede crear categorías (201)

- Crear categoría duplicada retorna error específico (400)

- Nombre con menos de 3 caracteres es rechazado (400)

- Categorías se ordenan alfabéticamente

## Recursos de Aprendizaje

- **DRF Generic Views:** [Generic views - Django REST framework](https://www.django-rest-framework.org/api-guide/generic-views/#listcreateapiview)

- **Custom Permissions:** [Permissions - Django REST framework](https://www.django-rest-framework.org/api-guide/permissions/#custom-permissions)

- **Serializer Validation:** [Serializers - Django REST framework](https://www.django-rest-framework.org/api-guide/serializers/#validation)

---

## TAREA 7.2: Componente React CategoriaSelect con Modal Crear

**Historia de Usuario:** US-007A  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 3 horas  
**Día sugerido:** Lunes 28 de octubre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Crear componente reutilizable CategoriaSelect que muestre un dropdown con categorías dinámicas y permita a administradores crear nuevas categorías sin salir del flujo.

## Pasos Detallados

## 1. Actualizar `src/services/inventoryService.js`

javascript

`import api from './api'; // Categorías export const getCategorias = async () => {   const response = await api.get('/categorias/');   return response.data; }; export const createCategoria = async (categoriaData) => {   const response = await api.post('/categorias/', categoriaData);   return response.data; }; // Productos (se agregarán en tareas posteriores) export const getProductos = async (params = {}) => {   const response = await api.get('/inventario/', { params });   return response.data; };`

## 2. Crear componente `src/components/CategoriaSelect.jsx`

jsx

`` import React, { useState, useEffect } from 'react'; import { getCategorias, createCategoria } from '../services/inventoryService'; import { useAuth } from '../context/AuthContext'; import './CategoriaSelect.css'; const CategoriaSelect = ({ value, onChange, error, name = 'categoria' }) => {   const { user } = useAuth();   const [categorias, setCategorias] = useState([]);   const [loading, setLoading] = useState(true);   const [showModal, setShowModal] = useState(false);   const [nuevaCategoria, setNuevaCategoria] = useState({      nombre: '',      descripcion: ''    });   const [modalError, setModalError] = useState('');   const [creatingCategoria, setCreatingCategoria] = useState(false);   // Verificar si el usuario es administrador   const isAdmin = user?.rol === 'administrador';   useEffect(() => {     fetchCategorias();   }, []);   const fetchCategorias = async () => {     setLoading(true);     try {       const data = await getCategorias();       setCategorias(data);     } catch (err) {       console.error('Error al cargar categorías:', err);     } finally {       setLoading(false);     }   };   const handleCreateCategoria = async (e) => {     e.preventDefault();     setModalError('');          // Validaciones frontend     if (!nuevaCategoria.nombre.trim()) {       setModalError('El nombre es obligatorio');       return;     }          if (nuevaCategoria.nombre.trim().length < 3) {       setModalError('El nombre debe tener al menos 3 caracteres');       return;     }          setCreatingCategoria(true);     try {       const response = await createCategoria({         nombre: nuevaCategoria.nombre.trim(),         descripcion: nuevaCategoria.descripcion.trim()       });              // Agregar nueva categoría a la lista       const nuevaCat = response.categoria || response;       setCategorias([...categorias, nuevaCat]);              // Auto-seleccionar la categoría recién creada       onChange({          target: {            name: name,            value: nuevaCat.id          }        });              // Cerrar modal y limpiar       setShowModal(false);       setNuevaCategoria({ nombre: '', descripcion: '' });            } catch (err) {       // Manejar errores del backend       if (err.response?.data?.errors?.nombre) {         setModalError(err.response.data.errors.nombre[0]);       } else if (err.response?.data?.message) {         setModalError(err.response.data.message);       } else {         setModalError('Error al crear categoría. Por favor intente nuevamente.');       }     } finally {       setCreatingCategoria(false);     }   };   const handleCloseModal = () => {     setShowModal(false);     setNuevaCategoria({ nombre: '', descripcion: '' });     setModalError('');   };   if (loading) {     return (       <div className="loading-select">         <span className="spinner"></span> Cargando categorías...      </div>     );   }   return (     <>       <div className="categoria-select-wrapper">         <select           name={name}           value={value}           onChange={onChange}           className={error ? 'input-error' : ''}           required         >           <option value="">Seleccione una categoría...</option>           {categorias.map(cat => (             <option key={cat.id} value={cat.id}>               {cat.nombre}               {cat.cantidad_productos > 0 && ` (${cat.cantidad_productos} productos)`}             </option>           ))}         </select>                  {isAdmin && (           <button             type="button"             className="btn-add-categoria"             onClick={() => setShowModal(true)}             title="Crear nueva categoría"           >             + Nueva          </button>         )}       </div>              {error && <span className="error-text">{error}</span>}       {/* Modal para crear categoría */}       {showModal && (         <div className="modal-overlay-small" onClick={handleCloseModal}>           <div className="modal-content-small" onClick={(e) => e.stopPropagation()}>             <div className="modal-header-small">               <h3>Nueva Categoría</h3>               <button                  className="close-btn"                  onClick={handleCloseModal}                 type="button"               >                 &times;              </button>             </div>                          <form onSubmit={handleCreateCategoria} className="categoria-form">               <div className="form-group">                 <label htmlFor="cat-nombre">Nombre de la Categoría *</label>                 <input                   type="text"                   id="cat-nombre"                   value={nuevaCategoria.nombre}                   onChange={(e) => setNuevaCategoria({                     ...nuevaCategoria,                      nombre: e.target.value                   })}                   placeholder="Ej: TCG Lorcana"                   autoFocus                   required                 />                 <small className="help-text">Mínimo 3 caracteres</small>               </div>                              <div className="form-group">                 <label htmlFor="cat-descripcion">Descripción (opcional)</label>                 <textarea                   id="cat-descripcion"                   value={nuevaCategoria.descripcion}                   onChange={(e) => setNuevaCategoria({                     ...nuevaCategoria,                      descripcion: e.target.value                   })}                   placeholder="Descripción breve de la categoría..."                   rows="3"                 />               </div>                              {modalError && (                 <div className="error-message">                   ⚠️ {modalError}                 </div>               )}                              <div className="modal-footer-small">                 <button                    type="button"                    className="btn-secondary"                    onClick={handleCloseModal}                 >                   Cancelar                </button>                 <button                    type="submit"                    className="btn-primary"                    disabled={creatingCategoria}                 >                   {creatingCategoria ? 'Creando...' : 'Crear Categoría'}                 </button>               </div>             </form>           </div>         </div>       )}     </>   ); }; export default CategoriaSelect; ``

## 3. Crear estilos `src/components/CategoriaSelect.css`

css

`.categoria-select-wrapper {   display: flex;   gap: 10px;   align-items: flex-start; } .categoria-select-wrapper select {   flex: 1;   padding: 10px;   border: 1px solid #ced4da;   border-radius: 4px;   font-size: 14px;   background-color: white; } .categoria-select-wrapper select:focus {   outline: none;   border-color: #007bff;   box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25); } .btn-add-categoria {   background-color: #28a745;   color: white;   border: none;   padding: 10px 15px;   border-radius: 4px;   cursor: pointer;   white-space: nowrap;   font-size: 14px;   font-weight: 600;   transition: background-color 0.2s, transform 0.1s;   flex-shrink: 0; } .btn-add-categoria:hover {   background-color: #218838;   transform: translateY(-1px); } .btn-add-categoria:active {   transform: translateY(0); } .loading-select {   padding: 10px;   color: #6c757d;   font-style: italic;   display: flex;   align-items: center;   gap: 10px; } .spinner {   display: inline-block;   width: 16px;   height: 16px;   border: 2px solid #f3f3f3;   border-top: 2px solid #007bff;   border-radius: 50%;   animation: spin 1s linear infinite; } @keyframes spin {   0% { transform: rotate(0deg); }   100% { transform: rotate(360deg); } } /* Modal pequeño para crear categoría */ .modal-overlay-small {   position: fixed;   top: 0;   left: 0;   right: 0;   bottom: 0;   background-color: rgba(0, 0, 0, 0.5);   display: flex;   justify-content: center;   align-items: center;   z-index: 2000;   animation: fadeIn 0.2s; } @keyframes fadeIn {   from { opacity: 0; }   to { opacity: 1; } } .modal-content-small {   background: white;   border-radius: 8px;   width: 90%;   max-width: 500px;   box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);   animation: slideUp 0.3s; } @keyframes slideUp {   from {     opacity: 0;     transform: translateY(20px);   }   to {     opacity: 1;     transform: translateY(0);   } } .modal-header-small {   display: flex;   justify-content: space-between;   align-items: center;   padding: 20px;   border-bottom: 1px solid #dee2e6; } .modal-header-small h3 {   margin: 0;   font-size: 20px;   color: #495057; } .close-btn {   background: none;   border: none;   font-size: 28px;   cursor: pointer;   color: #6c757d;   line-height: 1;   transition: color 0.2s; } .close-btn:hover {   color: #000; } .categoria-form {   padding: 20px; } .categoria-form .form-group {   margin-bottom: 20px; } .categoria-form label {   display: block;   margin-bottom: 5px;   font-weight: 600;   color: #495057;   font-size: 14px; } .categoria-form input, .categoria-form textarea {   width: 100%;   padding: 10px;   border: 1px solid #ced4da;   border-radius: 4px;   font-size: 14px;   font-family: inherit; } .categoria-form input:focus, .categoria-form textarea:focus {   outline: none;   border-color: #007bff;   box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25); } .help-text {   display: block;   margin-top: 5px;   font-size: 12px;   color: #6c757d;   font-style: italic; } .error-message {   background-color: #f8d7da;   border: 1px solid #f5c6cb;   border-radius: 4px;   padding: 10px;   margin-bottom: 15px;   color: #721c24;   font-size: 14px; } .modal-footer-small {   display: flex;   justify-content: flex-end;   gap: 10px;   padding-top: 15px;   border-top: 1px solid #dee2e6; } .btn-secondary {   background-color: #6c757d;   color: white;   border: none;   padding: 10px 20px;   border-radius: 4px;   cursor: pointer;   font-size: 14px;   transition: background-color 0.2s; } .btn-secondary:hover {   background-color: #5a6268; } .btn-primary {   background-color: #007bff;   color: white;   border: none;   padding: 10px 20px;   border-radius: 4px;   cursor: pointer;   font-size: 14px;   font-weight: 600;   transition: background-color 0.2s; } .btn-primary:hover:not(:disabled) {   background-color: #0056b3; } .btn-primary:disabled {   background-color: #6c757d;   cursor: not-allowed;   opacity: 0.6; }`

## Entregables

- ✅ Componente CategoriaSelect reutilizable

- ✅ Select dinámico que carga categorías desde API

- ✅ Botón "+ Nueva" visible solo para administradores

- ✅ Modal integrado para crear categorías sin salir del flujo

- ✅ Auto-selección de categoría recién creada

- ✅ Validaciones frontend y backend con mensajes claros

- ✅ Loading state mientras carga categorías

- ✅ Manejo de errores con feedback visual

## Validación

- Select muestra 8 categorías base correctamente

- Botón "+ Nueva" NO aparece para vendedores

- Botón "+ Nueva" SÍ aparece para administradores

- Modal se abre correctamente al hacer clic en "+ Nueva"

- Crear categoría válida cierra el modal y auto-selecciona

- Crear categoría duplicada muestra error específico

- Nombre con menos de 3 caracteres muestra error

- ESC cierra el modal sin crear categoría

## Recursos de Aprendizaje

- **React Hooks:** This feature is available in the latest Canary version of React

- http://www.w3.org/2000/svg"

- /reference/react/act

- **Conditional Rendering:** https://react.dev/learn/conditional-rendering

- **Forms in React:** This feature is available in the latest Canary version of React

- /reference/react/act

---

## TAREA 7.3: Crear Endpoint GET `/api/inventario/` con Filtros

**Historia de Usuario:** US-007 (Ver listado de productos en inventario)  
**Responsable:** Backend (Angel)  
**Duración estimada:** 3 horas  
**Día sugerido:** Lunes 28 de octubre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Crear endpoint para listar productos con soporte para búsqueda por nombre/SKU, filtros por categoría y estado, ordenamiento y paginación.

## Pasos Detallados

## 1. Crear serializer para Producto en `inventory/serializers.py`

python

`class ProductoListSerializer(serializers.ModelSerializer):     """     Serializer optimizado para listar productos.    Incluye nombre de categoría en lugar de solo ID.    """     categoria_nombre = serializers.CharField(source='categoria.nombre', read_only=True)     stock_total = serializers.ReadOnlyField()     necesita_reabastecimiento = serializers.ReadOnlyField()          class Meta:         model = Producto        fields = [             'id', 'sku', 'nombre', 'descripcion',             'categoria', 'categoria_nombre',             'precio_compra', 'precio_venta',             'stock_disponible', 'stock_reservado', 'stock_total',             'stock_minimo', 'necesita_reabastecimiento',             'estado', 'activo', 'fecha_creacion', 'ultima_modificacion'         ] class ProductoDetailSerializer(serializers.ModelSerializer):     """     Serializer detallado para un producto individual.    Incluye información completa de la categoría.    """     categoria_info = CategoriaSerializer(source='categoria', read_only=True)     stock_total = serializers.ReadOnlyField()     necesita_reabastecimiento = serializers.ReadOnlyField()     margen_ganancia = serializers.SerializerMethodField()          class Meta:         model = Producto        fields = [             'id', 'sku', 'nombre', 'descripcion',             'categoria', 'categoria_info',             'precio_compra', 'precio_venta', 'margen_ganancia',             'stock_disponible', 'stock_reservado', 'stock_total',             'stock_minimo', 'necesita_reabastecimiento',             'estado', 'activo', 'fecha_creacion', 'ultima_modificacion'         ]          def get_margen_ganancia(self, obj):         """Calcula el margen de ganancia porcentual"""         if obj.precio_compra and obj.precio_venta:             margen = ((obj.precio_venta - obj.precio_compra) / obj.precio_compra) * 100             return round(margen, 2)         return 0`

## 2. Instalar django-filter si no está instalado

bash

`pip install django-filter==23.3 pip freeze > requirements.txt`

## 3. Agregar a INSTALLED_APPS en `settings.py`

python

`INSTALLED_APPS = [     # ...     'django_filters',     # ... ]`

## 4. Crear vista para listar productos en `inventory/views.py`

python

`from rest_framework import generics, filters from rest_framework.permissions import IsAuthenticated from django_filters.rest_framework import DjangoFilterBackend from django.db.models import Q from .models import Producto from .serializers import ProductoListSerializer from authentication.permissions import IsVendedor class ProductoListView(generics.ListAPIView):     """     GET /api/inventario/         Lista todos los productos activos con soporte para:         Búsqueda:    - ?search=pokemon → Busca en nombre y SKU         Filtros:    - ?categoria=1 → Filtra por ID de categoría    - ?estado=disponible → Filtra por estado (disponible/agotado/descontinuado)    - ?stock_bajo=true → Solo productos con stock <= stock_minimo         Ordenamiento:    - ?ordering=nombre → Orden alfabético ascendente    - ?ordering=-nombre → Orden alfabético descendente    - ?ordering=precio_venta → Por precio ascendente    - ?ordering=-stock_disponible → Por stock descendente         Paginación:    - ?page=1&page_size=25 → 25 productos por página         Ejemplos combinados:    - ?categoria=1&search=booster&ordering=-fecha_creacion    - ?stock_bajo=true&estado=disponible    """     serializer_class = ProductoListSerializer    permission_classes = [IsAuthenticated, IsVendedor]     filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]          # Campos de filtro exacto     filterset_fields = ['categoria', 'estado']          # Campos de búsqueda (busca en nombre y SKU con ILIKE en PostgreSQL)     search_fields = ['nombre', 'sku', 'descripcion']          # Campos permitidos para ordenamiento     ordering_fields = ['nombre', 'precio_venta', 'precio_compra', 'stock_disponible', 'fecha_creacion']     ordering = ['nombre']  # Ordenamiento por defecto          def get_queryset(self):         """         Queryset optimizado con select_related para evitar N+1 queries.        Solo muestra productos activos por defecto.        """         queryset = Producto.objects.filter(activo=True).select_related('categoria')                  # Filtro personalizado: stock bajo         stock_bajo = self.request.query_params.get('stock_bajo', None)         if stock_bajo and stock_bajo.lower() == 'true':             queryset = queryset.filter(stock_disponible__lte=models.F('stock_minimo'))                  return queryset`

## 5. Agregar URL en `inventory/urls.py`

python

`from django.urls import path from .views import CategoriaListCreateView, ProductoListView app_name = 'inventory' urlpatterns = [     path('categorias/', CategoriaListCreateView.as_view(), name='categoria-list-create'),     path('inventario/', ProductoListView.as_view(), name='producto-list'), ]`

## 6. Crear productos de prueba con comando seed

python

`# inventory/management/commands/seed_productos.py from django.core.management.base import BaseCommand from inventory.models import Producto, Categoria from decimal import Decimal class Command(BaseCommand):     help = 'Crea productos de prueba en el inventario'     def handle(self, *args, **kwargs):         # Obtener categorías         try:             cat_pokemon = Categoria.objects.get(nombre='TCG Pokémon')             cat_yugioh = Categoria.objects.get(nombre='TCG Yu-Gi-Oh!')             cat_magic = Categoria.objects.get(nombre='TCG Magic')             cat_accesorios = Categoria.objects.get(nombre='Accesorios')         except Categoria.DoesNotExist:             self.stdout.write(self.style.ERROR('Error: Ejecuta seed_categorias primero'))             return                  productos = [             {                 'sku': 'PKM-SV01-001',                 'nombre': 'Booster Pack Pokémon Escarlata y Púrpura',                 'descripcion': 'Sobre con 10 cartas aleatorias de la expansión Escarlata y Púrpura',                 'categoria': cat_pokemon,                 'precio_compra': Decimal('2500.00'),                 'precio_venta': Decimal('3500.00'),                 'stock_disponible': 50,                 'stock_minimo': 10,             },             {                 'sku': 'PKM-SV01-002',                 'nombre': 'Elite Trainer Box Pokémon Escarlata',                 'descripcion': 'Caja con 9 sobres, accesorios y guía del entrenador',                 'categoria': cat_pokemon,                 'precio_compra': Decimal('28000.00'),                 'precio_venta': Decimal('38000.00'),                 'stock_disponible': 8,                 'stock_minimo': 5,             },             {                 'sku': 'YGO-PHNI-001',                 'nombre': 'Booster Pack Yu-Gi-Oh! Phantom Nightmare',                 'descripcion': 'Sobre con 9 cartas de la expansión Phantom Nightmare',                 'categoria': cat_yugioh,                 'precio_compra': Decimal('2800.00'),                 'precio_venta': Decimal('4000.00'),                 'stock_disponible': 30,                 'stock_minimo': 10,             },             {                 'sku': 'YGO-SD-001',                 'nombre': 'Structure Deck Cyber Strike',                 'descripcion': 'Mazo estructurado pre-construido de 40 cartas',                 'categoria': cat_yugioh,                 'precio_compra': Decimal('8000.00'),                 'precio_venta': Decimal('12000.00'),                 'stock_disponible': 3,  # Stock bajo intencional                 'stock_minimo': 5,             },             {                 'sku': 'MTG-LCI-001',                 'nombre': 'Draft Booster Magic Lost Caverns of Ixalan',                 'descripcion': 'Sobre draft con 15 cartas de LCI',                 'categoria': cat_magic,                 'precio_compra': Decimal('3500.00'),                 'precio_venta': Decimal('5000.00'),                 'stock_disponible': 40,                 'stock_minimo': 15,             },             {                 'sku': 'ACC-SLV-001',                 'nombre': 'Sleeves Ultra Pro 100 unidades',                 'descripcion': 'Protectores de cartas tamaño estándar (66x91mm)',                 'categoria': cat_accesorios,                 'precio_compra': Decimal('3000.00'),                 'precio_venta': Decimal('4500.00'),                 'stock_disponible': 25,                 'stock_minimo': 10,             },             {                 'sku': 'ACC-DB-001',                 'nombre': 'Deck Box Ultimate Guard 80+',                 'descripcion': 'Caja rígida para almacenar hasta 80 cartas con sleeves',                 'categoria': cat_accesorios,                 'precio_compra': Decimal('5000.00'),                 'precio_venta': Decimal('7500.00'),                 'stock_disponible': 2,  # Stock bajo intencional                 'stock_minimo': 5,             },         ]                  creados = 0         for producto_data in productos:             producto, created = Producto.objects.get_or_create(                 sku=producto_data['sku'],                 defaults=producto_data             )             if created:                 creados += 1                 self.stdout.write(self.style.SUCCESS(f'  ✓ Creado: {producto.sku} - {producto.nombre}'))             else:                 self.stdout.write(f'  → Ya existe: {producto.sku}')                  self.stdout.write('')         self.stdout.write(self.style.SUCCESS(f'Resumen:'))         self.stdout.write(f'  - {creados} productos nuevos creados')                  # Mostrar productos con stock bajo         productos_bajo_stock = Producto.objects.filter(             stock_disponible__lte=models.F('stock_minimo')         )         if productos_bajo_stock.exists():             self.stdout.write('')             self.stdout.write(self.style.WARNING('⚠️  Productos con stock bajo:'))             for p in productos_bajo_stock:                 self.stdout.write(f'  - {p.sku}: {p.stock_disponible} unidades (mínimo: {p.stock_minimo})')`

## 7. Ejecutar comando

bash

`python manage.py seed_productos`

## 8. Probar endpoint con múltiples filtros

**Listar todos los productos:**

text

`GET http://localhost:8000/api/inventario/ Headers: Authorization: Bearer <token> Respuesta esperada (200): [   {    "id": 1,    "sku": "PKM-SV01-001",    "nombre": "Booster Pack Pokémon Escarlata y Púrpura",    "descripcion": "Sobre con 10 cartas aleatorias...",    "categoria": 1,    "categoria_nombre": "TCG Pokémon",    "precio_compra": "2500.00",    "precio_venta": "3500.00",    "stock_disponible": 50,    "stock_reservado": 0,    "stock_total": 50,    "stock_minimo": 10,    "necesita_reabastecimiento": false,    "estado": "disponible",    "activo": true,    "fecha_creacion": "2025-10-28T...",    "ultima_modificacion": "2025-10-28T..."  },  ... ]`

**Buscar por nombre:**

text

`GET http://localhost:8000/api/inventario/?search=booster Headers: Authorization: Bearer <token> Retorna: Productos que contengan "booster" en nombre o SKU`

**Filtrar por categoría:**

text

`GET http://localhost:8000/api/inventario/?categoria=1 Headers: Authorization: Bearer <token> Retorna: Solo productos de TCG Pokémon (categoria_id=1)`

**Solo productos con stock bajo:**

text

`GET http://localhost:8000/api/inventario/?stock_bajo=true Headers: Authorization: Bearer <token> Retorna: YGO-SD-001 y ACC-DB-001 (productos donde stock_disponible <= stock_minimo)`

**Combinación de filtros:**

text

`GET http://localhost:8000/api/inventario/?categoria=1&ordering=-stock_disponible&search=pokemon Headers: Authorization: Bearer <token> Retorna: Productos de Pokémon que contengan "pokemon", ordenados por stock descendente`

## Entregables

- ✅ Serializer ProductoListSerializer optimizado

- ✅ Endpoint GET con filtros, búsqueda y ordenamiento

- ✅ Paginación configurada

- ✅ Queryset optimizado con select_related

- ✅ Filtro personalizado stock_bajo

- ✅ 7 productos de prueba creados

- ✅ Documentación de parámetros de query en docstring

## Validación

- Listar sin filtros retorna todos los productos activos

- Búsqueda por "booster" encuentra 3 productos

- Filtro por categoría funciona correctamente

- Ordenamiento por precio y stock funciona

- Filtro stock_bajo retorna solo 2 productos

- Combinar múltiples filtros funciona correctamente

- Select_related evita N+1 queries (verificar con Django Debug Toolbar)

## Recursos de Aprendizaje

- **Django Filters:** [django-filter 25.2 documentation](https://django-filter.readthedocs.io/en/stable/)

- **DRF Search:** [Filtering - Django REST framework](https://www.django-rest-framework.org/api-guide/filtering/#searchfilter)

- **Query Optimization:** [QuerySet API reference | Django documentation | Django](https://docs.djangoproject.com/en/4.2/ref/models/querysets/#select-related)

---

## TAREA 7.4: Vista InventoryPage con Tabla y Filtros Dinámicos

**Historia de Usuario:** US-007  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 5 horas  
**Día sugerido:** Martes 29 de octubre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Crear página completa de inventario con tabla responsive, búsqueda en tiempo real, filtros por categoría y estado, y indicadores visuales de stock bajo.

## Pasos Detallados

## 1. Actualizar `src/services/inventoryService.js`

javascript

`` import api from './api'; // Categorías export const getCategorias = async () => {   const response = await api.get('/categorias/');   return response.data; }; export const createCategoria = async (categoriaData) => {   const response = await api.post('/categorias/', categoriaData);   return response.data; }; // Productos export const getProductos = async (params = {}) => {   const response = await api.get('/inventario/', { params });   return response.data; }; export const getProductoById = async (id) => {   const response = await api.get(`/inventario/${id}/`);   return response.data; }; ``

## 2. Crear `src/pages/InventoryPage.jsx`

jsx

`` import React, { useState, useEffect } from 'react'; import { getProductos, getCategorias } from '../services/inventoryService'; import { useAuth } from '../context/AuthContext'; import './InventoryPage.css'; const InventoryPage = () => {   const { user } = useAuth();   const isAdmin = user?.rol === 'administrador';      // Estados principales   const [productos, setProductos] = useState([]);   const [categorias, setCategorias] = useState([]);   const [loading, setLoading] = useState(true);   const [error, setError] = useState('');      // Estados de filtros   const [searchTerm, setSearchTerm] = useState('');   const [categoriaFiltro, setCategoriaFiltro] = useState('');   const [estadoFiltro, setEstadoFiltro] = useState('');   const [stockBajo, setStockBajo] = useState(false);   const [ordenamiento, setOrdenamiento] = useState('nombre');   const estados = [     { value: '', label: 'Todos los estados' },     { value: 'disponible', label: 'Disponible' },     { value: 'agotado', label: 'Agotado' },     { value: 'descontinuado', label: 'Descontinuado' },   ];   const ordenamientos = [     { value: 'nombre', label: 'Nombre (A-Z)' },     { value: '-nombre', label: 'Nombre (Z-A)' },     { value: 'precio_venta', label: 'Precio (menor a mayor)' },     { value: '-precio_venta', label: 'Precio (mayor a menor)' },     { value: '-stock_disponible', label: 'Stock (mayor a menor)' },     { value: 'stock_disponible', label: 'Stock (menor a mayor)' },     { value: '-fecha_creacion', label: 'Más recientes' },   ];   // Cargar categorías al montar   useEffect(() => {     fetchCategorias();   }, []);   // Cargar productos cuando cambian los filtros   useEffect(() => {     fetchProductos();   }, [searchTerm, categoriaFiltro, estadoFiltro, stockBajo, ordenamiento]);   const fetchCategorias = async () => {     try {       const data = await getCategorias();       setCategorias(data);     } catch (err) {       console.error('Error al cargar categorías:', err);     }   };   const fetchProductos = async () => {     setLoading(true);     setError('');          try {       const params = {};              if (searchTerm) params.search = searchTerm;       if (categoriaFiltro) params.categoria = categoriaFiltro;       if (estadoFiltro) params.estado = estadoFiltro;       if (stockBajo) params.stock_bajo = 'true';       if (ordenamiento) params.ordering = ordenamiento;              const data = await getProductos(params);       setProductos(data);     } catch (err) {       setError('Error al cargar productos. Por favor intente nuevamente.');       console.error(err);     } finally {       setLoading(false);     }   };   const formatCLP = (amount) => {     return new Intl.NumberFormat('es-CL', {       style: 'currency',       currency: 'CLP',       minimumFractionDigits: 0,       maximumFractionDigits: 0,     }).format(amount);   };   const limpiarFiltros = () => {     setSearchTerm('');     setCategoriaFiltro('');     setEstadoFiltro('');     setStockBajo(false);     setOrdenamiento('nombre');   };   const getEstadoBadgeClass = (estado) => {     const classes = {       disponible: 'badge-success',       agotado: 'badge-danger',       descontinuado: 'badge-secondary'     };     return classes[estado] || 'badge-secondary';   };   return (     <div className="inventory-page">       {/* Header */}       <div className="inventory-header">         <div className="header-left">           <h1>Inventario de Productos</h1>           <p className="subtitle">             {productos.length} {productos.length === 1 ? 'producto' : 'productos'}              {searchTerm && ` encontrados para "${searchTerm}"`}           </p>         </div>         {isAdmin && (           <button className="btn-primary" onClick={() => console.log('Abrir modal crear')}>             <span className="icon">+</span> Agregar Producto          </button>         )}       </div>       {/* Filtros */}       <div className="filters-container">         <div className="filters-row">           <div className="filter-group search-group">             <input               type="text"               placeholder="🔍 Buscar por nombre o SKU..."               value={searchTerm}               onChange={(e) => setSearchTerm(e.target.value)}               className="search-input"             />           </div>                      <div className="filter-group">             <select               value={categoriaFiltro}               onChange={(e) => setCategoriaFiltro(e.target.value)}               className="filter-select"             >               <option value="">Todas las categorías</option>               {categorias.map(cat => (                 <option key={cat.id} value={cat.id}>{cat.nombre}</option>               ))}             </select>           </div>                      <div className="filter-group">             <select               value={estadoFiltro}               onChange={(e) => setEstadoFiltro(e.target.value)}               className="filter-select"             >               {estados.map(est => (                 <option key={est.value} value={est.value}>{est.label}</option>               ))}             </select>           </div>                      <div className="filter-group">             <select               value={ordenamiento}               onChange={(e) => setOrdenamiento(e.target.value)}               className="filter-select"             >               {ordenamientos.map(ord => (                 <option key={ord.value} value={ord.value}>{ord.label}</option>               ))}             </select>           </div>         </div>                  <div className="filters-row-secondary">           <label className="checkbox-filter">             <input               type="checkbox"               checked={stockBajo}               onChange={(e) => setStockBajo(e.target.checked)}             />             <span>⚠️ Solo productos con stock bajo</span>           </label>                      {(searchTerm || categoriaFiltro || estadoFiltro || stockBajo) && (             <button className="btn-clear-filters" onClick={limpiarFiltros}>               ✕ Limpiar filtros            </button>           )}         </div>       </div>       {/* Tabla de productos */}       {loading ? (         <div className="loading-container">           <div className="spinner-large"></div>           <p>Cargando productos...</p>         </div>       ) : error ? (         <div className="error-container">           <p className="error-message">❌ {error}</p>           <button className="btn-secondary" onClick={fetchProductos}>             Reintentar          </button>         </div>       ) : productos.length === 0 ? (         <div className="empty-state">           <div className="empty-icon">📦</div>           <h3>No se encontraron productos</h3>           <p>             {searchTerm || categoriaFiltro || estadoFiltro || stockBajo              ? 'Intenta ajustar los filtros de búsqueda'               : 'Comienza agregando tu primer producto al inventario'}           </p>           {isAdmin && (             <button className="btn-primary" onClick={() => console.log('Abrir modal crear')}>               + Agregar Primer Producto            </button>           )}         </div>       ) : (         <div className="table-container">           <table className="productos-table">             <thead>               <tr>                 <th>SKU</th>                 <th>Nombre</th>                 <th>Categoría</th>                 <th className="text-right">Precio Venta</th>                 <th className="text-center">Stock Disp.</th>                 <th className="text-center">Stock Res.</th>                 <th className="text-center">Estado</th>                 {isAdmin && <th className="text-center">Acciones</th>}               </tr>             </thead>             <tbody>               {productos.map(producto => (                 <tr                    key={producto.id}                    className={producto.necesita_reabastecimiento ? 'row-warning' : ''}                 >                   <td className="font-mono">{producto.sku}</td>                   <td>                     <div className="producto-nombre">{producto.nombre}</div>                     {producto.descripcion && (                       <div className="producto-descripcion">{producto.descripcion}</div>                     )}                   </td>                   <td>                     <span className="categoria-tag">{producto.categoria_nombre}</span>                   </td>                   <td className="text-right font-bold">{formatCLP(producto.precio_venta)}</td>                   <td className="text-center">                     <span className={producto.necesita_reabastecimiento ? 'stock-bajo' : ''}>                       {producto.stock_disponible}                       {producto.necesita_reabastecimiento && (                         <span className="warning-icon" title="Stock bajo">⚠️</span>                       )}                     </span>                   </td>                   <td className="text-center">{producto.stock_reservado}</td>                   <td className="text-center">                     <span className={`badge ${getEstadoBadgeClass(producto.estado)}`}>                       {producto.estado}                     </span>                   </td>                   {isAdmin && (                     <td className="text-center">                       <div className="actions-group">                         <button                            className="btn-icon"                            title="Editar producto"                           onClick={() => console.log('Editar', producto.id)}                         >                           ✏️                        </button>                         <button                            className="btn-icon"                            title="Ajustar stock"                           onClick={() => console.log('Ajustar stock', producto.id)}                         >                           📦                        </button>                       </div>                     </td>                   )}                 </tr>               ))}             </tbody>           </table>         </div>       )}     </div>   ); }; export default InventoryPage; ``

## 3. Crear estilos `src/pages/InventoryPage.css`

css

`.inventory-page {   padding: 20px;   max-width: 1600px;   margin: 0 auto; } /* Header */ .inventory-header {   display: flex;   justify-content: space-between;   align-items: flex-start;   margin-bottom: 30px;   gap: 20px; } .header-left h1 {   margin: 0 0 5px 0;   font-size: 28px;   color: #212529; } .subtitle {   margin: 0;   color: #6c757d;   font-size: 14px; } .btn-primary {   background-color: #007bff;   color: white;   border: none;   padding: 12px 24px;   border-radius: 6px;   cursor: pointer;   font-size: 15px;   font-weight: 600;   display: flex;   align-items: center;   gap: 8px;   transition: all 0.2s;   white-space: nowrap; } .btn-primary:hover {   background-color: #0056b3;   transform: translateY(-1px);   box-shadow: 0 4px 8px rgba(0,123,255,0.3); } .btn-primary .icon {   font-size: 20px;   line-height: 1; } /* Filtros */ .filters-container {   background: white;   border-radius: 8px;   padding: 20px;   margin-bottom: 20px;   box-shadow: 0 1px 3px rgba(0,0,0,0.1); } .filters-row {   display: grid;   grid-template-columns: 2fr 1fr 1fr 1fr;   gap: 15px;   margin-bottom: 15px; } .filters-row-secondary {   display: flex;   justify-content: space-between;   align-items: center; } .filter-group {   display: flex;   flex-direction: column; } .search-group {   grid-column: span 1; } .search-input {   width: 100%;   padding: 12px 16px;   border: 2px solid #e0e0e0;   border-radius: 6px;   font-size: 14px;   transition: border-color 0.2s; } .search-input:focus {   outline: none;   border-color: #007bff;   box-shadow: 0 0 0 3px rgba(0,123,255,0.1); } .filter-select {   padding: 12px 16px;   border: 2px solid #e0e0e0;   border-radius: 6px;   font-size: 14px;   background-color: white;   cursor: pointer;   transition: border-color 0.2s; } .filter-select:focus {   outline: none;   border-color: #007bff; } .checkbox-filter {   display: flex;   align-items: center;   gap: 8px;   cursor: pointer;   font-size: 14px;   color: #495057; } .checkbox-filter input[type="checkbox"] {   width: 18px;   height: 18px;   cursor: pointer; } .btn-clear-filters {   background: none;   border: 1px solid #dc3545;   color: #dc3545;   padding: 8px 16px;   border-radius: 6px;   cursor: pointer;   font-size: 14px;   transition: all 0.2s; } .btn-clear-filters:hover {   background-color: #dc3545;   color: white; } /* Tabla */ .table-container {   background: white;   border-radius: 8px;   overflow: hidden;   box-shadow: 0 1px 3px rgba(0,0,0,0.1); } .productos-table {   width: 100%;   border-collapse: collapse; } .productos-table thead {   background-color: #f8f9fa;   border-bottom: 2px solid #dee2e6; } .productos-table th {   padding: 14px 12px;   text-align: left;   font-weight: 600;   color: #495057;   font-size: 13px;   text-transform: uppercase;   letter-spacing: 0.5px; } .productos-table td {   padding: 16px 12px;   border-bottom: 1px solid #f0f0f0;   font-size: 14px; } .productos-table tbody tr {   transition: background-color 0.2s; } .productos-table tbody tr:hover {   background-color: #f8f9fa; } .productos-table tbody tr.row-warning {   background-color: #fff3cd; } .productos-table tbody tr.row-warning:hover {   background-color: #ffe8a1; } .text-right {   text-align: right !important; } .text-center {   text-align: center !important; } .font-mono {   font-family: 'Courier New', monospace;   font-size: 13px;   color: #6c757d; } .font-bold {   font-weight: 600;   color: #212529; } .producto-nombre {   font-weight: 500;   color: #212529;   margin-bottom: 4px; } .producto-descripcion {   font-size: 12px;   color: #6c757d;   line-height: 1.4; } .categoria-tag {   background-color: #e7f3ff;   color: #004085;   padding: 4px 10px;   border-radius: 4px;   font-size: 12px;   font-weight: 500;   white-space: nowrap; } .stock-bajo {   color: #dc3545;   font-weight: 600; } .warning-icon {   margin-left: 4px;   font-size: 14px; } .badge {   padding: 5px 10px;   border-radius: 4px;   font-size: 12px;   font-weight: 600;   text-transform: capitalize;   display: inline-block; } .badge-success {   background-color: #d4edda;   color: #155724; } .badge-danger {   background-color: #f8d7da;   color: #721c24; } .badge-secondary {   background-color: #e2e3e5;   color: #383d41; } .actions-group {   display: flex;   gap: 8px;   justify-content: center; } .btn-icon {   background: none;   border: none;   font-size: 20px;   cursor: pointer;   padding: 4px 8px;   border-radius: 4px;   transition: background-color 0.2s; } .btn-icon:hover {   background-color: #e9ecef; } /* Estados de carga */ .loading-container {   text-align: center;   padding: 60px 20px; } .spinner-large {   display: inline-block;   width: 50px;   height: 50px;   border: 4px solid #f3f3f3;   border-top: 4px solid #007bff;   border-radius: 50%;   animation: spin 1s linear infinite;   margin-bottom: 20px; } @keyframes spin {   0% { transform: rotate(0deg); }   100% { transform: rotate(360deg); } } .error-container {   text-align: center;   padding: 60px 20px; } .error-message {   color: #dc3545;   font-size: 16px;   margin-bottom: 20px; } .btn-secondary {   background-color: #6c757d;   color: white;   border: none;   padding: 10px 20px;   border-radius: 6px;   cursor: pointer;   font-size: 14px; } .btn-secondary:hover {   background-color: #5a6268; } .empty-state {   text-align: center;   padding: 80px 20px;   background: white;   border-radius: 8px; } .empty-icon {   font-size: 64px;   margin-bottom: 20px; } .empty-state h3 {   margin: 0 0 10px 0;   color: #212529;   font-size: 24px; } .empty-state p {   color: #6c757d;   margin-bottom: 30px;   font-size: 16px; } /* Responsive */ @media (max-width: 1200px) {   .filters-row {     grid-template-columns: 1fr 1fr;   }      .search-group {     grid-column: span 2;   } } @media (max-width: 768px) {   .inventory-header {     flex-direction: column;   }      .filters-row {     grid-template-columns: 1fr;   }      .search-group {     grid-column: span 1;   }      .table-container {     overflow-x: auto;   }      .productos-table {     min-width: 800px;   } }`

## 4. Agregar ruta en `App.js`

jsx

`import InventoryPage from './pages/InventoryPage'; import PrivateRoute from './components/PrivateRoute'; <Routes>   <Route path="/" element={<LoginPage />} />   <Route      path="/dashboard"      element={       <PrivateRoute>         <DashboardPage />       </PrivateRoute>     }    />   <Route      path="/inventario"      element={       <PrivateRoute>         <InventoryPage />       </PrivateRoute>     }    /> </Routes>`

## 5. Agregar link en Dashboard o Nav

jsx

`// En DashboardPage.jsx o en un componente Nav <nav>   <a href="/inventario">📦 Inventario</a> </nav>`

## Entregables

- ✅ Página InventoryPage completa y responsive

- ✅ Tabla con todos los campos relevantes

- ✅ Búsqueda en tiempo real (debounce implícito por useEffect)

- ✅ Filtros múltiples combinables

- ✅ Indicador visual de stock bajo (fila amarilla + ⚠️)

- ✅ Estados de carga, error y vacío

- ✅ Botón "Agregar Producto" solo para admins

- ✅ Formato CLP para precios

- ✅ Badges de estado con colores

## Validación

- Tabla muestra 7 productos de prueba

- Búsqueda por "booster" filtra correctamente

- Filtro por categoría "TCG Pokémon" muestra 2 productos

- Checkbox "Stock bajo" muestra 2 productos con alerta

- Ordenamiento cambia el orden de la tabla

- Limpiar filtros restaura vista completa

- Productos con stock bajo tienen fila amarilla

- Responsive funciona en móviles

---

**Continuaré con las tareas 8.1, 8.2, 9.1, 9.2, 10.1 y 10.2 para completar Sprint 2. ¿Quieres que continúe?**

Perfecto, Angel. Continuaré con las tareas restantes del Sprint 2 manteniendo coherencia, detalle y profundidad.

---

## TAREA 8.1: Crear Endpoint POST `/api/inventario/` (Crear Producto)

**Historia de Usuario:** US-008 (Agregar nuevo producto al inventario)  
**Responsable:** Backend (Angel)  
**Duración estimada:** 3 horas  
**Día sugerido:** Martes 29 de octubre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Implementar endpoint para crear nuevos productos con validaciones completas de precios, stock y categoría.

## Pasos Detallados

## 1. Crear serializer para creación/edición en `inventory/serializers.py`

python

`class ProductoCreateUpdateSerializer(serializers.ModelSerializer):     """     Serializer para crear y actualizar productos.    Incluye todas las validaciones de negocio necesarias.    """     class Meta:         model = Producto        fields = [             'sku', 'nombre', 'descripcion', 'categoria',             'precio_compra', 'precio_venta',             'stock_disponible', 'stock_minimo', 'estado', 'activo'         ]          def validate_sku(self, value):         """Validar SKU único y formato"""         # Normalizar: mayúsculas y sin espacios extra         value = value.strip().upper()                  # Verificar que sea alfanumérico con guiones/guiones bajos         if not all(c.isalnum() or c in ['-', '_'] for c in value):             raise serializers.ValidationError(                 'El SKU solo puede contener letras, números, guiones (-) y guiones bajos (_)'             )                  # Verificar unicidad         qs = Producto.objects.filter(sku=value)                  # Si estamos editando, excluir el producto actual         if self.instance:             qs = qs.exclude(pk=self.instance.pk)                  if qs.exists():             raise serializers.ValidationError(                 f'Ya existe un producto con el SKU "{value}"'             )                  return value         def validate_nombre(self, value):         """Validar que el nombre tenga contenido real"""         value = value.strip()                  if len(value) < 3:             raise serializers.ValidationError(                 'El nombre debe tener al menos 3 caracteres'             )                  return value         def validate(self, data):         """Validaciones que requieren múltiples campos"""         # Validar relación de precios         precio_compra = data.get('precio_compra', None)         precio_venta = data.get('precio_venta', None)                  # Si estamos actualizando, usar valores actuales si no se proporcionan nuevos         if self.instance:             if precio_compra is None:                 precio_compra = self.instance.precio_compra             if precio_venta is None:                 precio_venta = self.instance.precio_venta                  if precio_compra and precio_venta:             if precio_venta <= precio_compra:                 raise serializers.ValidationError({                     'precio_venta': 'El precio de venta debe ser mayor al precio de compra'                 })                  # Validar stock inicial no negativo         if 'stock_disponible' in data:             if data['stock_disponible'] < 0:                 raise serializers.ValidationError({                     'stock_disponible': 'El stock no puede ser negativo'                 })                  # Validar que la categoría esté activa         if 'categoria' in data:             if not data['categoria'].activo:                 raise serializers.ValidationError({                     'categoria': 'No se pueden crear productos en una categoría inactiva'                 })                  return data`

## 2. Crear vista para crear productos en `inventory/views.py`

python

`from rest_framework.response import Response from rest_framework import status from rest_framework.views import APIView from authentication.permissions import IsAdministrador class ProductoCreateView(APIView):     """     POST /api/inventario/         Crea un nuevo producto en el inventario.    Solo administradores pueden crear productos.         Body ejemplo:    {        "sku": "PKM-SV02-001",        "nombre": "Booster Pack Pokémon Paradoja Temporal",        "descripcion": "Sobre con 10 cartas",        "categoria": 1,        "precio_compra": 2500.00,        "precio_venta": 3500.00,        "stock_disponible": 20,        "stock_minimo": 10,        "estado": "disponible",        "activo": true    }    """     permission_classes = [IsAuthenticated, IsAdministrador]          def post(self, request):         serializer = ProductoCreateUpdateSerializer(data=request.data)                  if serializer.is_valid():             # Guardar producto             producto = serializer.save()                          # Registrar en historial             ProductoHistorial.objects.create(                 producto=producto,                 accion='creacion',                 usuario=request.user,                 datos_nuevos={                     'sku': producto.sku,                     'nombre': producto.nombre,                     'categoria': producto.categoria.nombre,                     'precio_venta': str(producto.precio_venta),                     'stock_inicial': producto.stock_disponible,                 },                 observaciones=f'Producto creado por {request.user.username}'             )                          # Retornar respuesta con serializer de lectura             return Response(                 {                     'message': f'Producto "{producto.nombre}" creado exitosamente',                     'producto': ProductoDetailSerializer(producto).data                 },                 status=status.HTTP_201_CREATED             )                  return Response(             {                 'message': 'Error al crear producto',                 'errors': serializer.errors             },             status=status.HTTP_400_BAD_REQUEST         )`

## 3. Actualizar URLs en `inventory/urls.py`

python

`from django.urls import path from .views import (     CategoriaListCreateView,      ProductoListView,      ProductoCreateView ) app_name = 'inventory' urlpatterns = [     path('categorias/', CategoriaListCreateView.as_view(), name='categoria-list-create'),     path('inventario/', ProductoListView.as_view(), name='producto-list'),     path('inventario/crear/', ProductoCreateView.as_view(), name='producto-create'), ]`

## 4. Probar endpoint

**Crear producto válido:**

text

`POST http://localhost:8000/api/inventario/crear/ Headers:   Authorization: Bearer <admin_token>  Content-Type: application/json Body: {   "sku": "PKM-SV02-001",  "nombre": "Booster Pack Pokémon Paradoja Temporal",  "descripcion": "Sobre con 10 cartas de la nueva expansión",  "categoria": 1,  "precio_compra": 2500.00,  "precio_venta": 3500.00,  "stock_disponible": 30,  "stock_minimo": 10,  "estado": "disponible",  "activo": true } Respuesta esperada (201): {   "message": "Producto \"Booster Pack Pokémon Paradoja Temporal\" creado exitosamente",  "producto": {    "id": 8,    "sku": "PKM-SV02-001",    "nombre": "Booster Pack Pokémon Paradoja Temporal",    ...  } }`

**Error: SKU duplicado:**

text

`POST http://localhost:8000/api/inventario/crear/ Body: {   "sku": "PKM-SV01-001",  // SKU que ya existe  ... } Respuesta esperada (400): {   "message": "Error al crear producto",  "errors": {    "sku": [      "Ya existe un producto con el SKU \"PKM-SV01-001\""    ]  } }`

**Error: Precio venta menor a compra:**

text

`POST http://localhost:8000/api/inventario/crear/ Body: {   ...  "precio_compra": 5000.00,  "precio_venta": 3000.00  // Menor que compra } Respuesta esperada (400): {   "message": "Error al crear producto",  "errors": {    "precio_venta": [      "El precio de venta debe ser mayor al precio de compra"    ]  } }`

## Entregables

- ✅ Serializer ProductoCreateUpdateSerializer con validaciones completas

- ✅ Endpoint POST funcional solo para administradores

- ✅ Registro automático en ProductoHistorial

- ✅ Validación de SKU único con normalización

- ✅ Validación de precios coherentes

- ✅ Validación de categoría activa

- ✅ Respuestas con mensajes claros

## Validación

- Crear producto válido retorna 201 con datos completos

- SKU se convierte a mayúsculas automáticamente

- SKU duplicado retorna error específico

- Precio venta <= compra retorna error

- Stock negativo retorna error

- Categoría inactiva retorna error

- Vendedor intentando crear retorna 403

---

## TAREA 8.2: Modal ProductoModal para Crear Productos

**Historia de Usuario:** US-008  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 5 horas  
**Día sugerido:** Miércoles 30 de octubre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Crear modal completo con formulario para agregar nuevos productos, integrado con CategoriaSelect y validaciones frontend.

## Pasos Detallados

## 1. Actualizar `src/services/inventoryService.js`

javascript

`// Agregar función para crear productos export const createProducto = async (productoData) => {   const response = await api.post('/inventario/crear/', productoData);   return response.data; };`

## 2. Crear componente `src/components/ProductoModal.jsx`

jsx

`` import React, { useState, useEffect } from 'react'; import CategoriaSelect from './CategoriaSelect'; import './ProductoModal.css'; const ProductoModal = ({ isOpen, onClose, onSave, producto = null }) => {   const isEditMode = !!producto;      const [formData, setFormData] = useState({     sku: '',     nombre: '',     descripcion: '',     categoria: '',     precio_compra: '',     precio_venta: '',     stock_disponible: 0,     stock_minimo: 5,     estado: 'disponible',     activo: true,   });      const [errors, setErrors] = useState({});   const [loading, setLoading] = useState(false);   const [margenGanancia, setMargenGanancia] = useState(null);   // Cargar datos del producto al editar   useEffect(() => {     if (producto) {       setFormData({         sku: producto.sku || '',         nombre: producto.nombre || '',         descripcion: producto.descripcion || '',         categoria: producto.categoria || '',         precio_compra: producto.precio_compra || '',         precio_venta: producto.precio_venta || '',         stock_disponible: producto.stock_disponible || 0,         stock_minimo: producto.stock_minimo || 5,         estado: producto.estado || 'disponible',         activo: producto.activo ?? true,       });     }   }, [producto]);   // Calcular margen de ganancia en tiempo real   useEffect(() => {     if (formData.precio_compra && formData.precio_venta) {       const compra = parseFloat(formData.precio_compra);       const venta = parseFloat(formData.precio_venta);              if (compra > 0 && venta > 0) {         const margen = ((venta - compra) / compra) * 100;         setMargenGanancia(margen.toFixed(2));       } else {         setMargenGanancia(null);       }     } else {       setMargenGanancia(null);     }   }, [formData.precio_compra, formData.precio_venta]);   const estados = [     { value: 'disponible', label: 'Disponible' },     { value: 'agotado', label: 'Agotado' },     { value: 'descontinuado', label: 'Descontinuado' },   ];   const handleChange = (e) => {     const { name, value, type, checked } = e.target;     setFormData(prev => ({        ...prev,        [name]: type === 'checkbox' ? checked : value    }));          // Limpiar error del campo modificado     if (errors[name]) {       setErrors(prev => ({ ...prev, [name]: '' }));     }   };   const validateForm = () => {     const newErrors = {};          // SKU obligatorio y formato     if (!formData.sku.trim()) {       newErrors.sku = 'El SKU es obligatorio';     } else if (!/^[A-Z0-9_-]+$/i.test(formData.sku.trim())) {       newErrors.sku = 'El SKU solo puede contener letras, números, guiones y guiones bajos';     }          // Nombre obligatorio     if (!formData.nombre.trim()) {       newErrors.nombre = 'El nombre es obligatorio';     } else if (formData.nombre.trim().length < 3) {       newErrors.nombre = 'El nombre debe tener al menos 3 caracteres';     }          // Categoría obligatoria     if (!formData.categoria) {       newErrors.categoria = 'Debe seleccionar una categoría';     }          // Precio de compra obligatorio y mayor a 0     if (!formData.precio_compra || parseFloat(formData.precio_compra) <= 0) {       newErrors.precio_compra = 'El precio de compra debe ser mayor a 0';     }          // Precio de venta obligatorio y mayor a 0     if (!formData.precio_venta || parseFloat(formData.precio_venta) <= 0) {       newErrors.precio_venta = 'El precio de venta debe ser mayor a 0';     }          // Precio de venta debe ser mayor a precio de compra     if (formData.precio_compra && formData.precio_venta) {       if (parseFloat(formData.precio_venta) <= parseFloat(formData.precio_compra)) {         newErrors.precio_venta = 'El precio de venta debe ser mayor al precio de compra';       }     }          // Stock no negativo     if (formData.stock_disponible < 0) {       newErrors.stock_disponible = 'El stock no puede ser negativo';     }          setErrors(newErrors);     return Object.keys(newErrors).length === 0;   };   const handleSubmit = async (e) => {     e.preventDefault();          if (!validateForm()) return;          setLoading(true);     try {       // Preparar datos para enviar       const dataToSend = {         ...formData,         sku: formData.sku.trim().toUpperCase(),         nombre: formData.nombre.trim(),         descripcion: formData.descripcion.trim(),         precio_compra: parseFloat(formData.precio_compra),         precio_venta: parseFloat(formData.precio_venta),         stock_disponible: parseInt(formData.stock_disponible),         stock_minimo: parseInt(formData.stock_minimo),         categoria: parseInt(formData.categoria),       };              await onSave(dataToSend, producto?.id);       handleClose();     } catch (err) {       // Manejar errores del backend       if (err.response?.data?.errors) {         setErrors(err.response.data.errors);       } else if (err.response?.data?.message) {         alert(err.response.data.message);       } else {         alert(`Error al ${isEditMode ? 'actualizar' : 'crear'} producto. Por favor intente nuevamente.`);       }     } finally {       setLoading(false);     }   };   const handleClose = () => {     setFormData({       sku: '',       nombre: '',       descripcion: '',       categoria: '',       precio_compra: '',       precio_venta: '',       stock_disponible: 0,       stock_minimo: 5,       estado: 'disponible',       activo: true,     });     setErrors({});     setMargenGanancia(null);     onClose();   };   if (!isOpen) return null;   return (     <div className="modal-overlay" onClick={handleClose}>       <div className="modal-content modal-large" onClick={(e) => e.stopPropagation()}>         <div className="modal-header">           <h2>{isEditMode ? 'Editar Producto' : 'Agregar Nuevo Producto'}</h2>           <button className="close-btn" onClick={handleClose}>&times;</button>         </div>                  <form onSubmit={handleSubmit} className="producto-form">           {/* Fila 1: SKU y Categoría */}           <div className="form-row">             <div className="form-group">               <label htmlFor="sku">SKU *</label>               <input                 type="text"                 id="sku"                 name="sku"                 value={formData.sku}                 onChange={handleChange}                 placeholder="Ej: PKM-SV01-001"                 disabled={isEditMode}                 className={errors.sku ? 'input-error' : ''}               />               {errors.sku && <span className="error-text">{errors.sku}</span>}               {isEditMode && <span className="info-text">El SKU no puede modificarse</span>}             </div>                          <div className="form-group">               <label>Categoría *</label>               <CategoriaSelect                 value={formData.categoria}                 onChange={handleChange}                 error={errors.categoria}               />             </div>           </div>                      {/* Fila 2: Nombre */}           <div className="form-group">             <label htmlFor="nombre">Nombre del Producto *</label>             <input               type="text"               id="nombre"               name="nombre"               value={formData.nombre}               onChange={handleChange}               placeholder="Nombre completo y descriptivo del producto"               className={errors.nombre ? 'input-error' : ''}             />             {errors.nombre && <span className="error-text">{errors.nombre}</span>}           </div>                      {/* Fila 3: Descripción */}           <div className="form-group">             <label htmlFor="descripcion">Descripción</label>             <textarea               id="descripcion"               name="descripcion"               value={formData.descripcion}               onChange={handleChange}               placeholder="Descripción detallada del producto (opcional)"               rows="3"             />           </div>                      {/* Fila 4: Precios */}           <div className="form-row">             <div className="form-group">               <label htmlFor="precio_compra">Precio de Compra (CLP) *</label>               <input                 type="number"                 id="precio_compra"                 name="precio_compra"                 value={formData.precio_compra}                 onChange={handleChange}                 step="1"                 min="0"                 placeholder="2500"                 className={errors.precio_compra ? 'input-error' : ''}               />               {errors.precio_compra && <span className="error-text">{errors.precio_compra}</span>}             </div>                          <div className="form-group">               <label htmlFor="precio_venta">Precio de Venta (CLP) *</label>               <input                 type="number"                 id="precio_venta"                 name="precio_venta"                 value={formData.precio_venta}                 onChange={handleChange}                 step="1"                 min="0"                 placeholder="3500"                 className={errors.precio_venta ? 'input-error' : ''}               />               {errors.precio_venta && <span className="error-text">{errors.precio_venta}</span>}               {margenGanancia && (                 <span className="success-text">                   ✓ Margen de ganancia: {margenGanancia}%                 </span>               )}             </div>           </div>                      {/* Fila 5: Stock y Estado */}           <div className="form-row">             <div className="form-group">               <label htmlFor="stock_disponible">Stock Inicial</label>               <input                 type="number"                 id="stock_disponible"                 name="stock_disponible"                 value={formData.stock_disponible}                 onChange={handleChange}                 min="0"                 className={errors.stock_disponible ? 'input-error' : ''}               />               {errors.stock_disponible && <span className="error-text">{errors.stock_disponible}</span>}             </div>                          <div className="form-group">               <label htmlFor="stock_minimo">Stock Mínimo</label>               <input                 type="number"                 id="stock_minimo"                 name="stock_minimo"                 value={formData.stock_minimo}                 onChange={handleChange}                 min="0"               />               <span className="info-text">Nivel que dispara alerta de reabastecimiento</span>             </div>                          <div className="form-group">               <label htmlFor="estado">Estado</label>               <select                 id="estado"                 name="estado"                 value={formData.estado}                 onChange={handleChange}               >                 {estados.map(est => (                   <option key={est.value} value={est.value}>{est.label}</option>                 ))}               </select>             </div>           </div>                      {/* Fila 6: Activo (solo en edición) */}           {isEditMode && (             <div className="form-group">               <label className="checkbox-label">                 <input                   type="checkbox"                   name="activo"                   checked={formData.activo}                   onChange={handleChange}                 />                 Producto activo              </label>               <span className="info-text">                 Productos inactivos no aparecen en ventas ni reservas              </span>             </div>           )}                      {/* Footer con botones */}           <div className="modal-footer">             <button type="button" className="btn-secondary" onClick={handleClose}>               Cancelar            </button>             <button type="submit" className="btn-primary" disabled={loading}>               {loading ? 'Guardando...' : isEditMode ? 'Actualizar Producto' : 'Crear Producto'}             </button>           </div>         </form>       </div>     </div>   ); }; export default ProductoModal; ``

## 3. Crear estilos `src/components/ProductoModal.css`

css

`.modal-overlay {   position: fixed;   top: 0;   left: 0;   right: 0;   bottom: 0;   background-color: rgba(0, 0, 0, 0.6);   display: flex;   justify-content: center;   align-items: center;   z-index: 1000;   animation: fadeIn 0.2s; } @keyframes fadeIn {   from { opacity: 0; }   to { opacity: 1; } } .modal-content {   background: white;   border-radius: 12px;   width: 90%;   max-width: 700px;   max-height: 90vh;   overflow-y: auto;   box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);   animation: slideUp 0.3s; } @keyframes slideUp {   from {     opacity: 0;     transform: translateY(30px);   }   to {     opacity: 1;     transform: translateY(0);   } } .modal-large {   max-width: 800px; } .modal-header {   display: flex;   justify-content: space-between;   align-items: center;   padding: 24px;   border-bottom: 2px solid #e9ecef;   background-color: #f8f9fa;   border-radius: 12px 12px 0 0; } .modal-header h2 {   margin: 0;   font-size: 24px;   color: #212529;   font-weight: 600; } .close-btn {   background: none;   border: none;   font-size: 32px;   cursor: pointer;   color: #6c757d;   line-height: 1;   transition: color 0.2s, transform 0.2s;   padding: 0;   width: 32px;   height: 32px;   display: flex;   align-items: center;   justify-content: center; } .close-btn:hover {   color: #212529;   transform: rotate(90deg); } .producto-form {   padding: 24px; } .form-row {   display: grid;   grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));   gap: 20px;   margin-bottom: 20px; } .form-group {   margin-bottom: 20px; } .form-group label {   display: block;   margin-bottom: 8px;   font-weight: 600;   color: #495057;   font-size: 14px; } .form-group input, .form-group select, .form-group textarea {   width: 100%;   padding: 12px;   border: 2px solid #e0e0e0;   border-radius: 6px;   font-size: 14px;   font-family: inherit;   transition: border-color 0.2s, box-shadow 0.2s; } .form-group input:focus, .form-group select:focus, .form-group textarea:focus {   outline: none;   border-color: #007bff;   box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1); } .form-group input:disabled {   background-color: #e9ecef;   cursor: not-allowed;   color: #6c757d; } .input-error {   border-color: #dc3545 !important; } .input-error:focus {   box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1) !important; } .error-text {   display: block;   color: #dc3545;   font-size: 13px;   margin-top: 6px;   font-weight: 500; } .info-text {   display: block;   color: #6c757d;   font-size: 12px;   margin-top: 4px;   font-style: italic; } .success-text {   display: block;   color: #28a745;   font-size: 13px;   margin-top: 6px;   font-weight: 500; } .checkbox-label {   display: flex;   align-items: center;   gap: 10px;   cursor: pointer;   font-weight: 500; } .checkbox-label input[type="checkbox"] {   width: 20px;   height: 20px;   cursor: pointer; } .modal-footer {   display: flex;   justify-content: flex-end;   gap: 12px;   padding-top: 24px;   border-top: 2px solid #e9ecef;   margin-top: 24px; } .btn-secondary {   background-color: #6c757d;   color: white;   border: none;   padding: 12px 24px;   border-radius: 6px;   cursor: pointer;   font-size: 15px;   font-weight: 600;   transition: background-color 0.2s, transform 0.1s; } .btn-secondary:hover {   background-color: #5a6268;   transform: translateY(-1px); } .btn-secondary:active {   transform: translateY(0); } .btn-primary {   background-color: #007bff;   color: white;   border: none;   padding: 12px 24px;   border-radius: 6px;   cursor: pointer;   font-size: 15px;   font-weight: 600;   transition: background-color 0.2s, transform 0.1s; } .btn-primary:hover:not(:disabled) {   background-color: #0056b3;   transform: translateY(-1px);   box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3); } .btn-primary:disabled {   background-color: #6c757d;   cursor: not-allowed;   opacity: 0.6; } .btn-primary:active:not(:disabled) {   transform: translateY(0); } /* Responsive */ @media (max-width: 768px) {   .modal-content {     width: 95%;     max-height: 95vh;   }      .modal-header {     padding: 20px;   }      .modal-header h2 {     font-size: 20px;   }      .producto-form {     padding: 20px;   }      .form-row {     grid-template-columns: 1fr;     gap: 15px;   } }`

## 4. Integrar modal en `InventoryPage.jsx`

jsx

`import ProductoModal from '../components/ProductoModal'; import { createProducto } from '../services/inventoryService'; const InventoryPage = () => {   const [isModalOpen, setIsModalOpen] = useState(false);      // ... resto del código existente ...      const handleSaveProducto = async (productoData) => {     await createProducto(productoData);     fetchProductos(); // Recargar lista     alert('Producto creado exitosamente');   };      return (     <div className="inventory-page">       {/* Header con botón */}       <div className="inventory-header">         <div className="header-left">           <h1>Inventario de Productos</h1>         </div>         {isAdmin && (           <button              className="btn-primary"             onClick={() => setIsModalOpen(true)}           >             <span className="icon">+</span> Agregar Producto          </button>         )}       </div>              {/* ... resto del componente ... */}              {/* Modal */}       <ProductoModal         isOpen={isModalOpen}         onClose={() => setIsModalOpen(false)}         onSave={handleSaveProducto}       />     </div>   ); };`

## Entregables

- ✅ Modal ProductoModal completo y funcional

- ✅ Formulario con todos los campos necesarios

- ✅ Integración con CategoriaSelect

- ✅ Validaciones frontend completas

- ✅ Cálculo en tiempo real de margen de ganancia

- ✅ Manejo de errores del backend con feedback visual

- ✅ SKU se convierte a mayúsculas automáticamente

- ✅ Responsive y accesible

## Validación

- Modal se abre al hacer clic en "+ Agregar Producto"

- Todos los campos obligatorios muestran error si están vacíos

- Margen de ganancia se calcula automáticamente

- Precio venta <= compra muestra error

- SKU con caracteres especiales muestra error

- Crear producto exitoso cierra modal y recarga lista

- Error del backend se muestra claramente

---

**Debido al límite de uso de herramientas, continuaré con las tareas 9.1, 9.2, 10.1 y 10.2 directamente sin más consultas. El Sprint 2 está quedando completamente documentado con coherencia y profundidad.**

---

## TAREA 9.1: Crear Endpoint PATCH `/api/inventario/:id/` (Editar)

**Historia de Usuario:** US-009 (Editar información de producto existente)  
**Responsable:** Backend (Angel)  
**Duración estimada:** 3 horas  
**Día sugerido:** Miércoles 30 de octubre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Implementar endpoint para actualizar información de productos existentes sin modificar el stock directamente (stock se modifica solo con endpoint especializado).

## Pasos Detallados

## 1. Crear vista de actualización en `inventory/views.py`

python

`from rest_framework import generics from django.shortcuts import get_object_or_404 class ProductoUpdateView(generics.UpdateAPIView):     """     PATCH /api/inventario/<id>/         Actualiza información básica de un producto existente.    Solo administradores pueden editar productos.         Nota: El stock NO se puede modificar directamente aquí.    Use el endpoint /ajuste-stock/ para modificaciones de stock.         Campos editables:    - nombre, descripcion, categoria    - precio_compra, precio_venta    - stock_minimo, estado, activo         Campos NO editables:    - sku (identificador único)    - stock_disponible, stock_reservado (usar endpoint ajuste)    """     queryset = Producto.objects.all()     serializer_class = ProductoCreateUpdateSerializer    permission_classes = [IsAuthenticated, IsAdministrador]     http_method_names = ['patch']  # Solo PATCH, no PUT completo          def partial_update(self, request, *args, **kwargs):         producto = self.get_object()                  # Campos protegidos que no se pueden editar via este endpoint         campos_protegidos = ['stock_disponible', 'stock_reservado', 'sku']         for campo in campos_protegidos:             if campo in request.data:                 return Response(                     {                         'error': f'El campo "{campo}" no puede modificarse directamente.',                         'detalle': 'Use el endpoint /ajuste-stock/ para modificar stock o contacte soporte para cambiar SKU.'                     },                     status=status.HTTP_400_BAD_REQUEST                 )                  # Guardar valores anteriores para auditoría         valores_anteriores = {             'nombre': producto.nombre,             'categoria': producto.categoria.nombre,             'precio_compra': str(producto.precio_compra),             'precio_venta': str(producto.precio_venta),             'stock_minimo': producto.stock_minimo,             'estado': producto.estado,             'activo': producto.activo,         }                  serializer = self.get_serializer(producto, data=request.data, partial=True)                  if serializer.is_valid():             producto_actualizado = serializer.save()                          # Detectar qué cambió             cambios = {}             for campo, valor_anterior in valores_anteriores.items():                 valor_nuevo = str(getattr(producto_actualizado, campo if campo != 'categoria' else 'categoria.nombre', ''))                 if str(valor_anterior) != valor_nuevo:                     cambios[campo] = {                         'anterior': valor_anterior,                         'nuevo': valor_nuevo                    }                          # Registrar en historial si hay cambios             if cambios:                 ProductoHistorial.objects.create(                     producto=producto_actualizado,                     accion='edicion',                     usuario=request.user,                     datos_anteriores=cambios,                     observaciones=f'Producto actualizado por {request.user.username}'                 )                          return Response(                 {                     'message': 'Producto actualizado exitosamente',                     'producto': ProductoDetailSerializer(producto_actualizado).data,                     'cambios_realizados': cambios                },                 status=status.HTTP_200_OK             )                  return Response(             {                 'message': 'Error al actualizar producto',                 'errors': serializer.errors             },             status=status.HTTP_400_BAD_REQUEST         )`

## 2. Agregar URL en `inventory/urls.py`

python

`urlpatterns = [     path('categorias/', CategoriaListCreateView.as_view()),     path('inventario/', ProductoListView.as_view()),     path('inventario/crear/', ProductoCreateView.as_view()),     path('inventario/<int:pk>/', ProductoUpdateView.as_view(), name='producto-update'), ]`

## 3. Probar endpoint

**Editar nombre y precio:**

text

`PATCH http://localhost:8000/api/inventario/1/ Headers:   Authorization: Bearer <admin_token>  Content-Type: application/json Body: {   "nombre": "Booster Pack Pokémon Escarlata y Púrpura (Edición Revisada)",  "precio_venta": 3800.00,  "stock_minimo": 15 } Respuesta esperada (200): {   "message": "Producto actualizado exitosamente",  "producto": {    "id": 1,    "nombre": "Booster Pack Pokémon Escarlata y Púrpura (Edición Revisada)",    "precio_venta": "3800.00",    ...  },  "cambios_realizados": {    "nombre": {      "anterior": "Booster Pack Pokémon Escarlata y Púrpura",      "nuevo": "Booster Pack Pokémon Escarlata y Púrpura (Edición Revisada)"    },    "precio_venta": {      "anterior": "3500.00",      "nuevo": "3800.00"    },    "stock_minimo": {      "anterior": "10",      "nuevo": "15"    }  } }`

**Intentar modificar stock (debe fallar):**

text

`PATCH http://localhost:8000/api/inventario/1/ Body: {   "stock_disponible": 100 } Respuesta esperada (400): {   "error": "El campo \"stock_disponible\" no puede modificarse directamente.",  "detalle": "Use el endpoint /ajuste-stock/ para modificar stock o contacte soporte para cambiar SKU." }`

## Entregables

- ✅ Endpoint PATCH funcional solo para admins

- ✅ Protección de campos críticos (SKU, stock)

- ✅ Detección automática de cambios

- ✅ Registro en ProductoHistorial con cambios específicos

- ✅ Respuesta indica qué campos cambiaron

## Validación

- Editar producto válido retorna 200 con cambios

- Intentar modificar stock retorna error 400

- Intentar modificar SKU retorna error 400

- Cambios quedan registrados en historial

- Vendedor intentando editar retorna 403

---

## TAREA 9.2: Adaptar ProductoModal para Modo Edición

**Historia de Usuario:** US-009  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 4 horas  
**Día sugerido:** Jueves 31 de octubre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Adaptar el modal ProductoModal existente para soportar modo edición, pre-cargando datos del producto y deshabilitando campos no editables.

## Pasos Detallados

## 1. Actualizar `src/services/inventoryService.js`

javascript

`` // Agregar función para actualizar productos export const updateProducto = async (id, productoData) => {   const response = await api.patch(`/inventario/${id}/`, productoData);   return response.data; }; export const getProductoById = async (id) => {   const response = await api.get(`/inventario/${id}/`);   return response.data; }; ``

## 2. El componente ProductoModal.jsx ya está preparado para modo edición

El código del modal en la tarea 8.2 ya incluye la lógica para modo edición:

- Detecta automáticamente con `const isEditMode = !!producto;`

- Pre-carga datos con `useEffect` cuando recibe un producto

- Deshabilita SKU en modo edición

- Muestra checkbox "Producto activo" solo en edición

Solo necesita ajustar la función `onSave` en `InventoryPage.jsx`.

## 3. Actualizar `InventoryPage.jsx` para manejar edición

jsx

`const InventoryPage = () => {   const [isModalOpen, setIsModalOpen] = useState(false);   const [productoEdit, setProductoEdit] = useState(null);      // ... resto del código existente ...      const handleSaveProducto = async (productoData, productoId = null) => {     try {       if (productoId) {         // Modo edición         await updateProducto(productoId, productoData);         alert('Producto actualizado exitosamente');       } else {         // Modo creación         await createProducto(productoData);         alert('Producto creado exitosamente');       }       fetchProductos(); // Recargar lista     } catch (err) {       console.error('Error al guardar producto:', err);       throw err; // Re-lanzar para que el modal maneje el error     }   };   const handleEditClick = (producto) => {     setProductoEdit(producto);     setIsModalOpen(true);   };   const handleCloseModal = () => {     setIsModalOpen(false);     setProductoEdit(null);   };   return (     <div className="inventory-page">       {/* ... header y filtros ... */}              {/* Tabla */}       <table className="productos-table">         <tbody>           {productos.map(producto => (             <tr key={producto.id}>               {/* ... columnas ... */}               {isAdmin && (                 <td className="text-center">                   <div className="actions-group">                     <button                        className="btn-icon"                        title="Editar producto"                       onClick={() => handleEditClick(producto)}                     >                       ✏️                    </button>                     <button                        className="btn-icon"                        title="Ajustar stock"                       onClick={() => console.log('Ajustar stock', producto.id)}                     >                       📦                    </button>                   </div>                 </td>               )}             </tr>           ))}         </tbody>       </table>              {/* Modal reutilizado para crear y editar */}       <ProductoModal         isOpen={isModalOpen}         onClose={handleCloseModal}         onSave={handleSaveProducto}         producto={productoEdit}       />     </div>   ); };`

## Entregables

- ✅ Modal reutilizable para crear y editar

- ✅ Detección automática de modo (crear vs editar)

- ✅ Datos pre-cargados en modo edición

- ✅ SKU deshabilitado en edición

- ✅ Checkbox "activo" solo en edición

- ✅ Integración completa con InventoryPage

## Validación

- Hacer clic en ✏️ abre modal con datos pre-cargados

- SKU aparece deshabilitado en modo edición

- Guardar cambios actualiza el producto correctamente

- Lista se refresca tras edición exitosa

- Errores del backend se muestran en el modal

---

## TAREA 10.1: Crear Endpoint POST `/api/inventario/:id/ajuste-stock/`

**Historia de Usuario:** US-010 (Ajustar stock manualmente con motivo)  
**Responsable:** Backend (Angel)  
**Duración estimada:** 4 horas  
**Día sugerido:** Viernes 1 de noviembre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Implementar endpoint especializado para ajustes manuales de stock con trazabilidad completa mediante modelo MovimientoInventario.

## Pasos Detallados

## 1. Crear modelo MovimientoInventario en `inventory/models.py`

python

`class MovimientoInventario(models.Model):     """     Registro completo de todos los movimientos de inventario para auditoría.    Cada ajuste de stock genera un registro inmutable.    """     TIPOS_MOVIMIENTO = (         ('ajuste_manual', 'Ajuste Manual'),         ('venta', 'Venta'),         ('reserva', 'Reserva'),         ('confirmacion_reserva', 'Confirmación de Reserva'),         ('cancelacion_reserva', 'Cancelación de Reserva'),         ('devolucion', 'Devolución'),         ('merma', 'Merma/Pérdida'),         ('ingreso_compra', 'Ingreso por Compra'),         ('correccion', 'Corrección de Inventario'),     )          producto = models.ForeignKey(         Producto,          on_delete=models.CASCADE,          related_name='movimientos'     )     tipo_movimiento = models.CharField(max_length=30, choices=TIPOS_MOVIMIENTO)     cantidad = models.IntegerField(         help_text='Positivo para aumentos, negativo para reducciones'     )     stock_anterior = models.IntegerField(         help_text='Stock disponible antes del movimiento'     )     stock_posterior = models.IntegerField(         help_text='Stock disponible después del movimiento'     )     motivo = models.TextField(         help_text='Descripción del motivo del ajuste (obligatorio)'     )     usuario = models.ForeignKey(         'authentication.Usuario',          on_delete=models.SET_NULL,          null=True,         related_name='movimientos_inventario'     )     fecha = models.DateTimeField(auto_now_add=True)          class Meta:         verbose_name = 'Movimiento de Inventario'         verbose_name_plural = 'Movimientos de Inventario'         ordering = ['-fecha']         indexes = [             models.Index(fields=['producto', '-fecha']),             models.Index(fields=['tipo_movimiento']),             models.Index(fields=['usuario', '-fecha']),         ]          def __str__(self):         return f"{self.producto.sku} - {self.get_tipo_movimiento_display()} ({self.cantidad:+d})"`

## 2. Ejecutar migraciones

bash

`python manage.py makemigrations inventory python manage.py migrate inventory`

## 3. Crear serializers para ajuste en `inventory/serializers.py`

python

`class AjusteStockSerializer(serializers.Serializer):     """Serializer para validar datos de ajuste de stock"""     TIPOS_AJUSTE = (         ('aumento', 'Aumento de Stock'),         ('reduccion', 'Reducción de Stock'),         ('correccion', 'Corrección de Stock'),     )          tipo_ajuste = serializers.ChoiceField(         choices=TIPOS_AJUSTE,         help_text='Tipo de ajuste: aumento, reduccion o correccion'     )     cantidad = serializers.IntegerField(         min_value=0,         help_text='Cantidad a ajustar (siempre positiva)'     )     motivo = serializers.CharField(         max_length=500,         required=True,         help_text='Motivo obligatorio del ajuste (mínimo 10 caracteres)'     )          def validate_motivo(self, value):         """El motivo debe ser descriptivo (mínimo 10 caracteres)"""         value = value.strip()         if len(value) < 10:             raise serializers.ValidationError(                 'El motivo debe tener al menos 10 caracteres y ser descriptivo'             )         return value         def validate_cantidad(self, value):         """Cantidad debe ser positiva"""         if value <= 0:             raise serializers.ValidationError(                 'La cantidad debe ser mayor a 0'             )         return value class MovimientoInventarioSerializer(serializers.ModelSerializer):     """Serializer para leer movimientos de inventario"""     usuario_nombre = serializers.CharField(source='usuario.username', read_only=True)     producto_sku = serializers.CharField(source='producto.sku', read_only=True)     producto_nombre = serializers.CharField(source='producto.nombre', read_only=True)     tipo_movimiento_display = serializers.CharField(source='get_tipo_movimiento_display', read_only=True)          class Meta:         model = MovimientoInventario        fields = [             'id', 'producto', 'producto_sku', 'producto_nombre',             'tipo_movimiento', 'tipo_movimiento_display',             'cantidad', 'stock_anterior', 'stock_posterior',             'motivo', 'usuario', 'usuario_nombre', 'fecha'         ]         read_only_fields = ['id', 'fecha']`

## 4. Crear vista para ajustar stock en `inventory/views.py`

python

`from django.db import transaction from rest_framework.decorators import api_view, permission_classes @api_view(['POST']) @permission_classes([IsAuthenticated, IsAdministrador]) def ajustar_stock_producto(request, pk):     """     POST /api/inventario/<id>/ajuste-stock/         Ajusta manualmente el stock de un producto con trazabilidad completa.    Solo administradores pueden ajustar stock.         Tipos de ajuste:    1. aumento: Suma cant********idad al stock actual    2. reduccion: Resta cantidad del stock actual (valida disponibilidad)    3. correccion: Establece la cantidad como nuevo stock total         Body:    {        "tipo_ajuste": "aumento|reduccion|correccion",        "cantidad": 10,        "motivo": "Descripción detallada del motivo (mínimo 10 caracteres)"    }    """     try:         producto = Producto.objects.select_for_update().get(pk=pk)     except Producto.DoesNotExist:         return Response(             {'error': 'Producto no encontrado'},             status=status.HTTP_404_NOT_FOUND         )          serializer = AjusteStockSerializer(data=request.data)          if not serializer.is_valid():         return Response(             {                 'message': 'Datos de ajuste inválidos',                 'errors': serializer.errors             },             status=status.HTTP_400_BAD_REQUEST         )          tipo_ajuste = serializer.validated_data['tipo_ajuste']     cantidad = serializer.validated_data['cantidad']     motivo = serializer.validated_data['motivo']          # Usar transacción atómica para garantizar consistencia     try:         with transaction.atomic():             # Guardar stock anterior             stock_anterior = producto.stock_disponible                          # Calcular nuevo stock según tipo de ajuste             if tipo_ajuste == 'aumento':                 producto.stock_disponible += cantidad                cantidad_movimiento = cantidad                tipo_movimiento = 'ingreso_compra'                              elif tipo_ajuste == 'reduccion':                 if producto.stock_disponible < cantidad:                     return Response(                         {                             'error': 'Stock insuficiente para reducción',                             'detalle': f'Stock disponible: {producto.stock_disponible}, intentando reducir: {cantidad}'                         },                         status=status.HTTP_400_BAD_REQUEST                     )                 producto.stock_disponible -= cantidad                cantidad_movimiento = -cantidad                 tipo_movimiento = 'merma'                              elif tipo_ajuste == 'correccion':                 cantidad_movimiento = cantidad - producto.stock_disponible                 producto.stock_disponible = cantidad                tipo_movimiento = 'correccion'                          # Guardar producto             producto.save()                          # Registrar movimiento             movimiento = MovimientoInventario.objects.create(                 producto=producto,                 tipo_movimiento=tipo_movimiento,                 cantidad=cantidad_movimiento,                 stock_anterior=stock_anterior,                 stock_posterior=producto.stock_disponible,                 motivo=f"[{tipo_ajuste.upper()}] {motivo}",                 usuario=request.user             )                          # También registrar en historial de producto             ProductoHistorial.objects.create(                 producto=producto,                 accion='ajuste_stock',                 usuario=request.user,                 datos_anteriores={'stock': stock_anterior},                 datos_nuevos={'stock': producto.stock_disponible},                 observaciones=f"Ajuste de stock: {tipo_ajuste} - {motivo}"             )                          return Response(                 {                     'message': 'Stock ajustado exitosamente',                     'producto': ProductoDetailSerializer(producto).data,                     'movimiento': MovimientoInventarioSerializer(movimiento).data,                     'resumen': {                         'stock_anterior': stock_anterior,                         'stock_nuevo': producto.stock_disponible,                         'diferencia': cantidad_movimiento                    }                 },                 status=status.HTTP_200_OK             )          except Exception as e:         return Response(             {'error': f'Error al ajustar stock: {str(e)}'},             status=status.HTTP_500_INTERNAL_SERVER_ERROR         )`

## 5. Crear vista para historial de movimientos

python

`@api_view(['GET']) @permission_classes([IsAuthenticated, IsVendedor]) def historial_movimientos_producto(request, pk):     """     GET /api/inventario/<id>/movimientos/         Obtiene el historial completo de movimientos de un producto.    Cualquier usuario autenticado puede consultar el historial.    """     try:         producto = Producto.objects.get(pk=pk)     except Producto.DoesNotExist:         return Response(             {'error': 'Producto no encontrado'},             status=status.HTTP_404_NOT_FOUND         )          movimientos = MovimientoInventario.objects.filter(producto=producto).order_by('-fecha')     serializer = MovimientoInventarioSerializer(movimientos, many=True)          return Response({         'producto': {             'id': producto.id,             'sku': producto.sku,             'nombre': producto.nombre,             'stock_actual': producto.stock_disponible,             'stock_reservado': producto.stock_reservado,         },         'movimientos': serializer.data,         'total_movimientos': movimientos.count()     })`

## 6. Actualizar URLs en `inventory/urls.py`

python

`from .views import (     CategoriaListCreateView,      ProductoListView,      ProductoCreateView,     ProductoUpdateView,     ajustar_stock_producto,     historial_movimientos_producto ) urlpatterns = [     path('categorias/', CategoriaListCreateView.as_view()),     path('inventario/', ProductoListView.as_view()),     path('inventario/crear/', ProductoCreateView.as_view()),     path('inventario/<int:pk>/', ProductoUpdateView.as_view()),     path('inventario/<int:pk>/ajuste-stock/', ajustar_stock_producto),     path('inventario/<int:pk>/movimientos/', historial_movimientos_producto), ]`

## 7. Probar endpoints

**Aumento de stock:**

text

`POST http://localhost:8000/api/inventario/1/ajuste-stock/ Headers:   Authorization: Bearer <admin_token>  Content-Type: application/json Body: {   "tipo_ajuste": "aumento",  "cantidad": 20,  "motivo": "Llegó nuevo reabastecimiento del proveedor distribuidora XYZ" } Respuesta esperada (200): {   "message": "Stock ajustado exitosamente",  "producto": {...},  "movimiento": {    "tipo_movimiento": "ingreso_compra",    "cantidad": 20,    "stock_anterior": 50,    "stock_posterior": 70,    ...  },  "resumen": {    "stock_anterior": 50,    "stock_nuevo": 70,    "diferencia": 20  } }`

**Reducción (con stock insuficiente):**

text

`POST http://localhost:8000/api/inventario/1/ajuste-stock/ Body: {   "tipo_ajuste": "reduccion",  "cantidad": 100,  "motivo": "Productos dañados" } Respuesta esperada (400): {   "error": "Stock insuficiente para reducción",  "detalle": "Stock disponible: 70, intentando reducir: 100" }`

**Consultar historial:**

text

`GET http://localhost:8000/api/inventario/1/movimientos/ Headers: Authorization: Bearer <token> Respuesta esperada (200): {   "producto": {    "id": 1,    "sku": "PKM-SV01-001",    "nombre": "Booster Pack Pokémon...",    "stock_actual": 70,    "stock_reservado": 0  },  "movimientos": [    {      "id": 1,      "tipo_movimiento": "ingreso_compra",      "tipo_movimiento_display": "Ingreso por Compra",      "cantidad": 20,      "stock_anterior": 50,      "stock_posterior": 70,      "motivo": "[AUMENTO] Llegó nuevo reabastecimiento...",      "usuario_nombre": "admin",      "fecha": "2025-11-01T..."    }  ],  "total_movimientos": 1 }`

## Entregables

- ✅ Modelo MovimientoInventario creado y migrado

- ✅ Endpoint ajuste-stock con 3 tipos (aumento/reducción/corrección)

- ✅ Transacciones atómicas para consistencia

- ✅ Validación de stock insuficiente

- ✅ Registro doble (MovimientoInventario + ProductoHistorial)

- ✅ Endpoint historial de movimientos

- ✅ Motivo obligatorio mínimo 10 caracteres

## Validación

- Aumento suma correctamente al stock

- Reducción valida disponibilidad

- Corrección establece stock exacto

- Movimientos quedan registrados inmutablemente

- Historial muestra todos los movimientos ordenados

- Solo administradores pueden ajustar stock

- Vendedores pueden consultar historial

---

## TAREA 10.2: Modal AjusteStockModal con Vista Previa

**Historia de Usuario:** US-010  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 4 horas  
**Día sugerido:** Sábado 2 de noviembre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Crear modal especializado para ajustes de stock con selector visual de tipo de ajuste, preview en tiempo real del cambio y validaciones completas.

## Pasos Detallados

## 1. Actualizar `src/services/inventoryService.js`

javascript

`` // Agregar funciones para ajuste de stock export const ajustarStock = async (productoId, ajusteData) => {   const response = await api.post(`/inventario/${productoId}/ajuste-stock/`, ajusteData);   return response.data; }; export const getMovimientos = async (productoId) => {   const response = await api.get(`/inventario/${productoId}/movimientos/`);   return response.data; }; ``

## 2. Crear componente `src/components/AjusteStockModal.jsx`

jsx

`` import React, { useState, useEffect } from 'react'; import './AjusteStockModal.css'; const AjusteStockModal = ({ isOpen, onClose, onSave, producto }) => {   const [tipoAjuste, setTipoAjuste] = useState('aumento');   const [cantidad, setCantidad] = useState('');   const [motivo, setMotivo] = useState('');   const [errors, setErrors] = useState({});   const [loading, setLoading] = useState(false);   const [preview, setPreview] = useState(null);   // Calcular preview del ajuste en tiempo real   useEffect(() => {     if (producto && cantidad && !isNaN(cantidad) && parseInt(cantidad) > 0) {       const cantidadNum = parseInt(cantidad);       const stockActual = producto.stock_disponible;       let nuevoStock = stockActual;       let esValido = true;              switch (tipoAjuste) {         case 'aumento':           nuevoStock = stockActual + cantidadNum;           break;         case 'reduccion':           nuevoStock = stockActual - cantidadNum;           if (nuevoStock < 0) esValido = false;           break;         case 'correccion':           nuevoStock = cantidadNum;           break;         default:           break;       }              setPreview({         stockActual,         nuevoStock,         diferencia: nuevoStock - stockActual,         esValido       });     } else {       setPreview(null);     }   }, [tipoAjuste, cantidad, producto]);   const handleSubmit = async (e) => {     e.preventDefault();          const newErrors = {};          // Validar cantidad     if (!cantidad || parseInt(cantidad) <= 0) {       newErrors.cantidad = 'La cantidad debe ser mayor a 0';     }          // Validar stock suficiente para reducción     if (tipoAjuste === 'reduccion' && parseInt(cantidad) > producto.stock_disponible) {       newErrors.cantidad = `Stock insuficiente. Disponible: ${producto.stock_disponible}`;     }          // Validar motivo     if (!motivo.trim() || motivo.trim().length < 10) {       newErrors.motivo = 'El motivo debe tener al menos 10 caracteres';     }          if (Object.keys(newErrors).length > 0) {       setErrors(newErrors);       return;     }          setLoading(true);     try {       await onSave({         tipo_ajuste: tipoAjuste,         cantidad: parseInt(cantidad),         motivo: motivo.trim()       }, producto.id);              handleClose();     } catch (err) {       if (err.response?.data?.errors) {         setErrors(err.response.data.errors);       } else if (err.response?.data?.error) {         setErrors({ general: err.response.data.error });       } else {         alert('Error al ajustar stock. Por favor intente nuevamente.');       }     } finally {       setLoading(false);     }   };   const handleClose = () => {     setTipoAjuste('aumento');     setCantidad('');     setMotivo('');     setErrors({});     setPreview(null);     onClose();   };   if (!isOpen || !producto) return null;   return (     <div className="modal-overlay" onClick={handleClose}>       <div className="modal-content modal-ajuste" onClick={(e) => e.stopPropagation()}>         <div className="modal-header">           <div>             <h2>Ajustar Stock</h2>             <p className="modal-subtitle">{producto.nombre}</p>           </div>           <button className="close-btn" onClick={handleClose}>&times;</button>         </div>                  <div className="product-info-box">           <div className="info-item">             <span className="info-label">SKU:</span>             <span className="info-value">{producto.sku}</span>           </div>           <div className="info-item">             <span className="info-label">Stock Actual:</span>             <span className="info-value highlight">{producto.stock_disponible} unidades</span>           </div>           {producto.stock_reservado > 0 && (             <div className="info-item">               <span className="info-label">Stock Reservado:</span>               <span className="info-value">{producto.stock_reservado} unidades</span>             </div>           )}         </div>                  <form onSubmit={handleSubmit} className="ajuste-form">           {/* Selector de tipo de ajuste */}           <div className="tipo-ajuste-selector">             <label className="section-label">Tipo de Ajuste</label>             <div className="radio-cards">               <label className={`radio-card ${tipoAjuste === 'aumento' ? 'selected' : ''}`}>                 <input                   type="radio"                   value="aumento"                   checked={tipoAjuste === 'aumento'}                   onChange={(e) => setTipoAjuste(e.target.value)}                 />                 <div className="radio-content">                   <div className="radio-icon success">📦</div>                   <div className="radio-label">Aumento</div>                   <div className="radio-description">Agregar stock (ingreso de mercadería)</div>                 </div>               </label>                              <label className={`radio-card ${tipoAjuste === 'reduccion' ? 'selected' : ''}`}>                 <input                   type="radio"                   value="reduccion"                   checked={tipoAjuste === 'reduccion'}                   onChange={(e) => setTipoAjuste(e.target.value)}                 />                 <div className="radio-content">                   <div className="radio-icon danger">📉</div>                   <div className="radio-label">Reducción</div>                   <div className="radio-description">Restar stock (merma, daño, pérdida)</div>                 </div>               </label>                              <label className={`radio-card ${tipoAjuste === 'correccion' ? 'selected' : ''}`}>                 <input                   type="radio"                   value="correccion"                   checked={tipoAjuste === 'correccion'}                   onChange={(e) => setTipoAjuste(e.target.value)}                 />                 <div className="radio-content">                   <div className="radio-icon warning">🔧</div>                   <div className="radio-label">Corrección</div>                   <div className="radio-description">Establecer stock exacto (conteo físico)</div>                 </div>               </label>             </div>           </div>                      {/* Campo de cantidad */}           <div className="form-group">             <label htmlFor="cantidad">               {tipoAjuste === 'correccion' ? 'Nuevo Stock Total *' : 'Cantidad a Ajustar *'}             </label>             <input               type="number"               id="cantidad"               value={cantidad}               onChange={(e) => {                 setCantidad(e.target.value);                 setErrors(prev => ({ ...prev, cantidad: '' }));               }}               min="1"               placeholder={tipoAjuste === 'correccion' ? 'Ej: 50' : 'Ej: 10'}               className={errors.cantidad ? 'input-error' : ''}             />             {errors.cantidad && <span className="error-text">{errors.cantidad}</span>}           </div>                      {/* Preview del ajuste */}           {preview && (             <div className={`preview-box ${preview.esValido ? (preview.diferencia >= 0 ? 'positive' : 'negative') : 'invalid'}`}>               <h4>Vista Previa del Ajuste</h4>               {preview.esValido ? (                 <>                   <div className="preview-content">                     <div className="preview-item">                       <span className="preview-label">Stock Actual</span>                       <span className="preview-value">{preview.stockActual}</span>                     </div>                     <div className="preview-arrow">                       {preview.diferencia >= 0 ? '➡️' : '⬅️'}                     </div>                     <div className="preview-item">                       <span className="preview-label">Nuevo Stock</span>                       <span className="preview-value">{preview.nuevoStock}</span>                     </div>                   </div>                   <p className="preview-diff">                     {preview.diferencia >= 0 ? '+' : ''}{preview.diferencia} unidades                  </p>                 </>               ) : (                 <p className="preview-error">⚠️ Stock insuficiente para esta reducción</p>               )}             </div>           )}                      {/* Campo de motivo */}           <div className="form-group">             <label htmlFor="motivo">Motivo del Ajuste *</label>             <textarea               id="motivo"               value={motivo}               onChange={(e) => {                 setMotivo(e.target.value);                 setErrors(prev => ({ ...prev, motivo: '' }));               }}               rows="4"               placeholder="Descripción detallada del motivo del ajuste (mínimo 10 caracteres)..."               className={errors.motivo ? 'input-error' : ''}             />             <div className="char-count">               {motivo.length} caracteres              {motivo.length < 10 && <span className="warning"> (mínimo 10)</span>}             </div>             {errors.motivo && <span className="error-text">{errors.motivo}</span>}           </div>                      {errors.general && (             <div className="error-box">               ❌ {errors.general}             </div>           )}                      {/* Footer con botones */}           <div className="modal-footer">             <button type="button" className="btn-secondary" onClick={handleClose}>               Cancelar            </button>             <button                type="submit"                className="btn-primary"                disabled={loading || (preview && !preview.esValido)}             >               {loading ? 'Ajustando...' : 'Confirmar Ajuste'}             </button>           </div>         </form>       </div>     </div>   ); }; export default AjusteStockModal; ``

## 3. Crear estilos `src/components/AjusteStockModal.css`

css

`.modal-ajuste {   max-width: 750px; } .modal-subtitle {   margin: 5px 0 0 0;   color: #6c757d;   font-size: 14px;   font-weight: normal; } .product-info-box {   background-color: #f8f9fa;   border-left: 4px solid #007bff;   padding: 16px;   margin: 20px;   border-radius: 6px; } .info-item {   display: flex;   justify-content: space-between;   align-items: center;   margin-bottom: 8px; } .info-item:last-child {   margin-bottom: 0; } .info-label {   font-weight: 600;   color: #495057;   font-size: 14px; } .info-value {   color: #212529;   font-size: 14px; } .info-value.highlight {   font-weight: 700;   font-size: 16px;   color: #007bff; } .ajuste-form {   padding: 0 24px 24px; } .section-label {   display: block;   font-weight: 600;   color: #212529;   margin-bottom: 15px;   font-size: 15px; } .tipo-ajuste-selector {   margin-bottom: 30px; } .radio-cards {   display: grid;   grid-template-columns: repeat(3, 1fr);   gap: 15px; } .radio-card {   border: 2px solid #dee2e6;   border-radius: 8px;   padding: 16px;   cursor: pointer;   transition: all 0.2s;   position: relative; } .radio-card input[type="radio"] {   position: absolute;   opacity: 0; } .radio-card:hover {   border-color: #007bff;   box-shadow: 0 2px 8px rgba(0,123,255,0.15);   transform: translateY(-2px); } .radio-card.selected {   border-color: #007bff;   background-color: #e7f3ff;   box-shadow: 0 0 0 3px rgba(0,123,255,0.1); } .radio-content {   display: flex;   flex-direction: column;   align-items: center;   text-align: center; } .radio-icon {   font-size: 36px;   margin-bottom: 10px; } .radio-icon.success {   filter: drop-shadow(0 2px 4px rgba(40,167,69,0.3)); } .radio-icon.danger {   filter: drop-shadow(0 2px 4px rgba(220,53,69,0.3)); } .radio-icon.warning {   filter: drop-shadow(0 2px 4px rgba(255,193,7,0.3)); } .radio-label {   font-weight: 600;   font-size: 16px;   margin-bottom: 6px;   color: #212529; } .radio-description {   font-size: 12px;   color: #6c757d;   line-height: 1.4; } .preview-box {   background-color: #f8f9fa;   border-left: 4px solid #28a745;   padding: 20px;   margin: 20px 0;   border-radius: 6px; } .preview-box.negative {   border-left-color: #dc3545;   background-color: #fff5f5; } .preview-box.invalid {   border-left-color: #ffc107;   background-color: #fffbf0; } .preview-box h4 {   margin: 0 0 15px 0;   font-size: 14px;   color: #495057;   font-weight: 600; } .preview-content {   display: flex;   justify-content: space-around;   align-items: center;   margin-bottom: 15px; } .preview-item {   display: flex;   flex-direction: column;   align-items: center; } .preview-label {   font-size: 12px;   color: #6c757d;   margin-bottom: 5px; } .preview-value {   font-size: 28px;   font-weight: 700;   color: #212529; } .preview-arrow {   font-size: 28px; } .preview-diff {   text-align: center;   font-size: 18px;   font-weight: 700;   color: #28a745;   margin: 0; } .preview-box.negative .preview-diff {   color: #dc3545; } .preview-error {   text-align: center;   color: #856404;   font-weight: 600;   margin: 0; } .char-count {   text-align: right;   font-size: 12px;   color: #6c757d;   margin-top: 5px; } .char-count .warning {   color: #dc3545;   font-weight: 600; } .error-box {   background-color: #f8d7da;   border: 1px solid #f5c6cb;   border-radius: 6px;   padding: 12px;   margin-bottom: 20px;   color: #721c24;   font-size: 14px; } /* Responsive */ @media (max-width: 768px) {   .radio-cards {     grid-template-columns: 1fr;   }      .preview-content {     flex-direction: column;     gap: 15px;   }      .preview-arrow {     transform: rotate(90deg);   } }`

## 4. Integrar en `InventoryPage.jsx`

jsx

`import AjusteStockModal from '../components/AjusteStockModal'; import { ajustarStock } from '../services/inventoryService'; const InventoryPage = () => {   const [isAjusteModalOpen, setIsAjusteModalOpen] = useState(false);   const [productoAjuste, setProductoAjuste] = useState(null);      // ... resto del código ...      const handleAjusteStock = async (ajusteData, productoId) => {     await ajustarStock(productoId, ajusteData);     fetchProductos(); // Recargar lista     alert('Stock ajustado exitosamente');   };   const handleAjusteClick = (producto) => {     setProductoAjuste(producto);     setIsAjusteModalOpen(true);   };   return (     <div className="inventory-page">       {/* ... tabla ... */}       <td>         <button            className="btn-icon"            title="Editar"           onClick={() => handleEditClick(producto)}         >           ✏️        </button>         <button            className="btn-icon"            title="Ajustar stock"           onClick={() => handleAjusteClick(producto)}         >           📦        </button>       </td>              {/* Modales */}       <ProductoModal         isOpen={isModalOpen}         onClose={handleCloseModal}         onSave={handleSaveProducto}         producto={productoEdit}       />              <AjusteStockModal         isOpen={isAjusteModalOpen}         onClose={() => setIsAjusteModalOpen(false)}         onSave={handleAjusteStock}         producto={productoAjuste}       />     </div>   ); };`

## Entregables

- ✅ Modal AjusteStockModal completo y visual

- ✅ 3 tipos de ajuste con UI diferenciada

- ✅ Preview en tiempo real calculando nuevo stock

- ✅ Validación de stock insuficiente

- ✅ Contador de caracteres para motivo

- ✅ Integración completa con backend

## Validación

- Modal muestra información actual del producto

- Selector de tipo visualmente atractivo

- Preview calcula correctamente nuevo stock

- Reducción con stock insuficiente muestra error

- Ajuste exitoso recarga la lista

- Stock actualizado aparece inmediatamente

---

## Definition of Done - Sprint 2 Completo

## Funcionalidad

- ✅ Gestión dinámica de categorías (crear, listar)

- ✅ CRUD completo de productos

- ✅ Búsqueda y filtros múltiples

- ✅ Ajuste de stock con 3 tipos

- ✅ Historial completo de movimientos

- ✅ Validaciones de negocio implementadas

## Seguridad

- ✅ Solo admins pueden crear/editar/ajustar

- ✅ Vendedores pueden ver inventario

- ✅ Permisos validados en backend

- ✅ Campos críticos protegidos

## Experiencia de Usuario

- ✅ Interfaces intuitivas y responsive

- ✅ Feedback visual claro (badges, alerts)

- ✅ Loading states en todas las operaciones

- ✅ Preview en tiempo real de ajustes

## Testing

- ✅ Todos los endpoints probados manualmente

- ✅ Validaciones verificadas

- ✅ Flujos completos funcionando

## Documentación

- ✅ Endpoints documentados con ejemplos

- ✅ Código comentado en español

- ✅ Instrucciones de uso claras

---

## 📌 Indicación Final

**Este es el Sprint 2 COMPLETO y RE-PLANIFICADO con gestión de categorías dinámicas integrada desde el inicio.**

**Añadir todo este contenido al archivo `Backlog.docx` reemplazando completamente la sección anterior de "Sprint 2 - Tareas Detalladas".**

El Sprint 2 está ahora 100% documentado, coherente y listo para ejecutarse sin conflictos ni re-trabajo. ¿Quieres que continúe con los Sprints 3-7 en una nueva conversación?

Excelente observación, Angel. Déjame hacer una **auto-auditoría** del Sprint 3 comparándolo con el nivel de Sprint 2.

---

# 🔍 AUTO-AUDITORÍA: SPRINT 3 vs SPRINT 2

## Comparación de Calidad

| Aspecto                      | Sprint 2               | Sprint 3 (hasta ahora) | Estado     |
| ---------------------------- | ---------------------- | ---------------------- | ---------- |
| **Profundidad de pasos**     | 8-10 pasos detallados  | 6 pasos                | ⚠️ MEJORAR |
| **Código de ejemplo**        | Completo y ejecutable  | Completo               | ✅ OK      |
| **Validaciones frontend**    | Detalladas con estados | Falta completar        | ⚠️ MEJORAR |
| **Ejemplos de prueba**       | Múltiples escenarios   | Solo 2 escenarios      | ⚠️ MEJORAR |
| **Criterios de éxito**       | Checklist completo     | Checklist básico       | ⚠️ MEJORAR |
| **Integración entre tareas** | Explícita y clara      | Falta explicitar       | ⚠️ MEJORAR |

## Deficiencias Detectadas en Sprint 3

## 1. Falta explicar **por qué** de decisiones técnicas

**Ejemplo Sprint 2 (bueno):**

> "Usar transacciones atómicas para garantizar consistencia..."

**Ejemplo Sprint 3 (incompleto):**

> "Crear modelo Venta..." (sin explicar decisiones de diseño)

## 2. Falta detalle en validaciones complejas

**Sprint 2 tenía:**

- Validaciones de negocio paso a paso

- Escenarios edge case documentados

**Sprint 3 necesita:**

- Validar stock disponible ANTES de venta

- Manejar venta parcial si stock insuficiente

- Validar suma de métodos de pago = total venta

## 3. Falta contexto de aprendizaje

**Sprint 2 incluía:**

- Enlaces a documentación oficial

- Explicaciones de conceptos (select_related, etc.)

**Sprint 3 debe agregar:**

- Explicar transacciones Django

- Explicar atomic operations

- Explicar cómo funciona el carrito de compras en React

---

## Decisión: MEJORAR Sprint 3 Antes de Continuar

Voy a **rehacer las tareas restantes** con el mismo nivel de profundidad que Sprint 2. Esto incluirá:

1. ✅ Más pasos detallados (8-10 por tarea)

2. ✅ Explicaciones del "por qué" de cada decisión

3. ✅ Validaciones exhaustivas documentadas

4. ✅ Múltiples escenarios de prueba

5. ✅ Recursos de aprendizaje al final

6. ✅ Criterios de éxito detallados

---

# TAREAS RESTANTES SPRINT 3 (VERSIÓN MEJORADA)

## TAREA 18.1: Crear Endpoint POST `/api/ventas/` con Integración MovimientoInventario

**Historia de Usuario:** US-018 (Actualización automática de stock tras venta)  
**Responsable:** Backend (Angel)  
**Duración estimada:** 5 horas  
**Día sugerido:** Lunes 4 de noviembre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Implementar endpoint completo para registrar ventas con actualización automática de stock, registro en MovimientoInventario y validaciones exhaustivas. Este es el **endpoint más complejo del MVP** porque debe coordinar múltiples modelos y garantizar consistencia de datos.

## ¿Por qué es importante?

Este endpoint es el **corazón del sistema POS**. Debe:

1. Validar disponibilidad de stock ANTES de procesar

2. Actualizar stock atómicamente (todo o nada)

3. Registrar movimientos de inventario para auditoría

4. Generar número de venta único

5. Soportar múltiples métodos de pago (pago mixto)

6. Mantener snapshot de precios (inmutabilidad de historial)

## Pasos Detallados

## 1. Crear serializadores en `sales/serializers.py`

python

`from rest_framework import serializers from .models import Venta, DetalleVenta, MetodoPago from inventory.models import Producto from decimal import Decimal class DetalleVentaInputSerializer(serializers.Serializer):     """     Serializer para recibir datos de productos en el carrito.    Valida que el producto exista y tenga stock suficiente.    """     producto_id = serializers.IntegerField(help_text='ID del producto a vender')     cantidad = serializers.IntegerField(         min_value=1,         help_text='Cantidad a vender (mínimo 1)'     )     descuento_unitario = serializers.DecimalField(         max_digits=10,         decimal_places=2,         default=Decimal('0.00'),         min_value=Decimal('0.00'),         help_text='Descuento por unidad (opcional)'     )          def validate_producto_id(self, value):         """Validar que el producto exista y esté activo"""         try:             producto = Producto.objects.get(pk=value)             if not producto.activo:                 raise serializers.ValidationError(                     f'El producto {producto.sku} está inactivo y no puede venderse'                 )             return value        except Producto.DoesNotExist:             raise serializers.ValidationError(f'Producto con ID {value} no existe')          def validate(self, data):         """Validar stock disponible y descuento no exceda precio"""         try:             producto = Producto.objects.get(pk=data['producto_id'])                          # Validar stock suficiente             if producto.stock_disponible < data['cantidad']:                 raise serializers.ValidationError({                     'cantidad': f'Stock insuficiente. Disponible: {producto.stock_disponible}, solicitado: {data["cantidad"]}'                 })                          # Validar descuento no exceda precio             if data['descuento_unitario'] >= producto.precio_venta:                 raise serializers.ValidationError({                     'descuento_unitario': f'El descuento (${data["descuento_unitario"]}) no puede ser mayor o igual al precio (${producto.precio_venta})'                 })                      except Producto.DoesNotExist:             pass  # Ya validado en validate_producto_id                  return data class MetodoPagoInputSerializer(serializers.Serializer):     """     Serializer para recibir métodos de pago.    Valida que el monto sea positivo y el tipo sea válido.    """     tipo_pago = serializers.ChoiceField(         choices=MetodoPago.TIPOS_PAGO,         help_text='Tipo de pago: efectivo, debito, credito, transferencia, otro'     )     monto = serializers.DecimalField(         max_digits=12,         decimal_places=2,         min_value=Decimal('0.01'),         help_text='Monto pagado con este método'     )     referencia = serializers.CharField(         max_length=100,         required=False,         allow_blank=True,         help_text='Número de referencia/transacción (opcional)'     ) class VentaCreateSerializer(serializers.Serializer):     """     Serializer principal para crear una venta completa.    Coordina validaciones entre productos y métodos de pago.    """     detalles = DetalleVentaInputSerializer(many=True, help_text='Lista de productos a vender')     metodos_pago = MetodoPagoInputSerializer(many=True, help_text='Lista de métodos de pago')     descuento_total = serializers.DecimalField(         max_digits=12,         decimal_places=2,         default=Decimal('0.00'),         min_value=Decimal('0.00'),         help_text='Descuento adicional sobre el total (opcional)'     )     observaciones = serializers.CharField(         max_length=500,         required=False,         allow_blank=True,         help_text='Observaciones de la venta (opcional)'     )          def validate_detalles(self, value):         """Validar que haya al menos un producto"""         if not value:             raise serializers.ValidationError('Debe incluir al menos un producto en la venta')         return value         def validate_metodos_pago(self, value):         """Validar que haya al menos un método de pago"""         if not value:             raise serializers.ValidationError('Debe incluir al menos un método de pago')         return value         def validate(self, data):         """         Validación cruzada: La suma de métodos de pago debe coincidir con el total calculado.        Esta es una validación crítica para evitar inconsistencias contables.        """         # Calcular subtotal de productos         subtotal = Decimal('0.00')         for detalle in data['detalles']:             try:                 producto = Producto.objects.get(pk=detalle['producto_id'])                 precio_con_descuento = producto.precio_venta - detalle.get('descuento_unitario', Decimal('0.00'))                 subtotal += precio_con_descuento * detalle['cantidad']             except Producto.DoesNotExist:                 pass  # Ya validado anteriormente                  # Calcular total final         total_calculado = subtotal - data.get('descuento_total', Decimal('0.00'))                  if total_calculado < Decimal('0.00'):             raise serializers.ValidationError({                 'descuento_total': 'Los descuentos exceden el subtotal de la venta'             })                  # Sumar métodos de pago         suma_pagos = sum(Decimal(str(mp['monto'])) for mp in data['metodos_pago'])                  # Validar coincidencia (con tolerancia de 1 peso por redondeos)         diferencia = abs(suma_pagos - total_calculado)         if diferencia > Decimal('1.00'):             raise serializers.ValidationError({                 'metodos_pago': f'La suma de pagos (${suma_pagos}) no coincide con el total de la venta (${total_calculado}). Diferencia: ${diferencia}'             })                  # Guardar total calculado para uso posterior         data['_total_calculado'] = total_calculado        data['_subtotal_calculado'] = subtotal                 return data class VentaOutputSerializer(serializers.ModelSerializer):     """Serializer para mostrar información completa de una venta"""     vendedor_nombre = serializers.CharField(source='vendedor.username', read_only=True)     detalles = serializers.SerializerMethodField()     metodos_pago = serializers.SerializerMethodField()     cantidad_productos = serializers.ReadOnlyField()          class Meta:         model = Venta        fields = [             'id', 'numero_venta', 'vendedor', 'vendedor_nombre',             'subtotal', 'descuento_total', 'total',             'cantidad_productos', 'detalles', 'metodos_pago',             'observaciones', 'fecha_venta', 'anulada'         ]          def get_detalles(self, obj):         return [{             'producto_id': d.producto.id,             'producto_sku': d.producto_sku,             'producto_nombre': d.producto_nombre,             'cantidad': d.cantidad,             'precio_unitario': str(d.precio_unitario),             'descuento_unitario': str(d.descuento_unitario),             'total_linea': str(d.total_linea)         } for d in obj.detalles.all()]          def get_metodos_pago(self, obj):         return [{             'tipo_pago': mp.tipo_pago,             'tipo_pago_display': mp.get_tipo_pago_display(),             'monto': str(mp.monto),             'referencia': mp.referencia         } for mp in obj.metodos_pago.all()]`

## 2. Crear función helper para generar número de venta

python

`# sales/utils.py from datetime import datetime from .models import Venta def generar_numero_venta():     """     Genera un número único de venta en formato: V-YYYYMMDD-NNNN    Ejemplo: V-20251104-0001         ¿Por qué este formato?    - V: Prefijo para identificar como venta    - YYYYMMDD: Fecha para facilitar búsquedas y reportes    - NNNN: Correlativo del día (reinicia cada día)    """     hoy = datetime.now()     fecha_str = hoy.strftime('%Y%m%d')          # Obtener último número del día     ultimo = Venta.objects.filter(         numero_venta__startswith=f'V-{fecha_str}-'     ).order_by('-numero_venta').first()          if ultimo:         # Extraer número correlativo y sumar 1         ultimo_numero = int(ultimo.numero_venta.split('-')[-1])         nuevo_numero = ultimo_numero + 1     else:         # Primera venta del día         nuevo_numero = 1          return f'V-{fecha_str}-{nuevo_numero:04d}'`

## 3. Crear vista para registrar venta en `sales/views.py`

python

`from rest_framework.views import APIView from rest_framework.response import Response from rest_framework import status from rest_framework.permissions import IsAuthenticated from django.db import transaction from decimal import Decimal from inventory.models import Producto, MovimientoInventario from authentication.permissions import IsVendedor from .models import Venta, DetalleVenta, MetodoPago from .serializers import VentaCreateSerializer, VentaOutputSerializer from .utils import generar_numero_venta class VentaCreateView(APIView):     """     POST /api/ventas/         Registra una nueva venta con actualización automática de inventario.         ¿Qué hace este endpoint?    1. Valida stock disponible de todos los productos    2. Genera número único de venta    3. Crea registro de venta con detalles    4. Actualiza stock de productos (dentro de transacción)    5. Registra movimientos de inventario para auditoría    6. Registra métodos de pago         Body ejemplo:    {        "detalles": [            {                "producto_id": 1,                "cantidad": 2,                "descuento_unitario": 0.00            },            {                "producto_id": 3,                "cantidad": 1,                "descuento_unitario": 500.00            }        ],        "metodos_pago": [            {                "tipo_pago": "efectivo",                "monto": 6500.00            }        ],        "descuento_total": 0.00,        "observaciones": "Venta regular"    }    """     permission_classes = [IsAuthenticated, IsVendedor]          def post(self, request):         serializer = VentaCreateSerializer(data=request.data)                  if not serializer.is_valid():             return Response(                 {                     'message': 'Datos de venta inválidos',                     'errors': serializer.errors                 },                 status=status.HTTP_400_BAD_REQUEST             )                  validated_data = serializer.validated_data                  # Usar transacción atómica para garantizar consistencia         # Si algo falla, TODO se revierte automáticamente         try:             with transaction.atomic():                 # 1. Generar número de venta único                 numero_venta = generar_numero_venta()                                  # 2. Crear venta principal                 venta = Venta.objects.create(                     numero_venta=numero_venta,                     vendedor=request.user,                     subtotal=validated_data['_subtotal_calculado'],                     descuento_total=validated_data.get('descuento_total', Decimal('0.00')),                     total=validated_data['_total_calculado'],                     observaciones=validated_data.get('observaciones', '')                 )                                  # 3. Procesar cada producto del carrito                 for detalle_data in validated_data['detalles']:                     # Obtener producto con lock para evitar race conditions                     producto = Producto.objects.select_for_update().get(                         pk=detalle_data['producto_id']                     )                                          # Verificar stock nuevamente (por si cambió entre validación y ejecución)                     if producto.stock_disponible < detalle_data['cantidad']:                         raise ValueError(                             f'Stock insuficiente para {producto.nombre}. '                             f'Disponible: {producto.stock_disponible}, solicitado: {detalle_data["cantidad"]}'                         )                                          # Calcular totales de línea                     precio_unitario = producto.precio_venta                     descuento_unitario = detalle_data.get('descuento_unitario', Decimal('0.00'))                     cantidad = detalle_data['cantidad']                                          subtotal_linea = precio_unitario * cantidad                    total_linea = (precio_unitario - descuento_unitario) * cantidad                                         # Crear detalle de venta (snapshot inmutable)                     DetalleVenta.objects.create(                         venta=venta,                         producto=producto,                         producto_sku=producto.sku,                         producto_nombre=producto.nombre,                         cantidad=cantidad,                         precio_unitario=precio_unitario,                         descuento_unitario=descuento_unitario,                         subtotal_linea=subtotal_linea,                         total_linea=total_linea                     )                                          # 4. Actualizar stock del producto                     stock_anterior = producto.stock_disponible                     producto.stock_disponible -= cantidad                    producto.save()                                          # 5. Registrar movimiento de inventario                     MovimientoInventario.objects.create(                         producto=producto,                         tipo_movimiento='venta',                         cantidad=-cantidad,  # Negativo porque es salida                         stock_anterior=stock_anterior,                         stock_posterior=producto.stock_disponible,                         motivo=f'Venta {numero_venta} - {cantidad} unidades',                         usuario=request.user,                         venta_relacionada=venta                     )                                  # 6. Registrar métodos de pago                 for metodo_data in validated_data['metodos_pago']:                     MetodoPago.objects.create(                         venta=venta,                         tipo_pago=metodo_data['tipo_pago'],                         monto=metodo_data['monto'],                         referencia=metodo_data.get('referencia', '')                     )                                  # 7. Retornar venta creada                 return Response(                     {                         'message': f'Venta {numero_venta} registrada exitosamente',                         'venta': VentaOutputSerializer(venta).data                     },                     status=status.HTTP_201_CREATED                 )                  except ValueError as e:             # Error de validación de negocio             return Response(                 {'error': str(e)},                 status=status.HTTP_400_BAD_REQUEST             )                  except Exception as e:             # Error inesperado             return Response(                 {                     'error': 'Error al procesar la venta',                     'detalle': str(e)                 },                 status=status.HTTP_500_INTERNAL_SERVER_ERROR             )`

## 4. Crear URLs en `sales/urls.py`

python

`from django.urls import path from .views import VentaCreateView app_name = 'sales' urlpatterns = [     path('ventas/', VentaCreateView.as_view(), name='venta-create'), ]`

## 5. Incluir URLs en `urls.py` principal

python

`# mundo_cartas_backend/urls.py urlpatterns = [     # ... rutas existentes ...     path('api/', include('sales.urls')), ]`

## 6. Probar endpoint con múltiples escenarios

**Escenario 1: Venta simple exitosa**

text

`POST http://localhost:8000/api/ventas/ Headers:   Authorization: Bearer <vendedor_token>  Content-Type: application/json Body: {   "detalles": [    {      "producto_id": 1,      "cantidad": 2,      "descuento_unitario": 0.00    }  ],  "metodos_pago": [    {      "tipo_pago": "efectivo",      "monto": 7000.00    }  ],  "descuento_total": 0.00,  "observaciones": "Venta de prueba" } Respuesta esperada (201): {   "message": "Venta V-20251104-0001 registrada exitosamente",  "venta": {    "id": 1,    "numero_venta": "V-20251104-0001",    "vendedor_nombre": "vendedor1",    "subtotal": "7000.00",    "descuento_total": "0.00",    "total": "7000.00",    "cantidad_productos": 2,    "detalles": [...],    "metodos_pago": [...],    "fecha_venta": "2025-11-04T..."  } }`

**Escenario 2: Stock insuficiente**

text

`POST http://localhost:8000/api/ventas/ Body: {   "detalles": [    {      "producto_id": 1,      "cantidad": 1000  // Más del stock disponible    }  ],  "metodos_pago": [    {      "tipo_pago": "efectivo",      "monto": 3500000.00    }  ] } Respuesta esperada (400): {   "message": "Datos de venta inválidos",  "errors": {    "detalles": [      {        "cantidad": [          "Stock insuficiente. Disponible: 50, solicitado: 1000"        ]      }    ]  } }`

**Escenario 3: Pago mixto (múltiples métodos)**

text

`POST http://localhost:8000/api/ventas/ Body: {   "detalles": [    {      "producto_id": 1,      "cantidad": 3    }  ],  "metodos_pago": [    {      "tipo_pago": "efectivo",      "monto": 5000.00    },    {      "tipo_pago": "debito",      "monto": 5500.00,      "referencia": "TRANS-12345"    }  ],  "descuento_total": 0.00 } Respuesta esperada (201): Venta registrada con 2 métodos de pago`

**Escenario 4: Suma de pagos no coincide con total**

text

`POST http://localhost:8000/api/ventas/ Body: {   "detalles": [    {      "producto_id": 1,      "cantidad": 2  // Total: 7000    }  ],  "metodos_pago": [    {      "tipo_pago": "efectivo",      "monto": 5000.00  // Falta pago    }  ] } Respuesta esperada (400): {   "message": "Datos de venta inválidos",  "errors": {    "metodos_pago": [      "La suma de pagos ($5000.00) no coincide con el total de la venta ($7000.00). Diferencia: $2000.00"    ]  } }`

## 7. Verificar en base de datos

sql

`-- Ver venta creada SELECT * FROM sales_venta WHERE numero_venta = 'V-20251104-0001'; -- Ver detalles de venta SELECT * FROM sales_detalleventa WHERE venta_id = 1; -- Ver movimientos de inventario generados SELECT * FROM inventory_movimientoinventario WHERE venta_relacionada_id = 1; -- Ver stock actualizado del producto SELECT sku, nombre, stock_disponible FROM inventory_producto WHERE id = 1;`

## Entregables

- ✅ Endpoint POST `/api/ventas/` funcional

- ✅ Validaciones exhaustivas (stock, pagos, descuentos)

- ✅ Transacciones atómicas (todo o nada)

- ✅ Generación automática de número de venta

- ✅ Snapshot inmutable de productos vendidos

- ✅ Registro en MovimientoInventario para auditoría

- ✅ Soporte para pago mixto (múltiples métodos)

- ✅ Actualización automática de stock

- ✅ Manejo de race conditions con select_for_update

## Validación

- Venta simple se registra correctamente

- Stock se actualiza automáticamente tras venta

- MovimientoInventario registra cada producto vendido

- Venta con stock insuficiente es rechazada

- Suma de pagos debe coincidir con total

- Transacción se revierte si falla cualquier paso

- Número de venta es único y sigue formato correcto

- Vendedores pueden registrar ventas

## Recursos de Aprendizaje

- **Django Transactions:** [Database transactions | Django documentation | Django](https://docs.djangoproject.com/en/4.2/topics/db/transactions/)

- **select_for_update:** [QuerySet API reference | Django documentation | Django](https://docs.djangoproject.com/en/4.2/ref/models/querysets/#select-for-update)

- **Atomic Operations:** [Database transactions | Django documentation | Django](https://docs.djangoproject.com/en/4.2/topics/db/transactions/#django.db.transaction.atomic)

---

**Ahora voy a continuar con las tareas 12.2, 18.2, 6.1 y 6.2 con el mismo nivel de profundidad. ¿Confirmas que este nivel de detalle es el adecuado?**

Luego al terminar Sprint 3 completo, te entregaré una **guía de actualización de documentación** paso a paso para que no se acumule el trabajo.

Perfecto, Angel. Continuaré con las tareas restantes del Sprint 3 manteniendo el mismo nivel de profundidad y coherencia.

---

## TAREA 12.2: Diseñar Componente POS (Carrito + Métodos de Pago)

**Historia de Usuario:** US-012 (Registrar venta de productos)  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 7 horas  
**Día sugerido:** Martes 5 de noviembre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Crear componente completo de Punto de Venta (POS) que permita agregar productos a un carrito, aplicar descuentos, seleccionar métodos de pago y procesar la venta. Este es el **componente más complejo del frontend** porque coordina múltiples estados y validaciones en tiempo real.

## ¿Por qué es importante?

El POS es la herramienta principal que Claudio y sus vendedores usarán diariamente. Debe ser:

1. **Rápido:** Agregar productos con pocos clics

2. **Intuitivo:** No requerir entrenamiento extensivo

3. **A prueba de errores:** Validar stock antes de permitir venta

4. **Flexible:** Soportar descuentos y pago mixto

5. **Responsive:** Funcionar en tablets o laptops

## Pasos Detallados

## 1. Actualizar `src/services/salesService.js`

javascript

`` import api from './api'; export const createVenta = async (ventaData) => {   const response = await api.post('/ventas/', ventaData);   return response.data; }; export const getVentas = async (params = {}) => {   const response = await api.get('/ventas/', { params });   return response.data; }; export const getVentaById = async (id) => {   const response = await api.get(`/ventas/${id}/`);   return response.data; }; ``

## 2. Crear componente principal `src/pages/POSPage.jsx`

jsx

`` import React, { useState, useEffect } from 'react'; import { getProductos } from '../services/inventoryService'; import { createVenta } from '../services/salesService'; import { useAuth } from '../context/AuthContext'; import ProductSearch from '../components/ProductSearch'; import CarritoVenta from '../components/CarritoVenta'; import MetodosPagoModal from '../components/MetodosPagoModal'; import './POSPage.css'; const POSPage = () => {   const { user } = useAuth();      // Estados del carrito   const [carrito, setCarrito] = useState([]);   const [descuentoGlobal, setDescuentoGlobal] = useState(0);   const [observaciones, setObservaciones] = useState('');      // Estados de UI   const [showMetodosPagoModal, setShowMetodosPagoModal] = useState(false);   const [processingVenta, setProcessingVenta] = useState(false);   const [ventaExitosa, setVentaExitosa] = useState(null);   /**    * ¿Por qué estructura del carrito así?   * Cada item del carrito necesita:   * - Referencia al producto original (para validar stock)   * - Snapshot de precio (puede cambiar mientras el usuario compra)   * - Descuento individual por producto   * - Cantidad seleccionada   */   const agregarAlCarrito = (producto) => {     const itemExistente = carrito.find(item => item.producto.id === producto.id);          if (itemExistente) {       // Si ya existe, aumentar cantidad (validando stock)       if (itemExistente.cantidad < producto.stock_disponible) {         setCarrito(carrito.map(item =>           item.producto.id === producto.id             ? { ...item, cantidad: item.cantidad + 1 }             : item        ));       } else {         alert(`Stock insuficiente. Disponible: ${producto.stock_disponible}`);       }     } else {       // Agregar nuevo item       if (producto.stock_disponible > 0) {         setCarrito([...carrito, {           producto: producto,           cantidad: 1,           precio_unitario: parseFloat(producto.precio_venta),           descuento_unitario: 0         }]);       } else {         alert('Producto sin stock disponible');       }     }   };   const actualizarCantidad = (productoId, nuevaCantidad) => {     const item = carrito.find(i => i.producto.id === productoId);          if (nuevaCantidad <= 0) {       // Eliminar del carrito       setCarrito(carrito.filter(i => i.producto.id !== productoId));     } else if (nuevaCantidad <= item.producto.stock_disponible) {       // Actualizar cantidad       setCarrito(carrito.map(i =>         i.producto.id === productoId          ? { ...i, cantidad: nuevaCantidad }           : i      ));     } else {       alert(`Stock insuficiente. Disponible: ${item.producto.stock_disponible}`);     }   };   const aplicarDescuentoItem = (productoId, descuento) => {     setCarrito(carrito.map(item =>       item.producto.id === productoId        ? { ...item, descuento_unitario: parseFloat(descuento) || 0 }         : item    ));   };   const eliminarDelCarrito = (productoId) => {     setCarrito(carrito.filter(item => item.producto.id !== productoId));   };   const vaciarCarrito = () => {     if (window.confirm('¿Está seguro de vaciar el carrito?')) {       setCarrito([]);       setDescuentoGlobal(0);       setObservaciones('');     }   };   /**    * Cálculos del carrito   * ¿Por qué calcular en el frontend?   * - Feedback instantáneo al usuario   * - Backend valida de todas formas (doble validación)   */   const calcularSubtotal = () => {     return carrito.reduce((sum, item) => {       const precioConDescuento = item.precio_unitario - item.descuento_unitario;       return sum + (precioConDescuento * item.cantidad);     }, 0);   };   const calcularTotal = () => {     return Math.max(0, calcularSubtotal() - descuentoGlobal);   };   const handleProcesarVenta = async (metodosPago) => {     setProcessingVenta(true);          try {       // Preparar datos para backend       const ventaData = {         detalles: carrito.map(item => ({           producto_id: item.producto.id,           cantidad: item.cantidad,           descuento_unitario: item.descuento_unitario         })),         metodos_pago: metodosPago,         descuento_total: descuentoGlobal,         observaciones: observaciones      };              const response = await createVenta(ventaData);              // Venta exitosa       setVentaExitosa(response.venta);              // Limpiar carrito       setCarrito([]);       setDescuentoGlobal(0);       setObservaciones('');       setShowMetodosPagoModal(false);              // Mostrar mensaje de éxito       alert(`✅ ${response.message}`);            } catch (err) {       // Manejar errores del backend       if (err.response?.data?.errors) {         const errores = err.response.data.errors;         let mensajeError = 'Error en la venta:\n\n';                  // Formatear errores de manera legible         Object.keys(errores).forEach(campo => {           if (Array.isArray(errores[campo])) {             errores[campo].forEach(error => {               if (typeof error === 'object') {                 // Errores anidados (detalles)                 Object.values(error).forEach(subError => {                   mensajeError += `• ${subError}\n`;                 });               } else {                 mensajeError += `• ${error}\n`;               }             });           } else {             mensajeError += `• ${errores[campo]}\n`;           }         });                  alert(mensajeError);       } else {         alert('Error al procesar la venta. Por favor intente nuevamente.');       }     } finally {       setProcessingVenta(false);     }   };   const puedeFinalizarVenta = () => {     return carrito.length > 0 && calcularTotal() > 0;   };   return (     <div className="pos-page">       {/* Header */}       <div className="pos-header">         <h1>🛒 Punto de Venta</h1>         <div className="vendedor-info">           <span>Vendedor: <strong>{user?.username}</strong></span>         </div>       </div>       <div className="pos-container">         {/* Panel izquierdo: Búsqueda de productos */}         <div className="pos-left-panel">           <ProductSearch onProductSelect={agregarAlCarrito} />         </div>         {/* Panel derecho: Carrito y totales */}         <div className="pos-right-panel">           <CarritoVenta             items={carrito}             onUpdateCantidad={actualizarCantidad}             onAplicarDescuento={aplicarDescuentoItem}             onEliminarItem={eliminarDelCarrito}             onVaciarCarrito={vaciarCarrito}           />           {/* Descuento global */}           <div className="descuento-global-section">             <label htmlFor="descuento-global">Descuento adicional:</label>             <div className="input-group">               <span className="input-prefix">$</span>               <input                 type="number"                 id="descuento-global"                 value={descuentoGlobal}                 onChange={(e) => setDescuentoGlobal(parseFloat(e.target.value) || 0)}                 min="0"                 max={calcularSubtotal()}                 placeholder="0"               />             </div>           </div>           {/* Observaciones */}           <div className="observaciones-section">             <label htmlFor="observaciones">Observaciones (opcional):</label>             <textarea               id="observaciones"               value={observaciones}               onChange={(e) => setObservaciones(e.target.value)}               placeholder="Notas sobre la venta..."               rows="2"             />           </div>           {/* Resumen de totales */}           <div className="totales-section">             <div className="total-row">               <span>Subtotal:</span>               <span className="total-value">${calcularSubtotal().toLocaleString('es-CL')}</span>             </div>             {descuentoGlobal > 0 && (               <div className="total-row descuento">                 <span>Descuento:</span>                 <span className="total-value">-${descuentoGlobal.toLocaleString('es-CL')}</span>               </div>             )}             <div className="total-row total-final">               <span>TOTAL:</span>               <span className="total-value">${calcularTotal().toLocaleString('es-CL')}</span>             </div>           </div>           {/* Botones de acción */}           <div className="acciones-section">             <button               className="btn-secondary btn-full"               onClick={vaciarCarrito}               disabled={carrito.length === 0}             >               🗑️ Vaciar Carrito            </button>             <button               className="btn-primary btn-full btn-large"               onClick={() => setShowMetodosPagoModal(true)}               disabled={!puedeFinalizarVenta() || processingVenta}             >               {processingVenta ? 'Procesando...' : '💳 Finalizar Venta'}             </button>           </div>         </div>       </div>       {/* Modal de métodos de pago */}       <MetodosPagoModal         isOpen={showMetodosPagoModal}         onClose={() => setShowMetodosPagoModal(false)}         onConfirm={handleProcesarVenta}         totalVenta={calcularTotal()}       />     </div>   ); }; export default POSPage; ``

## 3. Crear componente `src/components/ProductSearch.jsx`

jsx

`` import React, { useState, useEffect } from 'react'; import { getProductos } from '../services/inventoryService'; import './ProductSearch.css'; const ProductSearch = ({ onProductSelect }) => {   const [productos, setProductos] = useState([]);   const [searchTerm, setSearchTerm] = useState('');   const [categoria, setCategoria] = useState('');   const [loading, setLoading] = useState(false);   useEffect(() => {     fetchProductos();   }, [searchTerm, categoria]);   const fetchProductos = async () => {     setLoading(true);     try {       const params = {         search: searchTerm,         ordering: 'nombre'       };       if (categoria) params.categoria = categoria;              const data = await getProductos(params);              // Filtrar solo productos con stock > 0 para POS       const productsWithStock = data.filter(p => p.stock_disponible > 0);       setProductos(productsWithStock);     } catch (err) {       console.error('Error al cargar productos:', err);     } finally {       setLoading(false);     }   };   return (     <div className="product-search">       <h3>Buscar Productos</h3>              <div className="search-input-container">         <input           type="text"           placeholder="🔍 Buscar por nombre o SKU..."           value={searchTerm}           onChange={(e) => setSearchTerm(e.target.value)}           className="search-input-pos"           autoFocus         />       </div>       {loading ? (         <div className="loading-products">Cargando...</div>       ) : (         <div className="products-grid">           {productos.length === 0 ? (             <div className="no-products">               {searchTerm ? 'No se encontraron productos' : 'Busca productos para agregar al carrito'}             </div>           ) : (             productos.map(producto => (               <div                 key={producto.id}                 className="product-card"                 onClick={() => onProductSelect(producto)}               >                 <div className="product-card-header">                   <h4>{producto.nombre}</h4>                   <span className="product-sku">{producto.sku}</span>                 </div>                 <div className="product-card-body">                   <div className="product-price">                     ${parseFloat(producto.precio_venta).toLocaleString('es-CL')}                   </div>                   <div className={`product-stock ${producto.necesita_reabastecimiento ? 'low' : ''}`}>                     Stock: {producto.stock_disponible}                     {producto.necesita_reabastecimiento && ' ⚠️'}                   </div>                 </div>               </div>             ))           )}         </div>       )}     </div>   ); }; export default ProductSearch; ``

## 4. Crear componente `src/components/CarritoVenta.jsx`

jsx

`import React from 'react'; import './CarritoVenta.css'; const CarritoVenta = ({   items,   onUpdateCantidad,   onAplicarDescuento,   onEliminarItem,   onVaciarCarrito }) => {      const calcularTotalItem = (item) => {     const precioConDescuento = item.precio_unitario - item.descuento_unitario;     return precioConDescuento * item.cantidad;   };   if (items.length === 0) {     return (       <div className="carrito-vacio">         <div className="carrito-vacio-icon">🛒</div>         <p>Carrito vacío</p>         <p className="carrito-vacio-hint">Busca y selecciona productos para agregar</p>       </div>     );   }   return (     <div className="carrito-venta">       <div className="carrito-header">         <h3>Carrito de Compra ({items.length} {items.length === 1 ? 'producto' : 'productos'})</h3>       </div>       <div className="carrito-items">         {items.map(item => (           <div key={item.producto.id} className="carrito-item">             <div className="item-info">               <div className="item-nombre">{item.producto.nombre}</div>               <div className="item-sku">{item.producto.sku}</div>             </div>             <div className="item-cantidad">               <button                 className="btn-cantidad"                 onClick={() => onUpdateCantidad(item.producto.id, item.cantidad - 1)}               >                 −              </button>               <input                 type="number"                 value={item.cantidad}                 onChange={(e) => onUpdateCantidad(item.producto.id, parseInt(e.target.value) || 0)}                 min="0"                 max={item.producto.stock_disponible}                 className="input-cantidad"               />               <button                 className="btn-cantidad"                 onClick={() => onUpdateCantidad(item.producto.id, item.cantidad + 1)}                 disabled={item.cantidad >= item.producto.stock_disponible}               >                 +              </button>             </div>             <div className="item-precios">               <div className="item-precio-unitario">                 ${item.precio_unitario.toLocaleString('es-CL')} c/u              </div>                              {item.descuento_unitario > 0 && (                 <div className="item-descuento">                   -${item.descuento_unitario.toLocaleString('es-CL')} dcto                </div>               )}                              <div className="item-total">                 ${calcularTotalItem(item).toLocaleString('es-CL')}               </div>             </div>             <button               className="btn-eliminar-item"               onClick={() => onEliminarItem(item.producto.id)}               title="Eliminar del carrito"             >               🗑️            </button>           </div>         ))}       </div>     </div>   ); }; export default CarritoVenta;`

## 5. Crear componente `src/components/MetodosPagoModal.jsx`

jsx

`` import React, { useState, useEffect } from 'react'; import './MetodosPagoModal.css'; const MetodosPagoModal = ({ isOpen, onClose, onConfirm, totalVenta }) => {   const [metodosPago, setMetodosPago] = useState([     { tipo_pago: 'efectivo', monto: totalVenta, referencia: '' }   ]);   const [errors, setErrors] = useState({});   const tiposPago = [     { value: 'efectivo', label: 'Efectivo' },     { value: 'debito', label: 'Tarjeta de Débito' },     { value: 'credito', label: 'Tarjeta de Crédito' },     { value: 'transferencia', label: 'Transferencia' },     { value: 'otro', label: 'Otro' },   ];   // Actualizar monto cuando cambia el total   useEffect(() => {     if (metodosPago.length === 1) {       setMetodosPago([{ ...metodosPago[0], monto: totalVenta }]);     }   }, [totalVenta]);   const agregarMetodo = () => {     const totalPagado = metodosPago.reduce((sum, m) => sum + (parseFloat(m.monto) || 0), 0);     const faltante = totalVenta - totalPagado;          setMetodosPago([       ...metodosPago,       { tipo_pago: 'efectivo', monto: Math.max(0, faltante), referencia: '' }     ]);   };   const actualizarMetodo = (index, field, value) => {     const nuevosMetodos = [...metodosPago];     nuevosMetodos[index][field] = value;     setMetodosPago(nuevosMetodos);   };   const eliminarMetodo = (index) => {     if (metodosPago.length > 1) {       setMetodosPago(metodosPago.filter((_, i) => i !== index));     }   };   const calcularTotalPagado = () => {     return metodosPago.reduce((sum, m) => sum + (parseFloat(m.monto) || 0), 0);   };   const calcularDiferencia = () => {     return calcularTotalPagado() - totalVenta;   };   const validarYConfirmar = () => {     const newErrors = {};          // Validar cada método de pago     metodosPago.forEach((metodo, index) => {       if (!metodo.monto || metodo.monto <= 0) {         newErrors[`monto_${index}`] = 'El monto debe ser mayor a 0';       }     });          // Validar que la suma coincida     const diferencia = Math.abs(calcularDiferencia());     if (diferencia > 1) {  // Tolerancia de 1 peso       newErrors.general = `La suma de pagos no coincide con el total. Diferencia: $${diferencia.toFixed(0)}`;     }          setErrors(newErrors);          if (Object.keys(newErrors).length === 0) {       onConfirm(metodosPago);     }   };   if (!isOpen) return null;   const diferencia = calcularDiferencia();   return (     <div className="modal-overlay" onClick={onClose}>       <div className="modal-content modal-pagos" onClick={(e) => e.stopPropagation()}>         <div className="modal-header">           <h2>💳 Métodos de Pago</h2>           <button className="close-btn" onClick={onClose}>&times;</button>         </div>         <div className="modal-body">           <div className="total-venta-display">             <span>Total a cobrar:</span>             <span className="total-amount">${totalVenta.toLocaleString('es-CL')}</span>           </div>           <div className="metodos-pago-list">             {metodosPago.map((metodo, index) => (               <div key={index} className="metodo-pago-item">                 <div className="metodo-header">                   <h4>Método {index + 1}</h4>                   {metodosPago.length > 1 && (                     <button                       className="btn-eliminar-metodo"                       onClick={() => eliminarMetodo(index)}                     >                       ✕                    </button>                   )}                 </div>                 <div className="metodo-fields">                   <div className="form-group">                     <label>Tipo de Pago</label>                     <select                       value={metodo.tipo_pago}                       onChange={(e) => actualizarMetodo(index, 'tipo_pago', e.target.value)}                     >                       {tiposPago.map(tipo => (                         <option key={tipo.value} value={tipo.value}>{tipo.label}</option>                       ))}                     </select>                   </div>                   <div className="form-group">                     <label>Monto</label>                     <div className="input-group">                       <span className="input-prefix">$</span>                       <input                         type="number"                         value={metodo.monto}                         onChange={(e) => actualizarMetodo(index, 'monto', parseFloat(e.target.value) || 0)}                         min="0"                         step="100"                         className={errors[`monto_${index}`] ? 'input-error' : ''}                       />                     </div>                     {errors[`monto_${index}`] && (                       <span className="error-text">{errors[`monto_${index}`]}</span>                     )}                   </div>                   {metodo.tipo_pago !== 'efectivo' && (                     <div className="form-group">                       <label>Referencia (opcional)</label>                       <input                         type="text"                         value={metodo.referencia}                         onChange={(e) => actualizarMetodo(index, 'referencia', e.target.value)}                         placeholder="Nº transacción, voucher, etc."                       />                     </div>                   )}                 </div>               </div>             ))}           </div>           <button className="btn-agregar-metodo" onClick={agregarMetodo}>             + Agregar Método de Pago          </button>           {/* Resumen */}           <div className="resumen-pagos">             <div className="resumen-row">               <span>Total a cobrar:</span>               <span>${totalVenta.toLocaleString('es-CL')}</span>             </div>             <div className="resumen-row">               <span>Total pagado:</span>               <span>${calcularTotalPagado().toLocaleString('es-CL')}</span>             </div>             <div className={`resumen-row diferencia ${diferencia < 0 ? 'faltante' : diferencia > 0 ? 'exceso' : 'correcto'}`}>               <span>                 {diferencia < 0 ? 'Faltante:' : diferencia > 0 ? 'Exceso/Vuelto:' : 'Estado:'}               </span>               <span>                 {diferencia !== 0 ? `$${Math.abs(diferencia).toLocaleString('es-CL')}` : '✓ Correcto'}               </span>             </div>           </div>           {errors.general && (             <div className="error-box">{errors.general}</div>           )}         </div>         <div className="modal-footer">           <button className="btn-secondary" onClick={onClose}>             Cancelar          </button>           <button             className="btn-primary"             onClick={validarYConfirmar}             disabled={Math.abs(diferencia) > 1}           >             Confirmar Venta          </button>         </div>       </div>     </div>   ); }; export default MetodosPagoModal; ``

## 6. Crear estilos para todos los componentes

**`src/pages/POSPage.css`:**

css

`.pos-page {   padding: 20px;   max-width: 1800px;   margin: 0 auto;   background-color: #f5f5f5;   min-height: 100vh; } .pos-header {   display: flex;   justify-content: space-between;   align-items: center;   background: white;   padding: 20px;   border-radius: 8px;   margin-bottom: 20px;   box-shadow: 0 2px 4px rgba(0,0,0,0.1); } .pos-header h1 {   margin: 0;   font-size: 28px; } .vendedor-info {   font-size: 14px;   color: #6c757d; } .pos-container {   display: grid;   grid-template-columns: 1fr 450px;   gap: 20px;   min-height: calc(100vh - 150px); } .pos-left-panel {   background: white;   border-radius: 8px;   padding: 20px;   box-shadow: 0 2px 4px rgba(0,0,0,0.1);   overflow-y: auto; } .pos-right-panel {   background: white;   border-radius: 8px;   padding: 20px;   box-shadow: 0 2px 4px rgba(0,0,0,0.1);   display: flex;   flex-direction: column; } .descuento-global-section, .observaciones-section {   margin: 15px 0; } .descuento-global-section label, .observaciones-section label {   display: block;   font-weight: 600;   margin-bottom: 8px;   font-size: 14px; } .input-group {   display: flex;   align-items: center;   border: 2px solid #e0e0e0;   border-radius: 6px;   overflow: hidden; } .input-prefix {   background-color: #f8f9fa;   padding: 10px 12px;   font-weight: 600;   border-right: 2px solid #e0e0e0; } .input-group input {   border: none;   padding: 10px;   flex: 1;   font-size: 14px; } .input-group input:focus {   outline: none; } .observaciones-section textarea {   width: 100%;   padding: 10px;   border: 2px solid #e0e0e0;   border-radius: 6px;   font-family: inherit;   font-size: 14px;   resize: vertical; } .totales-section {   background-color: #f8f9fa;   padding: 15px;   border-radius: 6px;   margin: 15px 0; } .total-row {   display: flex;   justify-content: space-between;   padding: 8px 0;   font-size: 16px; } .total-row.descuento {   color: #dc3545; } .total-row.total-final {   border-top: 2px solid #dee2e6;   padding-top: 12px;   margin-top: 8px;   font-size: 20px;   font-weight: 700;   color: #007bff; } .acciones-section {   margin-top: auto;   display: flex;   flex-direction: column;   gap: 10px; } .btn-full {   width: 100%;   padding: 12px;   border-radius: 6px;   font-size: 15px;   font-weight: 600;   cursor: pointer;   border: none;   transition: all 0.2s; } .btn-large {   padding: 16px;   font-size: 18px; } .btn-primary {   background-color: #007bff;   color: white; } .btn-primary:hover:not(:disabled) {   background-color: #0056b3;   transform: translateY(-2px);   box-shadow: 0 4px 8px rgba(0,123,255,0.3); } .btn-primary:disabled {   background-color: #6c757d;   cursor: not-allowed;   opacity: 0.6; } .btn-secondary {   background-color: #6c757d;   color: white; } .btn-secondary:hover:not(:disabled) {   background-color: #5a6268; } /* Responsive */ @media (max-width: 1200px) {   .pos-container {     grid-template-columns: 1fr;   }      .pos-right-panel {     order: -1;   } }`

**`src/components/ProductSearch.css`:**

css

`.product-search h3 {   margin-top: 0;   margin-bottom: 20px; } .search-input-container {   margin-bottom: 20px; } .search-input-pos {   width: 100%;   padding: 12px 16px;   border: 2px solid #e0e0e0;   border-radius: 8px;   font-size: 16px;   transition: border-color 0.2s; } .search-input-pos:focus {   outline: none;   border-color: #007bff;   box-shadow: 0 0 0 3px rgba(0,123,255,0.1); } .products-grid {   display: grid;   grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));   gap: 15px;   max-height: 600px;   overflow-y: auto; } .product-card {   border: 2px solid #e0e0e0;   border-radius: 8px;   padding: 15px;   cursor: pointer;   transition: all 0.2s;   background: white; } .product-card:hover {   border-color: #007bff;   box-shadow: 0 4px 8px rgba(0,123,255,0.2);   transform: translateY(-2px); } .product-card-header h4 {   margin: 0 0 5px 0;   font-size: 14px;   color: #212529; } .product-sku {   font-size: 12px;   color: #6c757d;   font-family: monospace; } .product-card-body {   margin-top: 10px; } .product-price {   font-size: 18px;   font-weight: 700;   color: #007bff;   margin-bottom: 5px; } .product-stock {   font-size: 12px;   color: #28a745; } .product-stock.low {   color: #ffc107; } .loading-products, .no-products {   text-align: center;   padding: 40px;   color: #6c757d; }`

**`src/components/CarritoVenta.css`:**

css

`.carrito-vacio {   text-align: center;   padding: 60px 20px;   color: #6c757d; } .carrito-vacio-icon {   font-size: 64px;   margin-bottom: 20px;   opacity: 0.3; } .carrito-vacio-hint {   font-size: 14px;   margin-top: 10px; } .carrito-venta {   flex: 1;   display: flex;   flex-direction: column; } .carrito-header {   border-bottom: 2px solid #e0e0e0;   padding-bottom: 15px;   margin-bottom: 15px; } .carrito-header h3 {   margin: 0;   font-size: 18px; } .carrito-items {   flex: 1;   overflow-y: auto;   max-height: 400px; } .carrito-item {   display: grid;   grid-template-columns: 1fr auto auto auto;   gap: 15px;   align-items: center;   padding: 15px;   border: 2px solid #e0e0e0;   border-radius: 6px;   margin-bottom: 10px;   background: #f8f9fa; } .item-nombre {   font-weight: 600;   font-size: 14px;   margin-bottom: 4px; } .item-sku {   font-size: 12px;   color: #6c757d;   font-family: monospace; } .item-cantidad {   display: flex;   align-items: center;   gap: 8px; } .btn-cantidad {   width: 32px;   height: 32px;   border: 2px solid #007bff;   background: white;   color: #007bff;   border-radius: 4px;   font-size: 18px;   font-weight: 700;   cursor: pointer;   transition: all 0.2s; } .btn-cantidad:hover:not(:disabled) {   background: #007bff;   color: white; } .btn-cantidad:disabled {   opacity: 0.3;   cursor: not-allowed; } .input-cantidad {   width: 50px;   text-align: center;   padding: 6px;   border: 2px solid #e0e0e0;   border-radius: 4px;   font-weight: 600; } .item-precios {   text-align: right; } .item-precio-unitario {   font-size: 12px;   color: #6c757d; } .item-descuento {   font-size: 12px;   color: #dc3545;   margin: 2px 0; } .item-total {   font-size: 16px;   font-weight: 700;   color: #212529;   margin-top: 4px; } .btn-eliminar-item {   background: none;   border: none;   font-size: 20px;   cursor: pointer;   opacity: 0.6;   transition: opacity 0.2s; } .btn-eliminar-item:hover {   opacity: 1; }`

**`src/components/MetodosPagoModal.css`:**

css

`.modal-pagos {   max-width: 600px; } .total-venta-display {   display: flex;   justify-content: space-between;   align-items: center;   background-color: #e7f3ff;   padding: 15px 20px;   border-radius: 8px;   margin-bottom: 20px;   border-left: 4px solid #007bff; } .total-amount {   font-size: 24px;   font-weight: 700;   color: #007bff; } .metodos-pago-list {   margin-bottom: 15px; } .metodo-pago-item {   border: 2px solid #e0e0e0;   border-radius: 8px;   padding: 15px;   margin-bottom: 15px;   background: #f8f9fa; } .metodo-header {   display: flex;   justify-content: space-between;   align-items: center;   margin-bottom: 15px; } .metodo-header h4 {   margin: 0;   font-size: 16px; } .btn-eliminar-metodo {   background: #dc3545;   color: white;   border: none;   width: 28px;   height: 28px;   border-radius: 50%;   cursor: pointer;   font-size: 16px;   line-height: 1; } .metodo-fields {   display: flex;   flex-direction: column;   gap: 12px; } .btn-agregar-metodo {   width: 100%;   padding: 10px;   background: white;   border: 2px dashed #007bff;   color: #007bff;   border-radius: 6px;   cursor: pointer;   font-weight: 600;   transition: all 0.2s; } .btn-agregar-metodo:hover {   background: #e7f3ff; } .resumen-pagos {   background-color: #f8f9fa;   padding: 15px;   border-radius: 6px;   margin-top: 20px; } .resumen-row {   display: flex;   justify-content: space-between;   padding: 8px 0;   font-size: 16px; } .resumen-row.diferencia {   border-top: 2px solid #dee2e6;   padding-top: 12px;   margin-top: 8px;   font-weight: 700; } .resumen-row.faltante {   color: #dc3545; } .resumen-row.exceso {   color: #ffc107; } .resumen-row.correcto {   color: #28a745; }`

## 7. Agregar ruta en `App.js`

jsx

`import POSPage from './pages/POSPage'; <Route    path="/pos"    element={     <PrivateRoute>       <POSPage />     </PrivateRoute>   }  />`

## Entregables

- ✅ Componente POS completo y funcional

- ✅ Búsqueda de productos con filtrado en tiempo real

- ✅ Carrito interactivo con cantidades

- ✅ Cálculo automático de totales

- ✅ Validación de stock antes de agregar

- ✅ Soporte para descuentos individuales y globales

- ✅ Modal de métodos de pago con pago mixto

- ✅ Validación de suma de pagos

- ✅ Feedback visual claro (faltante/exceso/correcto)

- ✅ Responsive para tablets

## Validación

- Buscar producto y agregarlo al carrito funciona

- Cantidad se puede modificar con botones o input

- No se puede exceder stock disponible

- Descuentos se aplican correctamente

- Total se calcula en tiempo real

- Modal de pago valida coincidencia de montos

- Venta se procesa correctamente en backend

- Carrito se vacía tras venta exitosa

- Errores del backend se muestran claramente

## Recursos de Aprendizaje

- **React State Management:** https://react.dev/learn/managing-state

- **Controlled Inputs:** This feature is available in the latest Canary version of React

- /reference/react/act

- **useEffect Hook:** [- This feature is available in the latest Canary version of React -] https://react.dev/reference/react/useEffect

---

## TAREA 18.2: Verificar Actualización Automática de Stock en Frontend

**Historia de Usuario:** US-018 (Actualización automática de stock tras venta)  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 2 horas  
**Día sugerido:** Miércoles 6 de noviembre  
**Prioridad:** 🔴 CRÍTICA

## Descripción

Implementar mecanismos visuales para confirmar que el stock se actualiza correctamente tras una venta. Esta tarea es de **validación y UX**, no de funcionalidad nueva.

## ¿Por qué es importante?

Los usuarios necesitan **confirmar visualmente** que el stock se descontó correctamente. Sin esta retroalimentación:

- El vendedor puede dudar si la venta se procesó bien

- Puede intentar vender stock que ya no existe

- Se genera desconfianza en el sistema

## Pasos Detallados

## 1. Agregar notificación de éxito con detalles de stock en `POSPage.jsx`

jsx

`// Dentro de handleProcesarVenta, después de venta exitosa const handleProcesarVenta = async (metodosPago) => {   setProcessingVenta(true);      try {     const ventaData = { /* ... datos ... */ };     const response = await createVenta(ventaData);          // Mostrar detalles de stock actualizado     const detallesStock = carrito.map(item => ({       nombre: item.producto.nombre,       stockAnterior: item.producto.stock_disponible,       vendido: item.cantidad,       stockNuevo: item.producto.stock_disponible - item.cantidad     }));          setVentaExitosa({       ...response.venta,       detallesStock: detallesStock    });          // Limpiar carrito     setCarrito([]);     setDescuentoGlobal(0);     setObservaciones('');     setShowMetodosPagoModal(false);          // Mostrar modal de confirmación     setShowConfirmacionVenta(true);        } catch (err) {     // ... manejo de errores ...   } finally {     setProcessingVenta(false);   } };`

## 2. Crear componente `src/components/ConfirmacionVentaModal.jsx`

jsx

`import React from 'react'; import './ConfirmacionVentaModal.css'; const ConfirmacionVentaModal = ({ isOpen, onClose, venta }) => {   if (!isOpen || !venta) return null;   return (     <div className="modal-overlay" onClick={onClose}>       <div className="modal-content modal-confirmacion" onClick={(e) => e.stopPropagation()}>         <div className="modal-header success">           <div className="success-icon">✓</div>           <h2>¡Venta Registrada Exitosamente!</h2>         </div>                  <div className="modal-body">           <div className="venta-info-box">             <div className="info-row">               <span className="info-label">Número de Venta:</span>               <span className="info-value destacado">{venta.numero_venta}</span>             </div>             <div className="info-row">               <span className="info-label">Total:</span>               <span className="info-value total">${parseFloat(venta.total).toLocaleString('es-CL')}</span>             </div>             <div className="info-row">               <span className="info-label">Productos:</span>               <span className="info-value">{venta.cantidad_productos} unidades</span>             </div>           </div>           {venta.detallesStock && venta.detallesStock.length > 0 && (             <div className="stock-actualizado-section">               <h3>📦 Stock Actualizado</h3>               <div className="stock-items">                 {venta.detallesStock.map((detalle, index) => (                   <div key={index} className="stock-item">                     <div className="stock-item-nombre">{detalle.nombre}</div>                     <div className="stock-item-cambio">                       <span className="stock-anterior">{detalle.stockAnterior}</span>                       <span className="stock-arrow">→</span>                       <span className="stock-nuevo">{detalle.stockNuevo}</span>                       <span className="stock-vendido">(-{detalle.vendido})</span>                     </div>                   </div>                 ))}               </div>             </div>           )}           <div className="acciones-post-venta">             <p className="ayuda-text">¿Qué deseas hacer ahora?</p>             <button className="btn-primary btn-full" onClick={onClose}>               🛒 Nueva Venta            </button>             <button                className="btn-secondary btn-full"               onClick={() => {                 // Aquí podrías abrir una vista de detalle o imprimir                 console.log('Ver detalle de venta:', venta.numero_venta);                 onClose();               }}             >               📄 Ver Detalle / Imprimir            </button>           </div>         </div>       </div>     </div>   ); }; export default ConfirmacionVentaModal;`

## 3. Crear estilos `src/components/ConfirmacionVentaModal.css`

css

`.modal-confirmacion {   max-width: 600px; } .modal-header.success {   background: linear-gradient(135deg, #28a745 0%, #20c997 100%);   color: white;   padding: 30px 24px;   text-align: center; } .success-icon {   width: 80px;   height: 80px;   background: white;   border-radius: 50%;   display: flex;   align-items: center;   justify-content: center;   font-size: 48px;   color: #28a745;   margin: 0 auto 20px;   font-weight: bold;   box-shadow: 0 4px 12px rgba(0,0,0,0.2); } .modal-header.success h2 {   margin: 0;   font-size: 24px;   color: white; } .venta-info-box {   background-color: #f8f9fa;   border-left: 4px solid #28a745;   padding: 20px;   border-radius: 6px;   margin-bottom: 20px; } .info-row {   display: flex;   justify-content: space-between;   padding: 10px 0;   border-bottom: 1px solid #e0e0e0; } .info-row:last-child {   border-bottom: none; } .info-label {   font-weight: 600;   color: #6c757d; } .info-value {   color: #212529;   font-weight: 500; } .info-value.destacado {   font-family: monospace;   font-size: 18px;   color: #007bff;   font-weight: 700; } .info-value.total {   font-size: 24px;   font-weight: 700;   color: #28a745; } .stock-actualizado-section {   margin: 20px 0; } .stock-actualizado-section h3 {   margin: 0 0 15px 0;   font-size: 16px;   color: #495057; } .stock-items {   background-color: #fff3cd;   border: 1px solid #ffc107;   border-radius: 6px;   padding: 15px; } .stock-item {   padding: 10px;   border-bottom: 1px dashed #ffc107; } .stock-item:last-child {   border-bottom: none; } .stock-item-nombre {   font-weight: 600;   color: #212529;   margin-bottom: 5px;   font-size: 14px; } .stock-item-cambio {   display: flex;   align-items: center;   gap: 10px;   font-size: 18px;   color: #856404; } .stock-anterior {   font-weight: 700;   color: #6c757d; } .stock-arrow {   color: #ffc107;   font-size: 20px; } .stock-nuevo {   font-weight: 700;   color: #28a745; } .stock-vendido {   font-size: 14px;   color: #dc3545;   font-weight: 600; } .acciones-post-venta {   margin-top: 30px;   padding-top: 20px;   border-top: 2px solid #e0e0e0; } .ayuda-text {   text-align: center;   color: #6c757d;   margin-bottom: 15px;   font-size: 14px; } .btn-full {   width: 100%;   padding: 14px;   border-radius: 6px;   font-size: 16px;   font-weight: 600;   cursor: pointer;   border: none;   margin-bottom: 10px;   transition: all 0.2s; } .btn-primary {   background-color: #007bff;   color: white; } .btn-primary:hover {   background-color: #0056b3;   transform: translateY(-2px);   box-shadow: 0 4px 8px rgba(0,123,255,0.3); } .btn-secondary {   background-color: #6c757d;   color: white; } .btn-secondary:hover {   background-color: #5a6268; }`

## 4. Integrar en `POSPage.jsx`

jsx

`import ConfirmacionVentaModal from '../components/ConfirmacionVentaModal'; const POSPage = () => {   const [showConfirmacionVenta, setShowConfirmacionVenta] = useState(false);   const [ventaExitosa, setVentaExitosa] = useState(null);      // ... resto del código ...      return (     <div className="pos-page">       {/* ... componentes existentes ... */}              <ConfirmacionVentaModal         isOpen={showConfirmacionVenta}         onClose={() => {           setShowConfirmacionVenta(false);           setVentaExitosa(null);         }}         venta={ventaExitosa}       />     </div>   ); };`

## 5. Agregar validación visual en búsqueda de productos

Actualizar `ProductSearch.jsx` para mostrar advertencia si el stock es bajo:

jsx

`` <div className="products-grid">   {productos.map(producto => (     <div       key={producto.id}       className={`product-card ${producto.stock_disponible === 0 ? 'sin-stock' : ''}`}       onClick={() => producto.stock_disponible > 0 && onProductSelect(producto)}     >       {/* ... contenido existente ... */}              {producto.stock_disponible === 0 && (         <div className="sin-stock-badge">Sin Stock</div>       )}     </div>   ))} </div> ``

Agregar CSS correspondiente:

css

`.product-card.sin-stock {   opacity: 0.5;   cursor: not-allowed; } .sin-stock-badge {   position: absolute;   top: 10px;   right: 10px;   background-color: #dc3545;   color: white;   padding: 4px 8px;   border-radius: 4px;   font-size: 11px;   font-weight: 700; }`

## 6. Probar flujo completo

**Escenario de prueba:**

1. Agregar producto con stock conocido al carrito (ej: 50 unidades)

2. Vender 5 unidades

3. Verificar que modal de confirmación muestra:

   - Stock anterior: 50

   - Stock nuevo: 45

   - Vendido: -5

4. Cerrar modal y buscar el mismo producto

5. Confirmar que ahora muestra 45 unidades disponibles

## Entregables

- ✅ Modal de confirmación con detalles de stock

- ✅ Visualización clara de stock anterior → nuevo

- ✅ Indicador de unidades vendidas

- ✅ Productos sin stock visualmente deshabilitados

- ✅ Feedback inmediato tras venta exitosa

## Validación

- Modal se abre automáticamente tras venta exitosa

- Muestra stock actualizado para cada producto vendido

- Cambios de stock son claros y fáciles de entender

- Productos sin stock aparecen deshabilitados en búsqueda

- Nueva venta refleja stock actualizado inmediatamente

---

## TAREA 6.1: Crear Endpoint GET `/api/dashboard/` con Métricas

**Historia de Usuario:** US-006 (Ver dashboard con métricas clave)  
**Responsable:** Backend (Angel)  
**Duración estimada:** 3 horas  
**Día sugerido:** Miércoles 6 de noviembre  
**Prioridad:** 🟡 Alta

## Descripción

Crear endpoint que calcule y retorne métricas clave del negocio: ventas del día, productos más vendidos, stock bajo y totales generales. Este endpoint es la **fuente de datos para el dashboard**.

## ¿Por qué es importante?

El dashboard permite a Claudio:

1. Ver rendimiento del día en tiempo real

2. Identificar productos que necesitan reabastecimiento

3. Conocer qué productos se venden más

4. Tomar decisiones basadas en datos

## Pasos Detallados

## 1. Crear vista de dashboard en `sales/views.py`

python

`from rest_framework.decorators import api_view, permission_classes from rest_framework.permissions import IsAuthenticated from rest_framework.response import Response from django.db.models import Sum, Count, F, Q from django.utils import timezone from datetime import datetime, timedelta from decimal import Decimal from .models import Venta, DetalleVenta from inventory.models import Producto from authentication.permissions import IsVendedor @api_view(['GET']) @permission_classes([IsAuthenticated, IsVendedor]) def dashboard_metricas(request):     """     GET /api/dashboard/         Retorna métricas clave del negocio para el dashboard.         ¿Qué métricas calcula?    1. Ventas del día actual (total y cantidad)    2. Productos con stock bajo (necesitan reabastecimiento)    3. Top 5 productos más vendidos (del mes actual)    4. Resumen de métodos de pago del día    5. Comparación con día anterior         Parámetros query opcionales:    - fecha: Fecha específica en formato YYYY-MM-DD (default: hoy)    """     # Obtener fecha solicitada o usar hoy     fecha_param = request.query_params.get('fecha', None)     if fecha_param:         try:             fecha = datetime.strptime(fecha_param, '%Y-%m-%d').date()         except ValueError:             return Response(                 {'error': 'Formato de fecha inválido. Use YYYY-MM-DD'},                 status=400             )     else:         fecha = timezone.now().date()          # Definir rangos de tiempo     inicio_dia = datetime.combine(fecha, datetime.min.time())     fin_dia = datetime.combine(fecha, datetime.max.time())          # Día anterior para comparación     fecha_ayer = fecha - timedelta(days=1)     inicio_ayer = datetime.combine(fecha_ayer, datetime.min.time())     fin_ayer = datetime.combine(fecha_ayer, datetime.max.time())          # Inicio del mes actual     inicio_mes = fecha.replace(day=1)          # ============================================     # 1. VENTAS DEL DÍA     # ============================================     ventas_hoy = Venta.objects.filter(         fecha_venta__range=[inicio_dia, fin_dia],         anulada=False     )          total_ventas_hoy = ventas_hoy.aggregate(         total=Sum('total'),         cantidad=Count('id')     )          ventas_ayer = Venta.objects.filter(         fecha_venta__range=[inicio_ayer, fin_ayer],         anulada=False     )          total_ventas_ayer = ventas_ayer.aggregate(         total=Sum('total'),         cantidad=Count('id')     )          # Calcular variación porcentual     def calcular_variacion(actual, anterior):         """         Calcula variación porcentual entre dos valores.        Retorna dict con valor y porcentaje.        """         if anterior and anterior > 0:             variacion = ((actual - anterior) / anterior) * 100             return {                 'valor': float(actual - anterior),                 'porcentaje': round(float(variacion), 2),                 'tendencia': 'aumento' if variacion > 0 else 'disminucion' if variacion < 0 else 'igual'             }         return {             'valor': float(actual),             'porcentaje': 100.0 if actual > 0 else 0.0,             'tendencia': 'nuevo'         }          metricas_ventas = {         'total_dinero': {             'valor': float(total_ventas_hoy['total'] or 0),             'variacion': calcular_variacion(                 total_ventas_hoy['total'] or Decimal('0'),                 total_ventas_ayer['total'] or Decimal('0')             )         },         'cantidad_ventas': {             'valor': total_ventas_hoy['cantidad'] or 0,             'variacion': calcular_variacion(                 total_ventas_hoy['cantidad'] or 0,                 total_ventas_ayer['cantidad'] or 0             )         },         'ticket_promedio': {             'valor': float(                 (total_ventas_hoy['total'] / total_ventas_hoy['cantidad'])                 if total_ventas_hoy['cantidad'] > 0                 else 0             )         }     }          # ============================================     # 2. PRODUCTOS CON STOCK BAJO     # ============================================     productos_stock_bajo = Producto.objects.filter(         activo=True,         stock_disponible__lte=F('stock_minimo')     ).values(         'id', 'sku', 'nombre', 'stock_disponible', 'stock_minimo'     ).order_by('stock_disponible')[:10]  # Top 10 más urgentes          # ============================================     # 3. TOP PRODUCTOS MÁS VENDIDOS (MES ACTUAL)     # ============================================     top_productos = DetalleVenta.objects.filter(         venta__fecha_venta__gte=inicio_mes,         venta__anulada=False     ).values(         'producto__id',         'producto__sku',         'producto__nombre'     ).annotate(         cantidad_vendida=Sum('cantidad'),         total_vendido=Sum('total_linea')     ).order_by('-cantidad_vendida')[:5]          # ============================================     # 4. RESUMEN MÉTODOS DE PAGO (DÍA ACTUAL)     # ============================================     from .models import MetodoPago         metodos_pago_resumen = MetodoPago.objects.filter(         venta__fecha_venta__range=[inicio_dia, fin_dia],         venta__anulada=False     ).values('tipo_pago').annotate(         total=Sum('monto'),         cantidad_transacciones=Count('id')     ).order_by('-total')          # ============================================     # 5. ESTADÍSTICAS ADICIONALES     # ============================================     total_productos_activos = Producto.objects.filter(activo=True).count()     total_productos_sin_stock = Producto.objects.filter(         activo=True,         stock_disponible=0     ).count()          # Calcular valor total del inventario     valor_inventario = Producto.objects.filter(         activo=True     ).aggregate(         total=Sum(F('stock_disponible') * F('precio_venta'))     )['total'] or Decimal('0')          # ============================================     # CONSTRUIR RESPUESTA     # ============================================     return Response({         'fecha': fecha.strftime('%Y-%m-%d'),         'fecha_label': fecha.strftime('%d de %B de %Y'),                  'ventas': metricas_ventas,                  'productos_stock_bajo': {             'cantidad': len(productos_stock_bajo),             'productos': list(productos_stock_bajo)         },                  'top_productos': list(top_productos),                  'metodos_pago': list(metodos_pago_resumen),                  'inventario': {             'total_productos': total_productos_activos,             'sin_stock': total_productos_sin_stock,             'valor_total': float(valor_inventario)         },                  'ultima_actualizacion': timezone.now().isoformat()     })`

## 2. Agregar URL en `sales/urls.py`

python

`from .views import VentaCreateView, dashboard_metricas urlpatterns = [     path('ventas/', VentaCreateView.as_view(), name='venta-create'),     path('dashboard/', dashboard_metricas, name='dashboard'), ]`

## 3. Probar endpoint con diferentes escenarios

**Escenario 1: Dashboard del día actual**

text

`GET http://localhost:8000/api/dashboard/ Headers: Authorization: Bearer <token> Respuesta esperada (200): {   "fecha": "2025-11-06",  "fecha_label": "06 de Noviembre de 2025",  "ventas": {    "total_dinero": {      "valor": 45000.00,      "variacion": {        "valor": 5000.00,        "porcentaje": 12.5,        "tendencia": "aumento"      }    },    "cantidad_ventas": {      "valor": 8,      "variacion": {        "valor": 2,        "porcentaje": 33.33,        "tendencia": "aumento"      }    },    "ticket_promedio": {      "valor": 5625.00    }  },  "productos_stock_bajo": {    "cantidad": 3,    "productos": [      {        "id": 4,        "sku": "YGO-SD-001",        "nombre": "Structure Deck Cyber Strike",        "stock_disponible": 1,        "stock_minimo": 5      },      ...    ]  },  "top_productos": [    {      "producto__id": 1,      "producto__sku": "PKM-SV01-001",      "producto__nombre": "Booster Pack Pokémon...",      "cantidad_vendida": 25,      "total_vendido": "87500.00"    },    ...  ],  "metodos_pago": [    {      "tipo_pago": "efectivo",      "total": "30000.00",      "cantidad_transacciones": 5    },    {      "tipo_pago": "debito",      "total": "15000.00",      "cantidad_transacciones": 3    }  ],  "inventario": {    "total_productos": 7,    "sin_stock": 0,    "valor_total": 185000.00  },  "ultima_actualizacion": "2025-11-06T15:30:00Z" }`

**Escenario 2: Dashboard de fecha específica**

text

`GET http://localhost:8000/api/dashboard/?fecha=2025-11-05 Headers: Authorization: Bearer <token> Retorna métricas del 5 de noviembre`

## 4. Optimizar consultas con índices

python

`# En sales/models.py - Agregar índices si no existen class Venta(models.Model):     # ... campos existentes ...          class Meta:         # ... meta existente ...         indexes = [             models.Index(fields=['fecha_venta', 'anulada']),  # Para filtros de dashboard             models.Index(fields=['-fecha_venta']),  # Para ordenamiento         ] class DetalleVenta(models.Model):     # ... campos existentes ...          class Meta:         indexes = [             models.Index(fields=['venta', 'producto']),  # Para top productos         ]`

Ejecutar migraciones:

bash

`python manage.py makemigrations sales python manage.py migrate sales`

## Entregables

- ✅ Endpoint GET `/api/dashboard/` funcional

- ✅ Métricas de ventas con variación día anterior

- ✅ Lista de productos con stock bajo

- ✅ Top 5 productos más vendidos del mes

- ✅ Resumen de métodos de pago

- ✅ Estadísticas de inventario

- ✅ Soporte para consultar fecha específica

- ✅ Optimización con índices de base de datos

## Validación

- Endpoint retorna estructura correcta

- Variaciones porcentuales se calculan correctamente

- Stock bajo muestra productos urgentes primero

- Top productos refleja ventas del mes

- Métodos de pago suman correctamente

- Consulta es rápida (<500ms con 1000 ventas)

## Recursos de Aprendizaje

- **Django Aggregation:** [Aggregation | Django documentation | Django](https://docs.djangoproject.com/en/4.2/topics/db/aggregation/)

- **Query Optimization:** [Database access optimization | Django documentation | Django](https://docs.djangoproject.com/en/4.2/topics/db/optimization/)

- **F expressions:** [Query Expressions | Django documentation | Django](https://docs.djangoproject.com/en/4.2/ref/models/expressions/#f-expressions)

---

## TAREA 6.2: Diseñar Dashboard con Cards de Métricas

**Historia de Usuario:** US-006  
**Responsable:** Frontend (Alejandro)  
**Duración estimada:** 5 horas  
**Día sugerido:** Jueves-Viernes 7-8 de noviembre  
**Prioridad:** 🟡 Alta

## Descripción

Crear página de dashboard con cards visuales que muestren las métricas clave del negocio de forma clara y atractiva.

## ¿Por qué es importante?

El dashboard es la **primera pantalla que ve Claudio** al iniciar sesión. Debe:

1. Mostrar información más relevante primero

2. Ser visualmente clara (números grandes, colores significativos)

3. Actualizarse en tiempo real

4. Facilitar toma de decisiones rápidas

## Pasos Detallados

## 1. Actualizar `src/services/salesService.js`

javascript

`export const getDashboardMetricas = async (fecha = null) => {   const params = fecha ? { fecha } : {};   const response = await api.get('/dashboard/', { params });   return response.data; };`

## 2. Crear componente principal `src/pages/DashboardPage.jsx`

jsx

`import React, { useState, useEffect } from 'react'; import { getDashboardMetricas } from '../services/salesService'; import { useAuth } from '../context/AuthContext'; import MetricCard from '../components/MetricCard'; import ProductosStockBajo from '../components/ProductosStockBajo'; import TopProductos from '../components/TopProductos'; import './DashboardPage.css'; const DashboardPage = () => {   const { user, logout } = useAuth();   const [metricas, setMetricas] = useState(null);   const [loading, setLoading] = useState(true);   const [error, setError] = useState('');   const [autoRefresh, setAutoRefresh] = useState(true);   useEffect(() => {     fetchMetricas();          // Auto-refresh cada 30 segundos si está habilitado     let interval;     if (autoRefresh) {       interval = setInterval(fetchMetricas, 30000);     }          return () => {       if (interval) clearInterval(interval);     };   }, [autoRefresh]);   const fetchMetricas = async () => {     try {       const data = await getDashboardMetricas();       setMetricas(data);       setError('');     } catch (err) {       setError('Error al cargar métricas del dashboard');       console.error(err);     } finally {       setLoading(false);     }   };   const formatCurrency = (value) => {     return new Intl.NumberFormat('es-CL', {       style: 'currency',       currency: 'CLP',       minimumFractionDigits: 0,       maximumFractionDigits: 0     }).format(value);   };   const getTendenciaIcon = (tendencia) => {     switch(tendencia) {       case 'aumento': return '📈';       case 'disminucion': return '📉';       case 'igual': return '➡️';       default: return '🆕';     }   };   const getTendenciaColor = (tendencia) => {     switch(tendencia) {       case 'aumento': return '#28a745';       case 'disminucion': return '#dc3545';       default: return '#6c757d';     }   };   if (loading) {     return (       <div className="dashboard-loading">         <div className="spinner-large"></div>         <p>Cargando dashboard...</p>       </div>     );   }   if (error) {     return (       <div className="dashboard-error">         <p>{error}</p>         <button onClick={fetchMetricas}>Reintentar</button>       </div>     );   }   return (     <div className="dashboard-page">       {/* Header */}       <div className="dashboard-header">         <div>           <h1>📊 Dashboard</h1>           <p className="fecha-actual">{metricas?.fecha_label || ''}</p>         </div>         <div className="header-actions">           <label className="auto-refresh-toggle">             <input               type="checkbox"               checked={autoRefresh}               onChange={(e) => setAutoRefresh(e.target.checked)}             />             <span>Auto-actualizar</span>           </label>           <button className="btn-refresh" onClick={fetchMetricas}>             🔄 Actualizar          </button>         </div>       </div>       {/* Cards de métricas principales */}       <div className="metricas-grid">         <MetricCard           title="Ventas del Día"           value={formatCurrency(metricas.ventas.total_dinero.valor)}           icon="💰"           variacion={metricas.ventas.total_dinero.variacion}           getTendenciaIcon={getTendenciaIcon}           getTendenciaColor={getTendenciaColor}         />         <MetricCard           title="Cantidad de Ventas"           value={metricas.ventas.cantidad_ventas.valor}           icon="🛒"           variacion={metricas.ventas.cantidad_ventas.variacion}           getTendenciaIcon={getTendenciaIcon}           getTendenciaColor={getTendenciaColor}         />         <MetricCard           title="Ticket Promedio"           value={formatCurrency(metricas.ventas.ticket_promedio.valor)}           icon="🧾"         />         <MetricCard           title="Productos con Stock Bajo"           value={metricas.productos_stock_bajo.cantidad}           icon="⚠️"           alert={metricas.productos_stock_bajo.cantidad > 0}         />       </div>       {/* Métodos de pago */}       {metricas.metodos_pago && metricas.metodos_pago.length > 0 && (         <div className="metodos-pago-section">           <h2>💳 Métodos de Pago del Día</h2>           <div className="metodos-pago-grid">             {metricas.metodos_pago.map(metodo => (               <div key={metodo.tipo_pago} className="metodo-card">                 <div className="metodo-tipo">                   {metodo.tipo_pago === 'efectivo' && '💵'}                   {metodo.tipo_pago === 'debito' && '💳'}                   {metodo.tipo_pago === 'credito' && '💳'}                   {metodo.tipo_pago === 'transferencia' && '🏦'}                   {metodo.tipo_pago === 'otro' && '📱'}                   <span>{metodo.tipo_pago.charAt(0).toUpperCase() + metodo.tipo_pago.slice(1)}</span>                 </div>                 <div className="metodo-total">{formatCurrency(metodo.total)}</div>                 <div className="metodo-transacciones">                   {metodo.cantidad_transacciones} transacciones                </div>               </div>             ))}           </div>         </div>       )}       {/* Grid de secciones adicionales */}       <div className="dashboard-sections-grid">         {/* Productos con stock bajo */}         <ProductosStockBajo productos={metricas.productos_stock_bajo.productos} />         {/* Top productos */}         <TopProductos productos={metricas.top_productos} formatCurrency={formatCurrency} />       </div>       {/* Resumen de inventario */}       <div className="inventario-resumen">         <h2>📦 Inventario General</h2>         <div className="inventario-stats">           <div className="stat-item">             <span className="stat-label">Total Productos Activos:</span>             <span className="stat-value">{metricas.inventario.total_productos}</span>           </div>           <div className="stat-item">             <span className="stat-label">Productos Sin Stock:</span>             <span className="stat-value alert">{metricas.inventario.sin_stock}</span>           </div>           <div className="stat-item">             <span className="stat-label">Valor Total Inventario:</span>             <span className="stat-value">{formatCurrency(metricas.inventario.valor_total)}</span>           </div>         </div>       </div>     </div>   ); }; export default DashboardPage;`

## 3. Crear componentes auxiliares

**`src/components/MetricCard.jsx`:**

jsx

`` import React from 'react'; import './MetricCard.css'; const MetricCard = ({    title,    value,    icon,    variacion,    getTendenciaIcon,    getTendenciaColor,   alert  }) => {   return (     <div className={`metric-card ${alert ? 'alert' : ''}`}>       <div className="metric-header">         <span className="metric-icon">{icon}</span>         <h3>{title}</h3>       </div>       <div className="metric-value">{value}</div>       {variacion && (         <div            className="metric-variacion"           style={{ color: getTendenciaColor(variacion.tendencia) }}         >           <span className="tendencia-icon">{getTendenciaIcon(variacion.tendencia)}</span>           <span>{Math.abs(variacion.porcentaje).toFixed(1)}%</span>           <span className="variacion-label">vs ayer</span>         </div>       )}     </div>   ); }; export default MetricCard; ``

**`src/components/ProductosStockBajo.jsx`:**

jsx

`import React from 'react'; import './ProductosStockBajo.css'; const ProductosStockBajo = ({ productos }) => {   if (!productos || productos.length === 0) {     return (       <div className="productos-stock-bajo">         <h2>⚠️ Stock Bajo</h2>         <div className="no-items">           ✓ No hay productos con stock bajo        </div>       </div>     );   }   return (     <div className="productos-stock-bajo">       <h2>⚠️ Productos con Stock Bajo ({productos.length})</h2>       <div className="productos-list">         {productos.map(producto => (           <div key={producto.id} className="producto-item">             <div className="producto-info">               <div className="producto-nombre">{producto.nombre}</div>               <div className="producto-sku">{producto.sku}</div>             </div>             <div className="producto-stock">               <span className="stock-actual">{producto.stock_disponible}</span>               <span className="stock-separator">/</span>               <span className="stock-minimo">{producto.stock_minimo}</span>             </div>           </div>         ))}       </div>     </div>   ); }; export default ProductosStockBajo;`

**`src/components/TopProductos.jsx`:**

jsx

`import React from 'react'; import './TopProductos.css'; const TopProductos = ({ productos, formatCurrency }) => {   if (!productos || productos.length === 0) {     return (       <div className="top-productos">         <h2>🏆 Top Productos del Mes</h2>         <div className="no-items">           No hay ventas registradas este mes        </div>       </div>     );   }   return (     <div className="top-productos">       <h2>🏆 Top Productos del Mes</h2>       <div className="productos-ranking">         {productos.map((producto, index) => (           <div key={producto.producto__id} className="ranking-item">             <div className="ranking-position">#{index + 1}</div>             <div className="ranking-info">               <div className="ranking-nombre">{producto.producto__nombre}</div>               <div className="ranking-sku">{producto.producto__sku}</div>             </div>             <div className="ranking-stats">               <div className="stat-unidades">{producto.cantidad_vendida} uds</div>               <div className="stat-total">{formatCurrency(producto.total_vendido)}</div>             </div>           </div>         ))}       </div>     </div>   ); }; export default TopProductos;`

## 4. Crear estilos (consolidados en archivos CSS correspondientes según estructura de Sprint 2)

## 5. Actualizar ruta en `App.js`

jsx

`<Route    path="/dashboard"    element={     <PrivateRoute>       <DashboardPage />     </PrivateRoute>   }  />`

## Entregables

- ✅ Dashboard completo con métricas visuales

- ✅ Cards con variaciones porcentuales

- ✅ Indicadores de tendencia (aumento/disminución)

- ✅ Auto-refresh cada 30 segundos (opcional)

- ✅ Lista de productos con stock bajo

- ✅ Top 5 productos más vendidos

- ✅ Resumen de métodos de pago

- ✅ Estadísticas de inventario

- ✅ Responsive para tablets

## Validación

- Dashboard muestra métricas correctamente

- Variaciones se visualizan con colores apropiados

- Auto-refresh actualiza datos sin recargar página

- Stock bajo muestra alertas visuales claras

- Top productos rankean correctamente

- Responsive funciona en diferentes tamaños

---

## Definition of Done - Sprint 3 Completo

## Funcionalidad

- ✅ Eliminar productos con validaciones

- ✅ Registrar ventas completas con stock automático

- ✅ POS funcional con carrito y métodos de pago

- ✅ Dashboard con métricas en tiempo real

- ✅ Confirmación visual de actualización de stock

## Seguridad

- ✅ Solo admins pueden eliminar productos

- ✅ Vendedores y admins pueden registrar ventas

- ✅ Transacciones atómicas en ventas

- ✅ Validaciones exhaustivas de stock y pagos

## Experiencia de Usuario

- ✅ POS intuitivo y rápido

- ✅ Feedback visual inmediato tras ventas

- ✅ Dashboard claro y accionable

- ✅ Confirmaciones de eliminación claras

## Testing

- ✅ Flujo completo de venta probado

- ✅ Validaciones de stock verificadas

- ✅ Dashboard con datos reales validado

- ✅ Eliminación con restricciones probada

## Documentación

- ✅ Endpoints documentados con ejemplos

- ✅ Código comentado explicando decisiones

- ✅ Validaciones de negocio documentadas

---
