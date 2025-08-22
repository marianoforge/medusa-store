#!/bin/bash
set -e

echo "🚀 Iniciando setup de producción..."

echo "📦 Intentando migraciones completas..."
NODE_ENV=production npx @medusajs/cli db:migrate || {
    echo "⚠️ Migraciones fallaron, continuando..."
}

echo "🌱 Intentando seed completo..."
NODE_ENV=production yarn seed || {
    echo "⚠️ Seed falló, continuando..."
}

echo "✅ Setup de producción completado (con warnings)"
