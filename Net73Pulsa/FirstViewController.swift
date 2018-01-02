//
//  FirstViewController.swift
//  Net73Pulsa
//
//  Created by Eka Putra on 12/31/17.
//  Copyright © 2017 Eka Putra. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


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
    
    var nominalsKeys: [String] = []
    var nomor: String = ""
    var nominal: Int = 10
    var pembelianKe: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
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
    
    // On KIRIM button clicked.
    @IBAction func onKirimButtonClick(_ sender: Any) {
        
        if (nomorInput.text?.isEmpty)! || (nominalInput.text?.isEmpty)! || (pembelianKeInput.text?.isEmpty)! {
            return
        }
        let pk = pembelianKeInput.text == "1" ? "" : " \(pembelianKeInput.text!)"
        let smsFormat = "\(nominals[nominalInput.text!]!) \(nomorInput.text!) 2017\(pk)"
        
        let share = UIActivityViewController(activityItems: [smsFormat], applicationActivities: [])
        present(share, animated: true)
    }
}

