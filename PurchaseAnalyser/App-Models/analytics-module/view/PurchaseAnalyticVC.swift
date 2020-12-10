//
//  PurchaseAnalyticVC.swift
//  PurchaseAnalyser
//
//  Created by Sushobhit.Jain on 09/11/20.
//

import UIKit
import DropDown

class PurchaseAnalyticVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var presentor:ViewToPresenterProtocol?
    
    var arrayList: [[PurchaseCellModel]]?
    
    let header_height:CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSubViews()
        showProgressIndicator(view: self.view)
        presentor?.startFetchingAnalyticalData()
        self.arrayList = presentor?.createViewModel()
        // Do any additional setup after loading the view.
    }
    
    func configSubViews()
    {
        self.title = "Purchase Record"
        self.tableView.register(UINib(nibName: PATableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PATableViewCell.identifier)
        self.tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: PHTableHeaderView.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: PHTableHeaderView.identifier)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PurchaseAnalyticVC : PresenterToViewProtocol {
    func update(manufactorList: Array<String>, categoryList: Array<String>, countryList: Array<String>, stateList: Array<String>, items: Array<String>) {
        DispatchQueue.main.async {
            hideProgressIndicator(view: self.view)
            if self.arrayList!.count > 2 && (self.arrayList?[0].count)! > 3{
                self.arrayList?[0][0].dropDownList = manufactorList
                self.arrayList?[0][0].selectedValue = manufactorList.count>0 ? manufactorList[0] : ""
                self.arrayList?[0][0].value = self.presentor?.getPurchaseCost(query: manufactorList.count>0 ? manufactorList[0] : "", indexPath: IndexPath(row: 0, section: 0)) ?? ""
                self.arrayList?[0][1].dropDownList = categoryList
                self.arrayList?[0][1].selectedValue = categoryList.count>0 ? "\(categoryList[0])" : ""
                self.arrayList?[0][1].value = self.presentor?.getPurchaseCost(query: categoryList.count>0 ? categoryList[0] : "", indexPath: IndexPath(row: 1, section: 0)) ?? ""
                self.arrayList?[0][2].dropDownList = countryList
                self.arrayList?[0][2].selectedValue = countryList.count>0 ? "\(countryList[0])" : ""
                self.arrayList?[0][2].value = self.presentor?.getPurchaseCost(query: countryList.count>0 ? countryList[0] : "", indexPath: IndexPath(row: 2, section: 0)) ?? ""
                self.arrayList?[0][3].dropDownList = stateList
                self.arrayList?[0][3].selectedValue = stateList.count>0 ? "\(stateList[0])" : ""
                self.arrayList?[0][3].value = self.presentor?.getPurchaseCost(query: stateList.count>0 ? stateList[0] : "", indexPath: IndexPath(row: 3, section: 0)) ?? ""
                self.arrayList?[1][0].dropDownList = items
                self.arrayList?[1][0].selectedValue = items.count>0 ? "\(items[0])" : ""
                self.arrayList?[1][0].value = self.presentor?.getPurchaseCost(query: items.count>0 ? items[0] : "", indexPath: IndexPath(row: 0, section: 1)) ?? ""
                self.arrayList?[2][0].selectedValue = self.presentor?.getMostTotalPurchasesBuildingName() ?? ""
            }
            self.tableView.reloadData()
        }
    }
    
    func showError() {
        DispatchQueue.main.async {
            hideProgressIndicator(view: self.view)
            let alert = UIAlertController(title: "Alert", message: "Problem Fetching AnaticData", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func update() {
        
    }
    
}

extension PurchaseAnalyticVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.arrayList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrayList?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PATableViewCell.identifier, for: indexPath) as? PATableViewCell
        if let createdCell = cell {
            createdCell.setupData(data: self.arrayList?[indexPath.section][indexPath.row])
            return createdCell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? PATableViewCell
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = cell // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        
        if let dropDownArr = self.arrayList?[indexPath.section][indexPath.row].dropDownList as? [String]
        {
            dropDown.dataSource = dropDownArr
        }
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.arrayList?[indexPath.section][indexPath.row].selectedValue = "\(item)"
            self.arrayList?[indexPath.section][indexPath.row].value = self.presentor?.getPurchaseCost(query:item, indexPath: indexPath)
            self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            dropDown.hide()
        }

        // Will set a custom width instead of the anchor view width
//        dropDownLeft.width = 200
        dropDown.show()


    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: PHTableHeaderView.identifier) as? PHTableHeaderView
        {
            headerCell.titleL.text = presentor?.getHeaderTitles(atIndex: section)
            return headerCell
        }
        else {
            return UIView()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return header_height
    }
    
}
