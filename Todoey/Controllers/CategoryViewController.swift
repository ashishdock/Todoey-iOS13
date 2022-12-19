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

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categories: Results<ItemGroups>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadCategories()
        
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet!"
        
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
    
//MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = ItemGroups()
            newCategory.name = textField.text!
            
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
