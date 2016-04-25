//
//  ViewController.swift
//  
//
//  Created by kiwitech on 07/04/16.
//  Copyright © 2016 kiwitech. All rights reserved.
//

import UIKit
import TSGSecurity
import Foundation

let KEY:String = "bbC2H19lkVbQDfakxcrtNMQdd0FloLyw"
let IV =  "gqLOHUioQ0QjhuvI"

class EncryptionViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate{
    
    var encryptionType:EncryptionType = EncryptionType.AES
    var decodedString:String = ""
    var encodedObject:AnyObject!
    var dummyImage:UIImage!
    var plaintText: UITextField!
    
    @IBOutlet weak var cipherText: UILabel!
    @IBOutlet weak var decryptedText: UILabel!
    @IBOutlet weak var selectEncryption: UIButton!
    @IBOutlet weak var selectDecryption: UIButton!
    @IBOutlet weak var deletValueFromKeychain: UIButton!
    @IBOutlet weak var scrollViewOb: UIScrollView!
    @IBOutlet weak var decryptedImage: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        self.addTapGesture()
        self.setUILayout()
    }
    
    func addTapGesture()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EncryptionViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setUILayout()
    {
        selectEncryption.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        selectDecryption.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        scrollViewOb.frame = CGRectMake(20, 70, self.view.frame.size.width-40, 65)
        
        let titleLabel = UILabel(frame: CGRectMake(0,5,scrollViewOb.frame.size.width,17))
        titleLabel.text = "Enter text"
        scrollViewOb.addSubview(titleLabel)
        
        plaintText = UITextField(frame: CGRectMake(0,30,scrollViewOb.frame.size.width,35))
        plaintText.delegate = self
        plaintText.textAlignment = NSTextAlignment.Left
        plaintText.placeholder = "type your text here"
        scrollViewOb.addSubview(plaintText)
        
        let imageObj   = UIImageView(frame: CGRectMake(scrollViewOb.frame.size.width, 10, scrollViewOb.frame.size.width, 55))
        imageObj.image = UIImage(named: "01_Feed")
        
        scrollViewOb.addSubview(imageObj)
        scrollViewOb.contentSize = CGSizeMake((self.view.frame.size.width-40)*2, 55)
        scrollViewOb.delegate = self
        print("Scrollview width is \(scrollViewOb.frame.width)")

    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func encryptionButtonClicked(sender: AnyObject) {
        
        self.selectDecryption.hidden = false
        self.deletValueFromKeychain.hidden = true
        decryptedImage.image = UIImage(named: "")
        decryptedText.text = ""
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Select your option", preferredStyle: .ActionSheet)
        
        // 2
        let aes128Action = UIAlertAction(title: "AES-128 Encryption", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.selectEncryption.setTitle("AES-128 Encryption", forState: UIControlState.Normal)
            self.selectDecryption.setTitle("Click for AES-128 Decryption", forState: UIControlState.Normal)
            self.aesEncryption()
        })
        
        let chacha20Action = UIAlertAction(title: "ChaCha20 Encryption", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.selectEncryption.setTitle("ChaCha20 Encryption", forState: UIControlState.Normal)
            self.selectDecryption.setTitle("Click for ChaCha20 Decryption", forState: UIControlState.Normal)
            self.chacha20Encryption()
        })
        
        let createMD5Action = UIAlertAction(title: "Create MD5", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.selectEncryption.setTitle("Create MD5", forState: UIControlState.Normal)
            self.selectDecryption.hidden = true
            
            self.md5Encryption()
        })
        
        let saveValueInKeyChain = UIAlertAction(title: "Save in Keychain", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.selectEncryption.setTitle("Item saved in Keychain", forState: UIControlState.Normal)
            self.selectDecryption.setTitle("Get value from Keychain", forState: UIControlState.Normal)
            self.settingKeyChainItemValue()
            self.deletValueFromKeychain.hidden = false
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.selectEncryption.titleLabel?.text = "Select Encryption"
            self.selectDecryption.hidden = true
            self.cipherText.text = ""

        })
        
        // 4
        optionMenu.addAction(aes128Action)
        optionMenu.addAction(chacha20Action)
        optionMenu.addAction(createMD5Action)
        optionMenu.addAction(saveValueInKeyChain)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    //AES Encrption
    func aesEncryption() {
        
    encryptionType = EncryptionType.AES
   
        if (dummyImage != nil) {
            
            let imageData = UIImagePNGRepresentation(dummyImage)

            TSGSecurityManager.encryptObjectWithSuccess(KEY, iv: IV, object: imageData, encryptionType: EncryptionType.AES, onCompletion: { (status, object) in
                
                if status == true {
                    let base64String = object.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                    self.cipherText.text = base64String
                } else {
                    self.cipherText.text = "Unable to Encrypt"
                    self.selectDecryption.hidden = true
                }
            })

        } else {
            
            TSGSecurityManager.encryptObjectWithSuccess(KEY, iv: IV, object: plaintText.text!, encryptionType: EncryptionType.AES, onCompletion: { (status, object) in
                if status == true {
                    self.cipherText.text = object as? String
                } else {
                    self.cipherText.text = "Unable to Encrypt"
                    self.selectDecryption.hidden = true
                }
            })
 
        }
  }
    
    internal func aesDecryption() {
        
        if (dummyImage != nil) {
            
            let decodedData = NSData(base64EncodedString: self.cipherText.text!, options: NSDataBase64DecodingOptions(rawValue: 0))
            TSGSecurityManager.decryptObjectWithSuccess(KEY, iv: IV, object: decodedData, decryptionType: EncryptionType.AES, onCompletion: { (status, object) in
                if status == true {
                    let returnImg = UIImage(data: object as! NSData)
                    self.decryptedImage.image = returnImg
                } else {
                    print("Unable to decrypt")
                    self.decryptedText.text = "Unable to decrypt"
                }
            })
            
        } else {
            
            
            TSGSecurityManager.decryptObjectWithSuccess(KEY, iv: IV, object: cipherText.text, decryptionType: EncryptionType.AES, onCompletion: { (status, object) in
                if status == true {
                    self.decryptedText.text = object as? String
                } else {
                    self.decryptedText.text = "Unable to decrypt"
                    print("Unable to decrypt")
                }
            })
        }
    }
    
    
    //ChaCha20 Encryption
    func chacha20Encryption() {
        
        encryptionType = EncryptionType.CHACHA20
        
        if (dummyImage != nil) {
            
            let imageData = UIImagePNGRepresentation(dummyImage)

            TSGSecurityManager.encryptObjectWithSuccess(KEY, iv: IV, object: imageData, encryptionType: EncryptionType.CHACHA20, onCompletion: { (status, object) in
                if status == true {
                    
                    let base64String = object.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                    self.cipherText.text = base64String
                    
                } else {
                    self.cipherText.text = "Unable to encrypt"
                    self.selectDecryption.hidden = true
                }
            })
            
        } else {
            
            TSGSecurityManager.encryptObjectWithSuccess(KEY, iv: IV, object: plaintText.text!, encryptionType: EncryptionType.CHACHA20, onCompletion: { (status, object) in
                if status == true {
                    self.cipherText.text = object as? String
                } else {
                    self.cipherText.text = "Unablet to Encrpt"
                    self.selectDecryption.hidden = true
                }
            })
            
            
        }

  }
    
    internal func chacha20Decryption() {
        
        if (dummyImage != nil) {
            
            let decodedData = NSData(base64EncodedString: self.cipherText.text!, options: NSDataBase64DecodingOptions(rawValue: 0))
            
            TSGSecurityManager.decryptObjectWithSuccess(KEY, iv: IV, object: decodedData, decryptionType: EncryptionType.CHACHA20, onCompletion: { (status, object) in
                if status == true {
                    let returnImg = UIImage(data: object as! NSData)
                    self.decryptedImage.image = returnImg
                } else {
                    print("Unable to decrypt")
                }
            })
        } else {
            
            TSGSecurityManager.decryptObjectWithSuccess(KEY, iv: IV, object: cipherText.text, decryptionType: EncryptionType.CHACHA20, onCompletion: { (status, object) in
                if status == true {
                    self.decryptedText.text = object as? String
                } else {
                    self.decryptedText.text = "Unable to decrypt"
                }
            })
        }
        
    }
    
    func md5Encryption() {
        
        if (dummyImage != nil) {
            
            let imageData = UIImagePNGRepresentation(dummyImage)
            let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
            cipherText.text = TSGSecurityManager.md5Hashing(base64String)
            
        } else {
            decodedString = TSGSecurityManager.md5Hashing(plaintText.text!)
            cipherText.text = decodedString

        }
        
    }
    
    func settingKeyChainItemValue() {
        
         if (dummyImage != nil) {
            
            let imageData = UIImagePNGRepresentation(dummyImage)
            let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0));
            TSGSecurityManager.storeValueInKeyChain("SuperSecret", value:base64String)
            encryptionType = EncryptionType.GET_KEYCHAIN_VALUE
            cipherText.text = base64String


         } else {
            TSGSecurityManager.storeValueInKeyChain("SuperSecret", value:plaintText.text!)
            encryptionType = EncryptionType.GET_KEYCHAIN_VALUE
            cipherText.text = plaintText.text!

        }
 
    }
    
    @IBAction func btnDecryptClicked(sender: AnyObject) {
        
        switch encryptionType {
            
        case EncryptionType.AES:
            aesDecryption()
            
        case EncryptionType.CHACHA20:
            chacha20Decryption()
         
        case EncryptionType.GET_KEYCHAIN_VALUE:
            getKeyChainItemValue()
            
        default:
            break
        }
        
        
    }
    
    func getKeyChainItemValue() {
        
        
        let superSecretValue = TSGSecurityManager.getValueFromKeyChain("SuperSecret")
        decryptedText.text = superSecretValue
        print("The super secret value is: \(superSecretValue)")
        
    }
    
    @IBAction func btnDeleteValueFromKeyChain(sender: AnyObject) {
        
        TSGSecurityManager.removeKeyChainValues("SuperSecret")
        decryptedText.text = ""
        plaintText.text = ""
        cipherText.text = ""
        selectDecryption.hidden = true
        deletValueFromKeychain.hidden = true
    }
    
    @IBAction func btnClearAllClicked(sender: AnyObject) {
        cipherText.text = ""
        decryptedText.text = ""
        selectDecryption.hidden = true
        self.selectEncryption.setTitle("Select your option", forState: UIControlState.Normal)
        decryptedImage.image = UIImage(named: "")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        encodedObject = textField.text
        self.view.endEditing(true)
        dummyImage = nil
        decryptedImage.image = UIImage(named: "")
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        dummyImage = nil
        decryptedImage.image = UIImage(named: "")
        return true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
       let pagenumber = scrollView.contentOffset.x / scrollView.bounds.size.width
        self.selectEncryption.setTitle("Select your option", forState: UIControlState.Normal)
        self.selectDecryption.hidden = true
        cipherText.text = ""
        decryptedText.text = ""

        switch pagenumber {
            
        case 1:
            let image : UIImage = UIImage(named:"01_Feed")!
            dummyImage = image
            decryptedImage.hidden = false
            dismissKeyboard()
            
        case 0:
            dummyImage = nil
            decryptedImage.hidden = true
            decryptedImage.image = UIImage(named: "")

        default:
            break
        }
    }
}

