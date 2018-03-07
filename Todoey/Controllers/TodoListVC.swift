//
//  ViewController.swift
//  Todoey
//
//  Created by codalmacmini3 on 05/03/18.
//  Copyright © 2018 ahemad. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC : UITableViewController {
   
   // let defaults = UserDefaults.standard
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
       // loadItems()
        
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
          
        
            if textField.text != "" {
                let newItem = Item(context: self.context)
                newItem.title = textField.text
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                self.saveItem()
                
            } else {
                
                 print("ERROR While FILLUP")
            }
            
            //self.defaults.set(self.itemArray, forKey: "TodolistArray")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Mark model manipulation methods
    
    func saveItem() {
        
        do {
           try context.save()
        } catch {
            print("Error while saving data:\(error)")
        }
          tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest() , predicate:NSPredicate? = nil) {
        
        let catogoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catogoryPredicate,additionalPredicate])
        } else {
            request.predicate = catogoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error While Fetching data from context: \(error)")
        }
            tableView.reloadData()
    }
}

extension TodoListVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
        
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
