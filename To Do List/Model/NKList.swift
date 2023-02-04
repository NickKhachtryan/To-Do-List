//
//  NKList.swift
//  To Do List
//
//  Created by Nick Khachatryan on 01.02.2023.
//

import RealmSwift
import Foundation

class NKList : Object {
    @objc dynamic var item : String = ""
    @objc dynamic var isCheck : Bool = false
    @objc dynamic var date : Date = Date()
    var currentCategory = LinkingObjects(fromType: NKCategory.self, property: "items")
}
