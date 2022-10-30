# google-auth-library-token aka. GOOGLE_APPLICATION_CREDENTIALS_to_access_token

## TLDR usage
Download either executable `google-auth-library-token(.exe)` from `dist`, define/`export GOOGLE_APPLICATION_CREDENTIALS` or `$env:GOOGLE_APPLICATION_CREDENTIALS`, `%GOOGLE_APPLICATION_CREDENTIALS%`, e.g.

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

then run

```
# curl.exe -L https://github.com/Masterxilo/google-auth-library-token/raw/master/dist/google-auth-library-token.exe -o google-auth-library-token.exe
# curl -L https://github.com/Masterxilo/google-auth-library-token/raw/master/dist/google-auth-library-token -o google-auth-library-token ; chmod +x ./google-auth-library-token

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

# Description
Reads the file pointed to by the GOOGLE_APPLICATION_CREDENTIALS environment variable and obtains a new oauth 2 token for the service client/service account described by it to access Google APIs.

Figuring out how long the token will be valid is a separate concern.

This tool has about the same function as

```bash
gcloud auth application-default print-access-token
```

but does not depend on the entire google-cloud-sdk.

## See
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
