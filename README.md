# jenkins-k8s-infra

There is more than to go on about running jenkins, one way is running jenkins on WSL (ubuntu) or running jenkins inside docker to isolate and manage it but we'll stick to running jenkins in docker for now!

## Run Jenkins in Docker (on WSL Ubuntu)
This guide will get you up and running using the official jenkins/jenkins:lts image.

###  1. Install Docker
``` bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
```
###  2. Create a Docker Volume (for Jenkins data)

So your Jenkins data (jobs, configs, plugins) doesn't get lost:

```bash 
docker volume create jenkins-data
```
### 3. Run Jenkins Container
```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  jenkins/jenkins:lts
```
### 4. Get Jenkins Admin Password
##### After Jenkins starts (check with docker ps), run:
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
##### Copy the output — you'll need it to unlock the UI.
9659cbf3b0a341dc8c13e4a83a6a663c


###  5. Access Jenkins in Your Browser
```arduino
http://localhost:8080
```
##### Paste the admin password, install plugins, and set up your admin user.

# Welcome to Jenkins!
 ##### Now clone your GitHub repo and possibly run a pipeline or build job from it.
 ## 1. Connect Jenkins to GitHub
 ### 1. Install the Git Plugin 
 ### 2. Create a New Job
Name job (eg: infra-pipeline), then select pipeline
### 3. Add GitHub Repository
#### For Pipeline Job:
- Scroll to Pipeline section
- Set Definition to Pipeline script from SCM
- SCM = Git
- Add your GitHub repo URL and credentials
### 5. Add Jenkinsfile (For Pipelines) 
#### If your repo contains a Jenkinsfile: (name: Jenkinsfile-infra)
- Jenkins will automatically detect and run it.
- Make sure the file is in the root of your repo.
### Now save and build!


