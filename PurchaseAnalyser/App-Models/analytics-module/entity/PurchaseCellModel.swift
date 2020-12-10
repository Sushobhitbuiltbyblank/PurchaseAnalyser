//
//  PurchaseCellModel.swift
//  PurchaseAnalyser
//
//  Created by Sushobhit.Jain on 09/11/20.
//

import Foundation

class PurchaseCellModel {
    var headerTitle:String?
    var dropDownList:[Any]?
    var selectedValue:Any?
    var value:String?
    init(headerTitle:String,dropDownList:[Any],selectedValue:Any,value:String) {
        self.headerTitle = headerTitle
        self.dropDownList = dropDownList
        self.selectedValue = selectedValue
        self.value = value
    }
}
