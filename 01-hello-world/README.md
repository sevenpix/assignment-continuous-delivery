# 01-hello-world

The goal of this assignment was to create a Docker container which contains a simple hello-world example made with express.

### Create Docker container

```
docker build -t mtaferner/hello-world .
```

### Run Docker container
```
docker run -p 3000:3000 --name hello-world mtaferner/hello-world
```

### Stop Docker container
```
docker stop hello-world
```