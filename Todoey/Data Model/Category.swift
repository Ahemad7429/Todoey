//
//  Category.swift
//  Todoey
//
//  Created by codalmacmini3 on 07/03/18.
//  Copyright © 2018 ahemad. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
}
