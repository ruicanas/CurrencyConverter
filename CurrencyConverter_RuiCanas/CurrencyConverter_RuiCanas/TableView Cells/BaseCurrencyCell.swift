//
//  BaseCurrencyCell.swift
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 06/04/2021.
//

import UIKit

protocol BaseCurrencyCellDelegate {
    func changeView()
}

class BaseCurrencyCell: UITableViewCell {
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var currencyLabel: UILabel!
    var delegate: BaseCurrencyCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateCell(model: Rate){
        codeLabel.text = model.currencyCode
        currencyLabel.text = model.currencyName
        let url = URL(string: model.flagUrl)
        flagImageView.kf.setImage(with: url)
    }
    
    @IBAction func changeBaseCurrencyPressed(_ sender: Any) {
        delegate?.changeView()
    }
}
