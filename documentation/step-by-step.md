# Device specs
M1 Macbook Air
- RAM: 8gb
- Storage: 256gb


# Prereq installs

Python side...
> Adapted from this guide: https://medium.com/swlh/build-your-first-automated-test-integration-with-pytest-jenkins-and-docker-ec738ec43955
- Initiate VENV.
- Install libraries/extensions/add-ons within the VENV
    - Libraries/Plugins:
        - pytest==7.1.2
        - pytest-custom-exit-code==0.3.0
        - pytest-mock==3.8.2
- use command to extract installed libaries:
    - PIP freeze > requirements.txt

Docker side to setup Jenkins:
- Follow this doc: https://www.jenkins.io/doc/book/installing/docker/
    - FOLLOW EVERY STEP TO A TEA.

# Create Dockerfiles

For python:
- Python's Dockerfile example:
    - FROM python:3
        WORKDIR /usr/src/app
        COPY requirements.txt .
        RUN pip install --no-cache-dir -r requirements.txt
        COPY /mypkg .
        RUN ["pytest", "-v", "--junitxml=reports/results.xml"]
        CMD tail -f /dev/null

For Docker:
- FROM jenkins/jenkins:latest-jdk11

    USER root

    RUN apt-get update && apt-get install -y lsb-release

    RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg

    RUN echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

    RUN apt-get update && apt-get install -y docker-ce-cli

    USER jenkins
    
    RUN jenkins-plugin-cli --plugins "blueocean:1.25.5 docker-workflow:1.28

# Setup docker-compose
- #Comments meant to show equalivance to running commands in terminal with "Docker run"

- docker-compose.yml:
    version: '3.8'
    services:
        dind-docker:

            # docker run [-flags] docker:dind
            image: docker:dind
            
            networks:
            # --network jenkins 
            jenkins:
                # --network-alias
                aliases:
                - docker
            environment:
            # --env DOCKER_TLS_CERTDIR=/certs 
            DOCKER_TLS_CERTDIR: /certs

            volumes:
            # --volume jenkins-docker-certs:/certs/client
            - jenkins_docker_certs:/certs/client
            
            # --volume jenkins-data:/var/jenkins_home
            - jenkins_data:/var/jenkins_home
            
            ports:
            # --publish 2376:2376
            - 2376:2376

            # --name dind-docker
            container_name: dind-docker

            # --privileged
            privileged: true

            # --storage-driver overlay2
            command: ["--storage-driver=overlay2"]

            # Commands not need: ['--rm', '--detach']
            ## Not using '--rm' as I want to keep it around. Running 'docker-compose down' will remove all containers anyways
            ## '--detach'/'-d' can be used with docker-compose
                ### Example: 'docker-compose up -d'

        jenkins-docker:
            # Using Dockerfile that's located in a sub-directory
            build: ./dockerfile-jenkins


            networks:
            # --network jenkins
            - jenkins

            ports:
            # --publish 8080:8080
            - "8080:8080"
            # --publish 50000:50000
            - "50000:50000"

            environment:

            # --env DOCKER_HOST=tcp://docker:2376
            DOCKER_HOST: tcp://docker:2376

            # --env DOCKER_CERT_PATH=/certs/client
            DOCKER_CERT_PATH: /certs/client
            
            # --env DOCKER_TLS_VERIFY=1
            DOCKER_TLS_VERIFY: 1
            
            volumes:

            # --volume jenkins-data:/var/jenkins_home
            - jenkins_data:/var/jenkins_home

            # --volume jenkins-docker-certs:/certs/client:ro
            - jenkins_docker_certs:/certs/client:ro

            # --name jenkins-blueocean
            container_name: myjenkins-blueocean
            
            # --restart=on-failure 
            restart: on-failure

            ## privileged might not be needed here; test later #TODO
            #privileged: true  
        

        volumes:
        jenkins_data:
        jenkins_docker_certs:
            

        networks:
        jenkins:
            external: true
# Run docker-compose
- To run docker-compose detached (make sure to have terminal in the directory of docker-compose.yml):
    > docker-compose up -d

# Setting up Jenkins:

How to add creditials with private repo:
- SSH Key video: https://www.youtube.com/watch?v=HSA_mZoADSw

- Primary build step commands using "Execute shell":

    IMAGE_NAME="test-image"
    CONTAINER_NAME="test-container"

    echo "Check current working directory"
    pwd

    echo "Build docker image and run container"
    docker build -t $IMAGE_NAME .
    docker run -d --name $CONTAINER_NAME $IMAGE_NAME

    echo "Copy result.xml into Jenkins container"
    rm -rf reports; mkdir reports
    docker cp $CONTAINER_NAME:/usr/src/app/reports/results.xml reports/

    echo "Cleanup"
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
    docker rmi $IMAGE_NAME



