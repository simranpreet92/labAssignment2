//
//  providerProvider.swift
//  A2_FA_iOS_Simranpreet_C0813004
//
//  Created by Simranpreet kaur on 25/05/21.


import UIKit
import CoreData
class productProvider: UITableViewController {
    // create an array of ProductDetail to populate the table
    var products = [ProductDetail]()
   
    // create a context to work with core data
    @IBOutlet var trashBtn: UIBarButtonItem!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        staticData()
        loadProducts()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "provider", for: indexPath)
        
        cell.textLabel?.text = products[indexPath.row].productProvider
        cell.textLabel?.textColor = .red
        cell.detailTextLabel?.textColor = .blue
        cell.imageView?.image = UIImage(systemName: "Provider")
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
            products.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /// Save notes into core data
    func saveProduct() {
        do {
            try context.save()
        } catch {
            print("Error saving the products \(error.localizedDescription)")
        }
    }
    func loadProducts() {
        let request: NSFetchRequest<ProductDetail> = ProductDetail.fetchRequest()
        
        do {
            products = try context.fetch(request)
           for data in products as [NSManagedObject] {
            data.value(forKey: "productProvider")as! String
            
            }
        } catch {
            print("Error loading products \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
  
    /// save products into core data
    func deleteProducts(folder: ProductDetail) {
        context.delete(folder)
    }
    

    @IBAction func trashBtnpressed(_ sender: UIBarButtonItem) {
    
    if let indexPaths = tableView.indexPathsForSelectedRows {
                let rows = (indexPaths.map {$0.row}).sorted(by: >)
                let _ = rows.map {products.remove(at: $0)}
                tableView.reloadData()
                saveProduct()
        }
    }
    func save(  productProvider: String) {
      
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let request: NSFetchRequest<ProductDetail> = ProductDetail.fetchRequest()
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "ProductDetail",
                                       in: managedContext)!
        let product = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
     
      product.setValue(productProvider, forKeyPath: "productProvider")
        do {
            products = try context.fetch(request)
            try managedContext.save()
        } catch let error as NSError {
        }
        tableView.reloadData()
    }
    
       // appending data into core data
        func staticData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
       let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
                NSEntityDescription.entity(forEntityName: "ProductDetail",
                                           in: managedContext)!
            
            let p1 = NSManagedObject(entity: entity,
                                          insertInto: managedContext)
            
    
        p1.setValue("Mary", forKeyPath: "productProvider")
        let p2 = NSManagedObject(entity: entity,
                                          insertInto: managedContext)
        p2.setValue("john", forKeyPath: "productProvider")
            self.save(productProvider: "methew")
            self.save(productProvider: "seema")
            self.save(productProvider: "neha")
            self.save(productProvider: "ginni")
    }
    

}

    
    

