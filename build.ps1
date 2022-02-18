$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

mkdir dist -ErrorAction SilentlyContinue
Remove-Item dist/* -ErrorAction SilentlyContinue

# depends on nodejs/npm
npm run package

pushd dist
Copy-Item google-auth-library-token-win.exe google-auth-library-token.exe -ErrorAction SilentlyContinue
Copy-Item google-auth-library-token.exe google-auth-library-token-win.exe -ErrorAction SilentlyContinue
Copy-Item google-auth-library-token-linux google-auth-library-token -ErrorAction SilentlyContinue
Copy-Item google-auth-library-token google-auth-library-token-linux -ErrorAction SilentlyContinue

Remove-Item *-linux -ErrorAction SilentlyContinue
Remove-Item *-win.exe -ErrorAction SilentlyContinue
popd
