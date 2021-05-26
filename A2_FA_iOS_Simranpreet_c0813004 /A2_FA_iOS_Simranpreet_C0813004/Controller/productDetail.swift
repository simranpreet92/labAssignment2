//
//  productDetail.swift
//  A2_FA_iOS_Simranpreet_C0813004
//
//  Created by Simranpreet kaur on 25/05/21.
import UIKit

class productDetail: UIViewController {

    @IBOutlet weak var pID: UITextView!
    
    @IBOutlet weak var pProvider: UITextView!
    @IBOutlet weak var pPrice: UITextView!
    @IBOutlet weak var pDescription: UITextView!
    @IBOutlet weak var pName: UITextView!
    var selectedItem: ProductDetail? {
        didSet {
            editMode = true
        }
    }
    
    // edit mode by default is false
    var editMode: Bool = false
    
    // an  instance of the productFiles in productFiles - delegate
    weak var delegate: productFiles?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pID.backgroundColor = .systemFill
        pName.backgroundColor = .systemFill
        pDescription.backgroundColor = .systemFill
        pPrice.backgroundColor = .systemFill
        pProvider.backgroundColor = .systemFill
        pID.text = selectedItem?.productID
        pName.text = selectedItem?.productName
        pDescription.text = selectedItem?.productDescription
        pPrice.text = selectedItem?.productPrice
        pProvider.text = selectedItem?.productProvider
        view.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if editMode {
            delegate!.deleteProduct(note: selectedItem!)
        }
        guard pID.text != "" else {return}
        delegate!.updateProduct(with: pID.text , with: pName.text , with: pDescription.text , with: pPrice.text, with: pProvider.text )
        guard  pProvider.text != "" else {
            return
        }
        delegate!.updateProduct(with: pID.text , with: pName.text , with: pDescription.text , with: pPrice.text, with: pProvider.text )
    }

}
