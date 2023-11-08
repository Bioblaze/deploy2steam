var SteamTotp = require('steam-totp');

// Check if a command line argument is provided
if (process.argv.length < 3) {
    process.exit(1);
}

// The first command line argument after the script name is the secret_token
var secret_token = process.argv[2];
var code = SteamTotp.generateAuthCode(secret_token);
console.log(code);
