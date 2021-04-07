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
    var availableCountries = CountriesRates()
    var countriesCopy = [Rate]()
    var isSelectingFrom: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.listTableView.delegate = self
        self.listTableView.dataSource = self;
        self.listTableView.register(UINib(nibName: "RatesListCell", bundle: nil), forCellReuseIdentifier: "rateListCell")
        removeBaseFromList()
    }
    
    //This method will make the user always chose a different base. If he changes his mind, he can always go back.
    func removeBaseFromList(){
        countriesCopy = availableCountries.rates as! [Rate]
        countriesCopy.removeAll { (rate: Rate) -> Bool in
            return rate.currencyCode == availableCountries.source
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vcs = self.navigationController?.viewControllers {
            let previousVC = vcs[vcs.count - 2]
            if previousVC is BaseViewController {
                availableCountries.source = countriesCopy[indexPath.row].currencyCode
            }
            else if previousVC is CalculatorViewController {
                let previous = previousVC as! CalculatorViewController
                if isSelectingFrom{
                    availableCountries.source = countriesCopy[indexPath.row].currencyCode
                }
                else {
                    previous.toRate = countriesCopy[indexPath.row].currencyCode
                }
            }
        }
        availableCountries.request(withBase: availableCountries.source)
        navigationController?.popViewController(animated: true)
    }
}

