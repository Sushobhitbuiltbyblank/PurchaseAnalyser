//
//  UserModel.swift
//  DirectMessagingApp
//
//  Created by Sushobhit.Jain on 28/09/19.
//  Copyright © 2019 Sushobhit.Jain. All rights reserved.
//

import Foundation
typealias completionBlock = (Data?, Bool, String?,Int) -> (Void)

enum HTTPMethod:String {
    case GET
    case POST
    case DELET
    case PUT
}

class HttpClient
{
    public static func get(param:[String:Any],urlRequest: URLRequest, completionBlock: @escaping completionBlock) -> Void {
        print(urlRequest)
        var request = urlRequest
        request.httpMethod = HTTPMethod.GET.rawValue
        let task = URLSession.shared.dataTask(with: request) { (responseData, responseUrl, error) in
            guard let dataResponse = responseData else {
                print(error?.localizedDescription ?? "Response Error")
                completionBlock(nil, true, error?.localizedDescription,0)
                return
            }
            if let httpResponse = responseUrl as? HTTPURLResponse {
                print("Status code: (\(httpResponse.statusCode))")
                completionBlock(dataResponse, true, error?.localizedDescription,httpResponse.statusCode)
            }
        }
        task.resume()
    }
}
