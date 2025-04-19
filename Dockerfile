# Use Node.js Alpine base image
FROM --platform=$BUILDPLATFORM node:23-alpine3.20 AS build

# Create and set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json /app/

# Install dependencies
RUN npm install

# Copy the entire codebase to the working directory
FROM --platform=$BUILDPLATFORM node:23-alpine3.20 AS runtime
WORKDIR /app
COPY --from=build /app/ ./

# Expose the port your app runs on (replace <PORT_NUMBER> with your app's actual port)
EXPOSE 3000

# Define the command to start your application (replace "start" with the actual command to start your app)
CMD ["npm", "start"]

