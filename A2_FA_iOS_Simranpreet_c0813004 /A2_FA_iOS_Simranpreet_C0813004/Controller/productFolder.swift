//
//  productFolder.swift
//  A2_FA_iOS_Simranpreet_C0813004
//
//  Created by Simranpreet kaur on 25/05/21.

import UIKit
import CoreData

class productFolder: UITableViewController {
    
    // create an array of product  to enter the detail in table
    var products = [Product]()
   
    // create a context to work with core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - view lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let newProduct = Product(context: self.context)
        newProduct.name = "products"
        loadProducts()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
  
    // MARK: - Table view data source
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        //  return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folder_cell", for: indexPath)
        cell.textLabel?.text = products[indexPath.row].name
        cell.textLabel?.textColor = .red
        cell.detailTextLabel?.textColor = .blue
        cell.imageView?.image = UIImage(systemName: "Product")
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteProducts(folder: products[indexPath.row])
            saveProducts()
            products.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    //MARK: - IB Action methods
    
    /// add folder button pressed
    /// - Parameter sender: bar button
    @IBAction func addFolderBtnPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Product", message: "please give a name", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let folderNames = self.products.map {$0.name?.lowercased()}
            guard !folderNames.contains(textField.text?.lowercased()) else {self.showAlert(); return}
            let newProduct = Product(context: self.context)
            newProduct.name = textField.text!
            self.products.append(newProduct)
            self.saveProducts()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // change the color of the cancel button action
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "product name"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// show alert when the name of the folder is taken
    func showAlert() {
        let alert = UIAlertController(title: "Name Already Exists", message: "Please choose another name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - core data interaction methods
    
    /// load folder from core data
    func loadProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            products = try context.fetch(request)
        } catch {
            print("Error loading products \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    /// save products into core data
    func saveProducts() {
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error saving the folder \(error.localizedDescription)")
        }
    }
    
    func deleteProducts(folder: Product) {
        context.delete(folder)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // get the destination file through segue
       let destination = segue.destination as! productFiles
       if let indexPath = tableView.indexPathForSelectedRow {
           destination.ProductFolderTaken = products[indexPath.row]
       }
    }
}
