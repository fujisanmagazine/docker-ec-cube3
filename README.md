Dockerfile for EC-CUBE 3.x
====

## What's this

Docker image for [EC-CUBE 3.x](https://github.com/EC-CUBE/ec-cube).  

* Components
    * [PHP](https://registry.hub.docker.com/_/php/)
        * Debian Stetch-Slim
        * PHP 7.3

## How to Build Image

* docker build
    * tag `latest`

        ```make build```

## Example Usage

1. Start container

    ```make run```

2. Let's Access in Browser
    * ex)```http://localhost:8080/admin```
    * ID: admin / PW: password

3. Enter Container (Development)

    ```make attach```

4. Cleanup

    ```make stop```

----
* This software is released under the MIT License, see LICENSE.txt.



