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
 
    var ProductFolderTaken: Product? {
        didSet {
            loadProducts()
        }
    }
    
    // create a context to work with core data
    @IBOutlet var trashBtn: UIBarButtonItem!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ProductFolderTaken?.name
        loadProducts()
       // showSearchBar()
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
        let prod = products[indexPath.row]
        let prodt = prod.productName! + ":" + prod.productProvider!
        cell.textLabel?.text = prodt
        cell.textLabel?.textColor = .red
        
       // cell.detailTextLabel?.text = products[indexPath.row].productName
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
            saveProduct()
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
   func loadProducts(predicate: NSPredicate? = nil) {
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
   
    /// update note in core data
    /// - Parameter title: note's title
    func updateProduct(with ID: String , with name : String , with description : String , with price : String , with provider : String ) {
        products = []
        let newData = ProductDetail(context: context)
        newData.productID = ID
        newData.productName = name
        newData.productDescription = description
        newData.productPrice = price
        newData.productProvider = provider
        newData.parentFolder = ProductFolderTaken
        saveProduct()
        loadProducts()
    }
    

}

    
