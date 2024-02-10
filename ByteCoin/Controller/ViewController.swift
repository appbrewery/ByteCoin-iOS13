import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,CoinManagerApiJson {
  
    
    
    
    
 //BTC
    
    @IBOutlet weak var btcPriceField: UILabel!
    
    @IBOutlet weak var btccurrencyLabel: UILabel!
    
    @IBOutlet weak var pickerElement: UIPickerView!

//ETC
    
    
    @IBOutlet weak var etcPriceLabel: UILabel!
    
    @IBOutlet weak var ethCurrencyLabel: UILabel!
    
    
//Solana
    
    
    @IBOutlet weak var solPriceLabel: UILabel!
    
    
    @IBOutlet weak var solCurrencyLabel: UILabel!
    
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerElement.dataSource = self
        pickerElement.delegate = self
        coinManager.delegate = self
        
    }
    
    
    func updatePriceETH(_ price: String, _ currentcurrency: String) {
        DispatchQueue.main.async {
            self.etcPriceLabel.text = price
            self.ethCurrencyLabel.text = currentcurrency

               }
    }
    
    func updatePriceSOL(_ price: String, _ currentcurrency: String) {
        DispatchQueue.main.async {
                   self.solPriceLabel.text = price
                   self.solCurrencyLabel.text = currentcurrency

               }
    }
    
    func updatePrice(_ price: String, _ currentcurrency: String) {
        DispatchQueue.main.async {
                   self.btcPriceField.text = price
                   self.btccurrencyLabel.text = currentcurrency
               }
    }
    
    func didFailedWithError(error: Error) {
        print(error)
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row],coin:"BTC/")
        coinManager.getCoinPrice(for: coinManager.currencyArray[row],coin:"ETH/")
        coinManager.getCoinPrice(for: coinManager.currencyArray[row],coin:"SOL/")
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
        
    }
   
    
    
    


}
	





