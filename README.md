## TP: 01/02/2021: Docker

**Database:**
> ​ **Why do we need a volume to be attached to our postgres container ?**

If we don't do that, it's impossible to make the database persistent. the volume to the docker container to transfer the modifications from the database to the host. This volume is then used during a redeployment

> **Why do we need a multistage build ?**

To avoid having too heavy a docker image as well as to avoid transmitting unnecessary environments

> **Why do we need a reverse proxy ?**
> 
the reverse proxy allows to redirect requests to the API

>  **Why is docker-compose so important ?**

Docker compose allows you to orchestrate the different builds for a requested configuration.

> **Why do we put our images into an online repository ?**

To publish your project




# TP 01/02/2021: CI/CD
## Sample application
just do: 
`docker-compose up -d --build`

## Build and test your application

> You need to launch this command from your pom.xml directory or specify the path to it with --file /path/to/pom.xml ​argument.
   **Ok, what is this supposed to do ?**

 - The description of a project is made in an XML file named POM (Project Object Model). This description contains in particular the dependencies, the construction specifics (compilation and packaging), possibly the deployment, the generation of the documentation, the execution of static code analysis tools, etc.

>This command will actually clear your previous builds inside your cache (otherwise your can have unexpected behavior because maven did not build again each part of your application), then it will freshly build each module inside your application and finally it will run both ​Unit Tests​ and ​Integration Tests​ (sometime called Component Tests as well).
    **Unit tests ? Component test ?**

- A unit test makes it possible to test a precise function while the integration tests make it possible to test the whole process from end to end.
they are important because they constitute an important safeguard during the evolution of the application and avoid bugging features that worked previously.


> As you can see, there is a testcontainers dependency inside the pom.
	**What are testcontainers?**

 - Testcontainers is a Java library that supports JUnit tests, providing lightweight, throwaway instances of common databases, Selenium web browsers, or anything else that can run in a Docker container. -->  https://www.testcontainers.org/

> The docker-compose will handle the three containers and a network for
> us.
**What does the default java and node.js travis images do?**


## First steps into the CD world

> Here we are going to configure the Continuous Delivery of our project.
> Therefore, the main goal will be to create and save a docker image
> containing our application on the Docker Hub every time there is a
> commit on a develop branch.
>     
>     **Why do we need this branch ?**

When there is a commit on the branch, by default the travis pipeline is started. it is currently the master branch. We could specify, depending on the type of branch, which jobs to launch


Create new develop branch:
on vscode:

    git fetch origin
    git checkout -b "develop" "origin/develop"'


> Add your docker hub credentials to the environment variables in Travis
> CI (and let them be secured).
> 
>  **Secured variables, why ?**

In order to allow the travis runner to push on docker hub, he needs his own access. This allows you to be more secure and to know who is pushing.


# TP 03/02/2021: Ansible
## Intro

> **What’s up with the /api/actuator endpoint? What could it be used for?**

Actuator is a sprint-boot service allowing you to monitor your application
https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html#production-ready-enabling

> **what is $basearch?**
> 
You can use $**basearch** to reference the base architecture of the system. For example, i686 machines have a base architecture of i386 , and AMD64 and Intel 64 machines have a base architecture of x86_64 .

This allows whatever the machine, to deploy with the right base of architecture