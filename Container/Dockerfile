# Base Image is latest Alpine
FROM alpine:3.18

# Maintainer information and description
LABEL maintainer="Jorge Pabón <pianistapr@hotmail.com>" description="A bash application to update Custom DNS entries in a Mail-in-a-Box instance."

# Install required packages and create the /app and /config folders
RUN apk add --no-cache --update \
    bind-tools \
    curl \
    && mkdir /app /config \
    && chmod -R 777 /config

# Copy application to the /app directory
COPY ./app.sh /app
RUN chmod -R 777 /app

# Add the entrypoint script
ADD entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]

# Execute the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]