using Org.BouncyCastle.Asn1;
using Org.BouncyCastle.Asn1.Sec;
using Org.BouncyCastle.Crypto.Parameters;
using Security.Cryptography.X509Certificates;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace Win10secp384
{
    class Program
    {
        static void Main(string[] args)
        {
            TestCase("Alice secp256 test cert", "Bob secp256 test cert");
            TestCase("Alice secp384 test cert", "Bob secp384 test cert");
            TestCase("Alice secp521 test cert", "Bob secp521 test cert");

            TestCase("Test ECC Alice secp256r1 SS", "Test ECC Bob secp256r1 SS");
            TestCase("Test ECC Alice secp384r1 SS", "Test ECC Bob secp384r1 SS");
            TestCase("Test ECC Alice secp521r1 SS", "Test ECC Bob secp521r1 SS");

            Console.WriteLine("Press any key to exit ...");
            Console.ReadLine();
        }

        private static void TestCase(string party1Cn, string party2Cn)
        {
            var party1Cert = LoadCert(party1Cn);
            var party2Cert = LoadCert(party2Cn);

            if (party1Cert == null || party2Cert == null)
            {
                Console.WriteLine("ERROR: Test certificates missing. You need to run " + 
                    "\\certs\\InstallTestCerts.bat first. Read the Readme.MD for details.");
                return;
            }
                
            var party1Key = party1Cert.GetCngPrivateKey();
            var party2Key = party2Cert.GetCngPrivateKey();

            var symKey12 = Generate256BitKey(party1Key, party2Cert);
            var symKey21 = Generate256BitKey(party2Key, party1Cert);

            Console.WriteLine("Case {0}-{1}", party1Cn, party2Cn);
            Console.WriteLine("SymKey12 = {0}", BitConverter.ToString(symKey12));
            Console.WriteLine("SymKey21 = {0}", BitConverter.ToString(symKey21));
            Console.WriteLine(new string('-', 30));
        }

        public static X509Certificate2 LoadCert(string searchValue)
        {
            StoreName storeName = StoreName.My;
            StoreLocation storeLocation = StoreLocation.CurrentUser;
            X509FindType searchType = X509FindType.FindBySubjectName;

            X509Certificate2 cert = null;

            // The following code gets the cert from the keystore
            var store = new X509Store(storeName, storeLocation);
            store.Open(OpenFlags.OpenExistingOnly | OpenFlags.ReadOnly);

            var certs = store.Certificates.Find(searchType, searchValue, true);

            if (certs.Count > 0)
            {
                cert = certs[0];
            }
            store.Close();
            return cert;
        }

        private static byte[] Generate256BitKey(CngKey ourPvtEcCngKey, X509Certificate2 theirCert)
        {
            if (ourPvtEcCngKey == null) throw new ArgumentNullException("ourPvtEcCngKey");

            var ourEcDh = new ECDiffieHellmanCng(ourPvtEcCngKey)
            {
                KeyDerivationFunction = ECDiffieHellmanKeyDerivationFunction.Hash,
                HashAlgorithm = CngAlgorithm.Sha256
            };

            ECDiffieHellmanCngPublicKey theirEcDh = GetECDiffieHellmanCngPublicKey(theirCert);
            byte[] symKey = ourEcDh.DeriveKeyMaterial(theirEcDh);

            return symKey;
        }

        private static ECDiffieHellmanCngPublicKey GetECDiffieHellmanCngPublicKey(X509Certificate2 cert)
        {
            var keyAlgoDerBytes = cert.GetKeyAlgorithmParameters();
            var keyAlgoAsn1 = new Asn1InputStream(keyAlgoDerBytes).ReadObject();
            var keyAlgoOid = new DerObjectIdentifier(keyAlgoAsn1.ToString());
            var xmlImport = Rfc4050XmlMaker("ECDH", keyAlgoOid, cert);
            var ecDiffieHellmanCngPublicKey = ECDiffieHellmanCngPublicKey.FromXmlString(xmlImport);
            return ecDiffieHellmanCngPublicKey;
        }

        private static string Rfc4050XmlMaker(string algo, DerObjectIdentifier keyAlgoOid, X509Certificate2 cert)
        {
            if (!algo.Equals("ECDH", StringComparison.InvariantCultureIgnoreCase) &&
                !algo.Equals("ECDSA", StringComparison.InvariantCultureIgnoreCase))
                throw new Exception("Cannot generate rfc4050 keys for unknown EC algorithm");

            algo = algo.ToUpper();
            var namedCurve = SecNamedCurves.GetByOid(keyAlgoOid);
            var publickey = new ECPublicKeyParameters(algo,
                        namedCurve.Curve.DecodePoint(cert.GetPublicKey()), // Q
                        keyAlgoOid);

            //now we have the public key in bouncy castle
            //we can create the xml to import to CngKey            
            string xml = "<" + algo + @"KeyValue xmlns='http://www.w3.org/2001/04/xmldsig-more#'>
                              <DomainParameters>
                                <NamedCurve URN='urn:oid:" + keyAlgoOid.Id + @"' />
                              </DomainParameters>
                              <PublicKey>
                                <X Value='" + publickey.Q.X.ToBigInteger() +
                                                        @"' xsi:type='PrimeFieldElemType' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' />
                                <Y Value='" + publickey.Q.Y.ToBigInteger() +
                                                        @"' xsi:type='PrimeFieldElemType' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' />
                              </PublicKey>
                            </" + algo + "KeyValue>";

            return xml;
        }
    }
}
