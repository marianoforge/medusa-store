# Medusa v2 requiere Node 20+
FROM node:20-alpine

# Recomendado usar /server para evitar conflictos con el Admin
WORKDIR /server

# Instala dependencias primero (mejor cache)
COPY package.json yarn.lock* package-lock.json* ./
# Usa el gestor que prefieras; por defecto el starter trae yarn.lock
RUN corepack enable && corepack prepare yarn@1.22.19 --activate || true \
 && yarn install --frozen-lockfile || npm ci

# Copia el resto del código
COPY . .

EXPOSE 9001

# Arranca en modo dev (hot reload)
CMD ["yarn", "dev"]