# ============================================
# STAGE 1: Dependencies (Builder Stage)
# ============================================
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Install build dependencies for native modules
RUN apk add --no-cache python3 make g++

# Copy package files first (better layer caching)
COPY package*.json ./

# Install ALL dependencies (including devDependencies for build)
RUN npm ci --only=production && \
    npm cache clean --force

# ============================================
# STAGE 2: Production Image
# ============================================
FROM node:18-alpine AS production

# Labels for container metadata
LABEL maintainer="junaidrao47" \
      version="1.0.0" \
      description="Node.js Redis MongoDB Application" \
      org.opencontainers.image.source="https://github.com/junaidrao47/labexamdevops"

# Set NODE_ENV to production
ENV NODE_ENV=production

# Create non-root user for security (best practice)
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Set working directory
WORKDIR /app

# Install runtime dependencies only (curl for healthcheck, dumb-init for proper signal handling)
RUN apk add --no-cache curl dumb-init

# Copy node_modules from builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy application source code
COPY --chown=nodejs:nodejs . .

# Remove unnecessary files from production image
RUN rm -rf tests/ docs/ .github/ .eslintrc.json eslint.config.cjs jest.config.js \
    *.md docker-compose*.yml .gitignore 2>/dev/null || true

# Switch to non-root user
USER nodejs

# Expose application port
EXPOSE 5000

# Health check configuration
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/api/health || exit 1

# Use dumb-init as PID 1 for proper signal handling
ENTRYPOINT ["dumb-init", "--"]

# Start the application
CMD ["node", "index.js"]