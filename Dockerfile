################################################################################
# STAGE 1: Build Stage
# This stage installs ALL dependencies (including devDependencies) and prepares
# the application files. This stage will be discarded in the final image.
################################################################################
FROM node:22-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies (including dev dependencies)
RUN npm ci

# Copy all source code
COPY . .

################################################################################
# STAGE 2: Production Stage
# This stage creates the final lightweight image with only production
# dependencies and necessary application files from the build stage.
################################################################################
FROM node:22-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy all application code from builder stage
# (excluding node_modules since we installed fresh production deps above)
COPY --from=builder /app .

# Expose the application port
EXPOSE 3333

# Start the application
CMD ["node", "src/server.ts"]