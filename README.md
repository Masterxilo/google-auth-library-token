# google-auth-library-token
aka. GOOGLE_APPLICATION_CREDENTIALS_to_access_token, GOOGLE_APPLICATION_CREDENTIALS to Authorization header

## TLDR usage
Download either executable `google-auth-library-token(.exe)` from `dist`:

Windows:
```cmd
curl.exe -L https://github.com/Masterxilo/google-auth-library-token/raw/master/dist/google-auth-library-token.exe -o google-auth-library-token.exe
```
Linux:
```bash
curl -L https://github.com/Masterxilo/google-auth-library-token/raw/master/dist/google-auth-library-token -o google-auth-library-token ; chmod +x ./google-auth-library-token
```

Define the environment variable [`GOOGLE_APPLICATION_CREDENTIALS`](https://cloud.google.com/docs/authentication/application-default-credentials) to point to a service account credentials .json file `export GOOGLE_APPLICATION_CREDENTIALS` or `$env:GOOGLE_APPLICATION_CREDENTIALS`, `%GOOGLE_APPLICATION_CREDENTIALS%`, e.g.

```bash
export GOOGLE_APPLICATION_CREDENTIALS="$(realpath GOOGLE_APPLICATION_CREDENTIALS)"
```
```powershell
$env:GOOGLE_APPLICATION_CREDENTIALS=(Get-Item GOOGLE_APPLICATION_CREDENTIALS).FullName
```

to point to the full path of a `GOOGLE_APPLICATION_CREDENTIALS` file sometimes named `service-account-file.json` containing something like

```
{
  "type": "service_account",
  "project_id": "googlecloudprojectname-....",
  "private_key_id": "0e2382b3....e829",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBAzGF2D....5PrjwqY5TxkckWI.............Y8XXTZSilaEZw9NbYNXkJbDNYbAZmpQ4KJUV4CX1AoGBALxfl4vAexkBr3OrPw47\nJIStE/+6XbbTTqzg\n/\n6sQosMIlSscB2EI3tnsdVg6M\n-----END PRIVATE KEY-----\n",
  "client_email": "clientname@projectname-projectid.iam.gserviceaccount.com",
  "client_id": "10.....672",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/clientname%40projectname-projectid.iam.gserviceaccount.com"
}
```

then run it

```bash
./google-auth-library-token


# or alternatively, using docker
sudo docker run --rm --volume /:/host --env "GOOGLE_APPLICATION_CREDENTIALS=/host${GOOGLE_APPLICATION_CREDENTIALS}" masterxilo/google-auth-library-token
```

and obtain on stdout an access_token like:

```
ya29.c.b0AXv0zTMcQpRhiECLqICqHZNgzbGeuQ0ArL9l********************Ni1Oi9Q0cOarCqUZPCNDX70........................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................................
```

that can be sent to authenticate/authorize the given client to Google APIs via https header

```
Authorization: Bearer ${access_token}
```

# Performance Comparison
Given a properly configured `GOOGLE_APPLICATION_CREDENTIALS` env variable:

```bash
$ time gcloud auth application-default print-access-token
ya29.c.c0ASRK0GYgbQi9-jPK19_NeEPenRviiM7-G3FetLySV_nRT1kdzexKPzwRj-IQpCyAu_T4h8z5BsjQ3eepXIWk5uV8O5wlij2i7oonYh_4QUCQMpP0jDU6Q2q9OcKcacEAvSgTEOJd2aGtzRUj3cKx_UtqP5iOOsD0Ueix-lilAQdistCh26zahKJaZ3_dfDPslOpJDAlG0IUqxrmD0TjfnxFqLLf84VRt2bTuoGh9mcx_HpXMvSkunxGBqDtMLXVHDxg-SCA3UJ3HNtS92ZBbcXiU0RDrRzJjOxTe8MONZ5ggGY.....9wdygyXz9rlVwvJpz1-tpQcmdp2Jv3V7

real    0m0.543s
user    0m0.422s
sys     0m0.053s

$ time ./google-auth-library-token 2>/dev/null
ya29.c.c0ASRK0GYmRff9DmE-vfSSqi4hEsIGZG7JPUZtLK18X_J7kk2kErH8qQjYN3ugNqxTHIkb0AQ2ffy...5qhSbczqZtdBo43V-hi7kR7m-4Uogvc644eBgI2_izl6FJB-YJ8SQF5MS6phB0VRcMUysdSOjX1F3XmmzcrfSs

real    0m0.172s
user    0m0.079s
sys     0m0.023s

```

# Troubleshooting
```
{
  error: Error: error:25066067:DSO support routines:dlfcn_load:could not load the shared library
      at Sign.sign (internal/crypto/sig.js:105:29)
      at Object.sign (/snapshot/app/node_modules/jwa/index.js:152:45)
      at Object.jwsSign [as sign] (/snapshot/app/node_modules/jws/lib/sign-stream.js:32:24)
      at GoogleToken.requestToken (/snapshot/app/node_modules/gtoken/build/src/index.js:225:31)
      at GoogleToken.getTokenAsyncInner (/snapshot/app/node_modules/gtoken/build/src/index.js:163:21)
      at GoogleToken.getTokenAsync (/snapshot/app/node_modules/gtoken/build/src/index.js:142:55)
      at GoogleToken.getToken (/snapshot/app/node_modules/gtoken/build/src/index.js:94:21)
      at JWT.refreshTokenNoCache (/snapshot/app/node_modules/google-auth-library/build/src/auth/jwtclient.js:171:36)
      at JWT.refreshToken (/snapshot/app/node_modules/google-auth-library/build/src/auth/oauth2client.js:152:24)
      at JWT.refreshAccessTokenAsync (/snapshot/app/node_modules/google-auth-library/build/src/auth/oauth2client.js:198:30) {
    opensslErrorStack: [
      'error:0E076071:configuration file routines:module_run:unknown module name',
      'error:0E07506E:configuration file routines:module_load_dso:error loading dso',
      'error:25070067:DSO support routines:DSO_load:could not load the shared library'
    ],
    library: 'DSO support routines',
    function: 'dlfcn_load',
    reason: 'could not load the shared library',
    code: 'ERR_OSSL_DSO_COULD_NOT_LOAD_THE_SHARED_LIBRARY'
  }
}
```

workaround
```bash
export OPENSSL_CONF=/dev/null
```

# Description
Reads the file pointed to by the GOOGLE_APPLICATION_CREDENTIALS environment variable and obtains a new oauth 2 token for the service client/service account described by it to access Google APIs.

Figuring out how long the token will be valid is a separate concern.

This tool has about the same function as

```bash
gcloud auth application-default print-access-token
```

but does not depend on the entire google-cloud-sdk.

# See
* https://cloud.google.com/docs/authentication/getting-started
* https://cloud.google.com/docs/authentication/production

# Implementation and building
Current implementation uses [google-auth-library](https://www.npmjs.com/package/google-auth-library).GoogleAuth. Binaries are pretty large because they bundle nodejs (built using [pkg](https://www.npmjs.com/package/pkg)), but at least run fast.

You can build it on your own using powershell on Windows, pwsh or bash, assuming nodejs/npm are installed:
```
npm install
./build
```

## TODO
[ ] Maybe we could use cpp client lib for highest efficiency and smaller binaries instead of this insanely large node packaged app.
* https://github.com/googleapis/google-cloud-cpp
* https://github.com/googleapis/google-cloud-cpp/blob/main/google/cloud/storage/quickstart/README.md

[ ] the tool would be more useful if you could also pass the filename GOOGLE_APPLICATION_CREDENTIALS as a relative path as a commandline argument or even the contents of the file...

[x] alpine (musl) instead of glibc based version

# Tags
GOOGLE_APPLICATION_CREDENTIALS

google-auth-library GoogleAuth example

token

access token

OAuth 2.0

Google APIs

Authentication

Service Client

Service Credentials

Service Account

Machine to Machine authentication

Google Cloud

gcloud

google-cloud-sdk
