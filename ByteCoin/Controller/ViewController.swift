//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var bitcoinLabel: UILabel!
	@IBOutlet weak var currencyLabel: UILabel!
	@IBOutlet weak var currencyPicker: UIPickerView!
	
	@IBOutlet weak var stackInterno: UIStackView!
	@IBOutlet weak var coinViewInterno: UIView!
	
	var coinManager = CoinManager()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		coinManager.delegate = self
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let keys = appDelegate.keys!
		
		coinManager.apiKey = keys["apiKey"] as! String
		
		// Setting the VC as the Picker's DataSource & Delegate
		currencyPicker.dataSource = self
		currencyPicker.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// Para meter el break point
		
	}
	
}


//MARK: - UIPickerView DataSource and Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return coinManager.currencyArray.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return coinManager.currencyArray[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		let selectedCurrency = coinManager.currencyArray[row]
		
		print(coinManager.getCoinPrice(for: selectedCurrency))
		
		coinManager.getCoinPrice(for: selectedCurrency)
	}
}


//MARK: - CoinManager Delegate

extension ViewController: CoinManagerDelegate {
	
	// CAMBIOS DE LOS ELEMENTOS DEL VC
	
	func didUpdateCurrency(_ coinManager: CoinManager, coin: CoinModel) {
		print(coin.rate)
		
		DispatchQueue.main.async {
			self.bitcoinLabel.text = String(format: "%.2f", coin.rate)
			self.currencyLabel.text = coin.selectedCurrency
		}
	}
	
	func didFailWithError(error: Error) {
		print(error)
	}
}
