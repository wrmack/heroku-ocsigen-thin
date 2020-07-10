# heroku-ocsigen-thin

This is a Dockerfile to build a thinned down image for deploying the Ocaml [ocsigenserver](https://ocsigen.org) to Heroku as a Docker container.  

It runs the bare ocsigenserver (not the eliom web framework).  Image size is 370MB.

Thinning has been achieved by not installing Ocaml and, from the local filesystem, just transferring binaries and library packages that are required by ocsigenserver.  These files were built using a different image but same base.  (Ocsigen uses modules which are loaded dynamically at runtime.  The `.conf` file contains the modules to be used. Their packages, and dependencies, need to be available to findlib hence the need to copy the packages over.)

## To deploy to Heroku

#### Edit entrypoint.sh if necessary
Environment variables for PORT, USER and GROUP need to be set for the Heroku environment.
The default version has these correct for Heroku

#### Create a Heroku app
```
cd to directory with this Dockerfile
heroku login
heroku container:login
heroku create *your-app-name*
```
#### Each time you make changes, push to Heroku and release
```

heroku container:push web --app *your-app-name*
heroku container:release web --app *your-app-name*
```
#### View on web
```
heroku open --app *your-app-name*
```

#### Inspect running Heroku app
- run a bash shell in the container
```
heroku run bash --app *your-app-name*
```
- view logs
```
heroku logs --tail --app *your-app-name*
```

## To test locally

- uncomment PORT, USER, GROUP variables in entrypoint.sh for local use and comment out the Heroku ones, then
```
docker build -t *your-image-name*
docker run -it -d --name *your-container-name* -p 8080:8080 *your-image-name*
```
- view on localhost:8080


Live site [here](https://ocsi-thin-test.herokuapp.com).  I am using the free tier.  With this thin version it takes about 10 seconds for a sleeping dyno to load the page



