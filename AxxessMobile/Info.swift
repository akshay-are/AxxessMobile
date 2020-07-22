//
//  Info.swift
//  AxxessMobile
//
//  Created by Akshay Are on 21/07/20.
//  Copyright © 2020 Akshay Are. All rights reserved.
//

import Foundation
import RealmSwift

class Info: Object {
      @objc dynamic var id = ""
      @objc dynamic var type = ""
      @objc dynamic var date = ""
      @objc dynamic var data = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
