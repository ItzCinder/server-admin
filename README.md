# Server Admin - Documentación

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

- **sysadmin**: administración general del servidor y tareas de alto privilegio.
- **webadmin**: administración de componentes relacionados con la aplicación web.
- **dbadmin**: administración de la base de datos.
- **backup**: operación y mantenimiento de respaldos.
- **audit**: revisión y auditoría del entorno.
- **users**: cuenta de uso general y estándar.
- **scriptdev**: desarrollo y mantenimiento de scripts de automatización.


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