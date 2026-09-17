# Steam Guard for deploys

> **Deprecated Action tutorial.** Do not install steamguard-cli, Cargo, Node, or npm `steam-totp`. Guard TOTP is built into [blazium-cli](https://github.com/blazium-games/blazium-cli).

```text
blazium-cli deploy steam guard setup
blazium-cli deploy steam guard totp
blazium-cli deploy steam guard import --mafile path/to/account.maFile
```

Existing Steam Desktop Authenticator / steamguard-cli maFiles still work with `guard import`. Set `BLAZIUM_STEAM_SHARED_SECRET` (or `shared_secret` in `blazium-deploy.yml`) for CI.

`guard setup` is interactive and binds the builder account. Do not run it on a GitHub Actions runner. Write down the Steam revocation code before Finalize; losing it and the maFile can lock the account.

Then upload with:

```text
blazium-cli deploy steam upload --dry-run
blazium-cli deploy steam upload
```
