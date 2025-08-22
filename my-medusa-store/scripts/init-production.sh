#!/bin/bash
set -e

echo "🚀 Iniciando setup de producción..."

echo "📦 Ejecutando migraciones..."
npx @medusajs/cli db:migrate || {
    echo "❌ Error en migraciones, intentando db:setup..."
    npx @medusajs/cli db:setup || {
        echo "❌ db:setup falló, continuando sin migraciones..."
    }
}

echo "🌱 Ejecutando seed..."
yarn seed || {
    echo "❌ Seed falló, continuando sin datos iniciales..."
}

echo "✅ Setup de producción completado"
