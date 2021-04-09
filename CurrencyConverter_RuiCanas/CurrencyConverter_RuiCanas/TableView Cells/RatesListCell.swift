//
//  RatesListCell.swift
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 06/04/2021.
//

import UIKit

class RatesListCell: UITableViewCell {
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(model: Rate, baseCurrency: String){
        codeLabel.text = model.currencyCode
        currencyLabel.text = model.currencyName
        let url = URL(string: model.flagUrl)
        flagImageView.kf.setImage(with: url)
        if model.currencyCode == baseCurrency{
            checkmarkImageView.isHidden = false
        }
        else{
            checkmarkImageView.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
