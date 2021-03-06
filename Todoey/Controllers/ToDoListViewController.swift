//
//  ViewController.swift
//  Todoey
//
//  Created by Jamal Simmonds on 10/10/18.
//  Copyright © 2018 Jamal Simmonds. All rights reserved.
//

import UIKit
import RealmSwift


class ToDoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var toDoItems : Results<Item>?
    
    var selectedCategory : Category?    {
        didSet{
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
    
        
        
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
//
//            itemArray = items
//
//
//        }
//
        
    }
    //MARK - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
       
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    //MARK - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = toDoItems?[indexPath.row]{
            do{
                
                try realm.write {
                item.done = !item.done
                }
            }catch{
                print("Error \(error)")
            }
        }
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated:  true)
        
    }
    

    //MARK: - Add New Items
   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when the user clicks the add button on our screen
            
            //Text Property Defaults to Empty String
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date.init()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error \(error)")
                }
            }

            self.tableView.reloadData()
        
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }

        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func loadItems()    {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
        
    }

    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch  {
                    print("Error Deleting Item, \(error)")
            }
        }
        
    }
    
    
}


        //MARK: - Search bar methods

extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }

}


