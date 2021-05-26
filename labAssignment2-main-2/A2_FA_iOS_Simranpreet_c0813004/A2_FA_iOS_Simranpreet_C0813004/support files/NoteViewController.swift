//
//  NoteViewController.swift
//  NoteFolder App Demo
//
//  Created by Mohammad Kiani on 2020-06-20.
//  Copyright © 2020 mohammadkiani. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    var selectedNote: ProductDetail? {
        didSet {
            editMode = true
        }
    }
    
    var editMode: Bool = false
    
    // a delegate for the noteTableVC
    weak var delegate: NoteTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        noteTextView.text = selectedNote?.productID
        noteTextView.text = selectedNote?.productDescription
        noteTextView.text = selectedNote?.productName
        noteTextView.text = selectedNote?.productPrice
        noteTextView.text = selectedNote?.productProvider
        
    }
    
    //MARK: - view will disappar
    override func viewWillDisappear(_ animated: Bool) {
        if editMode {
            delegate!.deleteNote(note: selectedNote!)
        }
        delegate!.updateNote(with: noteTextView.text ,with: noteTextView.text , with: noteTextView.text , with: noteTextView.text , with: noteTextView.text  )
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
