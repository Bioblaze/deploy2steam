var SteamTotp = require('steam-totp');

// Check if a command line argument is provided
if (process.argv.length < 3) {
    process.exit(1);
}

// The first command line argument after the script name is the secret_token
var secret_token = process.argv[2];
if (process.argv.length > 2) {
    var time_offset = process.argv[3];
    var code = SteamTotp.generateAuthCode(secret_token, Number(time_offset));
    console.log(code);
} else {
    var code = SteamTotp.generateAuthCode(secret_token);
    console.log(code);
}

