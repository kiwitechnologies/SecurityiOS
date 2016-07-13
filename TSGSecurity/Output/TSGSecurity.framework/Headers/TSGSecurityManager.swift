//
//  TSGSecurityManager.swift
//  TSGSecurity
//
//  Created by kiwitech on 14/04/16.
//  Copyright © 2016 kiwitech. All rights reserved.
//

/* -------------------------------------------------------------------------------------------
 * A class is written to manage the different type of encryptions and respective decryptions 
 * eg. AES, ChaCha20.
 * It also supports md5Hashing
 * Reduce the line of code in entire application.
 * —————————————————————————————————————————————-----------------------------------------------*/

import Foundation

public enum EncryptionType:Int
{
    case AES
    case CHACHA20
    case GET_KEYCHAIN_VALUE
    case OTHER
}

public class TSGSecurityManager {
   

    /*
     *	@functionName	: encryptObjectWithSuccess
     *	@parameters		: key : It would be the key to encrypt the given string
     *                  : iv  : It would be the Intialization vector (for more info: http://crypto.stackexchange.com/questions/732/why-use-an-initialization-vector-iv
     *                  : object : It could be any object i.e String or Data
     *                  : encryptionType : It specify the type of encryption you want to implelment
     *                  : completion : Its completion block which will catch success state and object
     *                  :
     * */

    public class func encryptObjectWithSuccess(key:String, iv:String, object:AnyObject!, encryptionType:EncryptionType,
                                               onCompletion completion:(Bool,AnyObject)-> ()) {
        
        var encryptedObj:AnyObject
        
        switch encryptionType {
            
        case .AES:
            do{
                encryptedObj = try TSGHelper.aesEncrypt(key, iv: iv, object: object)
                
                switch encryptedObj {
                    
                case is NSError:
                    completion(false,NSError(domain: "Error", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Unable to Encrypt"]))
                    
                default:
                    completion(true,encryptedObj)
                    
                }
            } catch{
                completion(false,NSError(domain: "Error", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Unable to Encrypt"]))
            }
            
        case .CHACHA20:
            do {
                encryptedObj = try TSGHelper.chacha20Encypt(key, iv: iv, object: object)
                completion(true,encryptedObj)
                
            } catch{
                completion(false,"Unable to encrypt")
            }
            
        default:
            completion(false,"Unable to encrypt")
            
        }
        
    }
    /*
     *	@functionName	: decryptObjectWithSuccess
     *	@parameters		: key : It would be the key to encrypt the given string
     *                  : iv  : It would be the Intialization vector (for more info: http://crypto.stackexchange.com/questions/732/why-use-an-initialization-vector-iv
     *                  : object : It could be any object i.e String or Data
     *                  : encryptionType : It specify the type of encryption you want to implelment
     *                  : completion : Its completion block which will catch success state and object
     *
     * */
    

    public class func decryptObjectWithSuccess(key:String, iv:String, object:AnyObject!, decryptionType:EncryptionType,
                                                onCompletion completion:(Bool,AnyObject)-> ()) {
        
        var decryptedObj:AnyObject!
        
        switch decryptionType {
            
        case .AES:
            do {
                decryptedObj = try TSGHelper.aesDecrypt(key, iv: iv, object: object)
                completion(true,decryptedObj)
            } catch{
                completion(false, NSError(domain: "Error", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Unable to Encrypt"]))
            }
            break
            
        case .CHACHA20:
            do {
                decryptedObj = try TSGHelper.chacha20Decrypt(key, iv: iv, object: object)
                completion(true,decryptedObj)
            } catch{
                completion(false, NSError(domain: "Error", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Unable to Encrypt"]))
            }
            break
            
        default:
            break
        }
    }
    
    /*
     *	@functionName	: storeValueInKeyChain
     *	@parameters		: identifier : It would be the key to encrypt the given string
     *                  : accessGroup  : It would be the Intialization vector
     *                  : secretKey : It could be any object i.e String or Data
     *                  : value : It specify the type of encryption you want to implelment
     *	@return			: It return the encrypted string
     */
    
    public class func storeValueInKeyChain(secretKey:String, value:String) {
        
         KeychainWrapper.standardKeychainAccess().setString(value, forKey: secretKey)
    }
    
    /*
     *	@functionName	: getValueFromKeyChain
     *	@parameters		: identifier : It would be the identifier string
     *                  : accessGroup  : It would be the accesGroup string
     *                  : secretKey : It could be any object i.e String or Data
     *	@return			: It return the value from Keychain for given identifier,accessgroup and secretkey
     */
    
    public class func getValueFromKeyChain(secretKey:String) -> String {

     guard let result: String = KeychainWrapper.standardKeychainAccess().stringForKey(secretKey)
        else {
            return ""
        }
        return result
    }
    
    /*
     *	@functionName	: md5Hashing
     *	@parameters		: str : It would be the string for md5hashing has to create
     *
     *	@return			: It return the md5Hashing string
     */
    
    public class func md5Hashing(str:String)->String {
        return str.md5()
        
    }
    
    public class func removeKeyChainValues (secretKey:String){
    
        KeychainWrapper.standardKeychainAccess().removeObjectForKey(secretKey)
    }
}

