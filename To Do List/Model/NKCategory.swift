//
//  NKCategory.swift
//  To Do List
//
//  Created by Nick Khachatryan on 01.02.2023.
//
import Foundation
import RealmSwift

class NKCategory : Object {
    @objc dynamic var name : String = ""
    let items = List<NKList>()
}
