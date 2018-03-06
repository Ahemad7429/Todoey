//
//  ViewController.swift
//  Todoey
//
//  Created by codalmacmini3 on 05/03/18.
//  Copyright © 2018 ahemad. All rights reserved.
//

import UIKit

class TodoListVC : UITableViewController {
   
    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        let item1 = Item()
        item1.title = "item 1"
        item1.done = true
        itemArray.append(item1)
        
        let item2 = Item()
        item2.title = "item 2"
        itemArray.append(item2)
        
        let item3 = Item()
        item3.title = "item 3"
        itemArray.append(item3)
        
        if let items = defaults.array(forKey: "TodolistArray") as? [Item] {
            itemArray = items
        }
        
        }



    
    //Mark Table View Datasource  methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoeyCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
       cell.accessoryType = item.done == true ? .checkmark : .none
    
        
        
        
        return cell
    }
    
    
    //Mark Table View Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark Add Item method
    
    @IBAction func addItemButtonClicked(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodolistArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

