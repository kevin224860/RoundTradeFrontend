# Stage 1: Build the Vue application
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

ARG VUE_APP_URL
ENV VUE_APP_URL=${VUE_APP_URL}

ARG VUE_APP_LOGIN
ENV VUE_APP_LOGIN=${VUE_APP_LOGIN}

ARG VUE_APP_SIGNUP
ENV VUE_APP_SIGNUP=${VUE_APP_SIGNUP}

ARG VUE_APP_DASHBOARD
ENV VUE_APP_DASHBOARD=${VUE_APP_DASHBOARD}

ARG VUE_APP_PORTFOLIO
ENV VUE_APP_PORTFOLIO=${VUE_APP_PORTFOLIO}

ARG NODE_ENV
ENV NODE_ENV=${NODE_ENV}

# Build the application
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM nginx:stable-alpine

# Remove default Nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy built Vue app from the previous stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]

