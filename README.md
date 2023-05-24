# <b>nwserver</b>

Last updated: 20230524

## Registries

- `ghcr.io/urothis/nwserver:{A_TAG}`
- `urothis/nwserver:{A_TAG}`

## Tags

- [`8193.35.36`](https://hub.docker.com/repository/docker/urothis/nwserver/tags)
- [`8193.35`](https://hub.docker.com/repository/docker/urothis/nwserver/tags/8193.35)
- [`8193`](https://hub.docker.com/repository/docker/urothis/nwserver/tags/8193)

# <b>Where to file issues</b>

<https://github.com/urothis/nwserver/issues>

## <b>Supported architectures</b>

- amd64
- arm64v8

## Run configuration (base image)

Through env - i.e. via docker -e or --env-file.

The following environmental variables are used to configure your instance (with their defaults listed):

```bash
NWN_PORT=5121
NWN_MODULE=DockerDemo
NWN_SERVERNAME=I was too lazy to configure my server.
NWN_PUBLICSERVER=0
NWN_MAXCLIENTS=96
NWN_MINLEVEL=1
NWN_MAXLEVEL=40
NWN_PAUSEANDPLAY=1
NWN_PVP=2
NWN_SERVERVAULT=1
NWN_ELC=1
NWN_ILR=1
NWN_GAMETYPE=0
NWN_ONEPARTY=0
NWN_DIFFICULTY=3
NWN_AUTOSAVEINTERVAL=0
NWN_RELOADWHENEMPTY=0
NWN_PLAYERPASSWORD=
NWN_DMPASSWORD=
NWN_ADMINPASSWORD=
NWN_NWSYNCURL=
NWN_NWSYNCHASH=
```

The following environmental variables can be used to gather data about your instance during runtime (with example output listed):

```bash
NWN_VERSION=8193.35.36
NWN_IMAGE_BUILD_DATE=20230524
```

Note that this distribution does not ship with any campaign- or DD (Premium) modules; just the bare necessities to run a custom module. Everything you want to serve needs to be in your server home directory.

(The docker-proxy issue which would randomise the server port has been fixed; you don't need to do --net=host anymore. However, you still need to give NWN_PORT if you port-forward, so nwserver knows it's proper public port.)
Create a home for your server

This is where all your module and hak data will live.

```bash
mkdir server && cd server
mkdir modules/ hak/ tlk/   # < Put your stuff in there.
```

Please note that the serverhome you created above is a mostly read-only copy. It will not receive temp data from the running server (logs, currentgame, .nwnpid and so on), so you can share it between instances!
Test running it

```bash
$ cd server   # Make sure to run in your newly created server home.
$ docker run --rm -it \
    -p 5121:5121/udp -e NWN_PORT=5121 \
    -v $(pwd):/nwn/home \
    -e NWN_MODULE=mymodule \
    -e NWN_PUBLICSERVER=1 \
    urothis/nwserver:8189.35
```

See if it runs, then Ctrl+C/exit it. The server will shut down and your container will be removed.

Note how we are port-forwarding 5121/udp and are also telling nwserver that it's public port is 5121, via NWN_PORT. You need to change this if you port-forward a different port.

If you are behind NAT and do not port-forward, your server will appear on whatever external port your firewall assigns your connection. A NAT punch will be attempted for each connecting client; and if that fails, a relay connection will be used. It is strongly advised to set up a firewall rule or port forward once you are done testing.
Permanent setup

Now, that it works, run it in the background and restart it after a system reboot:

```bash
$ docker run --restart unless-stopped -dit \
    -p 5121:5121/udp -e NWN_PORT=5121 \
    --name mycoolserver \
    -v $(pwd):/nwn/home \
    -e NWN_MODULE=mymodule \
    -e NWN_PUBLICSERVER=1 \
    urothis/nwserver:8189.35
```

This starts a server in the background and tags your running container with "mycoolserver", which you can refer it by in addition to the hash.

The server exposes it's interactive console on the docker terminal, so you can docker attach to it (Hint: detach is ctrl+P ctrl+Q) to give it commands.

It also exposes the server log files to stdout, so you can do this:

```bash
docker logs -f mycoolserver
```

## Upgrading

Upgrading is simple enough. Since all your data is in your serverhome, just stop and remove the old image, and start the new one with the same parameters.

```bash
$ docker stop mycoolserver
$ docker rm mycoolserver
$ docker run --restart unless-stopped -dit \
    -p 5121:5121/udp -e NWN_PORT=5121 \
    --name mycoolserver \
    -v $(pwd):/nwn/home \
    -e NWN_MODULE=mymodule \
    -e NWN_PUBLICSERVER=1 \
    urothis/nwserver:8189.35
```

## What if it crashes?

Crash dumps are exported from the image into your serverhome (the one you created above).

## How do I make my server speak another language?

Grab the dialog.tlk from the distro of your choice and drop it in your serverhome (right next to modules/, hak/, etc.)
