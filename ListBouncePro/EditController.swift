//
//  EditController.swift
//  ListBouncePro
//
//  Created by Phuah Yee Keat on 05/05/2023.
//

import Foundation
import UIKit

class EditController : UIViewController {

	// closure for edited and new
	var updateThis: ((String, IndexPath?) -> ())?
	
	// closure for delete record
	var deleteThis: ((IndexPath?) -> ())?
	
	// this will hold the selected item's indexPath, or
	//	nil if it's a "+" new item
	// will be passed back in the closures
	var shoppingIndexPath: IndexPath?
	
	// the shopping.item string, instead of passing a copy of the item
	var shoppingString: String = ""

    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
	
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(save))
        
        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancel))
        
        navigationItem.leftBarButtonItems = [cancelButton]
        navigationItem.rightBarButtonItems = [saveButton]
        
		textField.text = shoppingString
    }
    
    @objc func save() {
		updateThis?(textField.text ?? "", shoppingIndexPath)
    }

	@IBAction func deleteShopping(_ sender: Any) {
		deleteThis?(shoppingIndexPath)
	}

    @objc func cancel() {
		// *could* also use a closure here for consistency,
		//	but not really needed
		//	(note that dragging down the presented controller also dismisses it as a "cancel" action)
        dismiss(animated: true)
    }
    
}
