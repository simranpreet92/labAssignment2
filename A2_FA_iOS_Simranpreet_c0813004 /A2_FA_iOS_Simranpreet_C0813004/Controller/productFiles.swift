
//  productFiles.swift
//  A2_FA_iOS_Simranpreet_C0813004
//
//  Created by Simranpreet kaur on 25/05/21.
import UIKit
import CoreData

class productFiles: UITableViewController {

    @IBOutlet weak var trashBtn: UIBarButtonItem!
    var flag = true
    var deletingMovingOption: Bool = false
    
    // create product data
    var products = [ProductDetail]()
    var ProductFolderTaken: Product? {
        didSet {
            loadProducts()
        }
    }
    
    // create the context
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
   // define a search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = ProductFolderTaken?.name
        showSearchBar()
         staticData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Products_cell", for: indexPath)
        let prod = products[indexPath.row]
        let prodt = "Product name is "+prod.productName!
        cell.textLabel?.text = prodt
        cell.textLabel?.textColor = .red
        cell.backgroundColor = .white
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
            deleteProduct(note: products[indexPath.row])
            saveProduct()
            products.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //MARK: - Core data interaction functions
    
    /// load notes deom core data
    /// - Parameter predicate: parameter comming from search bar - by default is nil
    func loadProducts(predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<ProductDetail> = ProductDetail.fetchRequest()
        let folderPredicate = NSPredicate(format: "parentFolder.name=%@", ProductFolderTaken!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [folderPredicate, additionalPredicate])
        } else {
            request.predicate = folderPredicate
        }
        
        do {
            products = try context.fetch(request)
        } catch {
            print("Error loading products \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    /// delete notes from context
    /// - Parameter note: note defined in Core Data
    func deleteProduct(note: ProductDetail) {
        context.delete(note)
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
    
    /// Save notes into core data
    func saveProduct() {
        do {
            try context.save()
        } catch {
            print("Error saving the products \(error.localizedDescription)")
        }
    }
    
    //MARK: - Action methods
    
    /// trash bar button functionality
    /// - Parameter sender: bar button
    @IBAction func trashBtnPressed(_ sender: UIBarButtonItem) {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            let rows = (indexPaths.map {$0.row}).sorted(by: >)
            let _ = rows.map {deleteProduct(note: products[$0])}
            let _ = rows.map {products.remove(at: $0)}
            tableView.reloadData()
            saveProduct()
        }
    }
    
    /// editing option functionality - when three dots is pressed this function is executed
    /// - Parameter sender: bar button
    @IBAction func editingBtnPressed(_ sender: UIBarButtonItem) {
        deletingMovingOption = !deletingMovingOption
        trashBtn.isEnabled = !trashBtn.isEnabled
        tableView.setEditing(deletingMovingOption, animated: true)
    }
    
    //MARK: - show search bar func
    func showSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter product name for Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.searchTextField.textColor = .lightGray
    }

    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier != "moveNotesSegue" else {
            return true
        }
        return deletingMovingOption ? false : true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? productDetail {
            destination.delegate = self
            if let cell = sender as? UITableViewCell {
                if let index = tableView.indexPath(for: cell)?.row {
                    destination.selectedItem = products[index]
                }
            }
        }
    }
    
    @IBAction func unwindToNoteTVC(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
        saveProduct()
        loadProducts()
        tableView.setEditing(false, animated: true)
    }
}

//MARK: - search bar delegate methods
extension productFiles: UISearchBarDelegate {
    /// search button on keypad functionality
    /// - Parameter searchBar: search bar is passed to this function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // add predicate
        let predicate = NSPredicate(format: "productName  CONTAINS[cd] %@", searchBar.text! )
        loadProducts(predicate: predicate )
    }
    
    
    /// when the text in text bar is changed
    /// - Parameters:
    ///   - searchBar: search bar is passed to this function
    ///   - searchText: the text that is written in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadProducts()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    func save(productId: String,productName: String,productDescription: String,productPrice: String,productProvider: String)
        {
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
        let dataProduct = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
       dataProduct.setValue(productId, forKeyPath: "productID")

       dataProduct.setValue(productName, forKeyPath: "productName")
       dataProduct.setValue(productDescription, forKeyPath: "productDescription")
       dataProduct.setValue(productPrice, forKeyPath: "productPrice")
       dataProduct.setValue(productProvider, forKeyPath: "productProvider")

        do {
            products = try context.fetch(request)
            try managedContext.save()
        } catch let error as NSError {
        }
        tableView.reloadData()
    }
    
     // prepopulate the data
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
            
            let data1 = NSManagedObject(entity: entity,
                                          insertInto: managedContext)
            
      data1.setValue("201",forKeyPath: "productID")
      data1.setValue("Fans", forKeyPath: "productName")
      data1.setValue("ceiling and table fans", forKeyPath: "productDescription")
      data1.setValue("$190", forKeyPath: "productPrice")
      data1.setValue("Mary", forKeyPath: "productProvider")
        
            let data2 = NSManagedObject(entity: entity,
                                          insertInto: managedContext)
            
      data2.setValue("202",forKeyPath: "productID")
      data2.setValue("goggle", forKeyPath: "productName")
      data2.setValue("anti glare ", forKeyPath: "productDescription")
      data2.setValue("$90", forKeyPath: "productPrice")
      data2.setValue("john", forKeyPath: "productProvider")
    
            self.save(productId: "300",productName: "mac",productDescription: "company good",productPrice: "$234",productProvider: "methew")
            self.save(productId: "301",productName: "Clothes",productDescription: "t-shirts , shirts",productPrice: "$500",productProvider: "seema")
            self.save(productId: "302",productName: "bottles",productDescription: "water bottles",productPrice: "$60",productProvider: "neha")
            self.save(productId: "303",productName: "laptop",productDescription: "Macbook , Hp",productPrice: "$2000",productProvider: "ginni")
          
    }
    

}

