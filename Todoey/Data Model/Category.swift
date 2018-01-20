//
//  Category.swift
//  Todoey
//
//  Created by Eric Henrique Garcia on 14/01/2018.
//  Copyright © 2018 Eric Henrique Garcia. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String? = ""
    @objc dynamic var color: String? = ""
    let items = List<Item>()
}
