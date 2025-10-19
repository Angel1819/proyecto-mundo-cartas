# Hola Alejandro 👋

Este documento es para explicarte cómo trabajar con el agente de IA en este proyecto.

## ¿Qué es esto?

Angel ha configurado un ambiente de trabajo con "ingeniería de contexto" para que los agentes de IA (como yo) podamos ayudar de manera más efectiva en el proyecto. Esto significa que tenemos acceso a:

- La estructura planificada del proyecto
- Las decisiones técnicas tomadas
- Los sprints y tareas definidas
- El modelo de datos y la arquitectura

## ¿Cómo puedes aprovechar esto?

1. **Para comenzar una sesión nueva**:

   - Menciona que eres Alejandro, el frontend developer del proyecto
   - La IA automáticamente entenderá tu rol y el contexto del proyecto

2. **Documentación importante**:

   - `/documentacion_2.0/CONTEXTO.md`: Visión general
   - `/documentacion_2.0/SPRINT_PLANNING.md`: Cronograma
   - `/documentacion_2.0/TAREAS_DETALLADAS.md`: Tareas específicas

3. **Stack Frontend Definido**:
   - React 18
   - React Router DOM 6
   - Axios para HTTP
   - Context API (no Redux)
   - CSS vanilla (sin frameworks)

## ¿Cómo hacer preguntas efectivas?

1. **Para decisiones técnicas**:

   ```
   ¿Cuál sería la mejor manera de estructurar [componente/feature] considerando que necesitamos [requisito específico]?
   ```

2. **Para implementación**:

   ```
   Necesito implementar [feature]. Teniendo en cuenta el diseño actual, ¿cómo sugieres que lo estructure?
   ```

3. **Para debugging**:
   ```
   Estoy teniendo un problema con [descripción]. Aquí está el código relevante: [código]
   ```

## Tips para el trabajo con la IA

1. **Sé específico**: Cuanto más contexto des en tu pregunta, mejor será la respuesta.

2. **Pide explicaciones**: Si necesitas entender por qué se sugiere cierta solución, pregunta.

3. **Iteración**: Puedes pedir mejoras o cambios sobre las sugerencias recibidas.

4. **Documentación**: La IA puede ayudarte a documentar tu código o crear guías técnicas.

## Configuración de Desarrollo

Si necesitas configurar tu ambiente de desarrollo:

1. La IA puede guiarte en la instalación de Node.js y dependencias
2. Puede ayudarte con la configuración de linters y formatters
3. Puede explicarte la estructura de carpetas y archivos

## Planificación del Proyecto

### Cronograma de Sprints

**Sprint 1 (19-25 oct): Autenticación** ⏳

- Configuración inicial del proyecto
- Sistema de autenticación con JWT
- Login/logout completo
- Roles: administrador/vendedor

**Sprint 2 (27 oct - 2 nov): Inventario** 📦

- CRUD completo de productos
- Categorías dinámicas
- Gestión de stock
- Auditoría de movimientos

**Sprint 3 (3-9 nov): POS (Punto de Venta)** 💰

- Registro de ventas
- Múltiples métodos de pago
- Actualización automática de stock
- Dashboard con métricas en tiempo real

**Sprints Futuros (4-7)** 🔄

- Sistema de reservas
- Reportes avanzados
- Notificaciones
- Despliegue a producción

### Comunicación con Backend

- Las APIs estarán en `http://localhost:8000/api/`
- Autenticación mediante JWT (tokens en localStorage)
- La estructura de datos está en `DB_MODEL_MUNDO_CARTAS.md`

### Requisitos Mínimos de Desarrollo

1. **Software Necesario**:

   - Node.js (para React)
   - VS Code (recomendado)
   - Git

2. **Extensiones VS Code Recomendadas**:
   - Prettier
   - ESLint
   - GitLens (opcional)
   - React Developer Tools (extensión de navegador)

## ¿Necesitas ayuda?

Solo pregunta. Por ejemplo:

```
"Hola, soy Alejandro, el frontend developer. Necesito ayuda para configurar [X] o implementar [Y]..."
```

La IA está configurada para:

- Respetar las decisiones técnicas ya tomadas
- Seguir las convenciones del proyecto
- Proporcionar código funcional completo (no pseudocódigo)
- Explicar los trade-offs de las soluciones propuestas

---

Cualquier duda sobre cómo trabajar con la IA o el proyecto, no dudes en preguntar.
