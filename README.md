# envoy-authz

Basic envoy setup example for running an external Authentication/Authorization backend

> The example on this repo was copied from [salrashid123/envoy_external_authz](https://github.com/salrashid123/envoy_external_authz), which is connected to [the article on medium](https://medium.com/google-cloud/envoy-external-authorization-server-envoy-ext-authz-helloworld-82eedc7f8122)
> 
> Cheers @[salrashid123](https://github.com/salrashid123) for providing such great and actionable content :beers:

On this repo you find the example in the form of a **`docker-compose.yaml`**, making it even easier *(for those who has familiarity with the tool, of course)* to get started with the concept presented on the [article](https://medium.com/google-cloud/envoy-external-authorization-server-envoy-ext-authz-helloworld-82eedc7f8122).

## Getting started

Open 2 terminals and run the following commands after cloning the repo:

### terminal 1

Bring the services up with `docker-compose`:

```
$ docker-compose up --build
Building service_backend
...
```

After that you should see logs like this:

```
service_authz_1    | 2020/03/21 17:30:23 Handling grpc Check request
service_authz_1    | 2020/03/21 17:30:28 Handling grpc Check request
service_authz_1    | 2020/03/21 17:30:33 Handling grpc Check request
service_authz_1    | 2020/03/21 17:30:39 Handling grpc Check request
service_authz_1    | 2020/03/21 17:30:45 Handling grpc Check request
```

... meaning that the envoy health checks are in action.

### terminal 2

Now that we have the services up and running, we can see the results by running `curl` commands at `http://localhost:8111`:

#### Without the **Authorization** header

```
$ curl -vv -w "\n" http://localhost:8111/
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8111 (#0)
> GET / HTTP/1.1
> Host: localhost:8111
> User-Agent: curl/7.58.0
> Accept: */*
> 
< HTTP/1.1 401 Unauthorized
< content-length: 46
< content-type: text/plain
< x-custom-header-from-lua: bar
< date: Sat, 21 Mar 2020 17:24:27 GMT
< server: envoy
< 
* Connection #0 to host localhost left intact
Authorization Header malformed or not provided
```

#### With the **Authorization** header

```
$ curl -vv -H "Authorization: Bearer foo" -w "\n" http://localhost:8111/
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8111 (#0)
> GET / HTTP/1.1
> Host: localhost:8111
> User-Agent: curl/7.58.0
> Accept: */*
> Authorization: Bearer foo
> 
< HTTP/1.1 200 OK
< x-custom-header-from-backend: from backend
< date: Sat, 21 Mar 2020 17:24:37 GMT
< content-length: 2
< content-type: text/plain; charset=utf-8
< x-envoy-upstream-service-time: 0
< x-custom-header-from-lua: bar
< server: envoy
< 
* Connection #0 to host localhost left intact
ok
```
