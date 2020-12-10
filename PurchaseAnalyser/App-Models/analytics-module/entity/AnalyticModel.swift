//
//  AnalyticModel.swift
//  PurchaseAnalyser
//
//  Created by Sushobhit.Jain on 09/11/20.
//

import Foundation


struct AnalyticModel:Codable {
    var manufacturer:String?
    var market_name:String?
    var codename:String?
    var model:String?
    var usage_statistics:UsageStatisticModel?
}


struct UsageStatisticModel:Codable {
    var session_infos:[SessionInfoModel]?
}

struct SessionInfoModel:Codable {
    var building_id:Int?
    var purchases:[PurchaseModel]?
}

struct PurchaseModel:Codable {
    var item_id:Int?
    var item_category_id:Int?
    var cost:Double?
}


struct BuildingDataModel:Codable {
    var building_id:Int?
    var building_name:String?
    var city:String?
    var state:String?
    var country:String?
}
