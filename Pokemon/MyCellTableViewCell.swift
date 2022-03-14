//
//  MyCellTableViewCell.swift
//  Pokemon
//
//  Created by Alexandru Bogdan Potcoava on 5/3/22.
//

import UIKit

protocol MyCellDelegate {
    func callPressed(name: String)
}

class MyCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    
    var delegate: MyCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
