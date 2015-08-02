@echo off
setlocal ENABLEDELAYEDEXPANSION
@echo.
@echo Description: Uses OpenSSL to create a specified named curve (defaults to secp521r1 if omitted) EC certificate (PEM). Also creates the PKCS#12 file to export the cert as well as the private key (AES256 encrypted)
@echo.

REM OpenSSL Setup Intro
REM ======================
REM Temporarily modify path to avoid conflicts with end-machine's current configuration
cd openssl
set __PrevPath=%PATH%
set PATH=""
set OPENSSL_CONF=openssl.cnf
date /t > .rnd
time /t >> .rnd
set HOME=.
set RANDFILE=.rnd

REM Input parsing & file setup
REM ======================
if [%1]==[] (
	set commonName=Test 1
	) else (
	set commonName=%1
	set commonName=!commonName:"=!
)

if [%2]==[] (
	SET curve=secp521r1
) else (
	SET curve=%2
)

SET keyTempFile="!commonName!.key.temp.pem"
SET keyFile="!commonName!.key.pem"
SET reqFile="!commonName!.csr"
SET certFile="!commonName!.cert.crt"
SET exportFile="../!commonName!.pfx"

echo Delete temp files from any prev runs, don't wipe out key!
echo ---------------------------------------------------
del /q /f %reqFile% %certFile% %exportFile% 

REM Actual certificate creation
REM ======================

REM http://infosecurity.ch/20100926/not-every-elliptic-curve-is-the-same-trough-on-ecc-security/
REM ------------+---------------+-------------
REM SECG        |  ANSI X9.62   |  NIST
REM ------------+---------------+-------------
REM secp256r1   |  prime256v1   |   NIST P-256 <=Suite B
REM secp384r1   |               |   NIST P-384 <=Suite B
REM secp521r1   |               |   NIST P-521
REM Basically use secp256r1 or secp384r1 or secp521r1
echo Create a new named curve EC key
echo -------------------------------
openssl ecparam -out %keyTempFile% -name %curve% -genkey

echo Make a certificate request, request signed via SHA512, set the common name
echo --------------------------------------------------------------------------
openssl req -new -key %keyTempFile% -sha512 -keyform PEM -out %reqFile% -outform PEM -subj '/C=US/CN=%commonName%'
IF %ERRORLEVEL% NEQ 0 GOTO :eof

echo Encrypt the EC key
echo -------------------
openssl ec -in %keyTempFile% -out %keyFile% -aes256 -passout file:testpassword.txt
IF %ERRORLEVEL% NEQ 0 GOTO :eof

echo Create (self-signed) certificate, ~10 years. This certificate will sign using SHA512
echo ----------------------------------------------------------------------------------
openssl x509 -req -days 3650 -extensions usr_cert -in %reqFile% -signkey %keyTempFile% -out %certFile% -sha512 
IF %ERRORLEVEL% NEQ 0 GOTO :eof

echo Export the certificate and private key, AES256 encrypt it, set friendly name
echo ----------------------------------------------------------------------------
openssl pkcs12 -export -aes256 -out %exportFile% -in %certFile% -inkey %keyTempFile% -name "%commonName%" -passout file:testpassword.txt
IF %ERRORLEVEL% NEQ 0 GOTO :eof

echo Delete the unencrypted key file (assumes secure storage/encrypted disks)
echo ------------------------------------------------------------------------
del /q /f %keyTempFile% %keyFile% %reqFile% %certFile%

REM OpenSSL Setup Outro
REM ======================
set PATH=%__PrevPath%
set __PrevPath=""
cd ..

goto :eof

:usage
@echo Usage: MakeEcCertSelfSigned certCommonName [namedCurve]
exit /B 1