# Guía de Estructura Frontend - Mundo Cartas

## 🎯 Propósito del Documento

Este documento explica en detalle la estructura del frontend, el razonamiento detrás de cada decisión y cómo usar cada parte. Sirve como guía tanto para el desarrollo inicial como para futuras modificaciones.

## 📁 Estructura General

```
mundo-cartas-frontend/
├── src/
│   ├── components/     # Componentes reutilizables
│   ├── pages/         # Páginas/rutas principales
│   ├── context/       # Estado global
│   ├── services/      # Llamadas a API
│   └── utils/         # Funciones auxiliares
```

## 🔍 Desglose Detallado

### 1. Components (`src/components/`)

Componentes reutilizables organizados por dominio de negocio.

```
components/
├── auth/              # Componentes de autenticación
│   ├── LoginForm.js   # Formulario de login
│   └── ProtectedRoute.js  # HOC para proteger rutas
├── inventory/         # Componentes de inventario
│   ├── ProductCard.js      # Tarjeta de producto
│   ├── CategorySelect.js   # Selector de categorías
│   └── StockMovement.js    # Formulario movimientos
├── sales/            # Componentes de ventas
│   ├── CartItem.js        # Ítem en carrito
│   ├── PaymentForm.js     # Formulario de pago
│   └── ReceiptPreview.js  # Vista previa boleta
└── common/           # Componentes genéricos
    ├── Layout.js     # Layout principal
    ├── Button.js     # Botón estilizado
    └── Modal.js      # Modal reutilizable
```

**Razonamiento:**

- Separación por dominio facilita encontrar componentes
- Componentes específicos en sus carpetas relevantes
- `common/` para elementos usados en múltiples secciones

### 2. Pages (`src/pages/`)

Páginas principales que representan rutas en la aplicación.

```
pages/
├── auth/
│   ├── LoginPage.js    # Página de login
│   └── LogoutPage.js   # Página de logout
├── inventory/
│   ├── ProductListPage.js     # Lista de productos
│   ├── ProductDetailPage.js   # Detalle de producto
│   └── StockAdjustmentPage.js # Ajustes de stock
└── sales/
    ├── POSPage.js            # Punto de venta
    └── SalesHistoryPage.js   # Historial ventas
```

**Razonamiento:**

- Estructura espeja los modelos del backend
- Facilita implementación de permisos por rol
- Páginas autocontenidas con su propia lógica

### 3. Context (`src/context/`)

Estado global usando Context API de React.

```
context/
├── AuthContext.js    # Estado de autenticación
├── CartContext.js    # Estado del carrito
└── AlertContext.js   # Notificaciones globales
```

**Razonamiento:**

- AuthContext: Manejo de JWT y roles
- CartContext: Estado temporal de venta en proceso
- AlertContext: Notificaciones y mensajes de error
- No se usa Redux por simplicidad y requisitos

### 4. Services (`src/services/`)

Centraliza llamadas a API y lógica de negocio.

```
services/
├── api.js           # Configuración base axios
├── authService.js   # Servicios de autenticación
├── inventoryService.js  # Servicios de inventario
└── salesService.js  # Servicios de ventas
```

**Razonamiento:**

- Separación clara de responsabilidades
- Reutilización de lógica de API
- Manejo centralizado de errores
- Fácil modificación de endpoints

### 5. Utils (`src/utils/`)

Funciones auxiliares y constantes.

```
utils/
├── formatters.js    # Formato (moneda, fechas)
├── validators.js    # Validaciones forms
└── constants.js     # Constantes globales
```

**Razonamiento:**

- Evita duplicación de código
- Mantiene consistencia en la aplicación
- Facilita cambios globales

## 🔄 Flujo de Datos

1. **Usuario interactúa con una página**

   - Ejemplo: `pages/sales/POSPage.js`

2. **La página usa componentes**

   - Ejemplo: `components/sales/CartItem.js`

3. **Los componentes acceden al estado global**

   - Ejemplo: `context/CartContext.js`

4. **Los servicios manejan llamadas API**
   - Ejemplo: `services/salesService.js`

## 🛠 Convenciones

1. **Nombrado:**

   - Componentes: PascalCase (ej: `ProductCard.js`)
   - Funciones/hooks: camelCase (ej: `useCart`)
   - Constantes: SNAKE_CASE (ej: `MAX_ITEMS`)

2. **Imports:**

   ```javascript
   // Primero externos
   import React from "react";
   import axios from "axios";

   // Luego contextos
   import { useAuth } from "context/AuthContext";

   // Luego componentes
   import { Button } from "components/common";

   // Finalmente utils
   import { formatCurrency } from "utils/formatters";
   ```

3. **Estilos:**
   - CSS modular para evitar conflictos
   - Variables CSS para temas consistentes

## 🔒 Seguridad

1. **Autenticación:**

   - JWT almacenado en localStorage
   - Refresh token para sesiones largas
   - Rutas protegidas por rol

2. **Datos Sensibles:**
   - No almacenar información sensible en estado
   - Limpiar estado al logout

## 🔄 Ciclo de Desarrollo

1. Crear componente en carpeta apropiada
2. Implementar lógica de negocio en servicios
3. Conectar con estado global si necesario
4. Implementar página usando componentes
5. Añadir validaciones y manejo de errores

## 📝 Notas Importantes

- Esta estructura puede evolucionar según necesidades
- Mantener componentes pequeños y enfocados
- Documentar cambios significativos
- Seguir principios SOLID

## 🚀 Próximos Pasos

1. Implementar estructura base
2. Configurar rutas principales
3. Implementar autenticación (Sprint 1)
4. Seguir con módulos según sprints
