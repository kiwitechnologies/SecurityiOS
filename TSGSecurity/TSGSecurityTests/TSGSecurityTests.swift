//
//  TSGSecurityFrameworkTests.swift
//  TSGSecurityFrameworkTests
//
//  Created by kiwitech on 14/04/16.
//  Copyright © 2016 kiwitech. All rights reserved.
//

import XCTest
import UIKit

@testable import TSGSecurity

class TSGSecurityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAESEncryption() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let KEY:String = "bbC2H19lkVbQDfakxcrtNMQdd0FloLyw"
        let IV =  "gqLOHUioQ0QjhuvI"
        let testingString = "Yogesh Bhatt"
        
        var encryptedString:String!
        var decryptedString:String!
        
        TSGSecurityManager.encryptObjectWithSuccess(KEY, iv: IV, object: testingString, encryptionType: EncryptionType.AES) { (status, object) in
            
            if status == true {
            encryptedString = object as! String
            }
            else {
               encryptedString = "Unable to Encrypt"
            }
        }
        
        TSGSecurityManager.decryptObjectWithSuccess(KEY, iv: IV, object: encryptedString, decryptionType: EncryptionType.AES) { (status, object) in
            
            if status == true {
                decryptedString = object as! String
            } else {
                decryptedString = "Unable to Decrypt"
            }
        }
        XCTAssertEqual(decryptedString, testingString,"AES Encryption passed")
        
    }
    
    func testChaCha20Encryption() {
        
        let KEY:String = "bbC2H19lkVbQDfakxcrtNMQdd0FloLyw"
        let IV =  "gqLOHUioQ0QjhuvI"
        let testingString = "Yogesh Bhatt"
        
        var encryptedString:String!
        var decryptedString:String!
        
        TSGSecurityManager.encryptObjectWithSuccess(KEY, iv: IV, object: testingString, encryptionType: EncryptionType.CHACHA20) { (status, object) in
            
            if status == true {
                encryptedString = object as! String
            }
            else {
                encryptedString = "Unable to Encrypt"
            }
        }
        
        TSGSecurityManager.decryptObjectWithSuccess(KEY, iv: IV, object: encryptedString, decryptionType: EncryptionType.CHACHA20) { (status, object) in
            
            if status == true {
                decryptedString = object as! String
            } else {
                decryptedString = "Unable to Decrypt"
            }
        }
        XCTAssertEqual(decryptedString, testingString,"AES Encryption passed")
        
    }
    
    
    func testKeyChainValueItem() {
        
        let hiddenKey = "ItemToDelete"
        let storedValue = "Yogesh Bhatt"
        
        let valueFromKeychain:String
        
        TSGSecurityManager.storeValueInKeyChain(hiddenKey, value: storedValue)
        
        valueFromKeychain = TSGSecurityManager.getValueFromKeyChain(hiddenKey)
        
        
        XCTAssertEqual(valueFromKeychain, storedValue,"KeyChainItemValue passed")
        
    }
    
    func testRemoveKeyChainItem() {
        
        //let storedValue = "Yogesh Bhatt"
        let hiddenKey = "ItemToDelete"
        
        TSGSecurityManager.removeKeyChainValues(hiddenKey)
        
    }
    
}
