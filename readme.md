Project Overview

TaskFlowX is a production-style 3-tier microservices application designed for DevOps learning and deployment workflows.

This includes:

1. Python Authentication Service (FastAPI)
2. Java Task Management Service (Spring Boot)
3. PostgreSQL Database
4. REST APIs
5. Environment Variable Support
6. Health Check Endpoints
7. Clean Folder Structure



For Spring Boot, common endpoints may look like:
http://localhost:8081/tasks
http://localhost:8081/api/tasks

For FastAPI:
http://localhost:8080/docs

To make it easier I have asked AI to create front end for this app and then to remove all the manual work I have created a bash script to create all the folders & files and add code to it. So simply run frontend.sh

./frontend.sh