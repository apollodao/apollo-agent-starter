FROM node:23-bullseye

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    build-essential \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev \
    && rm -rf /var/lib/apt/lists/* # Clean up apt cache

# Set environment variables
ENV CI=false
ENV NIXPACKS_PATH=/app/node_modules/.bin:$NIXPACKS_PATH
ENV NODE_ENV=production

# Copy package files first
COPY package.json pnpm-lock.yaml ./

# Install pnpm and dependencies
RUN npm install -g pnpm && \
    pnpm install --frozen-lockfile --prod

# Copy the rest of your application code
COPY . .

# Build your application
RUN pnpm run build

# Use tini as init process
RUN apt-get update && apt-get install -y tini && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/bin/tini", "--"]

# Start your application with proper signal handling
CMD ["node", "--max-old-space-size=4096", "dist/index.js"]