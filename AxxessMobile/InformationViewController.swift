//
//  InformationViewController.swift
//  AxxessMobile
//
//  Created by Akshay Are on 19/07/20.
//  Copyright © 2020 Akshay Are. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class InformationTableViewCell: UITableViewCell {
    static let identifier: String = "cell"
    
    var lblId = UILabel()
    var lblDate = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lblId)
        contentView.addSubview(lblDate)
        
        lblId.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(8)
        }
        
        lblDate.snp.makeConstraints { (make) in
            
            make.top.equalTo(lblId.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(8)
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Views
    
    var tblInformation: UITableView = {
    let tbl = UITableView(frame: .zero)
        tbl.backgroundColor = .white
        
        
    return tbl
    }()
   
    var segControl: UISegmentedControl = {
        
        let seg = UISegmentedControl(items: ["Text","Image","Other"])
        seg.selectedSegmentIndex = 0
        

        return seg
    }()
   //MARK: - Data Types
    
    var arrInfo = [Info]()
    let uirealm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        self.title = "Information"
        self.view.addSubview(segControl)
        self.view.addSubview(tblInformation)
        
        segControl.addTarget(self, action: #selector(segmentControlValueChange(segment:)), for: .valueChanged)
        
        self.setUpConstraint()
        tblInformation.register(InformationTableViewCell.self, forCellReuseIdentifier: InformationTableViewCell.identifier)
        tblInformation.delegate = self
        tblInformation.dataSource = self
        
        self.checkForInformation()
    }
    
    func setUpConstraint() {
        
        segControl.snp.makeConstraints { (make) in
           make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).inset(8)
           make.leading.trailing.equalToSuperview().inset(30)
           make.height.equalTo(40)
        }
        
        tblInformation.snp.makeConstraints { (make) in
            make.top.equalTo(segControl.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(8)
        }
        
    }
    
    func checkForInformation()
    {
       let webService = WebServices()
        webService.checkForNetwork { (network) in
            print("Network..\(network)")
            if network{
                self.challengeJSON()
            }else{
                self.updateDataAndDisplay(filter: "text")
            }
        }
        
    }
    
    func updateDataAndDisplay(filter:String){
        self.arrInfo = Array(self.uirealm.objects(Info.self).filter{
            $0.type == filter
        })
        self.tblInformation.reloadData()
    }
    
    //MARK: - SegmentControl Value Change
    
    @objc func segmentControlValueChange(segment:UISegmentedControl){
        
        switch segment.selectedSegmentIndex {
        case 0:
            
            self.updateDataAndDisplay(filter: "text")
            break
        case 1:
            self.updateDataAndDisplay(filter: "image")
            break
        case 2:
            self.updateDataAndDisplay(filter: "other")
            break
        default:
            break
        }
    }
    
    
    //MARK: - UITableView Delegate & DataSource
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Array count ...\(arrInfo.count)")
        return arrInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tblInformation.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier, for: indexPath) as! InformationTableViewCell
      
        let info = arrInfo[indexPath.row]
        
        cell.lblId.text = "ID   : \(info.id)"
        cell.lblDate.text = "DATE   : \(info.date)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tblInformation.deselectRow(at: indexPath, animated: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailInformationViewController") as! DetailInformationViewController
        vc.detailInfo = arrInfo[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func challengeJSON() -> Void {
        
       
              let apiController = WebServices()
              apiController.getRequestWithUrlArray(UrlString: "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json") { (response, error) in
                  print(response as Any)
                  if response != nil
                  {
                    let response = response as! [[String:Any]]
                    for dict in response
                    {
                        let info = Info()
                        info.id = dict["id"] as? String ?? "-"
                        info.date = dict["date"] as? String ?? "-"
                        info.type = dict["type"] as? String ?? "-"
                        info.data = dict["data"] as? String ?? ""
             //If you want to do nothing if it already exist
          /*
                        let existingInfo = self.uirealm.object(ofType: Info.self, forPrimaryKey: "id")
                        
                        if let existingInfo = existingInfo{
                            // Information Already Exist.
                        }else{
                        
                        try! self.uirealm.write(){
                            self.uirealm.add(info)
                        }
                        }
            */
            // If you want to update the object if it exist & add if it doesn't
                        try! self.uirealm.write(){
                            self.uirealm.add(info, update: .all)
                        }
                    }
                    
                    self.updateDataAndDisplay(filter: "text")
                  }
                  else{
                     
                      print("Error:..",error as Any)
                  }
              }
          }
        
    
    
}
