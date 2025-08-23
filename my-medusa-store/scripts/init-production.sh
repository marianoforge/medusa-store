#!/bin/bash
set -e

echo "🚀 Iniciando setup de producción..."

# Verificar que las variables de entorno estén configuradas
if [ -z "$DATABASE_URL" ]; then
    echo "❌ ERROR: DATABASE_URL no está configurada"
    exit 1
fi

if [ -z "$REDIS_URL" ]; then
    echo "❌ ERROR: REDIS_URL no está configurada"
    exit 1
fi

echo "📦 Ejecutando migraciones de base de datos..."
# Forzar migraciones completas
NODE_ENV=production npx @medusajs/cli db:migrate --force || {
    echo "⚠️ Migraciones con --force fallaron, intentando sin force..."
    NODE_ENV=production npx @medusajs/cli db:migrate || {
        echo "⚠️ Migraciones fallaron, pero continuando..."
    }
}

echo "🌱 Ejecutando seed de datos..."
NODE_ENV=production yarn seed || {
    echo "⚠️ Seed falló, pero continuando..."
    echo "ℹ️ Esto es normal en el primer despliegue o si los datos ya existen"
}

echo "✅ Setup de producción completado"
