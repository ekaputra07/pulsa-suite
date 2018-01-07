//
//  PLNViewController.swift
//  Net73Pulsa
//
//  Created by Eka Putra on 12/31/17.
//  Copyright © 2017 Eka Putra. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class PLNViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CNContactPickerDelegate, CNContactViewControllerDelegate {

    @IBOutlet weak var meterNumberInput: UINumberInput!
    @IBOutlet weak var phoneNumberInput: UINumberInput!
    @IBOutlet weak var creditInput: UINumberInput!
    @IBOutlet weak var transactionInput: UINumberInput!
    
    // Create UIPickerView instance for each input
    let creditPicker = UIPickerView()
    let transactionPicker = UIPickerView()
    
    // Create CNCContactPickerViewController for meter and phone number picker.
    let meterNumberPicker = CNContactPickerViewController()
    let phoneNumberPicker = CNContactPickerViewController()
    
    // Array of Tuple
    let credits: [(k: String, v: String)] = [
        ("20,000", "PLN20"),
        ("50,000", "PLN50"),
        ("100,000", "PLN100"),
        ("200,000", "PLN200"),
        ("500,000", "PLN500"),
        ("1,000,000", "PLN1000")]
    
    let transactions: [String] = ["1", "2", "3", "4", "5"]
    
    var transactionPin: String? = nil
    var creditKeys: [String] = []
    var meterNumber: String = ""
    var phoneNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Register our preferences
        UserDefaults.standard.register(defaults: [String : Any]())
        readUserDefaults()
        
        // Register observer to listen for preferences changes
        NotificationCenter.default.addObserver(self, selector: #selector(PLNViewController.userDefaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        for c in credits {
            creditKeys.append(c.k)
        }
        
        creditInput.inputView = creditPicker
        transactionInput.inputView = transactionPicker
        
        creditPicker.delegate = self
        transactionPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // read from preferences
    func readUserDefaults(){
        let userDefaults = UserDefaults.standard
        transactionPin = userDefaults.string(forKey: "pin_transaksi")
    }
    
    @objc func userDefaultsChanged(){
        readUserDefaults()
    }
    
    // Picker related codes
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case creditPicker:
            return creditKeys.count
        case transactionPicker:
            return transactions.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case creditPicker:
            return creditKeys[row]
        case transactionPicker:
            return transactions[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case creditPicker:
            creditInput.text = creditKeys[row]
        case transactionPicker:
            transactionInput.text = transactions[row]
        default:
            print("Do nothing")
        }
    }
    
    // Open contact picker
    @IBAction func openContactPicker(_ sender: Any) {
        phoneNumberPicker.delegate = self
        phoneNumberPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        
        present(phoneNumberPicker, animated: true, completion: nil)
    }
    
    @IBAction func openMeterNumberPicker(_ sender: Any) {
        meterNumberPicker.delegate = self
        meterNumberPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        
        present(meterNumberPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        
        //let contact = contactProperty.contact
        let number = contactProperty.value as? CNPhoneNumber
        //print(contact.givenName)
        
        switch picker {
        case phoneNumberPicker:
            phoneNumberInput.text = number?.stringValue
        case meterNumberPicker:
            meterNumberInput.text = number?.stringValue
        default:
            print("Do nothing")
        }

    }
    
    @IBAction func doShare(_ sender: Any) {
        if (phoneNumberInput.text ?? "").isEmpty || (meterNumberInput.text ?? "").isEmpty || (creditInput.text ?? "").isEmpty || (transactionInput.text ?? "").isEmpty {
            let alert = Utils.createSingleActionAlert(title: "Penting", message: "Nomer meter, Nomer HP, nominal dan transaksi tidak boleh kosong.")
            present(alert, animated: true, completion: nil)
        }
        
        //cleanup the meter and phone number
        let cleanedMeterNumber = Utils.cleanPhoneNumber(for: meterNumberInput.text!)
        let cleanedPhoneNumber = Utils.cleanPhoneNumber(for: phoneNumberInput.text!)
        let tx = transactionInput.text == "1" ? "" : " \(transactionInput.text!)"
        
        var credit = ""
        for c in credits {
            if c.k == creditInput.text! {
                credit = c.v
                break
            }
        }
        
        // format untuk Token PLN 100rb dengan pin 2018 -> "PLN100 1460000983 08174765123 2018"
        let messageFormat = "\(credit) \(cleanedMeterNumber) \(cleanedPhoneNumber) \(transactionPin ?? "1234")\(tx)"
        
        let share = UIActivityViewController(activityItems: [messageFormat], applicationActivities: [])
        present(share, animated: true)
    }
}

