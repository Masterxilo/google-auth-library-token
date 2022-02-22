const { GoogleAuth } = require('google-auth-library');
const assert = require('assert');
const fs = require('fs');

// input: environment variable (process.env) GOOGLE_APPLICATION_CREDENTIALS
// stdout output: token for that (service) client

// from https://github.com/googleapis/google-auth-library-nodejs

/**
* Instead of specifying the type of client you'd like to use (JWT, OAuth2, etc)
* this library will automatically choose the right client based on the environment.
*/
async function main() {
  const auth = new GoogleAuth({ scopes: 'https://www.googleapis.com/auth/cloud-platform' });
  const token = await auth.getAccessToken();
  console.log(token);
}

// validate assumptions about GOOGLE_APPLICATION_CREDENTIALS env var (as assumed by google-auth-library.GoogleAuth implementation...)
const GOOGLE_APPLICATION_CREDENTIALS = process.env.GOOGLE_APPLICATION_CREDENTIALS
assert(GOOGLE_APPLICATION_CREDENTIALS, 'GOOGLE_APPLICATION_CREDENTIALS environment variable is var not set!');
assert(fs.existsSync(GOOGLE_APPLICATION_CREDENTIALS), `GOOGLE_APPLICATION_CREDENTIALS file '${GOOGLE_APPLICATION_CREDENTIALS}' does not exist!`);

main().catch(error => {
  console.error({ error });
  process.exit(1);
});
