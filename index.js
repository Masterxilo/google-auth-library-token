const { GoogleAuth } = require('google-auth-library');

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

main().catch(error => {
  console.error({ error });
  process.exit(1);
});
