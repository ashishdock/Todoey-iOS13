//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ashish Sharma on 12/18/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()

    var categories: Results<ItemGroups>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadCategories()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}

        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let itemgroup = categories?[indexPath.row] {
            cell.textLabel?.text = itemgroup.name
            
            guard let categoryColour = UIColor(hexString: itemgroup.colour) else {
                fatalError("Fatal error related to category colour.")
            }
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        return cell
    }

    



//MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPathe = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPathe.row]
        }
    }
    
//MARK: - Data Manipulation Methods
    
    func saveCategories(itemGroups: ItemGroups){
        do {
            try realm.write{
                realm.add(itemGroups)
            }
        } catch {
            print("Error saving data \(error)")
        }
        
        tableView.reloadData()
        
        // only for a new commit
    }
    
    func loadCategories() {
        
        categories = realm.objects(ItemGroups.self)
//        let request : NSFetchRequest<ItemGroups> = ItemGroups.fetchRequest()
//
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error loading categories \(error)")
//        }
//
        tableView.reloadData()
    }
    
//MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        print("\(self.categories![indexPath.row].name) deleted" )
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
//MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = ItemGroups()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            self.saveCategories(itemGroups: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}


