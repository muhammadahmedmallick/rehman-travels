# Multi-stage build for React CMS

# Stage 1: Build the React application
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install dependencies
RUN npm ci

# Cache-bust: when this ARG changes, the COPY+build layers below are invalidated.
# Pass with: --build-arg CACHEBUST=$(date +%s)
ARG CACHEBUST=1

# Copy source code
COPY . .

# Always start from a clean slate so a stale dist/ or vite cache can't bleed
# into the image. (dist is already in .dockerignore, this is belt-and-braces.)
RUN rm -rf dist node_modules/.vite && npm run build

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
