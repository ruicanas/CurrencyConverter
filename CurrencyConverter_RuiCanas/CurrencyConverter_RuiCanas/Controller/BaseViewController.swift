//
//  BaseViewController.swift
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 05/04/2021.
//

import UIKit
import Kingfisher

class BaseViewController: UIViewController, BaseCurrencyCellDelegate{
    //Storyboard Components
    @IBOutlet weak var baseTableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    //Variables and Constants
    let networkLayer = NetworkLayer()
    var baseRate = "EUR"
    var rates: [Rate] = []
    
    override func viewWillAppear(_ animated: Bool) {
        executeRequestOfRates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.baseTableView.dataSource = self;
        self.baseTableView.register(UINib(nibName: "MainCell", bundle: nil), forCellReuseIdentifier: "mainCell")
        self.baseTableView.register(UINib(nibName: "BaseCurrencyCell", bundle: nil), forCellReuseIdentifier: "baseCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingView.isHidden = false
    }
    
    //Responsible for changing the view in order to make the user choose another currency
    func changeView() {
        performSegue(withIdentifier: "exchangeSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exchangeSegue"{
            let view = segue.destination as? ExchangeListViewController
            view?.countriesCopy = rates
            view?.baseCurrency = baseRate
        }
    }
    
    @IBAction func updatePressed(_ sender: Any) {
        loadingView.isHidden = false
        executeRequestOfRates()
    }
    
    func executeRequestOfRates(){
        networkLayer.requestRates(withBase: baseRate) { rates in
            self.rates = rates!
            for rate in self.rates{
                self.networkLayer.requestInfo(withCurrency: rate.currencyCode) { currencyName, flagUrl  in
                    rate.currencyName = currencyName!
                    rate.flagUrl = flagUrl!
                    if rate == self.rates.last{
                        self.baseTableView.reloadData()
                        self.loadingView.isHidden = true
                    }
                }
            }
        }
    }
}

extension BaseViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //The first cell will be the base currency cell. This cell is different from the other cells.
        if indexPath.row == 0{
            let cell = baseTableView.dequeueReusableCell(withIdentifier: "baseCell", for: indexPath) as! BaseCurrencyCell
            cell.codeLabel.text = rates[indexPath.row].currencyCode
            cell.currencyLabel.text = rates[indexPath.row].currencyName
            cell.delegate = self
        
            let url = URL(string: rates[indexPath.row].flagUrl)
            cell.flagImageView.kf.setImage(with: url)
            return cell;
        }
        
        let cell = baseTableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainCell
        cell.codeValueLabel.text = rates[indexPath.row].currencyCode
        cell.codeFlagLabel.text = rates[indexPath.row].currencyCode
        cell.valueLabel.text = rates[indexPath.row].value
        cell.currencyLabel.text = rates[indexPath.row].currencyName
        cell.timeLabel.text = rates[indexPath.row].time
        
        let url = URL(string: rates[indexPath.row].flagUrl)
        cell.flagImageView.kf.setImage(with: url)
        return cell;
    }
}

