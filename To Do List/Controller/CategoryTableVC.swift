//
//  CategoryTableVC.swift
//  To Do List
//
//  Created by Nick Khachatryan on 23.03.2021.
//

import UIKit
import RealmSwift

class CategoryTableVC: UITableViewController {
    
    
    //  MARK: - CUSTOM PROPERTIES
    var categoriesArray : Results<NKCategory>?
    let realm = try! Realm()
    
    
    //  MARK: - VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
}

    
    //  MARK: - ACTION
    @IBAction func pressedAddCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "For your list", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let category = NKCategory()
            if textField.text! != ""{
                category.name = textField.text!
                self.saveData(category: category)
            }
        }
        alert.addTextField { (textF) in
            textF.placeholder = "Input text here..."
            textField = textF
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pressedEditCategory(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
        }
    }
    
    
    //  MARK: - TABLE VIEW LIFE CYCLE
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let category = categoriesArray?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(category.items)
                    realm.delete(category)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        tableView.reloadData()
    }
    
    
    // MARK: - TABLE VIEW DATA SOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? ""
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedRow = tableView.indexPathForSelectedRow?.row else {return}
        
        if segue.identifier == "goToList"{
            let lisTVC = segue.destination as! TableViewController
            lisTVC.selectedCategory = categoriesArray?[selectedRow]
        }
    }
    
    
    //  MARK: - REALM DATA
    func saveData(category : NKCategory){
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("REALM" , error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    func readData(){
        categoriesArray =  realm.objects(NKCategory.self)
        tableView.reloadData()
        }
    }
