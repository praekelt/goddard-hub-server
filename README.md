# Goddard Hub Server

## About

The "Hub" is the management interface for the system.

Here all the nodes do their initial handshake and get their details on setup back. This repo contains the management interface that will be used to manage and configure the nodes.

The server will also connect to provision, but with details from this app that were saved and managed.

The app does a few things:

### Dashboards

The management console hosts dashboards that can be used to view information from the nodes and informations about requests that were made.

### Node Handshake

When a node first starts up it sets up the internal components to allow connection to the internet. Once that is working it contacts the Hub Server on the ``/setup.json`` endpoint. Which accepts the public key and mac address of the node. Returning the registered node info, after which the node saves this and locks the information. 

So now it has a identification and keys that are returned from the server that will allow the hub server to login to the Node and vice versa.

### Group / Application Mangement

The interface allows the configuration of nodes with groups and which applications are valid for which.

The nodes are then provisioned according to this dataset.

### 

## Install / Develop

To install or start developing. The project must be cloned from the repo and

````bash
npm install
````

must be run to setup all the configured packages. After this the project will be ready to be run by executing:

````bash
NODE_ENV=production PORT=port DB_URL=postgres://user:password@host/databasename node index.js
````

The app accepts a few parameters that allow configuration on a server running the instance:

* *NODE_ENV* - can be set to "development" or "production"
* *DB_URL* - the full url to the postgres server including the auth details
* *PORT* - port that the web interface will start and listen on