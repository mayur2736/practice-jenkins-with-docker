# Objective
- Learn how to setup Jenkins with Docker, and have it work with PyTest

# Post-learning on the Process
- https://medium.com/@BreakingLeft/abstract-learned-the-utility-of-docker-and-jenkins-and-how-to-combine-them-with-pytest-to-9b8cbb9b3a07

# Resources used
- #1: Currently following this example to learn:
    - https://medium.com/swlh/build-your-first-automated-test-integration-with-pytest-jenkins-and-docker-ec738ec43955
        - Creditials section is outdated AND does not work with private repos.

- #2: How to add creditials with private repo:
    - https://www.youtube.com/watch?v=HSA_mZoADSw
        - Skip to SSH section @ 5:56.

- #3 Prereq to run Docker commands in Jenkins:
    - Link: https://www.jenkins.io/doc/book/installing/docker/
    
- #4: Exposing Jenkin localhost to internet to connect to Github webhook using ngrok
    - Link: https://docs.github.com/en/developers/webhooks-and-events/webhooks/creating-webhooks#exposing-localhost-to-the-internet
    - include "github-webhook/"
        ex: https://<*EXAMPLE ID*>.ngrok.io/github-webhook/
    
- #5: Smee | Alternative to ngrok that might be more secured: https://www.jenkins.io/blog/2019/01/07/webhook-firewalls/
    - Docker/container verison from Probat: https://github.com/probot/smee.io

- #6: Pytest Custom exit code | This is needed so Jenkins doesn't stop if pytest fails: https://pypi.org/project/pytest-custom-exit-code/
    - SO suggestion: https://stackoverflow.com/a/57495334

- #7: Docker-compose specs: https://docs.docker.com/compose/compose-file/
