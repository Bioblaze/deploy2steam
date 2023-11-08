![Release Version](https://img.shields.io/github/v/release/Bioblaze/deploy2steam)

# Deploy2Steam GitHub Action

## Overview

The Deploy2Steam GitHub Action is designed to facilitate the deployment of game builds to Steam using the SteamSDK. It provides a straightforward process to connect to Steam's partner network, upload new builds, and manage depots with ease. This action is especially useful for game developers and CI/CD pipelines that aim to automate the deployment process as much as possible.

This GitHub Action utilizes a Docker image that includes the necessary tools to authenticate with Steam using either a shared secret or a config VDF file, generate a manifest, and execute the deployment.

## Inputs

### Required Inputs

- `username`: The username of your Steam builder account.
- `password`: The password for your Steam builder account.
- `appId`: The unique identifier for your application within Steam's partner network.
- `rootPath`: The root path where your game's build files are located. This is used to determine the files to be included in the depots.
- `depotId`: The identifier for your Steam depot.
- `depotPath`: The path where your depot files are located, relative to the `rootPath`.

### Optional Inputs

- `buildDescription`: A description for the build being deployed.
- `shared_secret`: The shared secret for Steam's two-factor authentication. This must be provided unless `configVdf` is used.
- `configVdf`: If `shared_secret` is not provided, this is required. It should contain the contents of your `STEAM_HOME/config/config.vdf`.

## Outputs

- `manifest`: The path to the generated manifest file `manifest.vdf`, which is used by Steam for the deployment.

## Environment Variables

The following environment variables are used by the action:

- `steam_username`
- `steam_password`
- `steam_shared_secret`
- `configVdf`
- `appId`
- `buildDescription`
- `rootPath`
- `depotId`
- `depotPath`

## Usage

To use this action, you must have a GitHub Actions workflow defined in your repository.

Here's a basic example of how to use the Deploy2Steam GitHub Action in a workflow:

```yaml
name: Deploy to Steam

on:
  push:
    branches:
      - master  # Trigger the workflow on push to the master branch

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    # Use the Deploy2Steam action
    - name: Deploy to Steam
      uses: ./.github/actions/steam-deploy  # Path to the action
      with:
        username: ${{ secrets.STEAM_USERNAME }}
        password: ${{ secrets.STEAM_PASSWORD }}
        shared_secret: ${{ secrets.STEAM_SHARED_SECRET }}
        appId: '1234567'
        buildDescription: 'My Game Build'
        rootPath: 'build'
        depotId: '1234568'
        depotPath: 'depot'
```

In this example, you would replace `appId`, `depotId`, and the `secrets` with your own credentials and identifiers. The action will take care of logging in to the Steam partner network, creating a manifest file, and executing the deployment.

## Notes

- Make sure your repository has GitHub Secrets set up for `STEAM_USERNAME`, `STEAM_PASSWORD`, and `STEAM_SHARED_SECRET` to keep your credentials secure.
- The `rootPath` should be relative to the root of your repository.
- Your depot's contents should be structured as expected by Steam, typically with a folder containing the executable and all other game assets.

## Node.js File: `get_totp.js`

This GitHub Action includes a Node.js file named `get_totp.js` that is used to generate the time-based one-time password (TOTP) for Steam's two-factor authentication when provided with a `shared_secret`.

# How to Get the Shared Token for Steam

To facilitate seamless deployment of game builds on Steam through our GitHub Actions workflow, obtaining a shared token for authentication is a critical step. This token is associated with Steam Guard's two-factor authentication system. For detailed instructions on setting this up, we have prepared a comprehensive tutorial.

Please refer to the following guide to obtain your shared token:

[How to Get the Shared Token for Steam (STEAM_TUTORIAL.md)](./STEAM_TUTORIAL.md)

This guide includes all the necessary steps from installing the required software, such as Rust and `steamguard-cli`, to linking an authenticator with your Steam account and finalizing the process to obtain your shared token.

Ensure that you follow the steps carefully and safeguard your revocation code as it is essential for account recovery purposes. If you encounter any issues, feel free to raise an issue on the repository or contact the maintainer.

## License

This GitHub Action is distributed under the MIT license. See the `LICENSE` file for more details.


---


This action is maintained by Randolph William Aarseth II <randolph@divine.games>. Please reach out for support or contributions.