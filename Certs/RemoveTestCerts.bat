REM Remove from certificate stores
certutil -user -delstore My "Alice secp256 test cert"
certutil -user -delstore My "Alice secp384 test cert"
certutil -user -delstore My "Alice secp521 test cert"
certutil -user -delstore My "Bob secp256 test cert"
certutil -user -delstore My "Bob secp384 test cert"
certutil -user -delstore My "Bob secp521 test cert"


certutil -user -delstore My "Test ECC Alice secp256r1 SS"
certutil -user -delstore My "Test ECC Alice secp384r1 SS"
certutil -user -delstore My "Test ECC Alice secp521r1 SS"
certutil -user -delstore My "Test ECC Bob secp256r1 SS"
certutil -user -delstore My "Test ECC Bob secp384r1 SS"
certutil -user -delstore My "Test ECC Bob secp521r1 SS"

echo Cleanup complete.
