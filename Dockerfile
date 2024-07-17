# Stage 1: Build the application
FROM ubuntu:20.04 AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs

# Set working directory
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/scotch-io/node-todo.git .

# Install dependencies
RUN npm install

# Stage 2: Run the application
FROM ubuntu:20.04

# Install Node.js
RUN apt-get update && apt-get install -y \
    curl \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs

# Set working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app .

# Install only production dependencies
RUN npm install --only=production

# Expose port
EXPOSE 8080

# Start the application
CMD ["npm", "start"]
