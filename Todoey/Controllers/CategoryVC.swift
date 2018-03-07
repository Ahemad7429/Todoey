//
//  CategoryVC.swift
//  Todoey
//
//  Created by codalmacmini3 on 06/03/18.
//  Copyright © 2018 ahemad. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        loadCategory()

    }

    //Mark : Add Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //Mark : Add Manipulation
    
    func saveItem() {
        
        do {
            try context.save()
        } catch {
            print("Error while saving data:\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error While Fetching data from context: \(error)")
        }
        tableView.reloadData()
    }
    
    //Mark : Add New Items
    
    
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
           
            self.saveItem()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Mark : Add Delegate methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListVC
        if let index = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[index.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goTodoListVC", sender: self)
    }
}
