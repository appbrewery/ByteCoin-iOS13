//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    
    func didUpdateCurrency(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
    
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "5D1840F0-0625-413B-8642-8E7E5F2F3C2A"
    
    let coinArray = ["BTC", "ETH", "AUR", "BCC", "DASH", "DOGE", "LTC", "BCH"]
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getPrice(for currency: String, in coin: String) {
        
        let requestString = "\(baseURL)/\(coin)/\(currency)?&apikey=\(apiKey)"
        
        if let url = URL(string: requestString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                print("Response: \(String(describing: response))")
                if let safeData = data {
                    // parseJSON returns a CoinModel type
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCurrency(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let time = decodedData.time
            let coinType = decodedData.asset_id_base
            let currency = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coin = CoinModel(time: time, coinType: coinType, currency: currency, rate: rate)
            return coin
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
