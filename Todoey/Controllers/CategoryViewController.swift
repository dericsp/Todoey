//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Eric Henrique Garcia on 14/01/2018.
//  Copyright © 2018 Eric Henrique Garcia. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    //    MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        
        return cell
    }

    //   MARK: - Add new categorys
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textFieldCat = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            if let textD = textFieldCat.text {
                let newCat = Category()
                newCat.name = textD
                self.save(category: newCat)
            }
            
        }
        
        alert.addTextField { (alertTextFieldCat) in
            alertTextFieldCat.placeholder = "Create new Category"
            textFieldCat = alertTextFieldCat
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    //    MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectecCategory = categories?[indexPath.row]
        }
    }
    
    
    //    MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        
        do {
            try realm.write {
             realm.add(category)
            }
        }catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories()  {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
}
