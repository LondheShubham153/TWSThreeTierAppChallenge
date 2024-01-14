# Stage 1: Build Stage
FROM node:14 AS build
WORKDIR /usr/src/app

# Copy only package.json and package-lock.json to leverage Docker cache
COPY package*.json ./

# Install the application's dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Stage 2: Production Stage
FROM node:14-alpine
WORKDIR /usr/src/app

# Copy only necessary files from the build stage
COPY --from=build /usr/src/app ./

# Create a non-root user and switch to it
RUN adduser -D backend
USER backend

# Specify the command to run when the container starts
CMD [ "node", "index.js" ]

