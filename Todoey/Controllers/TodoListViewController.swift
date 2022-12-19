//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var itemArray: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : ItemGroups? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            
    //        cell.accessoryType = item.done ? .checkmark : .none
            
            if item.done == true {
                cell.accessoryType = .checkmark
                print("\(item.title) is now checked")
            } else {
                cell.accessoryType = .none
                print("\(item.title) is now unchecked")
            }
        } else {
            cell.textLabel?.text = "No items added..."
        }
        
        return cell
    }
    
//MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        } else {
            // do nothing
            
        }
        
        tableView.reloadData()
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        self.saveItems()
//
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "Write a task for yourself", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
        
            if let currentCategory = self.selectedCategory {
                do {try self.realm.write{
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                }} catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
//            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
//MARK: - Model Manipulation Methods
    
//    func  saveItems() {
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context, \(error)")
//        }
//
//        self.tableView.reloadData()
//    }
//
    func loadItems() {
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name)
//
//        if predicate != nil {
//
//            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//
//            request.predicate = compoundPredicate
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }

        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!)//.sorted(byKeyPath: "title", ascending: true)
        
        print("Typed this is search bar: \(searchBar.text!)")
        
        tableView.reloadData()
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
