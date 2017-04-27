# Continuous deployment pipeline with Concourse


### Create docker-compose.yml

At first create a docker-compose.yml file for docker with the following settings.

```
concourse-db:
  image: postgres:9.5
  environment:
    POSTGRES_DB: concourse
    POSTGRES_USER: concourse
    POSTGRES_PASSWORD: changeme
    PGDATA: /database

concourse-web:
  image: concourse/concourse
  links: [concourse-db]
  command: web
  ports: ["8080:8080"]
  volumes: ["./keys/web:/concourse-keys"]
  environment:
    CONCOURSE_BASIC_AUTH_USERNAME: concourse
    CONCOURSE_BASIC_AUTH_PASSWORD: changeme
    CONCOURSE_EXTERNAL_URL: "${CONCOURSE_EXTERNAL_URL}"
    CONCOURSE_POSTGRES_DATA_SOURCE: |-
      postgres://concourse:changeme@concourse-db:5432/concourse?sslmode=disable

concourse-worker:
  image: concourse/concourse
  privileged: true
  links: [concourse-web]
  command: worker
  volumes: ["./keys/worker:/concourse-keys"]
  environment:
    CONCOURSE_TSA_HOST: concourse-web
```

### Generate keys

Generate all necessary keys and copy it to the keys folder.

```
mkdir -p keys/web keys/worker

ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''
ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''

ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''

cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys
cp ./keys/web/tsa_host_key.pub ./keys/worker
```

### Set the IP

Find your IP and set the IP for Concourse.

```
ipconfig getifaddr en1
export CONCOURSE_EXTERNAL_URL=http://192.168.1.102:8080
```

### Run docker

After you set the IP, you can run docker-compose up and see Concourse in your browser.

```
docker-compose up
```

## Set Concourse Pipeline

Now we need to set a pipeline for Concourse.
First download fly, copy it to your path and make it executable.

```
$ sudo mkdir -p /usr/local/bin
$ sudo mv ~/Downloads/fly /usr/local/bin
$ sudo chmod 0755 /usr/local/bin/fly
```

Now we have to create a pipeline.yml file with the desired tasks.
To set the pipeline for Concourse, it is necessary to first log in.

```
fly -t fh login -c http://192.168.1.102:8080
```

Afterwards we need to tell Concourse to use the pipeline.

```
fly set-pipeline -t fh -p fh -c pipeline.yml
```

## Run the tests

That's it! Now we can visit the url in the browser and run the defined tasks with Concourse :)
