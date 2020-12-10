//
//  ServiceManager.swift
//  PurchaseAnalyser
//
//  Created by Sushobhit.Jain on 09/11/20.
//

import Foundation

class ServiceManager {
    // create a URL from parameters
    public static func URLFromParameters(_ parameters: [String:Any], withPathExtension: String? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = PurchaseAnalyser.ApiScheme
        components.host = PurchaseAnalyser.ApiHost
        components.path = withPathExtension ?? ""
        if parameters.count > 0 {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        return components.url
    }
}
