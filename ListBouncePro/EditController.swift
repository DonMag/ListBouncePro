//
//  EditController.swift
//  ListBouncePro
//
//  Created by Phuah Yee Keat on 05/05/2023.
//

import Foundation
import UIKit

class EditController : UIViewController {
    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    var shopping: Shopping!
    var isNew: Bool = false

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(save))
        
        cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancel))
        
        navigationItem.leftBarButtonItems = [cancelButton]
        navigationItem.rightBarButtonItems = [saveButton]
        
        textField.text = shopping.item
    }
    
    @objc func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if (isNew) {
            let newItem = Shopping(context: context)
            newItem.item = textField.text
        } else {
            shopping.item = textField.text
        }
      
        appDelegate.saveContext()
        dismiss(animated: true)
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @IBAction func deleteShopping(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(shopping)
        appDelegate.saveContext()
        
        dismiss(animated: true)
    }
}
