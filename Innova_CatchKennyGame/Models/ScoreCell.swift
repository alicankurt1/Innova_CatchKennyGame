//
//  ScoreCell.swift
//  Innova_CatchKennyGame
//
//  Created by Alican Kurt on 29.12.2021.
//

import UIKit

class ScoreCell: UITableViewCell {
    
    private let allias: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
