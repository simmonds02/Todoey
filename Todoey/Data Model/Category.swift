//
//  Category.swift
//  Todoey
//
//  Created by Jamal Simmonds on 10/18/18.
//  Copyright © 2018 Jamal Simmonds. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
