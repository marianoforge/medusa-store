#!/bin/bash

# Script principal de gestión para Medusa E-commerce
# Autor: Script principal para Medusa E-commerce
# Uso: ./medusa.sh [COMANDO] [OPCIONES]

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Función para imprimir con colores
print_header() {
    echo -e "${MAGENTA}$1${NC}"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Función para mostrar el banner
show_banner() {
    echo ""
    print_header "🛍️  MEDUSA E-COMMERCE MANAGEMENT SCRIPT"
    echo "=================================================="
    echo ""
}

# Función para mostrar la ayuda principal
show_main_help() {
    show_banner
    echo "Uso: $0 [COMANDO] [OPCIONES]"
    echo ""
    echo "Comandos disponibles:"
    echo ""
    echo "  ${CYAN}start${NC}     Arrancar todos los servicios"
    echo "  ${CYAN}stop${NC}      Detener todos los servicios"
    echo "  ${CYAN}status${NC}    Ver estado de los servicios"
    echo "  ${CYAN}restart${NC}   Reiniciar todos los servicios"
    echo "  ${CYAN}logs${NC}      Ver logs de los servicios"
    echo "  ${CYAN}shell${NC}     Acceder al shell del contenedor Medusa"
    echo "  ${CYAN}seed${NC}      Ejecutar script de seeding de datos"
    echo "  ${CYAN}help${NC}      Mostrar esta ayuda"
    echo ""
    echo "Opciones adicionales:"
    echo "  --logs     Mostrar logs después de arrancar (para start)"
    echo "  --logs     Mostrar logs recientes (para status)"
    echo ""
    echo "Ejemplos:"
    echo "  $0 start              # Arrancar servicios"
    echo "  $0 start --logs      # Arrancar y mostrar logs"
    echo "  $0 status            # Ver estado"
    echo "  $0 status --logs     # Ver estado y logs"
    echo "  $0 stop              # Detener servicios"
    echo "  $0 restart           # Reiniciar servicios"
    echo "  $0 logs              # Ver logs en tiempo real"
    echo "  $0 shell             # Acceder al shell"
    echo "  $0 seed              # Ejecutar seeding"
    echo ""
    echo "Para más información sobre un comando específico:"
    echo "  $0 [comando] --help"
}

# Función para ejecutar comandos
execute_command() {
    local command="$1"
    local options="$2"
    
    case "$command" in
        start)
            ./start-medusa.sh $options
            ;;
        stop)
            ./stop-medusa.sh $options
            ;;
        status)
            ./status-medusa.sh $options
            ;;
        restart)
            print_header "🔄 Reiniciando servicios..."
            ./stop-medusa.sh
            sleep 2
            ./start-medusa.sh $options
            ;;
        logs)
            print_header "📝 Mostrando logs en tiempo real..."
            docker compose logs -f
            ;;
        shell)
            print_header "🐚 Accediendo al shell del contenedor Medusa..."
            docker exec -it medusa_backend bash
            ;;
        seed)
            print_header "🌱 Ejecutando script de seeding..."
            docker exec -it medusa_backend yarn seed
            ;;
        help|--help|-h)
            show_main_help
            exit 0
            ;;
        "")
            show_main_help
            exit 0
            ;;
        *)
            print_error "Comando desconocido: $command"
            echo ""
            show_main_help
            exit 1
            ;;
    esac
}

# Función principal
main() {
    local command="$1"
    local options="$2"
    
    # Verificar que los scripts existan
    if [[ ! -f "start-medusa.sh" ]] || [[ ! -f "stop-medusa.sh" ]] || [[ ! -f "status-medusa.sh" ]]; then
        print_error "Scripts de gestión no encontrados. Asegúrate de estar en el directorio correcto."
        exit 1
    fi
    
    # Ejecutar comando
    execute_command "$command" "$options"
}

# Ejecutar script principal
main "$1" "$2"
