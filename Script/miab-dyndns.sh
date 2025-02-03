#!/bin/sh
###########################################################################################
# Author:                        dmurphy@dmurphy.com                          | Apr X, 2018
# Updated By:                    pianistapr@hotmail.com                       | Feb 3, 2025
###########################################################################################
# What does it do:               Updates the listed dynamic DNS records in a Mail-in-a-Box 
#                                instance w/ the Public IP of the machine running this 
#                                script.
#
# Required linux packages:       dig, curl
#                                  sudo apt-get install -y dnsutils curl
#
# Other requirements:            1. OpenDNS MyIP service accessible ( myip.opendns.com )
#                                2. A M-I-A-B host ( see https://mailinabox.email )
#
# Required Configurations:       M-I-A-B admin username/password in the CFGFILE.
#                                One line file in the format ( curl cfg file ):
#                                  user = "<username>:<password>"
#
#                                List of Dynamic DNS entries to be updated in M-I-A-B.
#                                DYNDNSNAMELIST file contains one hostname per line.
#                                These entries must exist in the M-I-A-B instance.
#                                They will be set to the Public IP of the machine running
#                                this script.
###########################################################################################

# The name of the script and configuration files
MYNAME="miab-dyndns"

# File that will store the current Public IP of the box running this script
CURRENTIPFILE="$MYNAME.ip"

# The file that contains the administrator credentials for the M-I-A-B instance.
CFGFILE="$MYNAME.cfg"

# Define the location of the binaries for Dig, Curl, Cat
DIGCMD="/usr/bin/dig"
CURLCMD="/usr/bin/curl"
CATCMD="/usr/bin/cat"

# Define the domain that hosts the Mail in a Box machine ( domain.tld )
DOMAIN="<domain.tld>"

# Define the M-I-A-B host name ( box.domain.tld )
MIABHOST="<box>.$DOMAIN"

# The file containing the list of DNS entries to update
DYNDNSNAMELIST="$MYNAME.dynlist"

##### Pre-requisite validations #####

# Dig is available
if [ ! -x $DIGCMD ]; then
  echo "$MYNAME: dig command $DIGCMD not found.  Make sure that 'dig' is installed and available."
  exit 1
fi

# Curl is available
if [ ! -x $CURLCMD ]; then
  echo "$MYNAME: curl command $CURLCMD not found.  Make sure that 'curl' is installed and available."
  exit 2
fi

# Cat is available
if [ ! -x $CATCMD ]; then
  echo "$MYNAME: cat command $CATCMD not found.  Make sure that 'cat' is installed and available."
  exit 3
fi

# Admin cred file is available
if [ ! -f $CFGFILE ]; then
  echo "$MYNAME: $CFGFILE not found.  Make sure that the Administrator credentials file exists."
  exit 4
fi

# DNS entries file is available
if [ ! -f $DYNDNSNAMELIST ]; then
   echo "$MYNAME: $DYNDNSNAMELIST not found.  Make sure that the file with the DNS entries exists."
   exit 5
fi

##### Retrieve Current IP #####

# Retrieve the Public IP of this machine
MYIP="`$DIGCMD +short myip.opendns.com @resolver1.opendns.com`"

# Validate we retrieved the Public IP
if [ -z "$MYIP" ]; then
  echo "$MYNAME: dig output was blank.  Check myip.opendns.com services."
  exit 6
fi

##### Process Updates #####

# Process all of the DNS entries in the list
for DYNDNSNAME in `$CATCMD $DYNDNSNAMELIST`
do
  # Get the previously assigned IP
  PREVIP="`$DIGCMD +short $DYNDNSNAME @$MIABHOST`"

  # If not found
  if [ -z "$PREVIP" ]; then
    echo "$MYNAME: dig output was blank.  Check $MIABHOST DNS server is working and the entry '$DYNDNSNAME' exists."
    exit 7
  fi

  # If the IP is the same
  if [ "x$PREVIP" = "x$MYIP" ]; then
    echo "$MYNAME: $DYNDNSNAME hasn't changed."
  
  # If the IP has changed
  else
    echo "$MYNAME: $DYNDNSNAME has changed ( Previous IP: $PREVIP, Current IP: $MYIP )."
    # Execute update in M-I-A-B machine
    STATUS="`$CURLCMD -X PUT -K $CFGFILE -s -d $MYIP https://$MIABHOST/admin/dns/custom/$DYNDNSNAME`"
    # Validate the result
    case $STATUS in
      "OK")
        echo "$MYNAME: Mail-In-A-Box API has returned OK. The command succeeded but no update was necessary.";;
      "updated DNS: $DOMAIN")
        echo "$MYNAME: Mail-In-A-Box API updated $DYNDNSNAME successfully.";;
      *)
        echo "$MYNAME: Mail-In-A-Box returned the following response '$STATUS'. Something might be wrong.  Please check.";;
    esac
  fi
done

# If we got to this point, everything was successful
exit 0