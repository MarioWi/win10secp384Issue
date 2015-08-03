This code is to support the question at http://security.stackexchange.com/questions/95631/is-sec-p-384-and-p-521-broken-in-windows-10

Prerequisite
------------
You need to run `\Certs\InstallTestCerts.bat` to install the certificates. `RemoveTestCerts.bat` cleans them up. You don't need to create the PFX file but if you want, `RemoveTestCerts.bat` will do so; `git revert` to get the original .pfx files again.

Running the sample code snippet
-------------------------------
After doing the above, open the solution in visual studio and hit Run. For those without visual studio, the `/bin/debug/` folder has also been pushed into git.

The core issue
--------------
Here we spotlight the issue seen on Windows 10. For the full outputs on Windows 10 and Windows 8.1, see below. The output in bold below is incorrect.

	Case Test ECC Alice secp384r1 SS-Test ECC Bob secp384r1 SS
	SymKey12 = F3-55-B0-72-49-DA-A5-6B-D7-3E-B7-F5-87-E7-4B-D1-20-A1-6E-67-EE-FF-C2-A9-12-E4-B0-20-46-F7-A5-FA
	**SymKey21 = 8C-63-5E-21-AC-BB-C1-AB-17-73-E2-E9-4D-95-20-07-6A-60-69-B1-E6-3B-18-EA-B6-56-FF-38-9F-F8-46-2F**
	------------------------------
	Case Test ECC Alice secp521r1 SS-Test ECC Bob secp521r1 SS
	**SymKey12 = 22-46-6B-15-0F-9B-65-B0-D6-7D-AA-0E-C5-8A-7F-F3-18-1F-5F-62-88-26-90-67-DC-99-1B-98-73-3B-58-FF**
	SymKey21 = FD-C3-24-27-4C-4C-56-01-62-1E-B2-AE-B1-F6-68-64-61-72-EB-2E-6D-F4-30-21-F1-8A-73-C6-85-38-25-FA
	------------------------------

**SymKey12 should be identical to SymKey21.** 

Interestingly, the `Alice secp521 test cert`, `Bob secp521 test cert` certificate pairs do have matching keys even on Windows 10 so something peculiar about the `Test ECC Alice secp521r1 SS` and `Test ECC Bob secp521r1` certificate pair might be causing the bug to surface(?). Same for the secp384 pair.

Program results
===============
For those not having access to Visual Studio, here is the output (the certificates and code is available on GitHub)

Windows 10 output (version NT 10.0.10240.0)
-------------------------------------------

	Case Alice secp256 test cert-Bob secp256 test cert
	SymKey12 = 2D-6E-F9-E3-6D-A0-4B-E6-D8-66-D1-2B-DD-E0-1C-2A-2D-7F-BC-B5-AD-BD-EF-74-86-AD-14-1A-D9-C6-A5-DC
	SymKey21 = 2D-6E-F9-E3-6D-A0-4B-E6-D8-66-D1-2B-DD-E0-1C-2A-2D-7F-BC-B5-AD-BD-EF-74-86-AD-14-1A-D9-C6-A5-DC
	------------------------------
	Case Alice secp384 test cert-Bob secp384 test cert
	SymKey12 = D1-45-6D-16-46-E1-EF-9C-CB-71-30-30-37-1C-14-19-79-0F-7F-5C-D9-0C-ED-F0-79-67-C7-68-1B-16-75-71
	SymKey21 = D1-45-6D-16-46-E1-EF-9C-CB-71-30-30-37-1C-14-19-79-0F-7F-5C-D9-0C-ED-F0-79-67-C7-68-1B-16-75-71
	------------------------------
	Case Alice secp521 test cert-Bob secp521 test cert
	SymKey12 = B3-90-1C-1B-B0-66-BB-D8-A2-46-37-A9-E4-84-1F-FE-B8-ED-14-17-A8-D8-0C-EB-20-A0-98-5F-3A-85-73-3D
	SymKey21 = 44-62-AD-3F-DA-D4-7E-17-49-05-C4-22-93-DD-36-B7-0D-28-47-93-E5-D4-63-03-00-BC-F8-99-DF-BA-A3-92
	------------------------------
	Case Test ECC Alice secp256r1 SS-Test ECC Bob secp256r1 SS
	SymKey12 = AC-4D-4C-C7-4B-FD-E4-AA-4F-81-0F-CB-91-6A-11-9F-C2-D4-3C-1C-4C-FC-4D-1E-ED-AE-F4-29-E3-E0-D7-A5
	SymKey21 = AC-4D-4C-C7-4B-FD-E4-AA-4F-81-0F-CB-91-6A-11-9F-C2-D4-3C-1C-4C-FC-4D-1E-ED-AE-F4-29-E3-E0-D7-A5
	------------------------------
	Case Test ECC Alice secp384r1 SS-Test ECC Bob secp384r1 SS
	SymKey12 = F3-55-B0-72-49-DA-A5-6B-D7-3E-B7-F5-87-E7-4B-D1-20-A1-6E-67-EE-FF-C2-A9-12-E4-B0-20-46-F7-A5-FA
	SymKey21 = 8C-63-5E-21-AC-BB-C1-AB-17-73-E2-E9-4D-95-20-07-6A-60-69-B1-E6-3B-18-EA-B6-56-FF-38-9F-F8-46-2F
	------------------------------
	Case Test ECC Alice secp521r1 SS-Test ECC Bob secp521r1 SS
	SymKey12 = 22-46-6B-15-0F-9B-65-B0-D6-7D-AA-0E-C5-8A-7F-F3-18-1F-5F-62-88-26-90-67-DC-99-1B-98-73-3B-58-FF
	SymKey21 = FD-C3-24-27-4C-4C-56-01-62-1E-B2-AE-B1-F6-68-64-61-72-EB-2E-6D-F4-30-21-F1-8A-73-C6-85-38-25-FA
	------------------------------
	Press any key to exit ...

Windows 8 output (version NT 6.3.9600.0)
----------------------------------------
	
	Case Alice secp256 test cert-Bob secp256 test cert
	SymKey12 = 2D-6E-F9-E3-6D-A0-4B-E6-D8-66-D1-2B-DD-E0-1C-2A-2D-7F-BC-B5-AD-BD-EF-74-86-AD-14-1A-D9-C6-A5-DC
	SymKey21 = 2D-6E-F9-E3-6D-A0-4B-E6-D8-66-D1-2B-DD-E0-1C-2A-2D-7F-BC-B5-AD-BD-EF-74-86-AD-14-1A-D9-C6-A5-DC
	------------------------------
	Case Alice secp384 test cert-Bob secp384 test cert
	SymKey12 = D1-45-6D-16-46-E1-EF-9C-CB-71-30-30-37-1C-14-19-79-0F-7F-5C-D9-0C-ED-F0-79-67-C7-68-1B-16-75-71
	SymKey21 = D1-45-6D-16-46-E1-EF-9C-CB-71-30-30-37-1C-14-19-79-0F-7F-5C-D9-0C-ED-F0-79-67-C7-68-1B-16-75-71
	------------------------------
	Case Alice secp521 test cert-Bob secp521 test cert
	SymKey12 = 44-62-AD-3F-DA-D4-7E-17-49-05-C4-22-93-DD-36-B7-0D-28-47-93-E5-D4-63-03-00-BC-F8-99-DF-BA-A3-92
	SymKey21 = 44-62-AD-3F-DA-D4-7E-17-49-05-C4-22-93-DD-36-B7-0D-28-47-93-E5-D4-63-03-00-BC-F8-99-DF-BA-A3-92
	------------------------------
	Case Test ECC Alice secp256r1 SS-Test ECC Bob secp256r1 SS
	SymKey12 = AC-4D-4C-C7-4B-FD-E4-AA-4F-81-0F-CB-91-6A-11-9F-C2-D4-3C-1C-4C-FC-4D-1E-ED-AE-F4-29-E3-E0-D7-A5
	SymKey21 = AC-4D-4C-C7-4B-FD-E4-AA-4F-81-0F-CB-91-6A-11-9F-C2-D4-3C-1C-4C-FC-4D-1E-ED-AE-F4-29-E3-E0-D7-A5
	------------------------------
	Case Test ECC Alice secp384r1 SS-Test ECC Bob secp384r1 SS
	SymKey12 = F3-55-B0-72-49-DA-A5-6B-D7-3E-B7-F5-87-E7-4B-D1-20-A1-6E-67-EE-FF-C2-A9-12-E4-B0-20-46-F7-A5-FA
	SymKey21 = F3-55-B0-72-49-DA-A5-6B-D7-3E-B7-F5-87-E7-4B-D1-20-A1-6E-67-EE-FF-C2-A9-12-E4-B0-20-46-F7-A5-FA
	------------------------------
	Case Test ECC Alice secp521r1 SS-Test ECC Bob secp521r1 SS
	SymKey12 = FD-C3-24-27-4C-4C-56-01-62-1E-B2-AE-B1-F6-68-64-61-72-EB-2E-6D-F4-30-21-F1-8A-73-C6-85-38-25-FA
	SymKey21 = FD-C3-24-27-4C-4C-56-01-62-1E-B2-AE-B1-F6-68-64-61-72-EB-2E-6D-F4-30-21-F1-8A-73-C6-85-38-25-FA
	------------------------------
	Press any key to exit ...	