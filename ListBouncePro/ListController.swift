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
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! EditController
                controller.isNew = false
                controller.shopping = frc?.object(at: indexPath)
                tableView.deselectRow(at: indexPath, animated: false)
            } else {
                let controller = (segue.destination as! UINavigationController).topViewController as! EditController
                controller.isNew = true
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
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
