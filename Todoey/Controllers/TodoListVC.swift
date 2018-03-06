//
//  ViewController.swift
//  Todoey
//
//  Created by codalmacmini3 on 05/03/18.
//  Copyright © 2018 ahemad. All rights reserved.
//

import UIKit

class TodoListVC : UITableViewController {
   
   // let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
        
//        if let items = defaults.array(forKey: "TodolistArray") as? [Item] {
//            itemArray = items
//        }
        
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

        saveItem()
        
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
            self.saveItem()
            //self.defaults.set(self.itemArray, forKey: "TodolistArray")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error While Encoding: \(error)")
        }
          tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error While Decoding: \(error)")
            }
                
        }
    }
}

