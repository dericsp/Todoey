//
//  ViewController.swift
//  Todoey
//
//  Created by Eric Henrique Garcia on 13/01/2018.
//  Copyright © 2018 Eric Henrique Garcia. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController, UITextFieldDelegate {
    
    weak var actionToEnable : UIAlertAction?
    
    var itemArray: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    
    var selectecCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colourHex = selectecCategory?.color else {fatalError()}
        
        title = selectecCategory!.name
        
        updateNavBar(whitHexCode: colourHex)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
       
        updateNavBar(whitHexCode: "1D9BF6")
        
    }
    
    func updateNavBar(whitHexCode colourHexCode : String) {
        
        guard let navbar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        
        navbar.barTintColor = navBarColour
        
        navbar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navbar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //        Ternary operator ==>
            //        value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = (item.done) ? .checkmark : .none
            
            if let colour = UIColor(hexString: selectecCategory!.color!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemArray!.count)) {
                cell.backgroundColor = colour
                
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                cell.tintColor = ContrastColorOf(colour, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }

      
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let arraySelected = itemArray?[indexPath.row] {
            
            do {
                try realm.write {
                    arraySelected.done = !arraySelected.done
                }
            }catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

  
 
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFieldEric = UITextField()
        
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action1) in
          
            
            if let text = textFieldEric.text {

                action1.isEnabled = true
                if let currentCategory = self.selectecCategory {
                    
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = text
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new items, \(error)")
                    }
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textFieldEric = alertTextField
            
            textFieldEric.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                    for: .editingChanged)
            action.isEnabled = false
 
        }
        
        self.actionToEnable = action
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (cancel) in
            print("Cancelada a ação")
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text!.count > 0 {
            actionToEnable?.isEnabled = true
//            print("alterou")
        }else {
            actionToEnable?.isEnabled = false
//            print("nada")
        }
    }
    

    
    func loadItems()  {
        
        itemArray = selectecCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let todoForDeletion = self.itemArray?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(todoForDeletion)
                }
            }catch {
                print("Error trying to delete todo \(error)")
            }
        }
    }
    
    

    
}

//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

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
