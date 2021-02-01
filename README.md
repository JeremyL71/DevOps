## TP: 01/02/2021: Docker

**Database:**
*Why should we run the container with a flag -e to give the environment variables ?*

 1. When creating the container, the environment variables are not automatically transmitted (due to isolation). There are several ways to pass variables to the docker container: https://docs.docker.com/compose/environment-variables/