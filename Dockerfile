# Creating multi-stage build for production
FROM node:20-bullseye AS build

# Install necessary packages for building native modules like 'sharp'
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    autoconf \
    automake \
    zlib1g-dev \
    libpng-dev \
    libvips-dev \
    git \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY package.json package-lock.json ./

# Install node-gyp and dependencies for building native modules
RUN npm install -g node-gyp

# Install sharp without platform-specific flags, as Debian doesn't use musl
RUN npm install sharp

# Install all production dependencies
RUN npm config set fetch-retry-maxtimeout 600000 -g && npm install --only=production

ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .

# Build the project (Strapi in your case)
RUN npm run build

# Creating final production image
FROM node:20-bullseye

# Install runtime dependencies (libvips-dev for sharp)
RUN apt-get update && apt-get install -y libvips-dev && rm -rf /var/lib/apt/lists/*

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules

WORKDIR /opt/app
COPY --from=build /opt/app ./
ENV PATH=/opt/node_modules/.bin:$PATH

# Ensure correct file permissions
RUN chown -R node:node /opt/app
USER node

# Expose the Strapi port
EXPOSE 1337

# Start the Strapi server
CMD ["npm", "run", "start"]
