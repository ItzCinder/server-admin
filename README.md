# Nuva PanelSRV - Documentación

<details>
<summary>Índice de contenidos</summary>

- [1. Descripción general](#1-descripción-general)
- [2. Funcionalidades](#2-funcionalidades)
- [3. Estructura](#3-estructura)
- [4. Arquitectura](#4-arquitectura)
- [5. Menú principal](#5-menu-principal)
- [6. Gestión de usuarios](#6-gestión-de-usuarios)
  - [6.1 Crear usuario](#61-crear-usuario)
  - [6.2 Modificar usuario](#62-modificar-usuario)
  - [6.3 Eliminar usuario](#63-eliminar-usuario)
- [7. Gestión de grupos](#7-gestión-de-grupos)
  - [7.1 Crear grupo](#71-crear-grupo)
  - [7.2 Modificar grupo](#72-modificar-grupo)
  - [7.3 Eliminar grupo](#73-eliminar-grupo)
  - [7.4 Asignar grupo a usuario](#74-asignar-grupo-a-usuario)
- [8. Consultas del sistema](#8-consultas-del-sistema)
  - [8.1 Consultar usuarios](#81-consultar-usuarios)
  - [8.2 Consultar usuarios del sistema](#82-consultar-usuarios-del-sistema)
  - [8.3 Consultar grupos](#83-consultar-grupos)
  - [8.4 Consultar grupos del sistema](#84-consultar-grupos-del-sistema)
- [9. Provisionamiento](#9-provisionamiento)
  - [9.1 Preparación de usuarios](#91-preparación-de-usuarios)
  - [9.2 Grupos creados](#92-grupos-creados)
  - [9.3 Usuarios creados](#93-usuarios-creados)
  - [9.4 Roles y responsabilidades](#94-roles-y-responsabilidades)
  - [9.5 Provisionamiento de respaldos en cron](#95-provisionamiento-de-respaldos-en-cron)
- [10. Menús interactivos](#10-menús-interactivos)
  - [10.1 users_menu.sh](#101-users_menush)
  - [10.2 groups_menu.sh](#102-groups_menush)
  - [10.3 query_menu.sh](#103-query_menush)
  - [10.4 provisioning_menu.sh](#104-provisioning_menush)

</details>

## 1. Descripción general
Panel de administración de servidor desarrollado en Bash como parte del Proyecto Nuva. Su objetivo es facilitar la gestión administrativa del servidor que alojará la plataforma web de Gestión Deportiva Modular mediante un menú interactivo.

## 2. Funcionalidades
- Gestionar usuarios
- Gestionar grupos
- Consultar usuarios y grupos del sistema
- Panel de provisionamiento

## 3. Estructura

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
│   ├── setup_users.sh
│   └── setup_backups_cron.sh
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

## 4. Arquitectura
> El panel esta organizado con los siguientes modulos.

1. **Gestión de usuarios**
2. **Gestión de grupos**
3. **Consultas del sistema**
4. **Provisionamiento**

El archivo `start.sh` actúa como punto de entrada y muestra un menú principal que redirige a los submenús de cada módulo.

## 5. Menu Principal
El menú principal ofrece estas opciones:

- Gestionar usuarios
- Gestionar grupos
- Consultar grupos/usuarios
- Panel de provisionamiento
- Salir

## 6. Gestión de usuarios

### 6.1 Crear usuario
Este módulo permite administrar cuentas locales del sistema.

Script: `scripts/users/create_user.sh`

Funcionamiento:

- Verifica si el usuario ya existe.
- Solicita nombre de usuario.
- Pide y confirma contraseña.
- Crea el usuario con shell `/bin/bash`.
- Asigna la contraseña mediante `chpasswd`.

### 6.2 Modificar usuario

Script: `scripts/users/edit_user.sh`

Funcionamiento:

- Verifica que el usuario exista.
- Comprueba que no tenga procesos activos.
- Permite renombrar el usuario.
- Opcionalmente renombra también la carpeta `/home`.

### 6.3 Eliminar usuario

Script: `scripts/users/delete_user.sh`

Funcionamiento:

- Verifica que el usuario exista.
- No permite eliminar usuarios con procesos activos.
- Permite conservar o eliminar la carpeta personal `/home`.
- Solicita confirmación antes de ejecutar el borrado.

## 7. Gestión de grupos

Este módulo permite administrar grupos locales del sistema.

### 7.1 Crear grupo

Script: `scripts/groups/create_group.sh`

Funcionamiento:

- Verifica si el grupo ya existe.
- Permite definir un GID personalizado.
- Si no se indica GID, el sistema asigna uno automáticamente.
- Muestra información del grupo creado.

### 7.2 Modificar grupo

Script: `scripts/groups/edit_group.sh`

Funcionamiento:

- Verifica que el grupo exista.
- Cambia el nombre del grupo.

### 7.3 Eliminar grupo

Script: `scripts/groups/delete_group.sh`

Funcionamiento:

- Verifica que el grupo exista.
- Comprueba si es grupo primario de algún usuario.
- Advierte si hay usuarios que podrían perder el grupo secundario.
- Solicita confirmación antes de eliminarlo.

### 7.4 Asignar grupo a usuario

Script: `scripts/groups/assign_group.sh`

Funcionamiento:

- Verifica que el usuario exista.
- Verifica que el grupo exista.
- Comprueba si el usuario ya pertenece al grupo.
- Permite asignar el grupo como:
  - grupo secundario
  - grupo primario
 
## 8. Consultas del sistema

Este módulo permite listar usuarios y grupos desde los archivos del sistema.

### 8.1 Consultar usuarios

Script: `scripts/query/query_users.sh`

- Muestra usuarios normales.
- Excluye cuentas del sistema.
- Usa `/etc/passwd` para mostrar los usuarios.

### 8.2 Consultar usuarios del sistema

Script: `scripts/query/query_users_sys.sh`

- Muestra todos los usuarios.
- Incluye cuentas de servicio y del sistema.
- Usa `/etc/passwd` para mostrar los usuarios.

### 8.3 Consultar grupos

Script: `scripts/query/query_groups.sh`

- Muestra grupos normales.
- Excluye grupos del sistema.
- Usa `/etc/group` para mostrar los grupos.

### 8.4 Consultar grupos del sistema

Script: `scripts/query/query_groups_sys.sh`

- Muestra todos los grupos.
- Incluye grupos de servicio y del sistema.
- Usa `/etc/group` para mostrar los grupos.

## 9. Provisionamiento

El módulo de provisionamiento contiene scripts para la configuracion inicial del servidor para el despliegue del Proyecto Nuva.

### 9.1 Preparación de usuarios

Script: `scripts/provisioning/setup_users.sh`
> Este script automatiza la creación inicial de identidades necesarias para el servidor.

- Crea grupos necesarios para el servidor.
- Crea usuarios necesarios para el servidor, asignando tambien su tipo de shell y si posee sudo dependiendo de responsabilidades.

### 9.2 Grupos creados

- `sysadmin`
- `webadmin`
- `dbadmin`
- `backup`
- `audit`
- `users`
- `scriptdev`

### 9.3 Usuarios creados


| Usuario | Grupo primario | Shell | Descripción | Privilegios |
|---|---|---|---|---|
| `admin` | `sysadmin` | `/bin/bash` | Administrador del sistema | Sudo |
| `webadmin` | `webadmin` | `/bin/bash` | Administrador web | Sin sudo |
| `dbadmin` | `dbadmin` | `/bin/bash` | Administrador de base de datos | Sin sudo |
| `backupop` | `backup` | `/bin/bash` | Operador de respaldos | Sin sudo |
| `auditor` | `audit` | `/usr/bin/rbash` | Auditor | Shell restringida |
| `user` | `users` | `/bin/bash` | Usuario estándar | Sin sudo |
| `scriptdev` | `scriptdev` | `/bin/bash` | Desarrollador de scripts | Sin sudo |

### 9.4 Roles y responsabilidades

- **sysadmin**: Administra todo el servidor, instala paquetes, crea usuarios, configura servicios y resuelve problemas.
- **webadmin**: Gestiona el servidor web, ejecuta aplicaciones y administra los archivos del sitio web.
- **dbadmin**: Administra MySQL, crea base de datos, usuarios y hace respaldos.
- **backup**: Ejecuta y verifica copias de seguridad y restauraciones.
- **audit**: Revisa registros del sistema y verifica eventos de seguridad sin modificar configuraciones.
- **users**: Tiene acceso al servidor solo para tareas especificas (por ejemplo, desarrollo o mantenimiento limitado).
- **scriptdev**: Desarrolla, prueba y mantiene scripts de automatización para el servidor.

### 9.5 Provisionamiento de respaldos en cron

El script `scripts/provisioning/setup_backups_cron.sh` instala las tareas programadas en el crontab del usuario `backupop`:

| Respaldo | Programación |
|---|---|
| Base de datos diaria | Todos los días a las 23:00 |
| Base de datos full semanal | Domingos a las 02:00 |
| Repositorios diferencial | Lunes a viernes a las 20:00 |
| Repositorios full | Sábados a la 01:00 |
| Configuraciones full | Domingos a las 03:00 |
| Logs y evidencias diferencial | Todos los días a las 23:30 |
| Logs y evidencias full | Día 1 de cada mes a las 04:00 |

Ejecutar como administrador:

```bash
sudo bash scripts/provisioning/setup_backups_cron.sh
```

El bloque administrado se reemplaza de forma idempotente y las entradas de cron ajenas al proyecto se conservan. Para instalar los jobs en otro usuario, usar `BACKUP_USER=usuario`; para una ruta desplegada diferente, usar `PROJECT_DIR=/ruta/server-admin`.

## 10. Menús interactivos

Los menús del directorio `scripts/menus/` integran todo el flujo del panel.

### 10.1 users_menu.sh

Menú de administración de usuarios.

### 10.2 groups_menu.sh

Menú de administración de grupos.

### 10.3 query_menu.sh

Menú de consultas del sistema.

### 10.4 provisioning_menu.sh

Menú del módulo de aprovisionamiento.