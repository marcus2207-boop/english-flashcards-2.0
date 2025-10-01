# Dockerfile for Frontend (React + Vite)
# Location: docker/frontend/Dockerfile
FROM node:18-alpine AS build

WORKDIR /app

# Install dependencies
COPY ./frontend/package.json ./frontend/package-lock.json* ./
RUN npm ci

# Copy source and build
COPY ./frontend/ ./
RUN npm run build

# Serve static files with a lightweight server (caddy/nginx) - using nginx
FROM nginx:stable-alpine AS runtime
COPY --from=build /app/dist /usr/share/nginx/html
# Optional: custom nginx.conf can be added to enable SPA fallback
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]