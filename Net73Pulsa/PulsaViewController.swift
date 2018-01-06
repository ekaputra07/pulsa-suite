//
//  FirstViewController.swift
//  Net73Pulsa
//
//  Created by Eka Putra on 12/31/17.
//  Copyright © 2017 Eka Putra. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class PulsaViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CNContactPickerDelegate, CNContactViewControllerDelegate {

    @IBOutlet weak var nomorInput: UINumberInput!
    @IBOutlet weak var nominalInput: UINumberInput!
    @IBOutlet weak var pembelianKeInput: UINumberInput!
    
    // Create UIPickerView instance for each input
    let nominalPicker = UIPickerView()
    let pembelianKePicker = UIPickerView()
    
    let nominals: [String: Int] = ["5,000": 5,
                                  "10,000": 10,
                                  "15,000": 15,
                                  "20,000": 20,
                                  "25,000": 25,
                                  "30,000": 30,
                                  "50,000": 50,
                                  "100,000": 100,
                                  "150,000": 150,
                                  "200,000": 200]
    
    let pembelianKeOptions: [String] = ["1", "2", "3", "4", "5"]
    
    var pinTransaksi: String? = nil
    var nominalsKeys: [String] = []
    var nomor: String = ""
    var nominal: Int = 10
    var pembelianKe: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Register our preferences
        UserDefaults.standard.register(defaults: [String : Any]())
        readUserDefaults()

        // Register observer to listen for preferences changes
        NotificationCenter.default.addObserver(self, selector: #selector(PulsaViewController.userDefaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        //sort nominals by its value ASC
        let sortedNominals = nominals.sorted(by: {$0.1 < $1.1})
        for (key, _) in sortedNominals{
            nominalsKeys.append(key)
        }
        
        nominalPicker.delegate = self
        nominalPicker.dataSource = self
        pembelianKePicker.delegate = self
        pembelianKePicker.dataSource = self
        
        nominalInput.inputView = nominalPicker
        pembelianKeInput.inputView = pembelianKePicker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // read from preferences
    func readUserDefaults(){
        let userDefaults = UserDefaults.standard
        pinTransaksi = userDefaults.string(forKey: "pin_transaksi")
    }
    
    @objc func userDefaultsChanged(){
        readUserDefaults()
    }
    
    // Picker view related codes
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == nominalPicker {
            return nominalsKeys.count
        }else if pickerView == pembelianKePicker {
            return pembelianKeOptions.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == nominalPicker {
            return nominalsKeys[row]
        }else if pickerView == pembelianKePicker {
            return pembelianKeOptions[row]
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == nominalPicker {
            nominalInput.text = nominalsKeys[row]
        }
        if pickerView == pembelianKePicker {
            pembelianKeInput.text = pembelianKeOptions[row]
        }
    }
    
    // Open contact picker
    @IBAction func openContactPicker(_ sender: Any) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        
        present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        //let contact = contactProperty.contact
        let phoneNumber = contactProperty.value as? CNPhoneNumber
        
        //print(contact.givenName)
        nomorInput.text = phoneNumber?.stringValue
    }
    
    // On BAGIKAN button clicked.
    @IBAction func onKirimButtonClick(_ sender: Any) {
        if (nomorInput.text ?? "").isEmpty || (nominalInput.text ?? "").isEmpty || (pembelianKeInput.text ?? "").isEmpty {
            let alert = Utils.createSingleActionAlert(title: "Penting", message: "Nomor HP, nominal dan pembelian tidak boleh kosong.")
            present(alert, animated: true, completion: nil)
        }
        
        //cleanup the phone number
        let cleanedNumber = Utils.cleanPhoneNumber(for: nomorInput.text!)
        let pk = pembelianKeInput.text == "1" ? "" : " \(pembelianKeInput.text!)"
        
        // format untuk Pulsa 25rb dengan pin 2018 -> "25 08174765123 2018"
        let messageFormat = "\(nominals[nominalInput.text!]!) \(cleanedNumber) \(pinTransaksi ?? "1234")\(pk)"
        
        let share = UIActivityViewController(activityItems: [messageFormat], applicationActivities: [])
        present(share, animated: true)
    }
    
    @IBAction func addContact(_ sender: Any) {
        if(nomorInput.text ?? "").isEmpty {
            let alert = Utils.createSingleActionAlert(title: "Penting", message: "Nomer HP tidak boleh kosong.")
            present(alert, animated: true, completion: nil)
        }
        // Create new contact item
        let contact = CNMutableContact()
        contact.phoneNumbers.append(CNLabeledValue(label: "mobile", value: CNPhoneNumber(stringValue: nomorInput.text!)))
        
        // create contact view controller and sets its store
        let contactVC: CNContactViewController = CNContactViewController(forUnknownContact: contact)
        contactVC.contactStore = CNContactStore()
        contactVC.delegate = self
        
        // wrap it into navigation
        let nav = UINavigationController(rootViewController: contactVC)
        
        // There's a bug in iOS making contact screen missing a navigation bar.
        // but lets just implement it right now.
        present(nav, animated: true, completion: nil)
    }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        return true
    }
    
}

