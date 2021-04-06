//
//  BaseViewController.swift
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 05/04/2021.
//

import UIKit

class BaseViewController: UIViewController, CountriesRatesDelegate {
    @IBOutlet weak var baseTableView: UITableView!
    var countriesRates = CountriesRates()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.baseTableView.delegate = self
        self.baseTableView.dataSource = self;
        self.baseTableView.register(UINib(nibName: "MainCell", bundle: nil), forCellReuseIdentifier: "mainCell")
        self.baseTableView.register(UINib(nibName: "BaseCurrencyCell", bundle: nil), forCellReuseIdentifier: "baseCell")
        countriesRates.delegate = self;
        
        countriesRates.requestQuotes()
    }
}

extension BaseViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesRates.rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0{
//            let cell = baseTableView.dequeueReusableCell(withIdentifier: "baseCell", for: indexPath) as! BaseCurrencyCell
//            cell.codeLabel.text = countriesRates.source
//            return cell;
//        }
        let arrayObjects = countriesRates.rates[indexPath.row] as! Rate
        let cell = baseTableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainCell
        cell.codeValueLabel.text = arrayObjects.code
        cell.valueLabel.text = arrayObjects.value
        return cell;
    }
}

extension BaseViewController: UITableViewDelegate{
    func updateTableView(){
        baseTableView.reloadData()
    }
}

