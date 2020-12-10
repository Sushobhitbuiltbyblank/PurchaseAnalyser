//
//  PurchaseAnalyticsRouter.swift
//  PurchaseAnalyser
//
//  Created by Sushobhit.Jain on 09/11/20.
//

import Foundation


import UIKit

class PurchaseAnalyticsRouter:PresenterToRouterProtocol {
    
    func pushToListScreen(navigationConroller: UINavigationController) {
        
    }
    
    
    static func createModule() -> PurchaseAnalyticVC {
        
        let view = storyboard.instantiateViewController(withIdentifier: "PurchaseAnalyticVC") as! PurchaseAnalyticVC
        
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = AnalyticsPresenter()
        let interactor: PresenterToInteractorProtocol = PurchaseAnalyticsInteractor()
        let router:PresenterToRouterProtocol = PurchaseAnalyticsRouter()
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
        
    }
    
    static var storyboard: UIStoryboard{
        return UIStoryboard(name:"PurchaseAnalyticModule",bundle: Bundle.main)
    }
    
}
