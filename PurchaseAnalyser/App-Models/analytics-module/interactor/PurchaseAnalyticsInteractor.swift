//
//  PurchaseAnalyticsInteractor.swift
//  PurchaseAnalyser
//
//  Created by Sushobhit.Jain on 09/11/20.
//

import Foundation

enum URLEndpoints{
    case getBuildingData
    case getAnalyticData
  
    var urlEndpoint : String{
        
        get{
            switch self {
            case .getBuildingData:
                return "http://positioning-test.mapsted.com/api/Values/GetBuildingData/"
            case .getAnalyticData:
                return "http://positioning-test.mapsted.com/api/Values/GetAnalyticData/"
        }
    }
}
}

class PurchaseAnalyticsInteractor:PresenterToInteractorProtocol{
    
    var presenter: InteractorToPresenterProtocol?
    let dispatchGroup = DispatchGroup()
    var buildingDataList = Array<BuildingDataModel>()
    var analyticsDataList = Array<AnalyticModel>()
    func fetchAllData()
    {
        self.fetchList()
        self.fetchBuildingData()
        dispatchGroup.notify(queue: .main) {
            self.presenter?.listFetchSuccess(analyticsDataList: self.analyticsDataList, buildingDataList: self.buildingDataList)
        }
    }
    private func fetchBuildingData()
    {
        
        self.dispatchGroup.enter()
        self.getBuildingData(param: [:]) { (buildingDataList, success, error) in
            self.buildingDataList = buildingDataList
            self.dispatchGroup.leave()
        }
    }
    private func fetchList() {
        self.dispatchGroup.enter()
        self.getAnalyticData(param: [:]) { (analyticlist, success, error) in
            self.analyticsDataList = analyticlist
            self.dispatchGroup.leave()
        }
    }
    
    private func getAnalyticData(param:[String:Any], completionBlock: @escaping ([AnalyticModel],Bool,String)->Void) -> Void {
        
        guard let url = ServiceManager.URLFromParameters(param, withPathExtension: PAMethods.getAnalyticData) else
        {
            return
        }
        let urlRequest = URLRequest(url: url)
        HttpClient.get(param: [:], urlRequest: urlRequest) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                        print(json)
                    } catch let error {
                        print(error)
                    }
                    do{
                        let analyticRes = try JSONDecoder().decode([AnalyticModel].self, from: responseData)
                        completionBlock(analyticRes,true,"")
                    }
                    catch let error {
                        self.presenter?.listFetchFailed()
                        print(error)
                    }
                }
            }
            else {
                self.presenter?.listFetchFailed()
            }
        }
    }
    
    private func getBuildingData(param:[String:Any], completionBlock: @escaping ([BuildingDataModel],Bool,String)->Void) -> Void {
        
        guard let url = ServiceManager.URLFromParameters(param, withPathExtension: PAMethods.getBuildingData) else
        {
            return
        }
        let urlRequest = URLRequest(url: url)
        HttpClient.get(param: [:], urlRequest: urlRequest) { (response, status, error,statusCode) -> (Void) in
            if statusCode == 200 {
                if let responseData = response {
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                            print(responseData.prettyPrintedJSONString)
                        }
                        print(json)
                    } catch let error {
                        print(error)
                    }
                    do{
                        let buildingRes = try JSONDecoder().decode([BuildingDataModel].self, from: responseData)
                        completionBlock(buildingRes,true,"")
                    }
                    catch let error {
                        self.presenter?.listFetchFailed()
                        print(error)
                    }
                }
            }
            else {
                self.presenter?.listFetchFailed()
            }
        }
    }
}
extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
