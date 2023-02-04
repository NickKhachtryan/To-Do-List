//
//  TableViewController.swift
//  To Do List
//
//  Created by Nick Khachatryan on 02.03.2021.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController , UISearchBarDelegate{
    
    
    //  MARK: - CUSTOM PROPERTIES
    var realm : Realm?{
        do {
            return try Realm()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    var shopList : Results<NKList>?
    
    var selectedCategory : NKCategory? {
        didSet {
            readData()
        }
    }
    
    
    //  MARK: - VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lazy List"
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let list = shopList?[indexPath.row] {
            cell.textLabel?.text = list.item
            cell.accessoryType = list.isCheck ? .checkmark : .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let list = shopList?[indexPath.row] {
            do {
                try realm?.write{
                    list.isCheck = !list.isCheck
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let list = shopList?[indexPath.row] {
            do {
                try realm?.write{
                    realm?.delete(list)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        tableView.reloadData()}
    
    
    //  MARK: - BUTTONS
    @IBAction func pressedAdd(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "For your list", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            
            if textField.text! != ""{
                
                if let currentCategory = self.selectedCategory{
                    guard let safeRealm = self.realm else {return}
                    do {
                        try safeRealm.write{
                            let nkList = NKList()
                            nkList.item = textField.text!
                            nkList.date = Date()
                            currentCategory.items.append(nkList)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (textF) in
            textF.placeholder = "Input text here..."
            textField = textF
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//    @IBAction func pressedEdit(_ sender: UIBarButtonItem) {
//        if tableView.isEditing {
//            tableView.setEditing(false, animated: true)
//            sender.title = "Edit"
//            
//        } else {
//            tableView.setEditing(true, animated: true)
//            sender.title = "Done"
//        }
//    }
    
    
    //  MARK: - SEARCH
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchInDB(text: searchText, searchBar: searchBar)
    }
    
    func searchInDB(text : String , searchBar: UISearchBar){
        if text != ""{
            shopList = shopList?.filter("item CONTAINS[cd] %@" , text).sorted(byKeyPath: "item", ascending: true)
        } else {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            readData()
        }
        tableView.reloadData()
    }
    
    
    //  MARK: - REALM DATA
    func saveData(list : NKList){
    }
    
    func readData(){
        shopList = selectedCategory?.items.sorted(byKeyPath: "date" , ascending: true)
    }
}
