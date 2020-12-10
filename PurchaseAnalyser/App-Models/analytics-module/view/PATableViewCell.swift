//
//  PATableViewCell.swift
//  PurchaseAnalyser
//
//  Created by Sushobhit.Jain on 09/11/20.
//

import UIKit

class PATableViewCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var dropDownBGV: UIView!
    @IBOutlet weak var dropDownL: UILabel!
    @IBOutlet weak var valueL: UILabel!
    @IBOutlet weak var dropDownIconImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customizeView()
        // Initialization code
    }
    
    static let identifier = String(describing: PATableViewCell.self)

    func customizeView()
    {
        self.dropDownBGV.layer.cornerRadius = 5
        self.dropDownBGV.layer.masksToBounds = true
        self.dropDownBGV.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(data:Any?) {
        if let cellData = data as? PurchaseCellModel {
            self.titleL.text = cellData.headerTitle ?? ""
            self.dropDownL.text = "\(String(describing: cellData.selectedValue ?? ""))"
            self.valueL.text = cellData.value ?? ""
            if cellData.headerTitle ?? "" == CellHeaders.building.getHeader() {
                dropDownBGV.backgroundColor = UIColor(named: "cellBG")
                dropDownIconImg.isHidden = true
                valueL.isHidden = true
            } else {
                valueL.isHidden = false
                dropDownIconImg.isHidden = false
            }
        }
    }
    
}
