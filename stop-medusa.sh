#!/bin/bash

# Script para detener todos los servicios de Medusa
# Autor: Script de parada para Medusa E-commerce
# Uso: ./stop-medusa.sh

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
        print_error "Docker no está corriendo."
        exit 1
    fi
}

# Función para verificar si hay servicios corriendo
check_running_services() {
    if ! docker compose ps -q | grep -q .; then
        print_warning "No hay servicios de Medusa corriendo."
        exit 0
    fi
}

# Función para detener servicios
stop_services() {
    print_status "Deteniendo servicios de Medusa..."
    
    # Detener todos los servicios
    docker compose down
    
    print_success "Todos los servicios han sido detenidos"
}

# Función para mostrar estado final
show_final_status() {
    print_status "Estado final de los servicios:"
    docker compose ps
}

# Función principal
main() {
    echo "🛑 Script de Parada de Medusa E-commerce"
    echo "========================================="
    echo ""
    
    # Verificaciones previas
    check_docker
    check_running_services
    
    # Detener servicios
    stop_services
    
    # Mostrar estado final
    show_final_status
    
    print_success "¡Servicios detenidos correctamente! 👋"
}

# Función de ayuda
show_help() {
    echo "Uso: $0"
    echo ""
    echo "Este script detiene todos los servicios de Medusa:"
    echo "  - PostgreSQL"
    echo "  - Redis"
    echo "  - Medusa Backend"
    echo ""
    echo "Para volver a arrancar: ./start-medusa.sh"
}

# Manejo de argumentos
case "$1" in
    --help|-h)
        show_help
        exit 0
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
