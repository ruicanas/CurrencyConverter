//
//  MainCell.swift
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 06/04/2021.
//

import UIKit

class MainCell: UITableViewCell {
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var codeFlagLabel: UILabel!
    @IBOutlet private weak var codeValueLabel: UILabel!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCell(model: Rate){
        codeValueLabel.text = model.currencyCode
        codeFlagLabel.text = model.currencyCode
        valueLabel.text = model.value
        currencyLabel.text = model.currencyName
        timeLabel.text = model.time
    
        let url = URL(string: model.flagUrl)
        flagImageView.kf.setImage(with: url)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
