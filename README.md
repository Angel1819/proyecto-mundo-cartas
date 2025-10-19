# Proyecto Mundo Cartas

Este repositorio contiene el código y artefactos del proyecto de desarrollo de un MVP web para la pyme **Mundo Cartas**, cuyo dueño es Claudio.

## Descripción del Proyecto

El objetivo principal es construir una plataforma digital que facilite la gestión y comercialización de productos para Mundo Cartas. El proyecto incluye el desarrollo de un backend completo con Django REST Framework, un frontend en React, y una base de datos PostgreSQL. También se desarrolla un prototipo funcional en Figma para la interfaz de usuario, basado en requerimientos específicos recogidos mediante entrevistas y diagnóstico del negocio.

## Contenidos

- Diseño y especificación del MVP basado en análisis de necesidades.
- Modelo de datos completo con diagrama ER y scripts SQL.
- Backlog detallado con épicas, sprints, historias de usuario y tareas técnicas.
- Implementación backend con APIs REST seguras y auditables.
- Frontend responsivo para una experiencia de usuario óptima.
- Prototipo en Figma para validar el diseño y flujos de trabajo.

## Documentación Adjunta

El repositorio incluye documentos clave para entender el contexto y desarrollo del proyecto:

- **Informe-MVP-Mundo-Cartas-Angel-Alejandro.docx**: especificación funcional del MVP.
- **Backlog.docx**: planificación detallada con historias de usuario y tareas.
- **mundo_cartas.sql**: scripts y diseño de la base de datos.
- **Recopilacion-respuestas-entrevista.docx**: requisitos y comentarios del dueño, Claudio.
- Opcionalmente, **Informe-de-Diagnostico-Mundo-Cartas.docx** y **Entidades-principales-del-sistema-Mundo-Cartas.docx** para contexto adicional.

## Equipo

Este proyecto es desarrollado por Angel Medina y Alejandro Barraza como parte de su evaluación en el cuarto semestre.

## Tecnologías

- Backend: Django REST Framework
- Frontend: React
- Base de datos: PostgreSQL
- Diseño UI: Figma

## Inicio Rápido

### Requisitos Previos

- Python 3.11+
- Node.js 18+
- PostgreSQL 15
- Git

### Configuración Backend (Django)

```bash
# Crear y activar entorno virtual
python -m venv venv
venv\Scripts\activate  # Windows

# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus valores

# Ejecutar migraciones
python manage.py migrate

# Iniciar servidor
python manage.py runserver
```

### Configuración Frontend (React)

```bash
# Instalar dependencias
cd mundo-cartas-frontend
npm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus valores

# Iniciar aplicación
npm start
```

## Cómo contribuir

Al ser un proyecto académico orientado a entrega MVP, las contribuciones externas son limitadas. Para consultas o propuestas, contactar a los desarrolladores.

---

Este repositorio refleja la evolución y construcción metodológica de un sistema funcional para Mundo Cartas, integrando análisis de negocio, UI/UX y desarrollo técnico.
