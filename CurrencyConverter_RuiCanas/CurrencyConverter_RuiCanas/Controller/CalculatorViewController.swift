//
//  CalculatorViewController.swift
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 05/04/2021.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var codeFromCurrencyLabel: UILabel!
    @IBOutlet weak var currencyNameFromLabel: UILabel!
    @IBOutlet weak var codeToCurrencyLabel: UILabel!
    @IBOutlet weak var currencyNameToLabel: UILabel!
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var toCurrencyTextField: UITextField!
    @IBOutlet weak var changeFromImageView: UIImageView!
    @IBOutlet weak var changeToImageView: UIImageView!
    @IBOutlet weak var swapImageView: UIImageView!
    
    var fromRate = "EUR"
    var toRate = "USD"
    var countriesRates = CountryRateModel()
    
    override func viewWillAppear(_ animated: Bool) {
        calculateButton.layer.cornerRadius = 4
        fromRate = countriesRates.baseCurrency    //In order to make the baseCurrency always the "fromRate" on our calculator.
        fillLabels()
        clearFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = tabBarController as! TabViewController
        countriesRates = tabBar.ratesData
        dealGesturesTaps()
    }
    
    func fromStringToDouble(str: String) -> Double{
        if let val = Double(str) {
            return val
        }
        return 0
    }
    
    @IBAction func calculatePressed(_ sender: Any) {
        let arrayObjects = countriesRates.rates as! [Rate]
        var rateValue = 0.00
        
        for rates in arrayObjects{
            if rates.currencyCode == toRate{
                rateValue = fromStringToDouble(str: rates.value)
            }
        }
        let fromValue = fromStringToDouble(str: fromCurrencyTextField.text!)
        if rateValue > 0 && fromValue > 0{
            toCurrencyTextField.text = String(fromValue * rateValue)
        }
    }
    
    
    func fillLabels(){
        let arrayObjects = countriesRates.rates as! [Rate]
        var currencyNameFrom: String!
        var currencyNameTo: String!
        for rates in arrayObjects{
            if rates.currencyCode == toRate{
                currencyNameTo = rates.currencyName
            }
            if rates.currencyCode == fromRate{
                currencyNameFrom = rates.currencyName
            }
        }
        codeFromCurrencyLabel.text = fromRate
        codeToCurrencyLabel.text = toRate
        currencyNameFromLabel.text = currencyNameFrom
        currencyNameToLabel.text = currencyNameTo
    }
    
    func clearFields(){
        toCurrencyTextField.text = ""
        fromCurrencyTextField.text = ""
    }
    
    func dealGesturesTaps(){
        changeFromImageView.isUserInteractionEnabled = true
        changeToImageView.isUserInteractionEnabled = true
        swapImageView.isUserInteractionEnabled = true
        
        let gestureFrom = UITapGestureRecognizer(target: self, action: #selector(pencilFromTapped(gesture:)))
        let gestureTo = UITapGestureRecognizer(target: self, action: #selector(pencilToTapped(gesture:)))
        let gestureSwap = UITapGestureRecognizer(target: self, action: #selector(swapTapped(gesture:)))
        
        changeFromImageView.addGestureRecognizer(gestureFrom)
        changeToImageView.addGestureRecognizer(gestureTo)
        swapImageView.addGestureRecognizer(gestureSwap)
    }
    
    
    @objc func pencilFromTapped(gesture: UITapGestureRecognizer){
        let main = UIStoryboard(name: "Main", bundle: nil)
        let view: ExchangeListViewController = main.instantiateViewController(identifier: "exchange")
        view.availableCountries = countriesRates
        view.isSelectingFrom = true //This will tell 'ExchangeListViewController' that the 'from currency' is going to be changed.
        navigationController?.pushViewController(view, animated: true)
    }
    
    @objc func pencilToTapped(gesture: UITapGestureRecognizer){
        let main = UIStoryboard(name: "Main", bundle: nil)
        let view: ExchangeListViewController = main.instantiateViewController(identifier: "exchange")
        view.availableCountries = countriesRates
        view.isSelectingFrom = false //This will tell 'ExchangeListViewController' that the 'to currency' is going to be changed.
        navigationController?.pushViewController(view, animated: true)
    }
    
    @objc func swapTapped(gesture: UITapGestureRecognizer){
        let auxRate = toRate
        countriesRates.baseCurrency = fromRate
        fromRate = auxRate
        
        //When swap button is clicked, he is going to clear fields and fill labels with the new ones. It's also important to change the model source.
        clearFields()
        fillLabels()
        countriesRates.requestRates(withBase: countriesRates.baseCurrency)
    }
}
