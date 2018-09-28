//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Eric Henrique Garcia on 16/01/2018.
//  Copyright © 2018 Eric Henrique Garcia. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    
    
    
    // TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
//        print("cellForRowAt SwipeTable")
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            let alert = UIAlertController(title: "Danger", message: "You will delete todos", preferredStyle: .alert)
            
            let deleteAction1 = UIAlertAction(title: "Delete", style: .destructive, handler: { (deleteAction) in
//                print("Delete Cell")
                
                self.updateModel(at: indexPath)
                
            })
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancelActino) in
//                print("cancel")
            })
        
            alert.addAction(deleteAction1)
            alert.addAction(cancelAction)
        
            self.present(alert, animated: true, completion: nil)
        
            
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .none
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        
    }
    

}


