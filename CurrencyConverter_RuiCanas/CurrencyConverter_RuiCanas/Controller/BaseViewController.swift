//
//  BaseViewController.swift
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 05/04/2021.
//

import UIKit
import Kingfisher

class BaseViewController: UIViewController, CountriesRatesDelegate, BaseCurrencyCellDelegate {
    //Storyboard Components
    @IBOutlet weak var baseTableView: UITableView!
    
    //Variables and Constants
    let DEFAULT_IMG = "https://cdn1.iconfinder.com/data/icons/rounded-flat-country-flag-collection-1/2000/_Unknown.png"
    var countriesRates = CountryRateModel()
    var baseRate = "EUR"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.baseTableView.delegate = self
        self.baseTableView.dataSource = self;
        self.baseTableView.register(UINib(nibName: "MainCell", bundle: nil), forCellReuseIdentifier: "mainCell")
        self.baseTableView.register(UINib(nibName: "BaseCurrencyCell", bundle: nil), forCellReuseIdentifier: "baseCell")
        countriesRates.delegate = self;
        countriesRates.requestRates(withBase: countriesRates.baseCurrency)    //Needed to display information at the very beginning
    }
    
    //Responsible for changing the view in order to make the user choose another currency
    func changeView() {
        performSegue(withIdentifier: "exchangeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exchangeSegue"{
            let view = segue.destination as? ExchangeListViewController
            view?.availableCountries = countriesRates
        }
    }
}

extension BaseViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesRates.rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrayObjects = countriesRates.rates[indexPath.row] as! Rate
        
        //The first cell will be the base currency cell. This cell is different from the other cells.
        if indexPath.row == 0{
            let cell = baseTableView.dequeueReusableCell(withIdentifier: "baseCell", for: indexPath) as! BaseCurrencyCell
            cell.codeLabel.text = arrayObjects.currencyCode
            cell.currencyLabel.text = arrayObjects.currencyName
            cell.delegate = self
            
            if arrayObjects.flagUrl.isEmpty{
                let url = URL(string: DEFAULT_IMG)
                cell.flagImageView.kf.setImage(with: url)
            }
            else{
                let url = URL(string: arrayObjects.flagUrl)
                cell.flagImageView.kf.setImage(with: url)
            }
            return cell;
        }
        
        let cell = baseTableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainCell
        cell.codeValueLabel.text = arrayObjects.currencyCode
        cell.codeFlagLabel.text = arrayObjects.currencyCode
        cell.valueLabel.text = arrayObjects.value
        cell.currencyLabel.text = arrayObjects.currencyName
        cell.timeLabel.text = countriesRates.timestamp
        
        //Default image used for unavailable images.
        if arrayObjects.flagUrl.isEmpty{
            let url = URL(string: DEFAULT_IMG)
            cell.flagImageView.kf.setImage(with: url)
        }
        else{
            let url = URL(string: arrayObjects.flagUrl)
            cell.flagImageView.kf.setImage(with: url)
        }
        return cell;
    }
}

extension BaseViewController: UITableViewDelegate{
    func updateTableView(){
        baseTableView.reloadData()
        
        //Update info being holded at TabViewController
        let tabBar = tabBarController as! TabViewController
        tabBar.ratesData = countriesRates
    }
}

