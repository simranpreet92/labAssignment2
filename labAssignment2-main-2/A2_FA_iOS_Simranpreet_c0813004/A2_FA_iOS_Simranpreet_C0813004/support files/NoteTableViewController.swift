//
//  NoteTableViewController.swift
//  NoteFolder App Demo
//
//  Created by Mohammad Kiani on 2020-06-20.
//  Copyright © 2020 mohammadkiani. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController {

    @IBOutlet weak var trashBtn: UIBarButtonItem!
    @IBOutlet weak var moveToBtn: UIBarButtonItem!
    
    var products = [ProductDetail]()
    var selectedFolder: Product? {
        didSet {
            loadNotes()
        }
    }
    
    var editMode: Bool = false
    
    // create a context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSearchBar()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //MARK: - view will appear
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        let note = products[indexPath.row]
        cell.textLabel?.text = note.productDescription
        cell.textLabel?.text = note.productID
        cell.textLabel?.text = note.productName
        cell.textLabel?.text = note.productPrice
        cell.textLabel?.text = note.productProvider
        let backgroundView = UIView()
        backgroundView.backgroundColor = .darkGray
        cell.selectedBackgroundView = backgroundView
        
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
            
            deleteNote(note: products[indexPath.row])
            saveNotes()
            products.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //MARK: - Action methods
    
    @IBAction func deleteNotes(_ sender: UIBarButtonItem) {
        
        if let indexPaths = tableView.indexPathsForSelectedRows {
            let rows = (indexPaths.map {$0.row}).sorted(by: >)
            
            let _ = rows.map {deleteNote(note: products[$0])}
            let _ = rows.map {products.remove(at: $0)}
            
            tableView.reloadData()
            
            saveNotes()
        }
    }
    
    @IBAction func editModePressed(_ sender: UIBarButtonItem) {
        
        editMode = !editMode
        
        tableView.setEditing(editMode ? true : false, animated: true)
        
        trashBtn.isEnabled = !trashBtn.isEnabled
        moveToBtn.isEnabled = !moveToBtn.isEnabled
    }
    
    //MARK: - data manipulation core data
    
    func loadNotes(with request: NSFetchRequest<ProductDetail> = ProductDetail.fetchRequest(), predicate: NSPredicate? = nil) {
//        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let folderPredicate = NSPredicate(format: "parentFolder.name=%@", selectedFolder!.name!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [folderPredicate, addtionalPredicate])
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
    
    
    func deleteNote(note: ProductDetail) {
        context.delete(note)
    }
    
    func saveNotes() {
        do {
            try context.save()
        } catch {
            print("Error saving the context \(error.localizedDescription)")
        }
    }
    
    //MARK: - update note
    func updateNote(with description: String , with ID: String, with name: String, with price: String, with provider: String) {
        products = []
        let newNote = ProductDetail(context: context)
        newNote.productDescription = description
        newNote.productID = ID
        newNote.productName = name
        newNote.productPrice = price
        newNote.productProvider = provider
        newNote.parentFolder = selectedFolder
//        notes.append(newNote)
        saveNotes()
        loadNotes()
    }

    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier != "moveNoteSegue" else {
            return true
        }
        return editMode ? false : true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? NoteViewController {
            destination.delegate = self
            
            if let cell = sender as? UITableViewCell {
                if let index = tableView.indexPath(for: cell)?.row {
                    destination.selectedNote = products[index]
                }
            }
        }
        
        if let destination = segue.destination as? MoveToViewController {
            if let indexPaths = tableView.indexPathsForSelectedRows {
                let rows = indexPaths.map {$0.row}
                destination.selectedNotes = rows.map {products[$0]}
            }
        }
    }
    
    //MARK: - unwind segue
    @IBAction func unwindToNoteTableVC(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        saveNotes()
        loadNotes()
        tableView.setEditing(false, animated: false)
    }
    
    //MARK: - show search bar
    func showSearchBar() {
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Product"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.searchBar.searchTextField.textColor = .white
    }
    

}

extension NoteTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                
//        let request : NSFetchRequest<Note> = Note.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadNotes(with: request, predicate: predicate)
        loadNotes(predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadNotes()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
          
        }
    }
}
