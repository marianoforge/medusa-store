# 🚀 Scripts de Gestión para Medusa E-commerce

Este directorio contiene scripts automatizados para gestionar fácilmente todos los servicios de tu tienda Medusa.

## 📁 Scripts Disponibles

### 1. `start-medusa.sh` - Arrancar Servicios
**Función**: Inicia todos los servicios de Medusa de forma automática y ordenada.

**Uso**:
```bash
./start-medusa.sh          # Arrancar normalmente
./start-medusa.sh --logs   # Arrancar y mostrar logs
./start-medusa.sh --help   # Mostrar ayuda
```

**Qué hace**:
- ✅ Verifica que Docker esté corriendo
- ✅ Limpia contenedores anteriores si existen
- ✅ Inicia PostgreSQL (espera a que esté listo)
- ✅ Inicia Redis
- ✅ Inicia Medusa Backend
- ✅ Verifica el estado de todos los servicios
- ✅ Muestra URLs de acceso

### 2. `stop-medusa.sh` - Detener Servicios
**Función**: Detiene todos los servicios de Medusa de forma segura.

**Uso**:
```bash
./stop-medusa.sh           # Detener servicios
./stop-medusa.sh --help    # Mostrar ayuda
```

**Qué hace**:
- ✅ Verifica que Docker esté corriendo
- ✅ Detiene todos los contenedores
- ✅ Muestra el estado final

### 3. `status-medusa.sh` - Ver Estado
**Función**: Muestra información detallada del estado de todos los servicios.

**Uso**:
```bash
./status-medusa.sh         # Ver estado básico
./status-medusa.sh --logs  # Ver estado y logs recientes
./status-medusa.sh --help  # Mostrar ayuda
```

**Qué muestra**:
- 📊 Estado de todos los servicios
- 🗄️ Información de PostgreSQL
- 🔴 Información de Redis
- 🛍️ Información de Medusa y URLs
- 💾 Uso de recursos del sistema
- 🛠️ Comandos útiles

## 🎯 Flujo de Trabajo Típico

### Para desarrollo diario:
```bash
# 1. Arrancar servicios
./start-medusa.sh

# 2. Verificar estado
./status-medusa.sh

# 3. Trabajar en tu tienda...

# 4. Detener servicios al terminar
./stop-medusa.sh
```

### Para debugging:
```bash
# Arrancar y ver logs en tiempo real
./start-medusa.sh --logs

# Ver estado con logs recientes
./status-medusa.sh --logs
```

## 🌐 URLs de Acceso

Una vez que los servicios estén corriendo:

- **Admin Dashboard**: http://localhost:9001/app
- **API Store**: http://localhost:9001/store
- **API Admin**: http://localhost:9001/admin

## 🔧 Comandos Manuales Útiles

Si prefieres usar comandos manuales:

```bash
# Arrancar servicios
docker compose up -d

# Ver estado
docker compose ps

# Ver logs
docker compose logs -f

# Ver logs de un servicio específico
docker compose logs -f medusa
docker compose logs -f postgres
docker compose logs -f redis

# Detener servicios
docker compose down

# Reiniciar servicios
docker compose restart

# Acceder al shell del contenedor
docker exec -it medusa_backend bash
```

## ⚠️ Requisitos Previos

- **Docker Desktop** debe estar corriendo
- **Docker Compose** debe estar instalado
- Los scripts deben tener permisos de ejecución (`chmod +x *.sh`)

## 🚨 Solución de Problemas

### Si los servicios no arrancan:
1. Verifica que Docker Desktop esté corriendo
2. Ejecuta `./status-medusa.sh` para diagnosticar
3. Revisa los logs con `docker compose logs -f`

### Si hay problemas de base de datos:
1. Detén todos los servicios: `./stop-medusa.sh`
2. Elimina volúmenes: `docker compose down -v`
3. Arranca de nuevo: `./start-medusa.sh`

### Si hay conflictos de puertos:
Verifica que los puertos 5433, 6380 y 9001 estén libres en tu sistema.

## 📝 Personalización

Puedes modificar los scripts para:
- Cambiar puertos
- Agregar más servicios
- Modificar timeouts
- Agregar notificaciones

## 🤝 Contribuciones

Si encuentras bugs o quieres mejorar los scripts, ¡las contribuciones son bienvenidas!

---

**¡Disfruta de tu tienda Medusa! 🛍️✨**
