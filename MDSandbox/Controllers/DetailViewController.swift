//
//  DetailViewController.swift
//  MDSandbox
//
//  Created by ian schoenrock on 9/29/18.
//  Copyright © 2018 ian schoenrock. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var noteTextFeild: UITextView!
    
    
    var masterViewController: MasterViewController?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let note = noteTextFeild {
                note.text = detail.content
                
            }
        }
    }

    
    func textViewDidChange(_ textView: UITextView) {

        
        detailItem?.content = noteTextFeild.text
    
        saveNote()
        
        //let master = self.splitViewController?.viewControllers.first as? MasterViewController
        
        if UIDevice.current.userInterfaceIdiom == .pad{
    
        let masterController = splitViewController?.viewControllers[0] as? UINavigationController
        let tableController = masterController?.visibleViewController as? UITableViewController
        let tableView: UITableView? = tableController?.tableView
        tableView?.reloadData()
            
        } else{
            masterViewController?.tableView.reloadData()
        }
        
        
        
        
//
        //master.reloadMasterData()
    }
   
    
    
    
    @IBAction func expandButtonPressed(_ sender: Any) {

        if UIApplication.shared.statusBarOrientation != .portrait {
            if splitViewController?.preferredDisplayMode == .primaryHidden{
                splitViewController?.preferredDisplayMode = .allVisible
            } else{
                splitViewController?.preferredDisplayMode = .primaryHidden
            }
        }

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        noteTextFeild.delegate = self
        
        //print(fetchedResultsController.object(at: indexPath).content!)
        configureView()
    }

    var detailItem: Note? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    var index: IndexPath?
    var isAdded: Bool?
    
    
    func saveNote(){
        
        
        
        // Save the context.
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        if index != nil && isAdded == true {
        masterViewController!.reloadMasterData()
        }
    }
    
    func updateNote(){
        
    }


}

