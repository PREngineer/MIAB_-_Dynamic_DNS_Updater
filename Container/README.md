# Mail in a Box - Dynamic DNS Updater Container

## Introduction

So, you've set up Mail-in-a-Box as your domain's mail server and, by extension, made it the authoritative name server for it.  Now you need to manage your domain entries in it.

You might not have a static IP for some of your subdomains and you need to update the entries whenever the IP changes.

This container is the solution for that.

## How it works

This container connects to a Mail-in-a-Box instance to update a list of Custom DNS entries.

## Pre-requisites

You must provide the Mail-in-a-Box administrator credentials for it to work.

The Custom DNS entries to update must exist in the Mail-in-a-Box instance.

## Volumes

You must mount a volume to the container to the following path: /config

This allows the container to continue working even if re-created by storing your configuration files somewhere safe.

The "/config" folder will have 2 files.  These files will be created the first time that the container is run or if it can't find them for any reason.

1. **miab-dyndns.cfg** - The file that stores the administrator credentials.  The credentials are in the following format:

    user="\<user\>:\<password\>"

2. **miab-dyndns.dynlist** - This file contains a list of all the Custom DNS entries to update.  Each one in a separate line.  Update this file to include all the entries that you want to update on every run.  All of these entries will point to the Public IP of the machine running this container.

## Required Environment Variables for the container

1. **MIAB_USER** - The Mail-in-a-Box administrator user (email address).

    example: *admin@domain.tld*

2. **MIAB_PASSWORD** - The Mail-in-a-Box administrator password.

    example: *P@$$w0rd*

3. **DOMAIN** - The domain that you are handling e-mail for.

    example: *domain.tld*

4. **MIABHOST** - The FQDN of the Mail-in-a-Box host.

    example: *mail.domain.tld*

5. **HOURS** - The amount of hours to wait between runs.

    example: *1*

## Logs

The application logs every single action taken and its result to the container logs.  If you want to see what is has done, go check them out.

Example:

```
2025-02-03 16:27:24 ----------------------------------------
2025-02-03 16:27:24 Checking configuration...
2025-02-03 16:27:24 ----------------------------------------
2025-02-03 16:27:24 
2025-02-03 16:27:24 CURL configuration file exists.  :)
2025-02-03 16:27:24 Dynamic DNS list configuration file exists.  :)
2025-02-03 16:27:24 
2025-02-03 16:27:24 ----------------------------------------
2025-02-03 16:27:24 Starting Execution at 2025-02-03 21:27:24
2025-02-03 16:27:24 ----------------------------------------
2025-02-03 16:27:24 
2025-02-03 16:27:25 miab-dyndns: *.domain.tld hasn't changed.
2025-02-03 16:27:25 
2025-02-03 16:27:25 ----------------------------------------
2025-02-03 16:27:25 Ending Execution at 2025-02-03 21:27:25
2025-02-03 16:27:25 ----------------------------------------
2025-02-03 16:27:25 
2025-02-03 16:27:25 Done!  Next run will be in 3600 seconds.
```