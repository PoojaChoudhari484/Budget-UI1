
# Use an official Node.js runtime as a parent image
FROM node:22-alpine AS node_build

WORKDIR /app

RUN touch /app/app-settings.js

COPY package*.json .

RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build

# Stage 2: Create the WAR file using Java build tool (Maven in this example)
FROM maven:3.8-jdk-11 AS java_build

WORKDIR /app1

COPY --from=node_build /app/dist/browser/ /app1

# Add your Maven build instructions here to create the WAR file
#RUN cd /app1/

RUN  jar -cvf bluealgoAppDev.war .

FROM tomcat:8.5

COPY --from=java_build /app1/bluealgoAppDev.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]


