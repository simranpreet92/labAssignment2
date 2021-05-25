//Simranpreet kaur
import UIKit

class productDetail: UIViewController {

    @IBOutlet weak var pID: UITextView!
    
    @IBOutlet weak var pProvider: UITextView!
    @IBOutlet weak var pPrice: UITextView!
    @IBOutlet weak var pDescription: UITextView!
    @IBOutlet weak var pName: UITextView!
    var selectedNote: ProductDetail? {
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
        pID.text = selectedNote?.productID
        pName.text = selectedNote?.productName
        pDescription.text = selectedNote?.productDescription
        pPrice.text = selectedNote?.productPrice
        pProvider.text = selectedNote?.productProvider
        view.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if editMode {
            delegate!.deleteProduct(note: selectedNote!)
        }
        guard pID.text != "" else {return}
        delegate!.updateProduct(with: pID.text , with: pName.text , with: pDescription.text , with: pPrice.text, with: pProvider.text )
    }

}
