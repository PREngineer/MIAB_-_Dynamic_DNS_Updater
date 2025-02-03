#!/bin/sh

###########################
# Container Bootstrapping #
###########################

echo '----------------------------------------'
echo 'Checking configuration...'
echo '----------------------------------------'
echo

# Create CURL configuration file if not present
if [ -e "/config/miab-dyndns.cfg" ]; then
  echo "CURL configuration file exists.  :)"
else
  echo "CURL configuration file does not exist.  Creating it..."
  echo 'user="'$MIAB_USER':'$MIAB_PASSWORD'"' > /config/miab-dyndns.cfg
fi

# Create Dynamic DNS list file if not present
if [ -e "/config/miab-dyndns.dynlist" ]; then
  echo "Dynamic DNS list configuration file exists.  :)"
else
  echo "Dynamic DNS list configuration file does not exist.  Creating it..."
  echo '*.domain.tld' > /config/miab-dyndns.dynlist
fi

echo

###########################
# Container Execution     #
###########################


# Start Execution, re-run the script every HOURS converted to seconds
while true; do

  DATE=$(date +"%Y-%m-%d %H:%M:%S")
  echo '----------------------------------------'
  echo 'Starting Execution at '$DATE
  echo '----------------------------------------'
  echo

  # Run the application
  ./app/app.sh

  DATE=$(date +"%Y-%m-%d %H:%M:%S")
  echo
  echo '----------------------------------------'
  echo 'Ending Execution at '$DATE
  echo '----------------------------------------'

  NEXT=$(( HOURS*60*60 ))
  echo
  echo "Done!  Next run will be in $NEXT seconds."
  echo

  sleep $NEXT

done