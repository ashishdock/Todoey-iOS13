//
//  Item.swift
//  Todoey
//
//  Created by Ashish Sharma on 12/17/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

class Item: Codable { // so that the data can be encoded into plist or json
    var title: String = ""
    var done: Bool = false
}
