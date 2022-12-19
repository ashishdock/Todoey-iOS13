//
//  ItemGroups.swift
//  Todoey
//
//  Created by Ashish Sharma on 12/18/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class ItemGroups: Object {
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}
