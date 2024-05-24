//
//  CauHoiCell.swift
//  DoVui
//
//  Created by Thanh Hải on 16/05/2024.
//

import UIKit

class CauHoiCell: UITableViewCell {

    
    @IBOutlet weak var cauHoi: UILabel!
    @IBOutlet weak var dapAn1: UILabel!
    @IBOutlet weak var dapAn2: UILabel!
    @IBOutlet weak var dapAn3: UILabel!
    @IBOutlet weak var dapAn4: UILabel!
    @IBOutlet weak var dapAnDung: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
