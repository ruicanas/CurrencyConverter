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
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    var delegate: BaseCurrencyCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func changeBaseCurrencyPressed(_ sender: Any) {
        delegate?.changeView()
        
//        if ([self.delegate respondsToSelector:@selector(updateTableView)]) {
//            [self.delegate updateTableView];
//        }
    }
}
