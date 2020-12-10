//
//  AnalyticsProtocols.swift
//  PurchaseAnalyser
//
//  Created by Sushobhit.Jain on 09/11/20.
//

import Foundation
import UIKit

protocol ViewToPresenterProtocol: class{
    
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    func startFetchingAnalyticalData()
    func createViewModel() ->[[PurchaseCellModel]]
    func getHeaderTitles(atIndex:Int) -> String
    func getPurchaseCost(query:String,indexPath:IndexPath) -> String
    func getMostTotalPurchasesBuildingName() -> String

}

protocol PresenterToViewProtocol: class{
    
    func update(manufactorList:Array<String>,categoryList:Array<String>,countryList:Array<String>,stateList:Array<String>,items:Array<String>)
    func showError()
}

protocol PresenterToRouterProtocol: class {
//    static func createModule()-> NoticeViewController
    func pushToListScreen(navigationConroller:UINavigationController)
}

protocol PresenterToInteractorProtocol: class {
    var presenter:InteractorToPresenterProtocol? {get set}
    func fetchAllData()
}

protocol InteractorToPresenterProtocol: class {
    func listFetchSuccess(analyticsDataList:Array<AnalyticModel>,buildingDataList:Array<BuildingDataModel>)
    func listFetchFailed()
}

protocol DataModel {
    var title:String? {get set}
}
