# JSONSchemaDiscovery
This repository contains a 'compose.yaml' which when executed installs all the required dependencies to run this tool

# What you need 
Ensure that you have `docker compose` is installed on your local machine. You can check this by running the following command:
```docker compose version```

# Build the environment 
After cloning the repository into your local machine and navigating into the folder, Start up the containers by running the following command in your terminal:
```
docker compose up -d
```
The above command launches two containers in detached mode: `mongodb` for the database and `jsonschema` for the JSONSchemaDiscovery tool.

# Running the experiment
To run the experiment from insider the container, first ensure that both containers are still up and running. To check this, simply execute: ```docker ps```.

Execute the following command to enter into the `jsonschema` running container:
```
docker exec -it jsonschema /bin/bash
```

Once inside the `jsonschema` container, execute this command to run the experiment:
```
./doAll.sh
```
The above command executes the reproduction tool, which involves inserting the datasets into the database, extracting the JSON schema, comparing the reproduced results and then generating a `main.pdf` file which contains the report of this reproduction package.

# Viewing the generated PDF report 
Upon executing `./doAll.sh` as described above, the Makefile is invoked to produce the `main.pdf` file within the designated `ReproEngReport` directory. You can easily access the generated PDF file by navigating to this folder.

### Moving the generated file outside the container
To copy the `ReproEngReport` folder from the container to the host file system, run the following command from outside the container:
``` 
docker cp jsonschema:/home/kali/JSONSchemaDiscovery/ReproEngReport .
```