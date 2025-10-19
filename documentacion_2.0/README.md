# 📄 README.MD - ÚLTIMO DOCUMENTO

Aquí está el README.md completo, tu índice maestro de documentación:

text

`# MVP MUNDO CARTAS 🎴 **Sistema de Gestión de Inventario y Ventas para Tienda de Trading Cards** Sistema web completo que reemplaza hojas de cálculo Excel con gestión en tiempo real, auditoría automática y control de acceso por roles. --- ## 📊 ESTADO DEL PROYECTO **Fase actual:** Planificación completada   **Fecha de inicio desarrollo:** 20 de octubre de 2025   **Versión:** 3.0 (con categorías dinámicas)   **Última actualización:** 19 de octubre de 2025, 3:00 AM ### Progreso General - ✅ Sprint 1 planificado (Autenticación) - 35 horas - ✅ Sprint 2 planificado (Inventario) - 41 horas - ✅ Sprint 3 planificado (POS) - 29 horas - ⏳ Sprints 4-7 pendientes de planificación detallada --- ## 🎯 ¿QUÉ DOCUMENTO LEER? ### Para empezar a desarrollar HOY: **1. TAREAS_DETALLADAS.md** ⭐⭐⭐⭐⭐   → Pasos técnicos paso a paso para implementar cada tarea   → Código completo de ejemplo   → Validaciones y testing   → **Úsalo cuando:** Estés implementando cualquier funcionalidad ### Para entender el proyecto: **2. CONTEXTO.md** ⭐⭐⭐⭐⭐   → Prompt completo para copiar/pegar en nuevas sesiones con IA   → Estado del proyecto, decisiones arquitectónicas, stack técnico   → **Úsalo cuando:** Inicies una nueva conversación con IA o necesites recordar el contexto completo **3. BACKLOG.md**   → Historias de usuario con criterios de aceptación   → Épicas y priorización   → **Úsalo cuando:** Necesites validar que una funcionalidad cumple los requisitos ### Para planificar y hacer seguimiento: **4. SPRINT_PLANNING.md**   → Cronograma detallado de sprints 1-3   → Distribución de tareas por día   → Métricas de velocidad   → **Úsalo cuando:** Necesites saber qué hacer cada día o hacer seguimiento de progreso ### Para diseñar modelos y base de datos: **5. DB_MODEL_MUNDO_CARTAS.md**   → Modelo de datos completo con explicaciones   → Decisiones de diseño y diagramas   → **Úsalo cuando:** Estés creando modelos de Django o escribiendo migraciones **6. mundo_cartas.sql**   → Script SQL completo de base de datos   → Datos de prueba incluidos   → **Úsalo cuando:** Necesites crear la base de datos desde cero ### Para documentar decisiones: **7. BITACORA_DESARROLLO.md**   → Registro de decisiones técnicas y cambios importantes   → **Úsalo cuando:** Tomes una decisión arquitectónica importante --- ## 🚀 SETUP RÁPIDO (PRIMERA VEZ) ### Requisitos Previos - Python 3.11+ - Node.js 18+ - PostgreSQL 15 - Git ### Backend (Django)`

# 1. Clonar repositorio

git clone <url-repo>  
cd mundo-cartas-backend

# 2. Crear entorno virtual

python -m venv venv  
source venv/bin/activate # Windows: venv\Scripts\activate

# 3. Instalar dependencias

pip install -r requirements.txt

# 4. Crear base de datos

psql -U postgres  
CREATE DATABASE mundo_cartas_db;  
\q

# 5. Ejecutar script SQL

psql -U postgres -d mundo_cartas_db -f mundo_cartas.sql

# 6. Ejecutar migraciones

python manage.py makemigrations  
python manage.py migrate

# 7. Crear superusuario

python manage.py createsuperuser

# 8. Iniciar servidor

python manage.py runserver

text

`**Backend corriendo en:** http://localhost:8000 ### Frontend (React)`

# 1. Ir a carpeta frontend

cd mundo-cartas-frontend

# 2. Instalar dependencias

npm install

# 3. Crear archivo .env

echo "REACT_APP_API_URL=http://localhost:8000/api" > .env

# 4. Iniciar servidor

npm start

text

`**Frontend corriendo en:** http://localhost:3000 --- ## 🛠️ STACK TÉCNICO ### Backend - **Framework:** Django 4.2 + Django REST Framework 3.14 - **Base de datos:** PostgreSQL 15 - **Autenticación:** JWT (djangorestframework-simplejwt) - **Lenguaje:** Python 3.11+ ### Frontend - **Framework:** React 18 - **Routing:** React Router DOM 6 - **HTTP Client:** Axios - **State Management:** Context API - **Lenguaje:** JavaScript (ES6+) --- ## 📁 ESTRUCTURA DEL PROYECTO`

mundo-cartas/  
│  
├── docs/ # Documentación (ESTOS ARCHIVOS)  
│ ├── README.md # Este archivo (índice maestro)  
│ ├── CONTEXTO.md # Prompt para IA  
│ ├── TAREAS_DETALLADAS.md # Guía de implementación  
│ ├── SPRINT_PLANNING.md # Cronograma  
│ ├── BACKLOG.md # Historias de usuario  
│ ├── DB_MODEL_MUNDO_CARTAS.md # Modelo de datos  
│ ├── mundo_cartas.sql # Script de base de datos  
│ └── BITACORA_DESARROLLO.md # Decisiones técnicas  
│  
├── mundo-cartas-backend/ # Django  
│ ├── authentication/ # Login, usuarios, permisos  
│ ├── inventory/ # Productos, categorías, stock  
│ ├── sales/ # Ventas, POS, métodos de pago  
│ ├── mundo_cartas_backend/ # Configuración (settings.py)  
│ ├── manage.py  
│ └── requirements.txt  
│  
└── mundo-cartas-frontend/ # React  
├── src/  
│ ├── components/ # Componentes reutilizables  
│ ├── pages/ # Páginas principales  
│ ├── services/ # APIs (axios)  
│ ├── context/ # AuthContext  
│ └── App.js  
└── package.json

text

``--- ## 📚 GUÍA DE FLUJO DE TRABAJO ### Día típico de desarrollo: 1. **Al iniciar el día:**    - Consulta SPRINT_PLANNING.md para saber qué tarea hacer hoy   - Ejemplo: "Hoy es Lunes 28 oct → Tarea 7.2 (CategoriaSelect)" 2. **Durante implementación:**    - Abre TAREAS_DETALLADAS.md   - Busca la tarea (Ctrl+F: "TAREA 7.2")   - Sigue los pasos paso a paso   - Copia código de ejemplo y adáptalo 3. **Si tienes dudas técnicas:**    - Abre nueva conversación con IA   - Pega CONTEXTO.md completo   - Formula tu pregunta específica 4. **Si tomas una decisión técnica importante:**    - Documéntala en BITACORA_DESARROLLO.md   - Formato: Fecha, Decisión, Por qué, Impacto 5. **Al terminar la tarea:**    - Valida contra criterios de aceptación en BACKLOG.md   - Commit con mensaje descriptivo --- ## 🔑 USUARIOS DE PRUEBA Después de ejecutar mundo_cartas.sql: **Administrador:** - Usuario: `admin` - Password: `admin123` - Permisos: Todos **Vendedor:** - Usuario: `vendedor1` - Password: `vend123` - Permisos: Ver inventario, registrar ventas, gestionar reservas --- ## 📦 ENDPOINTS PRINCIPALES ### Autenticación - POST `/api/auth/login/` - Iniciar sesión - POST `/api/auth/logout/` - Cerrar sesión ### Inventario - GET `/api/inventario/` - Listar productos - POST `/api/inventario/crear/` - Crear producto - PATCH `/api/inventario/:id/` - Editar producto - POST `/api/inventario/:id/ajuste-stock/` - Ajustar stock ### Categorías - GET `/api/categorias/` - Listar categorías - POST `/api/categorias/` - Crear categoría ### Ventas - POST `/api/ventas/` - Registrar venta - GET `/api/dashboard/` - Métricas del negocio --- ## 🎨 CONVENCIONES DE CÓDIGO ### Django (Backend) **Nombres en español:**``

# ✅ BIEN

class Usuario(AbstractUser):  
rol = CharField(choices=ROLES)

# ❌ MAL

class User(AbstractUser):  
role = CharField(choices=ROLES)

text

`**Validaciones doble capa:** - Modelo: Constraints de base de datos - Serializer: Lógica de negocio **Permisos explícitos:**`

permission_classes = [IsAuthenticated, IsAdministrador]

text

`### React (Frontend) **Componentes funcionales:**`

// ✅ BIEN  
const LoginPage = () => {  
const [username, setUsername] = useState('');  
return <div>...</div>;  
};

// ❌ MAL (no usar clases)  
class LoginPage extends Component { }

text

``**Nombres de archivos:** - Componentes: `PascalCase.jsx` (ProductoModal.jsx) - Servicios: `camelCase.js` (authService.js) --- ## 🔥 DECISIONES ARQUITECTÓNICAS CLAVE ### 1. Categorías Dinámicas (19-oct-2025) **Cambio:** De CharField con choices → Tabla Categoria independiente   **Motivo:** Mundo Cartas necesita crear categorías según tendencias del mercado   **Impacto:** +6 horas Sprint 2, pero flexibilidad total ### 2. MovimientoInventario Anticipado **Cambio:** Implementado en Sprint 2 (no Sprint 3)   **Motivo:** Auditoría completa desde el primer ajuste de stock   **Beneficio:** Reutilización en Sprint 3 (-3 horas) ### 3. Snapshot en DetalleVenta **Decisión:** Duplicar SKU, nombre y precio en DetalleVenta   **Motivo:** Facturas son inmutables (requisito legal)   **Alternativa descartada:** Calcular dinámicamente → Facturas cambiarían retroactivamente ### 4. Transacciones Atómicas **Decisión:** `transaction.atomic()` en ventas   **Motivo:** 5 operaciones deben ejecutarse TODAS o NINGUNA   **Beneficio:** Consistencia garantizada --- ## 📞 SOPORTE Y CONTACTO **Desarrollador:** Angel Alejandro   **Compañero (Frontend):** Alejandro   **Cliente:** Claudio (Mundo Cartas) **Proyecto de:** Tesis / Proyecto de Título   **Universidad:** [Tu universidad]   **Año:** 2025 --- ## 📝 LICENCIA Y NOTAS **Licencia:** Uso académico - Proyecto de título   **Estado:** MVP en desarrollo   **Última revisión documentación:** 19 de octubre de 2025 --- ## 🎯 PRÓXIMOS PASOS **Inmediato (20 oct):** - [ ] Setup de repositorio Git - [ ] Instalación de dependencias locales - [ ] Ejecución de mundo_cartas.sql - [ ] Inicio de Sprint 1 - Tarea 1.1 **Esta semana (20-26 oct):** - [ ] Completar Sprint 1 (Autenticación) - [ ] Login funcional con JWT - [ ] Dashboard base **Próxima semana (27 oct - 2 nov):** - [ ] Completar Sprint 2 (Inventario) - [ ] CRUD de productos con categorías dinámicas - [ ] Ajustes de stock con auditoría --- **¿Tienes dudas? Consulta CONTEXTO.md para información completa o TAREAS_DETALLADAS.md para guías de implementación.** **¡Éxito en el desarrollo! 🚀**``


