//
//  ListController.swift
//  ListBouncePro
//
//  Created by Phuah Yee Keat on 05/05/2023.
//

import Foundation
import UIKit
import CoreData

class ListController : UITableViewController {
    var addButton: UIBarButtonItem!
    var frc : NSFetchedResultsController<Shopping>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(add))
        
        navigationItem.rightBarButtonItems = [addButton]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Shopping> = Shopping.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "item", ascending: true, selector: nil)]
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc?.delegate = self
        
        do {
            try frc?.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc?.sections?[0].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        cell.textLabel?.text = frc?.object(at: indexPath).item
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "edit") {
			// get a reference to the Edit controller
			let controller = (segue.destination as! UINavigationController).topViewController as! EditController
			// if we selected a row
            if let indexPath = tableView.indexPathForSelectedRow {
				controller.shoppingString = frc?.object(at: indexPath).item ?? ""
				controller.shoppingIndexPath = indexPath
                tableView.deselectRow(at: indexPath, animated: false)
            }
			// set Edit controller closures
			
			// this will be called on Save
			controller.updateThis = { [weak self] str, pth in
				guard let self = self else { return }
				// dismiss presented controller before updating core data
				self.dismiss(animated: true, completion: {
					let appDelegate = UIApplication.shared.delegate as! AppDelegate
					let context = appDelegate.persistentContainer.viewContext
					if let ipth = pth {
						// if we have an indexPath, we're updating an existing record
						let shopping = self.frc?.object(at: ipth)
						shopping?.item = str
					} else {
						// no indexPath, so "+" new record
						let newItem = Shopping(context: context)
						newItem.item = str
					}
					appDelegate.saveContext()
				})
			}
			
			// this will be called on Delete
			controller.deleteThis = { [weak self] pth in
				guard let self = self else { return }
				// dismiss presented controller before updating core data
				self.dismiss(animated: true, completion: {
					let appDelegate = UIApplication.shared.delegate as! AppDelegate
					let context = appDelegate.persistentContainer.viewContext
					// make sure we have a valid indexPath
					if let ipth = pth {
						let shopping = self.frc?.object(at: ipth)
						if let shopping = shopping {
							context.delete(shopping)
						}
					}
					appDelegate.saveContext()
				})
			}
        }
    }
    
    @objc func add() {
        performSegue(withIdentifier: "edit", sender: nil)
    }
}

extension ListController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
		// so we can easily switch between table view row animation to see the differences
		var anim: UITableView.RowAnimation = .fade
		// for example:
		//anim = .none
		
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: anim)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: anim)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: anim)
        case .move:
            self.tableView.deleteRows(at: [indexPath!], with: anim)
            self.tableView.insertRows(at: [newIndexPath!], with: anim)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
