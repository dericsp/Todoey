//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Eric Henrique Garcia on 14/01/2018.
//  Copyright © 2018 Eric Henrique Garcia. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadItems()
        
    }
    
    //    MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }

    //   MARK: - Add new categorys
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textFieldCat = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            if let textD = textFieldCat.text {
                let newCat = Category(context: self.context)
                newCat.name = textD
                self.categoryArray.append(newCat)
                
                self.saveItems()
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
            destinationVC.selectecCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //    MARK: - Data Manipulation Methods
    
    func saveItems() {
        
        
        do {
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest())  {
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print("Error fetchin data from context \(error)")
        }
        tableView.reloadData()
    }
    
}
