//
//  DetailInformationViewController.swift
//  AxxessMobile
//
//  Created by Akshay Are on 20/07/20.
//  Copyright © 2020 Akshay Are. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class DetailInformationViewController: UIViewController {

    //MARK: - View
    
    var imgView = UIImageView()
    var lblId : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
        }()
    var lblDate : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    var lblDetail : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    var detailInfo = Info()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
  
        //MARK:- Setup Scroll View
   
        self.view.addSubview(self.scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.scrollView)
            make.leading.trailing.equalTo(self.view)
            make.width.equalTo(self.scrollView)
          
        }
        
   //     print(detailInfo)
        
        if detailInfo.type == "text" || detailInfo.type == "other"
        {
            self.setUpForTextDetails()
            self.setTextForTextDetails(detailInfo: detailInfo)
        }else if detailInfo.type == "image"
        {
            self.setUpForImageDetails()
            self.setTextForImageDetails(detailInfo: detailInfo)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
       
        
    }
    

    func setUpForImageDetails()
    {
        self.contentView.addSubview(imgView)
        self.contentView.addSubview(lblId)
        self.contentView.addSubview(lblDate)
        
        imgView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(imgView.snp.width)
        }
        
        lblId.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(imgView.snp.bottom).offset(8)
        }
        
        lblDate.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview().inset(8)
            make.top.equalTo(lblId.snp.bottom).offset(8)
        }
        
    }
    
    func setUpForTextDetails()
    {
        self.contentView.addSubview(lblId)
        self.contentView.addSubview(lblDate)
        self.contentView.addSubview(lblDetail)
        
        lblId.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(8)
        }
              
        lblDate.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(lblId.snp.bottom).offset(8)
        }
        
        lblDetail.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview().inset(8)
            make.top.equalTo(lblDate.snp.bottom).offset(8)
        }
        
    }

    //MARK:- For Text & Other Type Details
    
    func setTextForTextDetails(detailInfo:Info) -> Void {
    
    
        lblId.text = "ID     :" + detailInfo.id
        lblDate.text = "Date   :" + detailInfo.date
        lblDetail.text = "Details :" + detailInfo.data
    }
    
   //MARK: - For Image Type Details
    
    func setTextForImageDetails(detailInfo:Info) -> Void {
        lblId.text = "ID     :" + detailInfo.id
        lblDate.text = "Date   :" + detailInfo.date
        imgView.image = UIImage(named: "placeholderImage")
        
        if let imgurl = URL(string: detailInfo.data) {
            imgView.load(url: imgurl)
        }
        
    }
    
}
