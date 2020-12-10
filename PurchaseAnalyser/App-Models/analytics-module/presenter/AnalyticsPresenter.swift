//
//  AnalyticsPresenter.swift
//  PurchaseAnalyser
//
//  Created by Sushobhit.Jain on 09/11/20.
//

import Foundation
import UIKit



class AnalyticsPresenter:ViewToPresenterProtocol{

    var items:Array<String> = Array<String>()
    var analyticsDataList: Array<AnalyticModel>?
    var buildingDataList: Array<BuildingDataModel>?
    
    func getHeaderTitles(atIndex: Int) -> String {
        return HeaderTitle(rawValue: atIndex)?.getHeader() ?? ""
    }
    
    var view: PresenterToViewProtocol?
    
    var interactor: PresenterToInteractorProtocol?
    
    var router: PresenterToRouterProtocol?
    
    var cellModelArr:Array<PurchaseCellModel>?
        
    func startFetchingAnalyticalData() {
        interactor?.fetchAllData()
    }
    
    func createViewModel() -> [[PurchaseCellModel]] {
        var arr:[[PurchaseCellModel]] = [[PurchaseCellModel]]()
        
        let istSec = [PurchaseCellModel(headerTitle: CellHeaders.manufactorer.getHeader(), dropDownList:[String](items), selectedValue:"" , value: "$0"),
                       PurchaseCellModel(headerTitle: CellHeaders.category.getHeader(), dropDownList:[String](items), selectedValue:"" , value: "$0"),
                       PurchaseCellModel(headerTitle: CellHeaders.country.getHeader(), dropDownList:[String](items), selectedValue:"" , value: "$0"),
                       PurchaseCellModel(headerTitle: CellHeaders.state.getHeader(), dropDownList:[String](items), selectedValue:"" , value: "$0")]
        
        let secSec = [PurchaseCellModel(headerTitle: CellHeaders.item.getHeader(), dropDownList:[String](items), selectedValue:"" , value: "$0")]
        let thirSec = [PurchaseCellModel(headerTitle: CellHeaders.building.getHeader(), dropDownList:[String](items), selectedValue:"" , value: "$0")]
        arr = [istSec,secSec,thirSec]
        return arr
    }
    
    func getPurchaseCost(query:String,indexPath:IndexPath) -> String {
        
        var totalCost:Double = Double()
        var totalNum:Int = Int()
        guard let analyticsDataListObj = analyticsDataList else {
            return ""
        }
        if indexPath.section == 0 && indexPath.row == 0 {
            
            let manufactorData = analyticsDataListObj.filter { $0.manufacturer == query }
            
            for analyticObj in manufactorData {
                
                for sessioninfo in analyticObj.usage_statistics?.session_infos ?? [] {
                    for purchase in sessioninfo.purchases ?? [] {
                        
                        if let cost = purchase.cost {
                            totalCost += cost
                        }
                        
                    }
                }
            }
            let finalcostStr = String(format: "%.2f", totalCost)
            return "$\(finalcostStr)"
        }
        else if indexPath.section == 0 && indexPath.row == 1 {
            for analyticObj in analyticsDataListObj {
                for sessioninfo in analyticObj.usage_statistics?.session_infos ?? [] {
                    let purchaseByCatergory = sessioninfo.purchases?.filter { $0.item_category_id == Int(query) }
                    for purchase in purchaseByCatergory ?? [] {
                        if let cost = purchase.cost {
                            totalCost += cost
                        }
                    }
                }
            }
            let finalcostStr = String(format: "%.2f", totalCost)
            return "$\(finalcostStr)"
        }
        else if indexPath.section == 0 && indexPath.row == 2 {
            let filterCountryList = buildingDataList?.filter {$0.country == query}
            for buildingDataObj in filterCountryList ?? []{
                for analyticObj in analyticsDataListObj {
                    for sessioninfo in analyticObj.usage_statistics?.session_infos ?? [] {
                        if buildingDataObj.building_id == sessioninfo.building_id {
                            for purchase in sessioninfo.purchases ?? [] {
                                
                                if let cost = purchase.cost {
                                    totalCost += cost
                                }
                                
                            }
                        }
                    }
                }
            }
            let finalcostStr = String(format: "%.2f", totalCost)
            return "$\(finalcostStr)"
        }
        else if indexPath.section == 0 && indexPath.row == 3 {
            let filterStateList = buildingDataList?.filter {$0.state == query}
            for buildingDataObj in filterStateList ?? []{
                for analyticObj in analyticsDataListObj {
                    for sessioninfo in analyticObj.usage_statistics?.session_infos ?? [] {
                        if buildingDataObj.building_id == sessioninfo.building_id {
                            for purchase in sessioninfo.purchases ?? [] {
                                
                                if let cost = purchase.cost {
                                    totalCost += cost
                                }
            
                            }
                        }
                    }
                }
            }
            let finalcostStr = String(format: "%.2f", totalCost)
            return "$\(finalcostStr)"
        }
        else if indexPath.section == 1 && indexPath.row == 0 {
            for analyticObj in analyticsDataListObj {
                for sessioninfo in analyticObj.usage_statistics?.session_infos ?? [] {
                    for purchase in sessioninfo.purchases ?? [] {
                        
                        if  Int(query) == purchase.item_id {
                            totalNum += 1
                        }
                        
                    }
                }
            }
            return "\(totalNum)"
        }
        else if indexPath.section == 2 && indexPath.row == 0 {
            var buildIDSet = Set<Int>()
            var buildIDCostDic:Dictionary<Int,Double> = Dictionary<Int,Double>()
            for buildingDataObj in buildingDataList ?? [] {
                if let id = buildingDataObj.building_id {
                    buildIDSet.insert(id)
                    buildIDCostDic[id] = 0.0
                }
            }
            for analyticObj in analyticsDataListObj {
                for sessioninfo in analyticObj.usage_statistics?.session_infos ?? [] {
                    for purchase in sessioninfo.purchases ?? [] {
                        for buildID in buildIDSet {
                            if sessioninfo.building_id == buildID {
                                if let cost = purchase.cost {
                                    if buildIDCostDic[buildID] != nil {
                                        buildIDCostDic[buildID]! += cost
                                    }
                                }
                            }
                           
                        }
                    }
                }
            }
            
            let value = buildIDCostDic.max { a, b in a.value < b.value }
            let maxPurchaseBuilding = buildingDataList?.filter { $0.building_id == value?.key }
            return "\(maxPurchaseBuilding?[0].building_name ?? "")"
        }
        return "$0"
    }
    
    func getMostTotalPurchasesBuildingName() -> String {
        guard let analyticsDataListObj = analyticsDataList else {
            return ""
        }
        var buildIDSet = Set<Int>()
        var buildIDCostDic:Dictionary<Int,Double> = Dictionary<Int,Double>()
        for buildingDataObj in buildingDataList ?? [] {
            if let id = buildingDataObj.building_id {
                buildIDSet.insert(id)
                buildIDCostDic[id] = 0.0
            }
        }
        for analyticObj in analyticsDataListObj {
            for sessioninfo in analyticObj.usage_statistics?.session_infos ?? [] {
                for purchase in sessioninfo.purchases ?? [] {
                    for buildID in buildIDSet {
                        if sessioninfo.building_id == buildID {
                            if let cost = purchase.cost {
                                if buildIDCostDic[buildID] != nil {
                                    buildIDCostDic[buildID]! += cost
                                }
                            }
                        }
                       
                    }
                }
            }
        }
        
        let value = buildIDCostDic.max { a, b in a.value < b.value }
        let maxPurchaseBuilding = buildingDataList?.filter { $0.building_id == value?.key }
        return "\(maxPurchaseBuilding?[0].building_name ?? "")"
    }
    
}

extension AnalyticsPresenter:InteractorToPresenterProtocol{
    
    func listFetchFailed() {
        view?.showError()
    }
    
    func listFetchSuccess(analyticsDataList:Array<AnalyticModel>,buildingDataList:Array<BuildingDataModel>){
        self.analyticsDataList = analyticsDataList
        self.buildingDataList = buildingDataList
        var manufactorSet:Set<String> = Set<String>()
        var categorySet:Set<Int> = Set<Int>()
        var countrySet:Set<String> = Set<String>()
        var stateSet:Set<String> = Set<String>()
        var itemsSet:Set<Int> = Set<Int>()
        for analyticObj in analyticsDataList {
            manufactorSet.insert(analyticObj.manufacturer ?? "")
            for sessioninfo in analyticObj.usage_statistics?.session_infos ?? [] {
                for purchase in sessioninfo.purchases ?? [] {
                    if let itemcat = purchase.item_category_id {
                        categorySet.insert(itemcat)
                    }
                    if let itemId = purchase.item_id {
                        itemsSet.insert(itemId)
                    }
                }
            }
        }
        for buildingObj in buildingDataList {
            countrySet.insert(buildingObj.country ?? "")
            stateSet.insert(buildingObj.state ?? "")
        }
        let categorySetString = categorySet.map { String($0)}
        let manufactorList = [String](manufactorSet)
        let categoryList = [String](categorySetString)
        let countryList = [String](countrySet)
        let stateList = [String](stateSet)
        let items = [String](itemsSet.map { String($0)})
        view?.update(manufactorList: manufactorList, categoryList: categoryList, countryList: countryList, stateList: stateList, items: items)
    }
    
}

enum CellHeaders {
    case manufactorer
    case category
    case country
    case state
    case item
    case building
    
    func getHeader() -> String {
        switch self {
        case .manufactorer:
            return "Manufactorer :"
        case .category:
            return "Category :"
        case .country:
            return "Country :"
        case .state:
            return "State :"
        case .item:
            return "Item :"
        case .building:
            return "Building :"
        }
    }
}

enum HeaderTitle:Int {
    case purchaseCosts
    case numberofPurchase
    case mostTotalPurchases
    
    func getHeader() -> String {
        switch self {
        case .purchaseCosts:
            return "Purchase Costs"
        case .numberofPurchase:
            return "Number of Purchase"
        case .mostTotalPurchases:
            return "Most Total Purchases"
        }
    }
}
