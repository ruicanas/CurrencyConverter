//
//  ExchangeListViewController.swift
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 05/04/2021.
//

import UIKit

class ExchangeListViewController: UIViewController{
    @IBOutlet weak var listTableView: UITableView!
    
    let DEFAULT_IMG = "https://cdn1.iconfinder.com/data/icons/rounded-flat-country-flag-collection-1/2000/_Unknown.png"
    var availableCountries = CountryRateModel()
    var countriesCopy = [Rate]()
    var isSelectingFrom: Bool!  //Bool to check which currency is going to be changed. If is 'true' is because the 'from' currency is going to be changed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self;
        self.listTableView.register(UINib(nibName: "RatesListCell", bundle: nil), forCellReuseIdentifier: "rateListCell")
        removeBaseFromList()
    }
    
    //This method will make the user always chose a different base. If user changes his mind, he can always go back.
    func removeBaseFromList(){
        countriesCopy = availableCountries.rates as! [Rate]
        countriesCopy.removeAll { (rate: Rate) -> Bool in
            return rate.currencyCode == availableCountries.baseCurrency
        }
    }
}

extension ExchangeListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesCopy.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrayObjects = countriesCopy[indexPath.row]
        let cell = listTableView.dequeueReusableCell(withIdentifier: "rateListCell", for: indexPath) as! RatesListCell
        cell.codeLabel.text = arrayObjects.currencyCode
        cell.currencyLabel.text = arrayObjects.currencyName
        if arrayObjects.flagUrl.isEmpty{
            let url = URL(string: DEFAULT_IMG)
            cell.flagImageView.kf.setImage(with: url)
        }
        else{
            let url = URL(string: arrayObjects.flagUrl)
            cell.flagImageView.kf.setImage(with: url)
        }
        return cell
    }
}

extension ExchangeListViewController: UITableViewDelegate{
    //This view can be accessed by two different views. So, this method will make sure
    //that the information is retrieved properly to the previous view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vcs = self.navigationController?.viewControllers {
            let previousVC = vcs[vcs.count - 2]
            //If the previous view is 'BaseViewController', we just want to change currency code.
            if previousVC is BaseViewController {
                availableCountries.baseCurrency = countriesCopy[indexPath.row].currencyCode
                availableCountries.requestRates(withBase: availableCountries.baseCurrency) //A request of rates is needed because the base currency changed
            }
            else if previousVC is CalculatorViewController {
                //If the previous view is 'CalculatorViewController' we want to change some currency (from ...// to...)
                let previous = previousVC as! CalculatorViewController
                if isSelectingFrom{
                    //If we are going to change the from currency (which is associated to base currency)
                    //we also want to change our base currency.
                    availableCountries.baseCurrency = countriesCopy[indexPath.row].currencyCode
                    availableCountries.requestRates(withBase: availableCountries.baseCurrency) //A request of rates is needed because the base currency changed
                }
                else {
                    previous.toRate = countriesCopy[indexPath.row].currencyCode
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

