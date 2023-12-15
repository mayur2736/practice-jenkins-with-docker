# Python Dockerfile
# Renamed worked
# This Dockerfile will be used by Jenkins to test.


FROM redhat/ubi8

WORKDIR /app

COPY . .
RUN yum -y install maven

COPY . .


RUN mvn clean package 

# Info on "--continue-on-collection-errors": https://stackoverflow.com/a/57003743
# "--suppress-tests-failed-exit-code" is from plugin: https://pypi.org/project/pytest-custom-exit-code/
    ## Ensures 'Results.xml' still gets published if collection error occurs


# Info about "tail": https://www.geeksforgeeks.org/tail-command-linux-examples/
# CMD tail -f /dev/null
