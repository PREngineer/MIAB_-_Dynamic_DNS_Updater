# Please Support This Project!

This project is being developed during my spare time.  I would appreciate a donation if you found it useful.

[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=53CD2WNX3698E&lc=US&item_name=PREngineer&item_number=M-I-A-B-DynDNS-Updater&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)

You can also support me by sending a BitCoin donation to the following address:

19JXFGfRUV4NedS5tBGfJhkfRrN2EQtxVo

___

# Mail in a Box - Dynamic DNS Updater

A script to automatically update the IP of custom DNS entries in a Mail in a Box instance.

## How to set it up

Make the following changes in the files referenced below.

### 1. miab-dyndns.sh

The following changes have to be made in the file:

Line # 42 - Must point to the domain where you are hosting your Mail-in-a-Box instance.

- Example:

```
  mysite.com
```

Line # 45 - Must point to the host that represents the Mail-in-a-Box instance in your domain.

- Examples: 

```  
  box.mysite.com
  
  mail.mysite.com
  
  smtp.mysite.com
```

### 2. miab-dyndns.cfg

The following changes have to be made in the file:

  a) Replace '\<username\>' with your Mail-in-a-Box administrator username (email).

  b) Replace '\<password\>' with your Mail-in-a-Box administrator password.

### 3. miab-dyndns.dynlist

Must contain a list of all the **existing** DNS records that need to be updated.  Each DNS record must be in a separate line.  

- Example:

```
  *.mysite.com

  mysite.com

  www.mysite.com
```

## How to use it

You can manually run the script or create a cron job to execute it on a schedule.

### 1. Running it manually

```
./miab-dyndns.sh
```

### 2. Running it on a schedule (every day at midnight)

```
crontab -e
```

Add a new line like this:

```
0 0 * * * /path/to/your/miab-dyndns.sh
```

___

# Important Notes

The Script folder is to be used in Debian linux distros like Ubuntu, Debian, and Raspbian.

The Container folder is for building an Alpine container.

___

# Containerized version

This application has been containerized and is available in my [Docker Hub](https://hub.docker.com/repository/docker/prengineer/miab_dyndns/general) repository.

All the necessary information to run it can be found there.

## How I built it for multiple platforms:

docker buildx build --platform linux/amd64,linux/arm64/v8,linux/arm/v6,linux/arm/v7 -t prengineer/miab_dyndns:1.0.0 .

docker push prengineer/miab_dyndns:1.0.0