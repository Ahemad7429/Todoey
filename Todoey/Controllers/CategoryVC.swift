//
//  CategoryVC.swift
//  Todoey
//
//  Created by codalmacmini3 on 06/03/18.
//  Copyright © 2018 ahemad. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: UITableViewController {

    let realm = try! Realm()
    
  
    var categoryArray : Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()

    }

    //Mark : Add Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
    }
    
    //Mark : Add Delegate methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListVC
        if let index = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[index.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goTodoListVC", sender: self)
    }
    
    //Mark : Add Manipulation
    
    func save(category:Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error while saving data:\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //Mark : Add New Items
    
    
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category : newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
