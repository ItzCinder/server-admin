# Server Admin

Panel de administración de servidor desarrollado en Bash como parte del Proyecto Nuva. Su objetivo es facilitar la gestión administrativa del servidor que alojará la plataforma web de Gestión Deportiva Modular mediante un menú interactivo.

## Funcionalidades
- Gestionar usuarios
- Gestionar grupos
- Consultar usuarios y grupos del sistema
- Panel de provisionamiento

## Estructura del proyecto

```
start.sh
scripts/
├── colors.sh
├── groups/
│   ├── assign_group.sh
│   ├── create_group.sh
│   ├── delete_group.sh
│   └── edit_group.sh
├── menus/
│   ├── groups_menu.sh
│   ├── provisioning_menu.sh
│   ├── query_menu.sh
│   └── users_menu.sh
├── provisioning/
│   └── setup_users.sh
├── query/
│   ├── query_groups.sh
│   ├── query_groups_sys.sh
│   ├── query_users.sh
│   └── query_users_sys.sh
└── users/
    ├── create_user.sh
    ├── delete_user.sh
    └── edit_user.sh
```

## Estructura de directorios

### scripts/
Contiene todos los scripts del panel de administración.

#### users/
Scripts relacionados con la administración de usuarios.

#### groups/
Scripts relacionados con la administración de grupos.

#### query/
Scripts destinados a consultas del sistema.

#### provisioning/
Scripts de aprovisionamiento del servidor.

#### menus/
Menús interactivos del panel.

---

## Archivos principales
- Archivos principales escenciales para correr el panel completo.

### start.sh
Punto de entrada del panel de administración.

### scripts/colors.sh
Define los colores utilizados por la interfaz.

---

## Administración de usuarios
- Modulo encargado de la administración de usuarios del sistema.

### create_user.sh
Permite crear usuarios.

### edit_user.sh
Permite modificar el nombre de un usuario.

### delete_user.sh
Permite eliminar un usuario y, opcionalmente, su directorio personal.

---

## Administración de grupos
- Modulo encargado de la administración de grupos del sistema.

### create_group.sh
Crea grupos.

### edit_group.sh
Modifica el nombre de un grupo.

### delete_group.sh
Elimina un grupo.

### assign_group.sh
Asigna grupos a usuarios.

---

## Consultas
- Modulo encargado de los scripts relacionados a consultas de información acerca del entorno.

### query_users.sh
Consulta usuarios (sin incluir servicios y de Linux).

### query_users_sys.sh
Consulta todos los usuarios (incluyendo de servicios y de Linux).

### query_groups.sh
Consulta grupos (sin incluir servicios y de Linux).

### query_groups_sys.sh
Consulta todos los grupos (incluyendo de servicios y de Linux).

---

## Provisionamiento
- El modulo de provisionamiento es la encargada de ejecutar scripts encargados de la preparación del entorno para el despliegue de la plataforma web.

### setup_users.sh
Realiza el aprovisionamiento inicial de usuarios y grupos.

---

## Menús
- El directorio de menús contiene los scripts de menús interactivos que permiten la integración de todos los modulos.

### users_menu.sh
Menú de administración de usuarios.

### groups_menu.sh
Menú de administración de grupos.

### query_menu.sh
Menú de consultas.

### provisioning_menu.sh
Menú del módulo de aprovisionamiento.