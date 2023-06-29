//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
import UIKit

protocol CoinManagerDelegate {
	func didUpdateCurrency(_ coinManager: CoinManager, coin: CoinModel)
	func didFailWithError(error: Error)
}

struct CoinManager {
    
	
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
	var apiKey = "" // We'll retrieve it from a Keys.plist storign our API Key
    
	var delegate: CoinManagerDelegate?
	
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

	func getCoinPrice(for currency: String) {
		
		fetchCurrencyRate(currency: currency)
	}
	
	func fetchCurrencyRate(currency: String) {
		let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
		
		print(urlString)
		performRequest(with: urlString)
	}
	
	func performRequest(with urlString: String) {
		// 1. Create URL
		if let url = URL(string: urlString) {
			
			// 2. Create session URLSession
			let session = URLSession(configuration: .default)
			
			// 3. Add task to the session
			let task = session.dataTask(with: url) { (data, response, error) in
				
				if error != nil {
					delegate?.didFailWithError(error: error!)
					return
				}
				
				if let safeData = data {
					print(String(data: safeData, encoding: .utf8)!)
					if let coin = parseJSON(safeData) {
						delegate?.didUpdateCurrency(self, coin: coin)
					}
				}
			}
			// 4. Start the task
			task.resume()
		}
	}
	
	func parseJSON(_ coinData: Data) -> CoinModel? {
		// Create a JSON decoder
		let decoder = JSONDecoder()
		
		do{
			// Trying to decode de data using the CoinData structure
			let decodedData = try decoder.decode(CoinData.self, from: coinData)
			
			let time = decodedData.time
			let bitcoin = decodedData.asset_id_base
			let selectedCurrency = decodedData.asset_id_quote
			let price = decodedData.rate
			
			let coin = CoinModel(time: time, bitcoin: bitcoin, selectedCurrency: selectedCurrency, rate: price)
			
			return coin
		} catch {
			delegate?.didFailWithError(error: error)
			return nil
		}
	}
	
}
