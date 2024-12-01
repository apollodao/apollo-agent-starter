FROM node:23.1.0

# Install pnpm globally
RUN npm install -g pnpm@9.4.0

# Set the working directory
WORKDIR /app

# Add configuration files and install dependencies
ADD package.json /app/package.json
ADD .npmrc /app/.npmrc
ADD tsconfig.json /app/tsconfig.json
ADD pnpm-lock.yaml /app/pnpm-lock.yaml
RUN pnpm install --frozen-lockfile

# Add the environment variables
ADD scripts /app/scripts
ADD characters /app/characters

# Expose the port
EXPOSE 3000

# Start command
CMD ["pnpm", "start", "--character=characters/eliza.character.json"]