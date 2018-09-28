//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Eric Henrique Garcia on 14/01/2018.
//  Copyright © 2018 Eric Henrique Garcia. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    weak var alertEnable : UIAlertAction?
    
    var numberOfRows : Int!
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            loadCategories()
    }
    
    //    MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if !(realm.objects(Category.self).count == 0){
        numberOfRows = realm.objects(Category.self).count
        }
//        print("numberCategory \(numberOfRows)")
            return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if !(categories?.count == Optional(0)) {
            
            if let category = categories?[indexPath.row]{
                
//                print("cellForRowAtCategory category")
            
                cell.textLabel?.text = category.name ?? "No categories added yet"
                
                guard let categoryColor = UIColor(hexString: category.color!) else {fatalError()}
                
                cell.backgroundColor = categoryColor
                
                cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            }
        
        }else {
            cell.backgroundColor = .white
            cell.textLabel?.textColor = ContrastColorOf(FlatWhite(), returnFlat: true)
            cell.textLabel?.text = "No categories added yet"

        }
        
        return cell
    }

    //   MARK: - Add new categorys
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textFieldCat = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            
        }
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            if let textD = textFieldCat.text {
                let newCat = Category()
                newCat.name = textD
                newCat.color = UIColor.randomFlat.hexValue()
                self.save(category: newCat)
            }
            
        }
        
        alert.addTextField { (alertTextFieldCat) in
            alertTextFieldCat.placeholder = "Create new Category"
            textFieldCat = alertTextFieldCat
            textFieldCat.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            action.isEnabled = false
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        alertEnable = action
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.count > 0 {
            alertEnable?.isEnabled = true
//            print("alterou")
        }else {
            alertEnable?.isEnabled = false
//            print("nada")
        }
    }
    
    
    //    MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !(realm.objects(Category.self).count == Optional(0)){

        performSegue(withIdentifier: "goToItems", sender: self)
        }else {
            tableView.deselectRow(at: indexPath, animated: false)
//            print("nothing")
        }
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

        if (realm.objects(Category.self).count == 0) {
            numberOfRows = 1

        } else {

            numberOfRows = realm.objects(Category.self).count
            
        }
        
        tableView.reloadData()
    }
    

    
    //    MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
      
        if let categoryForDeletion = self.categories?[indexPath.row] {
            if categoryForDeletion.items.count > 0 {
     
                    do {
                        try self.realm.write {
                            self.realm.delete((categories?[indexPath.row].items)!)
                        }
                    }catch {
                        print(error)
                    }
                    
                    do {
                        try self.realm.write {
                            
                            self.realm.delete((categories?[indexPath.row])!)
                        }
                        
                    }catch {
                        print("Error while deleting category \(error)")
                    }

            }else {
                do {
                    try self.realm.write {
                    
                        self.realm.delete(categoryForDeletion)
                    }
                
                }catch {
                    print("Error while deleting category \(error)")
                }
            
            }
            tableView.reloadData()
        
        }
        
    }
    
}


