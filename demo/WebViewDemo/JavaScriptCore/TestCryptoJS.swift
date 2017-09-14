import UIKit

/// Test CryptoJS
class TestCryptoJSVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testCryptoJS()
        testWebCrypto()
    }
    
    func testCryptoJS() {
        print("[RSA]\n")
        
        // Load only what's necessary
        let RSA = CryptoJS.RSA()
        
        // AES encryption
        let RSAencrypted = RSA.encrypt("80040001")
        print("RSAencrypted:",RSAencrypted)
        
        print("[AES]\n")
        
        // Load only what's necessary
        let AES = CryptoJS.AES()
        
        // AES encryption
        let encrypted = AES.encrypt("Secret message", password: "password123")
        
        // AES encryption with custom mode and padding
        _ = CryptoJS.mode.ECB() // Load custom mode
        _ = CryptoJS.pad.Iso97971() // Load custom padding scheme
        let encrypted2 = AES.encrypt("Secret message", password: "password123", options:[ "mode": CryptoJS.mode().ECB, "padding": CryptoJS.pad().Iso97971 ])
        
        print(encrypted)
        print(encrypted2)
        
        // AES decryption
        print(AES.decrypt(encrypted, password: "password123"))
        
        // AES decryption with custom mode and padding
        print(AES.decrypt(encrypted2, password: "password123", options:[ "mode": CryptoJS.mode().ECB, "padding": CryptoJS.pad().Iso97971 ]))
        
        print("\n[TripeDES]\n")
        
        // Load TripleDES
        let TripleDES = CryptoJS.TripleDES()
        
        // TripleDES encryption
        let TripleDESencrypted = TripleDES.encrypt("Secret message", password: "password123")
        
        print(TripleDESencrypted)
        
        // TripleDES decryption
        print(TripleDES.decrypt(TripleDESencrypted, password: "password123"))
        
        print("\n[DES]\n")
        
        // Load DES
        let DES = CryptoJS.DES()
        
        // TripleDES encryption
        let DESencrypted = DES.encrypt("Secret message", password: "password123")
        
        print(DESencrypted)
        
        // TripleDES decryption
        print(DES.decrypt(DESencrypted, password: "password123"))
        
        print("\n[Hashing functions]\n")
        
        // Hashers
        let MD5 = CryptoJS.MD5()
        let SHA1 = CryptoJS.SHA1()
        let SHA224 = CryptoJS.SHA224()
        let SHA256 = CryptoJS.SHA256()
        let SHA384 = CryptoJS.SHA384()
        let SHA512 = CryptoJS.SHA512()
        let SHA3 = CryptoJS.SHA3()
        let RIPEMD160 = CryptoJS.RIPEMD160()
        
        print(MD5.hash("mystring"))
        print(SHA1.hash("mystring"))
        print(SHA224.hash("mystring"))
        print(SHA256.hash("mystring"))
        print(SHA384.hash("mystring"))
        print(SHA512.hash("mystring"))
        print(SHA3.hash("mystring"))
        print(SHA3.hash("mystring",outputLength: 256))
        print(RIPEMD160.hash("mystring"))
    }
    
    func testWebCrypto() {
        
        let crypto = WebCrypto()
        
        crypto.generateKey(callback: {(key: String?, error: Error?) in
            print("Key:", key!)
        })
        crypto.generateKey(length: 192, callback: {(key: String?, error: Error?) in
            print("Key:", key!)
        })
        crypto.generateKey(length: 128, callback: {(key: String?, error: Error?) in
            print("Key:", key!)
        })
        
        crypto.generateIv(callback: {(iv: String?, error: Error?) in
            print("Iv:", iv!)
        })
        
        crypto.generateRandomNumber(length: 16, callback: {(number: String?, error: Error?) in
            print("Random number:", number!)
        })
        
        // AES string encryption
        
        let password = "awdawdawdawd"
        let stringSample = Data("Nullam quis risus egét urna mollis ornare vel eu leo.".utf8)
        
        crypto.encrypt(data: stringSample, password: password, callback: {(encrypted: Data?, error: Error?) in
            crypto.decrypt(data: encrypted!, password: password, callback: {(decrypted: Data?, error: Error?) in
                if decrypted! == stringSample {
                    print("Password-based encryption: success")
                }else{
                    print("Fail")
                }
            })
        })
        
        let key = "6f0f1c6f0e56afd327ff07b7b63a2d8ae91ab0a2f0c8cd6889c0fc1d624ac1b8"
        let iv = "92c9d2c07a9f2e0a0d20710270047ea2"
        
        crypto.encrypt(data: stringSample, key: key, iv: iv, callback: {(encrypted: Data?, error: Error?) in
            crypto.decrypt(data: encrypted!, key: key, iv: iv, callback: {(decrypted: Data?, error: Error?) in
                if decrypted! == stringSample {
                    print("Key-based encryption: success")
                }else{
                    print("Fail")
                }
            })
        })
        
        /*
         
         // AES file encryption
         
         do{
         // Load file from disk
         let sampleFileData = try Data(contentsOf: URL(string: "file:///var/tmp")!.appendingPathComponent("test10Mb.db"))
         
         let start = Date().timestamp()
         
         crypto.encrypt(data: sampleFileData, password: password, callback: {(encrypted: Data?, error: Error?) in
         
         print(Date().timestamp()-start)
         
         crypto.decrypt(data: encrypted!, password: password, callback: {(decrypted: Data?, error: Error?) in
         if decrypted! == sampleFileData {
         print("File successfully encrypted & decrypted")
         }else{
         print("Fail")
         }
         })
         })
         }catch(let error){
         print(error)
         }
         
         */
        
        // Hashing functions
        
        crypto.sha1(data: stringSample, callback: {(hash: String?, error: Error?) in
            if( hash! == "eab24f488a7cfbefde8436ad07a7402b98d50027" ){
                print("SHA1: success")
            }else{
                print("Fail")
            }
        })
        
        crypto.sha256(data: stringSample, callback: {(hash: String?, error: Error?) in
            if( hash! == "84be75d50e83e91f79a204b8191930b05a94e7fb4703c00d8a59e32890a9b2b0" ){
                print("SHA256: success")
            }else{
                print("Fail")
            }
        })
        
        crypto.sha384(data: stringSample, callback: {(hash: String?, error: Error?) in
            if( hash! == "7cee02575d6aaccd056914b1127b8f6a58fe3151f9b364fb747152d626ee24f153bc844c6e29ceaba81103323f4622a8" ){
                print("SHA384: success")
            }else{
                print("Fail")
            }
        })
        
        crypto.sha512(data: stringSample, callback: {(hash: String?, error: Error?) in
            if( hash! == "06024333c37aa22f2bcca35687cf603438c1e33aaa67b3435c464eff73f5ea03a030f223c274d96f6cd388837871c109a075e5dc2e911c23baacadb36450ae50" ){
                print("SHA512: success")
            }else{
                print("Fail")
            }
        })
        
        // Data conversion
        
        let dataKey = Data(bytes: [0, 1, 127, 128, 255, 0, 1, 127, 128, 255, 0, 1, 127, 128, 255, 3])
        
        if dataKey == crypto.dataFromHexEncodedString(crypto.hexEncodedStringFromData(dataKey)) {
            print("Hexadecimal data conversion: success")
        }
        
    }
}
