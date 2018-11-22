//
//  MasterViewController.swift
//  MDSandbox
//
//  Created by ian schoenrock on 9/29/18.
//  Copyright © 2018 ian schoenrock. All rights reserved.
//

import UIKit
import CoreData


var noteArray = [Note]()

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var myIndex: Int = 0
    var isAddPressed: Bool = false
    var isSelected: Bool = false
    var ShowNextIndexPathRow: Int?
    var object: Note?
    
    static var sharedInstance = MasterViewController()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        loadNote()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        splitViewController!.preferredDisplayMode = .allVisible
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    @IBAction func pleaseAdd(_ sender: UIBarButtonItem) {
        
        isAddPressed = true
        
        let newNote = Note(context: self.context)
        newNote.content = "AddedNew"
    
        noteArray.append(newNote)
        saveNote()
        
        performSegue(withIdentifier: "showDetail", sender: self)
    
        print(newNote.index(ofAccessibilityElement: newNote))
        
    }
    
    
    
    func saveNote(){
        
        // Save the context.
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    
    
    func loadNote(with request: NSFetchRequest<Note> = Note.fetchRequest()){
        
        do{
            noteArray = try context.fetch(request)
        } catch {
            print("Error")
        }
        
        tableView.reloadData()
    }


    
    

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var indexPath: IndexPath?
        
        if segue.identifier == "showDetail" {
        
            
            indexPath = tableView.indexPathForSelectedRow
            
            
            if isAddPressed{
                indexPath = [0, noteArray.count - 1]
                print("Added index path: " + String(indexPath!.row))
            } else if ShowNextIndexPathRow != nil{
                indexPath = [0, ShowNextIndexPathRow!]
            }
            
            if !isAddPressed && ShowNextIndexPathRow == nil {// SELECTED AN ITEM
                object = noteArray[indexPath!.row]
            } else if isAddPressed { // ADDING AN ITEM
                object = noteArray[indexPath!.row]
            } else if isAddPressed && indexPath!.row >= 0{
                object = noteArray[indexPath!.row - 1]
            }
            else{//DELETING AN ITEM but this gert called when you are selecting the first time since idexPath.row is 0
                self.object?.content = "Please select or add an Item"
            }
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.detailItem = object
            controller.index = indexPath
            controller.isAdded = isAddPressed
            controller.masterViewController = MasterViewController.sharedInstance
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            
            //tableView.deselectRow(at: indexPath!, animated: true)
            
            tableView.reloadData()
            
            print(indexPath!.row)
            
        }
        
       isAddPressed = false
       ShowNextIndexPathRow = nil
        isSelected = false
        
    }
    
    

    // MARK: - Table View

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = noteArray[indexPath.row].content
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    
    
    
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(noteArray[indexPath.row ])
            noteArray.remove(at: indexPath.row)
                
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            tableView.reloadData()
            ShowNextIndexPathRow = indexPath.row - 1
            
            if UIDevice.current.userInterfaceIdiom == .pad{
            performSegue(withIdentifier: "showDetail", sender: self)
            }
            
        }
    }
    func reloadMasterData() {
        tableView.reloadData()
    }
   
}

extension UISplitViewController {
    func toggleMasterView() {
        let barButtonItem = self.displayModeButtonItem
        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: nil, for: nil)
    }
}

