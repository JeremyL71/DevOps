LAURENT_JEREMY et LOUIS_MORANDET
  

# TP: 01/02/2021: Docker

## Database

  

> ​ **Why do we need a volume to be attached to our postgres container ?**

  

If we don't do that, it's impossible to make the database persistent. the volume to the docker container to transfer the modifications from the database to the host. This volume is then used during a redeployment

----

>  **Why do we need a multistage build ?**

>

To avoid having too heavy a docker image as well as to avoid transmitting unnecessary environments

  

----

>  **Why do we need a reverse proxy ?**

  

the reverse proxy allows to redirect requests to the API

  

---

>  **Why is docker-compose so important ?**

  

Docker compose allows you to orchestrate the different builds for a requested configuration.

  

----

  

>  **Why do we put our images into an online repository ?**

  

To publish your project

# TP 02/02/2021: CI/CD

  

## Sample application

  

just do:

  

`docker-compose up -d --build`

  

## Build and test your application

  

> You need to launch this command from your pom.xml directory or specify the path to it with --file /path/to/pom.xml ​argument.

**Ok, what is this supposed to do ?**

  

The description of a project is made in an XML file named POM (Project Object Model). This description contains in particular the dependencies, the construction specifics (compilation and packaging), possibly the deployment, the generation of the documentation, the execution of static code analysis tools, etc.

  

---

  

>This command will actually clear your previous builds inside your cache (otherwise your can have unexpected behavior because maven did not build again each part of your application), then it will freshly build each module inside your application and finally it will run both ​Unit Tests​ and ​Integration Tests​ (sometime called Component Tests as well).

**Unit tests ? Component test ?**

  

A unit test makes it possible to test a precise function while the integration tests make it possible to test the whole process from end to end.

They are important because they constitute an important safeguard during the evolution of the application and avoid bugging features that worked previously.

  

---

  

> As you can see, there is a testcontainers dependency inside the pom.

**What are testcontainers?**

  

Testcontainers is a Java library that supports JUnit tests, providing lightweight, throwaway instances of common databases, Selenium web browsers, or anything else that can run in a Docker container. --> https://www.testcontainers.org/

  

----

  

> The docker-compose will handle the three containers and a network for us.
> **What does the default java and node.js travis images do?**

By default, images install what is necessary to be able to run Java and Node

  

## First steps into the CD world

  

  

> Here we are going to configure the Continuous Delivery of our project. Therefore, the main goal will be to create and save a docker image containing our application on the Docker Hub every time there is a commit on a develop branch.

**Why do we need this branch ?**

  

When there is a commit on the branch, by default the travis pipeline is started. it is currently the master branch. We could specify, depending on the type of branch, which jobs to launch

  

----

Create new develop branch on Github. After on VScode:

  

git fetch origin

git checkout -b "develop" "origin/develop"'

  

> Add your docker hub credentials to the environment variables in Travis

CI (and let them be secured). **Secured variables, why ?**

  

In order to allow the travis runner to push on docker hub, he needs his own access. This allows you to be more secure and to know who is pushing.

  

# TP 03/02/2021: Ansible

  

## Intro

  

>  **What’s up with the /api/actuator endpoint? What could it be used for?**

  

Actuator is a sprint-boot service allowing you to monitor your application

https://docs.spring.io/spring-boot/docs/current/reference/html/production-ready-features.html#production-ready-enabling

  

---

>  **what is $basearch?**

  

You can use $**basearch** to reference the base architecture of the system. For example, i686 machines have a base architecture of i386 , and AMD64 and Intel 64 machines have a base architecture of x86_64 . This allows whatever the machine, to deploy with the right base of architecture

  

# Conclusion

In conclusion, here is our deployment process. Thanks to the association of github repository and travis (and sonard), during a commit (by default on all branches), the pipeline will perform the following stages:

  

- "Build and Test" -> carrying out tests and building the application

- "Package" -> Deposit in Docker Hub

- "Deploy" -> Deployment via Ansible

  

As Travis is a neutral machine, we use docker to be able to run our applications (test, build, run etc ...). Dockerfile allows you to configure our own docker images, and docker-compose allows you to use several dockerfiles to run our application (in this case our internships).

  

To be able to deploy our application on the remote server with Ansible and Travis, we transmitted an encrypted version of the RSA key, for which the deployment job can decrypt it with Ansible Vault and can then connect in RSA to the EC2 instance for perform the deployment.

# TP 04/02/2021: Extra

> **Ask yourself: why can we easily load balance between our backends? Heard of sticky sessions or stateless apps?**

apache allows you to easily do load balancing. In the appache conf (httpd.conf), activate the necessary modules ->

    LoadModule mod_proxy_balancer modules/mod_proxy_balancer.so
    LoadModule slotmem_shm_module modules/mod_slotmem_shm.so
    LoadModule lbmethod_byrequests_module modules/mod_lbmethod_byrequests.so
    
create the proxy balancer :

    <Proxy "balancer: // backend_cluser">
        <Proxy "balancer://backend_cluser">
        BalancerMember "http://backend_blue:8080/"
        BalancerMember "http://backend_green:8080/"
        ProxySet stickysession=ROUTEID
    </Proxy>

and finally modify the reverse proxy to request the link of the balancer. Modify this :

    <VirtualHost *: 80>
         ProxyPreserveHost On
         ProxyPass / api http: // backend: 8080 / api
         ProxyPassReverse / api http: // backend: 8080 / api
    </VirtualHost>

into this:

    <VirtualHost *: 80>
             ProxyPreserveHost On
             ProxyPass / api balancer: // backend_cluser / api
             ProxyPassReverse / api balancer: // backend_cluser / api
    </VirtualHost>

To use sticky session, one customer have to request the same server all the time he use the service. We can add a route id and put a cookie contain the route id the customer navigator :

    Header add Set-Cookie "ROUTEID=.%{BALANCER_WORKER_ROUTE}e; path=/" env=BALANCER_ROUTE_CHANGED
    <Proxy "balancer: // backend_cluser">
        <Proxy "balancer://backend_cluser">
        BalancerMember "http://backend_blue:8080/" route=1
        BalancerMember "http://backend_green:8080/" route=2
        ProxySet stickysession=ROUTEID
    </Proxy> 
