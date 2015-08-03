This code is to support the question at http://security.stackexchange.com/questions/95631/is-sec-p-384-and-p-521-broken-in-windows-10

Core Issue
==========
As seen in the Windows 10 program output, several ECDH secp384 and ECDH secp521 scenarios that passed on Windows 8.1 now fail on Windows 10 for no obvious reasons.

Prerequisite
------------
You need to run `\Certs\InstallTestCerts.bat` to install the certificates. `RemoveTestCerts.bat` cleans them up. You don't need to create the PFX file but if you want, `RemoveTestCerts.bat` will do so; `git revert` to get the original .pfx files again.

Running the sample code snippet
-------------------------------
After doing the above, open the solution in visual studio and hit Run. For those without visual studio, the `/bin/debug/` folder has also been pushed into git.

Program results
===============
For those not having access to Visual Studio, here is the output (the certificates and code is available on GitHub)

Windows 10 output (version NT 10.0.10240.0)
-------------------------------------------

	'Test ECC Alice secp521r1 SS' <=> 'Test ECC Bob secp521r1 SS'
	> FAILURE < ECDH Keys are different!
	SymKey12 = 22-46-6B-15-0F-9B-65-B0-D6-7D-AA-0E-C5-8A-7F-F3-18-1F-5F-62-88-26-90-67-DC-99-1B-98-73-3B-58-FF
	SymKey21 = FD-C3-24-27-4C-4C-56-01-62-1E-B2-AE-B1-F6-68-64-61-72-EB-2E-6D-F4-30-21-F1-8A-73-C6-85-38-25-FA
	------------------------------
	'Test ECC Alice secp384r1 SS' <=> 'Test ECC Bob secp384r1 SS'
	> FAILURE < ECDH Keys are different!
	SymKey12 = F3-55-B0-72-49-DA-A5-6B-D7-3E-B7-F5-87-E7-4B-D1-20-A1-6E-67-EE-FF-C2-A9-12-E4-B0-20-46-F7-A5-FA
	SymKey21 = 8C-63-5E-21-AC-BB-C1-AB-17-73-E2-E9-4D-95-20-07-6A-60-69-B1-E6-3B-18-EA-B6-56-FF-38-9F-F8-46-2F
	------------------------------
	'Test ECC Alice secp256r1 SS' <=> 'Test ECC Bob secp256r1 SS'
	Success, ECDH Keys agree
	------------------------------
	'Alice secp521 test cert' <=> 'Bob secp521 test cert'
	> FAILURE < ECDH Keys are different!
	SymKey12 = B3-90-1C-1B-B0-66-BB-D8-A2-46-37-A9-E4-84-1F-FE-B8-ED-14-17-A8-D8-0C-EB-20-A0-98-5F-3A-85-73-3D
	SymKey21 = 44-62-AD-3F-DA-D4-7E-17-49-05-C4-22-93-DD-36-B7-0D-28-47-93-E5-D4-63-03-00-BC-F8-99-DF-BA-A3-92
	------------------------------
	'Alice secp384 test cert' <=> 'Bob secp384 test cert'
	Success, ECDH Keys agree
	------------------------------
	'Alice secp256 test cert' <=> 'Bob secp256 test cert'
	Success, ECDH Keys agree
	------------------------------
	Press any key to exit ...

Windows 8 output (version NT 6.3.9600.0)
----------------------------------------
	
	'Test ECC Alice secp521r1 SS' <=> 'Test ECC Bob secp521r1 SS'
	Success, ECDH Keys agree
	------------------------------
	'Test ECC Alice secp384r1 SS' <=> 'Test ECC Bob secp384r1 SS'
	Success, ECDH Keys agree
	------------------------------
	'Test ECC Alice secp256r1 SS' <=> 'Test ECC Bob secp256r1 SS'
	Success, ECDH Keys agree
	------------------------------
	'Alice secp521 test cert' <=> 'Bob secp521 test cert'
	Success, ECDH Keys agree
	------------------------------
	'Alice secp384 test cert' <=> 'Bob secp384 test cert'
	Success, ECDH Keys agree
	------------------------------
	'Alice secp256 test cert' <=> 'Bob secp256 test cert'
	Success, ECDH Keys agree
	------------------------------
	Press any key to exit ...	
	
