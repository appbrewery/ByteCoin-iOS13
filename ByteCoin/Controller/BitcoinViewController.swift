//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

//MARK: - Base Class

class BitcoinViewController: UIViewController {
    
    
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var coinPicker: UIPickerView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var coinManager = CoinManager()
    var currency: String!
    var coin: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinPicker.delegate = self
        coinPicker.dataSource = self
        coinManager.delegate = self
        
        currency = coinManager.currencyArray[0]
        coin = coinManager.coinArray[0]
        
        // UI changes
        confirmButton.tintColor = .black
    }
    
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        print("Currency: \(String(describing: currency))")
        print("Coin: \(String(describing: coin))")
        coinManager.getPrice(for: currency, in: coin)
    }
}

//MARK: - UIPickerView
extension BitcoinViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // extensions must not contain stored properties
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 0: return coinManager.currencyArray.count
        case 1: return coinManager.coinArray.count
        default: return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0: return coinManager.currencyArray[row]
        case 1: return coinManager.coinArray[row]
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // get the currency at the row, and send that to coinManager to calculate the price
        
        if pickerView.tag == 0 {
            currency = coinManager.currencyArray[row]
        } else if pickerView.tag == 1 {
            coin = coinManager.coinArray[row]
        }
    }
}

extension BitcoinViewController: CoinManagerDelegate {
    
    func didUpdateCurrency(_ coinManager: CoinManager, coin: CoinModel) {
        // now update the UI asynchronously to reflect the changes
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%0.5f", coin.rate)
            self.currencyLabel.text = coin.currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

