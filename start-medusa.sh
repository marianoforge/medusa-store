#!/bin/bash

# Script para arrancar todos los servicios de Medusa
# Autor: Script de inicio para Medusa E-commerce
# Uso: ./start-medusa.sh

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
    echo -e "${RED}[ERROR]${NC} $1"
}

# Función para verificar si Docker está corriendo
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker no está corriendo. Por favor inicia Docker Desktop primero."
        exit 1
    fi
    print_success "Docker está corriendo"
}

# Función para verificar si Docker Compose está disponible
check_docker_compose() {
    if ! command -v docker compose &> /dev/null; then
        print_error "Docker Compose no está disponible. Por favor instálalo primero."
        exit 1
    fi
    print_success "Docker Compose está disponible"
}

# Función para limpiar contenedores anteriores si existen
cleanup_previous() {
    if docker compose ps -q | grep -q .; then
        print_warning "Detectados contenedores anteriores. Limpiando..."
        docker compose down
        print_success "Contenedores anteriores limpiados"
    fi
}

# Función para arrancar los servicios
start_services() {
    print_status "Arrancando servicios de Medusa..."
    
    # Arrancar PostgreSQL primero
    print_status "Iniciando PostgreSQL..."
    docker compose up postgres -d
    sleep 5  # Esperar a que PostgreSQL esté listo
    
    # Arrancar Redis
    print_status "Iniciando Redis..."
    docker compose up redis -d
    sleep 3
    
    # Arrancar Medusa backend
    print_status "Iniciando Medusa Backend..."
    docker compose up medusa -d
    
    print_success "Todos los servicios han sido iniciados"
}

# Función para verificar el estado de los servicios
check_services_status() {
    print_status "Verificando estado de los servicios..."
    
    # Esperar un poco para que los servicios se estabilicen
    sleep 10
    
    # Verificar estado
    if docker compose ps | grep -q "Up"; then
        print_success "Servicios corriendo correctamente"
        echo ""
        echo "📊 Estado de los servicios:"
        docker compose ps
        echo ""
        echo "🌐 URLs de acceso:"
        echo "   Admin Dashboard: http://localhost:9001/app"
        echo "   API Store:      http://localhost:9001/store"
        echo "   API Admin:      http://localhost:9001/admin"
        echo ""
        echo "📝 Para ver logs: docker compose logs -f"
        echo "🛑 Para detener:  docker compose down"
    else
        print_error "Algunos servicios no están corriendo correctamente"
        docker compose ps
        exit 1
    fi
}

# Función para mostrar logs si se solicita
show_logs() {
    if [[ "$1" == "--logs" ]]; then
        print_status "Mostrando logs de Medusa..."
        docker compose logs -f medusa
    fi
}

# Función principal
main() {
    echo "🚀 Script de Inicio de Medusa E-commerce"
    echo "=========================================="
    echo ""
    
    # Verificaciones previas
    check_docker
    check_docker_compose
    
    # Limpiar contenedores anteriores
    cleanup_previous
    
    # Arrancar servicios
    start_services
    
    # Verificar estado
    check_services_status
    
    # Mostrar logs si se solicita
    if [[ "$1" == "--logs" ]]; then
        show_logs "$1"
    fi
    
    print_success "¡Medusa está listo para usar! 🎉"
}

# Función de ayuda
show_help() {
    echo "Uso: $0 [OPCIONES]"
    echo ""
    echo "Opciones:"
    echo "  --logs     Mostrar logs de Medusa después del inicio"
    echo "  --help     Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0              # Arrancar servicios normalmente"
    echo "  $0 --logs      # Arrancar y mostrar logs"
    echo "  $0 --help      # Mostrar ayuda"
}

# Manejo de argumentos
case "$1" in
    --help)
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
