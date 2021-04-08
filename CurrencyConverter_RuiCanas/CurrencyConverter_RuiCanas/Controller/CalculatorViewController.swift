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
    @IBOutlet weak var loadingView: UIView!
    
    let networkLayer = NetworkLayer()
    var fromRate = "EUR"
    var toRate = "USD"
    var rates = [Rate]()
    
    override func viewWillAppear(_ animated: Bool) {
        calculateButton.layer.cornerRadius = 4
        executeRequestOfRates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dealGesturesTaps()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        loadingView.isHidden = false
    }
    
    func fromStringToDouble(str: String) -> Double{
        if let val = Double(str) {
            return val
        }
        return 0
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.25, animations: {
                sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
        var rateValue = 0.00
        
        for rate in rates{
            if rate.currencyCode == toRate{
                rateValue = fromStringToDouble(str: rate.value)
            }
        }
        let fromValue = fromStringToDouble(str: fromCurrencyTextField.text!)
        if rateValue > 0 && fromValue > 0{
            toCurrencyTextField.text = String(fromValue * rateValue)
        }
    }
    
    
    func fillLabels(){
        var currencyNameFrom: String!
        var currencyNameTo: String!
        for rate in rates{
            if rate.currencyCode == toRate{
                currencyNameTo = rate.currencyName
            }
            if rate.currencyCode == fromRate{
                currencyNameFrom = rate.currencyName
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
    
    func executeRequestOfRates(){
        networkLayer.requestRates(withBase: fromRate) { rates in
            self.rates = rates!
            for rate in self.rates{
                self.networkLayer.requestInfo(withCurrency: rate.currencyCode) { completeRate  in
                    rate.currencyName = completeRate!.currencyName
                    rate.flagUrl = completeRate!.flagUrl
                    if rate == self.rates.last{
                        self.fillLabels()
                        self.clearFields()
                        self.loadingView.isHidden = true
                    }
                }
            }
        }
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
        UIView.animate(withDuration: 0.4) {
            self.changeFromImageView.alpha = 0.5
        }
        UIView.animate(withDuration: 0.3) {
            self.changeFromImageView.alpha = 1
        }
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let view: ExchangeListViewController = main.instantiateViewController(identifier: "exchange")
        view.countriesCopy = rates
        view.isSelectingFrom = true //This will tell 'ExchangeListViewController' that the 'from currency' is going to be changed.
        navigationController?.pushViewController(view, animated: true)
    }
    
    @objc func pencilToTapped(gesture: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.4) {
            self.changeToImageView.alpha = 0.5
        }
        UIView.animate(withDuration: 0.3) {
            self.changeToImageView.alpha = 1
        }
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let view: ExchangeListViewController = main.instantiateViewController(identifier: "exchange")
        view.countriesCopy = rates
        view.isSelectingFrom = false //This will tell 'ExchangeListViewController' that the 'to currency' is going to be changed.
        navigationController?.pushViewController(view, animated: true)
    }
    
    @objc func swapTapped(gesture: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.4) {
            self.swapImageView.alpha = 0.5
        }
        UIView.animate(withDuration: 0.3) {
            self.swapImageView.alpha = 1
        }

        let auxRate = toRate
        toRate = fromRate
        fromRate = auxRate
        
        //When swap button is clicked, he is going to clear fields and fill labels with the new ones. It's also important to change the model source.
        clearFields()
        fillLabels()
        loadingView.isHidden = false
        executeRequestOfRates()
    }
}
