# How to Get the Shared Token for Steam

In order to deploy game builds to Steam using a GitHub Action or any other CI/CD tool, you may require a shared token for Steam. This shared token can be obtained through a Steam Guard Mobile Authenticator. Below is a guide on how to install the necessary tools and obtain your shared token using `steamguard-cli`, a command-line tool for generating Steam Guard codes.

### Pre-requisites
- Ensure that the Steam Authenticator is disconnected from the account you wish to use.
- On Windows, Chocolatey must be installed. On Linux, `curl` or `wget` should be available.

### Installing Rust

#### Windows
Open an elevated PowerShell and run:
```powershell
choco install rust -y
refreshenv
```

#### Linux
Open a terminal and run:
```bash
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
```

### Installing `steamguard-cli`

After Rust is installed, proceed to install `steamguard-cli` using Cargo (the Rust package manager):

```bash
cargo install steamguard-cli
```

If on Windows, you may need to refresh your environment path to ensure that the `steamguard-cli` command is available:
```powershell
refreshenv
```

### Setting up `steamguard-cli`

Now that `steamguard-cli` is installed, you can set it up by running:

```bash
steamguard setup
```

Follow the instructions on your screen. Below is an example of how the console output will look like:

```console
PS E:\your\infrastructure> steamguard setup
INFO - reading manifest from C:\Users\user\AppData\Roaming\steamguard-cli/maFiles
Log in to the account that you want to link to steamguard-cli
Username: divine_builder
Password: 
Enter the 2fa code sent to your email: 
INFO - Polling for tokens... -- If this takes a long time, try logging in again.
INFO - Logged in successfully!
INFO - Adding authenticator...
INFO - Saving manifest and accounts...
Authenticator has not yet been linked. Before continuing with finalization, please take the time to write down your revocation code: R12345
Press enter to continue...A code has been sent to your phone number ending in 6789.
Enter SMS code: 
INFO - Authenticator finalized.
INFO - Saving manifest and accounts...
Authenticator has been finalized. Please actually write down your revocation code: R12345
```

It is extremely important to write down your revocation code as it is required if you ever need to remove the Steam Guard Mobile Authenticator from your account without access to your phone.

### Note
- The process of adding an authenticator is sensitive and should be done with caution.
- Ensure that you are fully aware of the implications of adding and using a mobile authenticator with your Steam account.
- Keep your revocation code in a secure location to avoid any potential account lockouts.