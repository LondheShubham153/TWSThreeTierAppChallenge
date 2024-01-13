# Stage 1:

# Use the official Node.js 14 image as a base image
FROM node:14 AS backend

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install the application's dependencies inside the container
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Stage 2:

# Smaller NodeJS base image
FROM node:14-alpine

# Set Working Directory for the container
WORKDIR /usr/src/app

# Copy dependencies from Stage 1
COPY --from=backend /usr/src/app /usr/src/app

# Specify the command to run when the container starts
CMD [ "node", "index.js" ]
