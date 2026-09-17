> **Deprecated.** Steam deploy now lives in [blazium-cli](https://github.com/blazium-games/blazium-cli): `blazium-cli deploy steam upload`. This Action is no longer developed. Do not use steamguard-cli, Node, or `steam-totp`; Guard TOTP is built into the CLI.

![Release Version](https://img.shields.io/github/v/release/Bioblaze/deploy2steam)

# Deploy2Steam GitHub Action

## Overview

This Action previously uploaded a Steam depot via SteamCMD and Node TOTP. It is no longer developed.

## Inputs (historical)

### Required Inputs

- `username`: Steam builder username
- `password`: Steam builder password
- `appId`: Steam app id
- `rootPath`: Root path of depot content
- `depotId`: Steam depot id
- `depotPath`: Depot files relative to `rootPath`

### Optional Inputs

- `buildDescription`: Build description
- `shared_secret`: Steam Guard shared secret (unless `configVdf`)
- `configVdf`: Base64 `config.vdf` if `shared_secret` is not used

## Outputs

- `build_id`: Steam build id after a successful upload

## Usage

Use the CLI instead of `uses:` for this Action:

```text
blazium-cli deploy steam upload
```

Credentials: `BLAZIUM_STEAM_USERNAME`, `BLAZIUM_STEAM_PASSWORD`, `BLAZIUM_STEAM_SHARED_SECRET` (or `blazium-deploy.yml`). Steam Guard codes are generated in-process; do not install Node, `get_totp.js`, or steamguard-cli.

See [STEAM_TUTORIAL.md](./STEAM_TUTORIAL.md) and [blazium-cli deploy](https://github.com/blazium-games/blazium-cli).

## License

This GitHub Action is distributed under the MIT license. See the `LICENSE` file for more details.

---

This action is maintained by Randolph William Aarseth II <randolph@divine.games>. Please reach out for support or contributions.
