# Use an official Nginx runtime as a base image
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the built HTML file to nginx directory
COPY index.html /usr/share/nginx/html/

# Copy the APK file to be available for download
COPY pennyLog.apk /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]