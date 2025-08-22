#!/bin/bash

# Script para verificar el estado de los servicios de Medusa
# Autor: Script de estado para Medusa E-commerce
# Uso: ./status-medusa.sh

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para imprimir con colores
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1
}

print_header() {
    echo -e "${CYAN}$1${NC}"
}

# Función para verificar si Docker está corriendo
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker no está corriendo. Por favor inicia Docker Desktop primero."
        exit 1
    fi
}

# Función para mostrar estado de los servicios
show_services_status() {
    print_header "📊 Estado de los Servicios"
    echo "=================================="
    
    if docker compose ps -q | grep -q .; then
        docker compose ps
        echo ""
    else
        print_warning "No hay servicios corriendo"
        echo ""
        return
    fi
}

# Función para mostrar información de la base de datos
show_database_info() {
    print_header "🗄️  Información de la Base de Datos"
    echo "=========================================="
    
    if docker compose ps postgres | grep -q "Up"; then
        echo "PostgreSQL está corriendo en puerto 5433"
        echo "Base de datos: medusa-store"
        echo "Usuario: postgres"
        echo ""
    else
        print_warning "PostgreSQL no está corriendo"
        echo ""
    fi
}

# Función para mostrar información de Redis
show_redis_info() {
    print_header "🔴 Información de Redis"
    echo "============================"
    
    if docker compose ps redis | grep -q "Up"; then
        echo "Redis está corriendo en puerto 6380"
        echo ""
    else
        print_warning "Redis no está corriendo"
        echo ""
    fi
}

# Función para mostrar información de Medusa
show_medusa_info() {
    print_header "🛍️  Información de Medusa"
    echo "==============================="
    
    if docker compose ps medusa | grep -q "Up"; then
        echo "Medusa Backend está corriendo en puerto 9001"
        echo ""
        echo "🌐 URLs de acceso:"
        echo "   Admin Dashboard: http://localhost:9001/app"
        echo "   API Store:      http://localhost:9001/store"
        echo "   API Admin:      http://localhost:9001/admin"
        echo ""
    else
        print_warning "Medusa Backend no está corriendo"
        echo ""
    fi
}

# Función para mostrar logs recientes
show_recent_logs() {
    if [[ "$1" == "--logs" ]]; then
        print_header "📝 Logs Recientes de Medusa"
        echo "================================="
        echo "Mostrando últimos 20 logs..."
        echo ""
        docker compose logs --tail=20 medusa
        echo ""
    fi
}

# Función para mostrar uso de recursos
show_resource_usage() {
    print_header "💾 Uso de Recursos"
    echo "======================"
    
    if docker compose ps -q | grep -q .; then
        echo "Contenedores activos:"
        docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
        echo ""
    fi
}

# Función para mostrar comandos útiles
show_useful_commands() {
    print_header "🛠️  Comandos Útiles"
    echo "========================"
    echo "Para arrancar servicios:    ./start-medusa.sh"
    echo "Para detener servicios:     ./stop-medusa.sh"
    echo "Para ver logs en tiempo real: docker compose logs -f"
    echo "Para ver logs de un servicio: docker compose logs -f [servicio]"
    echo "Para acceder al shell:      docker exec -it medusa_backend bash"
    echo "Para reiniciar servicios:   docker compose restart"
    echo ""
}

# Función principal
main() {
    echo "📋 Estado de Medusa E-commerce"
    echo "==============================="
    echo ""
    
    # Verificaciones previas
    check_docker
    
    # Mostrar información de servicios
    show_services_status
    show_database_info
    show_redis_info
    show_medusa_info
    
    # Mostrar uso de recursos
    show_resource_usage
    
    # Mostrar comandos útiles
    show_useful_commands
    
    # Mostrar logs si se solicita
    if [[ "$1" == "--logs" ]]; then
        show_recent_logs "$1"
    fi
    
    print_success "Verificación completada! ✅"
}

# Función de ayuda
show_help() {
    echo "Uso: $0 [OPCIONES]"
    echo ""
    echo "Opciones:"
    echo "  --logs     Mostrar logs recientes de Medusa"
    echo "  --help     Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0              # Ver estado básico"
    echo "  $0 --logs      # Ver estado y logs recientes"
    echo "  $0 --help      # Mostrar ayuda"
}

# Manejo de argumentos
case "$1" in
    --help|-h)
        show_help
        exit 0
        ;;
    --logs)
        main "$1"
        ;;
    "")
        main
        ;;
    *)
        print_error "Opción desconocida: $1"
        show_help
        exit 1
        ;;
esac
