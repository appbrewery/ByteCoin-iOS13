import Foundation
protocol CoinManagerApiJson {
    func updatePrice(_ price: String ,_ currentcurrency : String)
    func updatePriceETH(_ price: String ,_ currentcurrency : String)
    func updatePriceSOL(_ price: String ,_ currentcurrency : String)


    func didFailedWithError(error:Error)
}
struct CoinManager  {
    
    //var delegate
    var delegate : CoinManagerApiJson?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "?apikey=2A9C7018-525E-4B2D-9158-AD3D8D7AB4F1"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency : String , coin :String ){
        let url =  baseURL+coin+currency+apiKey
        
        // Creating a URLSessionDataTask for a GET request
        if let url = URL(string:url) {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    // Handle the error
                    print("Error: \(error.localizedDescription)")
                } else if let CoinData = data {
                    // Process the data
                    print("Data received: \(CoinData)")
                    
                    let str = String.init(data: CoinData, encoding: .utf8)
                    if let coinData = self.parseJson(CoinData){
                        print(coinData)
                        let stringCoinPrice = String(format: " %.2f ", coinData)
                        if(coin == "BTC/"){
                            self.delegate?.updatePrice(stringCoinPrice,currency)

                        }
                        else if(coin == "ETH/"){
                            self.delegate?.updatePriceETH(stringCoinPrice,currency)
                        }
                        else if(coin == "SOL/"){
                            self.delegate?.updatePriceSOL(stringCoinPrice,currency)
                        }
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    //Parse Json
    func parseJson(_ data:Data) -> Double? {
        let decoder = JSONDecoder()
        do{
            
            let decodeData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodeData.rate
            return lastPrice
            
        }catch{
            delegate?.didFailedWithError(error: error)
            return nil
        }
        
    }
    
    
}



