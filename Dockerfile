# Use the latest steamcmd image as the base
FROM steamcmd/steamcmd:latest

# Maintainer information
LABEL maintainer="Randolph William Aarseth II <randolph@divine.games>"
LABEL homepage="https://divine.games/"
LABEL repository="https://github.com/Bioblaze/deploy2steam"

# License information
LABEL license="MIT"

# Credits
LABEL credits="This Dockerfile was created by Randolph William Aarseth II, with contributions from the community."

LABEL "com.github.actions.name"="deploy2steam"
LABEL "com.github.actions.description"="Deploy Project to Steam"
LABEL "com.github.actions.icon"="loader"
LABEL "com.github.actions.color"="blue"


# Set the working directory to /root
WORKDIR /root/

# Copy the required files into the container
COPY steam_deploy.sh .
COPY get_totp.js .
COPY package*.json ./

# Install Node.js and NPM in the steamcmd container
# Since the steamcmd image may not include Node.js and NPM, install them first
# Depending on the base OS in the steamcmd image, you might need to adjust the install commands

USER root

# For Debian/Ubuntu based containers
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    rm -rf /var/lib/apt/lists/*

# Install NPM dependencies for your Node.js script
RUN npm install

# Make sure your scripts are executable
RUN chmod +x steam_deploy.sh

# Set the entrypoint to your deployment script
ENTRYPOINT ["/root/steam_deploy.sh"]
