//
//  EncryptionDecrptionManager.swift
//  ServiceClient
//
//  Created by kiwitech on 08/04/16.
//  Copyright © 2016 kiwitech. All rights reserved.
//

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import CryptoSwift


public enum DataType:Int
{
    case DATA
}

public class TSGHelper: NSObject
{
    
    //AES Encryption
    
    public class func aesEncrypt(key: String, iv: String, object: AnyObject!) throws -> AnyObject!{
        
        let aesObj:AES
        let enc:[UInt8]
        let encData:NSData!
        var data:NSData!
        
        switch object {
            
        case is String:
            data = (object as! String).dataUsingEncoding(NSUTF8StringEncoding)!
            aesObj = try AES(key: key, iv: iv, blockMode:.CBC)
            enc = try aesObj.encrypt(data.arrayOfBytes(), padding: PKCS7())
            encData = NSData(bytes: enc, length: Int(enc.count))
            if let base64String = encData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)){
                return base64String
            }
            
        case is NSData:
            data = object as! NSData
            aesObj = try AES(key: key, iv: iv, blockMode:.CBC)
            enc = try aesObj.encrypt(data.arrayOfBytes(), padding: PKCS7())
            encData = NSData(bytes: enc, length: Int(enc.count))
            return encData
            
        default:
            return  NSError(domain: "Error", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Unable to Encrypt"])
            
        }
        
        return  NSError(domain: "Error", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Unable to Encrypt"])
    }
    
    //AES Decryption
    public class func aesDecrypt(key: String, iv: String, object: AnyObject?) throws -> AnyObject {
        
        let dec:[UInt8]
        let decData:NSData
        let result:String
        
        
        switch object {
            
        case is String:
            if let data = NSData(base64EncodedString: object as! String, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data.arrayOfBytes(), padding: PKCS7())
                decData = NSData(bytes: dec, length: Int(dec.count))
                result = String(data: decData, encoding: NSUTF8StringEncoding)!
                return result
            }
            
            
        case is NSData:
            let data = (object as! NSData)
            dec = try AES(key: key, iv: iv, blockMode:.CBC).decrypt(data.arrayOfBytes(), padding: PKCS7())
            decData = NSData(bytes: dec, length: Int(dec.count))
            return decData
            
            
        default:
            return NSError(domain: "Unable to Encrypt", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Unable to Encrypt"])
            
        }
        
        return  NSError(domain: "Unable to Encrypt", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Unable to Encrypt"])
    }
    
    //ChaCha20 Encryption
    public class func chacha20Encypt(key: String, iv: String, object: AnyObject) throws -> AnyObject {
        
        let enc:[UInt8]
        let encData:NSData!
        var data:NSData!
        let chacha = ChaCha20(key: key, iv: iv)
        
        switch object {
            
        case is String:
            data = object.dataUsingEncoding(NSUTF8StringEncoding)
            enc = try chacha!.encrypt(data.arrayOfBytes())
            encData = NSData(bytes: enc, length: Int(enc.count))
            
            if let base64String = encData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)){
                return base64String
            }
            
        case is NSData:
            data = (object as! NSData)
            enc = try chacha!.encrypt(data.arrayOfBytes())
            encData = NSData(bytes: enc, length: Int(enc.count))
            return encData
            
        default:
            return NSError(domain: "Error", code: 1004, userInfo: [NSLocalizedDescriptionKey:"Unable to Encrypt"])
            
        }

        return  NSError(domain: "Unable to Encrypt", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Unable to Encrypt"])
    }
    
    //ChaCha20 Decryption
    public class func chacha20Decrypt(key: String, iv: String, object: AnyObject?) throws -> AnyObject {
        
        let dec:[UInt8]
        let decData:NSData
        let result:String
        let chacha = ChaCha20(key: key, iv: iv)
        
        switch object {
            
        case is String:
            if let data = NSData(base64EncodedString: object as! String, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                dec =  try chacha!.decrypt(data.arrayOfBytes())
                decData = NSData(bytes: dec, length: Int(dec.count))
                result = String(data: decData, encoding: NSUTF8StringEncoding)!
                return result
            }
            
        case is NSData:
            
            let data = (object as! NSData)
            dec =  try chacha!.decrypt(data.arrayOfBytes())
            decData = NSData(bytes: dec, length: Int(dec.count))
            return decData
            
        default:
            return NSError(domain: "Unable to Encrypt", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Unable to Encrypt"])
        }
        
        return NSError(domain: "Unable to Encrypt", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Unable to Encrypt"])
    }
    
    
}
