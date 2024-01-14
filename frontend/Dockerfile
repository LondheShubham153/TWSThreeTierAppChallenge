# Stage 1: Build Stage
FROM node:14 as build
WORKDIR /usr/src/app

# Create a non-root user
RUN groupadd -g 1001 frontend && \
    useradd -u 1001 -g frontend -m -d /home/frontend -s /bin/sh frontend

# Copy only package.json and package-lock.json to leverage Docker cache
COPY package*.json ./

# Install the application's dependencies as the 'frontend' user
RUN chown -R frontend:frontend /usr/src/app
USER frontend

# Install the application's dependencies as the 'frontend' user
RUN npm install --quiet --no-progress --unsafe-perm=true --allow-root

# Copy the rest of the application code
COPY . .

# Stage 2: Production Stage
FROM node:14-alpine
WORKDIR /usr/src/app

# Copy only necessary files from the build stage
COPY --from=build /usr/src/app .

# Create a non-root user in the production stage
RUN addgroup -S frontend && adduser -S -G frontend -u 1001 frontend

# Switch to the non-root user
USER frontend

# Specify the command to run when the container starts
CMD [ "npm", "start" ]

