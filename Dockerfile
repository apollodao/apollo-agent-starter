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
    # Additional dependencies for @discordjs/opus
    libopus-dev \
    ffmpeg

# Set environment variables
ENV CI=false
ENV NIXPACKS_PATH=/app/node_modules/.bin:$NIXPACKS_PATH
ENV NODE_ENV=production

# Copy package.json and pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

# Install pnpm
RUN npm install -g pnpm

# Install dependencies with additional flags for better compatibility
RUN pnpm install --frozen-lockfile --unsafe-perm

# Copy the rest of your application code
COPY . .

# Build your application
RUN pnpm run build

# Start your application
CMD ["pnpm", "start"]