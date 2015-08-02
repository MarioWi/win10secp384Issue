@echo off
echo Installing the certificates into user's certificate store
certutil -f -user -p Testing123 -importPFX MY "Alice secp256 test cert.pfx"
certutil -f -user -p Testing123 -importPFX MY "Alice secp384 test cert.pfx"
certutil -f -user -p Testing123 -importPFX MY "Alice secp521 test cert.pfx"
certutil -f -user -p Testing123 -importPFX MY "Bob secp256 test cert.pfx"
certutil -f -user -p Testing123 -importPFX MY "Bob secp384 test cert.pfx"
certutil -f -user -p Testing123 -importPFX MY "Bob secp521 test cert.pfx"

certutil -f -user -p test -importPFX MY "Test ECC Alice secp256r1 SS.pfx"
certutil -f -user -p test -importPFX MY "Test ECC Alice secp384r1 SS.pfx"
certutil -f -user -p test -importPFX MY "Test ECC Alice secp521r1 SS.pfx"
certutil -f -user -p test -importPFX MY "Test ECC Bob secp256r1 SS.pfx"
certutil -f -user -p test -importPFX MY "Test ECC Bob secp384r1 SS.pfx"
certutil -f -user -p test -importPFX MY "Test ECC Bob secp521r1 SS.pfx"

echo Done!
