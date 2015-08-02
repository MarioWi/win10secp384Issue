@echo off
REM We use OpenSSL to create a pair of self-signed elliptic curve certificates

echo These Certificates seem to pass the test
call MakeEcCertSelfSigned "Alice secp256 test cert" secp256r1
call MakeEcCertSelfSigned "Alice secp384 test cert" secp384r1
call MakeEcCertSelfSigned "Alice secp521 test cert" secp521r1
call MakeEcCertSelfSigned "Bob secp256 test cert" secp256r1
call MakeEcCertSelfSigned "Bob secp384 test cert" secp384r1
call MakeEcCertSelfSigned "Bob secp521 test cert" secp521r1

echo Done!
