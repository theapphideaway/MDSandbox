//
//  DetailViewController.swift
//  MDSandbox
//
//  Created by ian schoenrock on 9/29/18.
//  Copyright © 2018 ian schoenrock. All rights reserved.
//


//Todo: Add scrolling functionality so the keyboard doesnt cover the the text

import UIKit
import AVFoundation

class DetailViewController: UIViewController, UITextViewDelegate, AVAudioPlayerDelegate{

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var noteTextFeild: UITextView!
    
    
    var masterViewController: MasterViewController?
    var isBullet: Bool = false
    var isList: Bool = false
    var counter: Int = 1
    var myChar: String?
    var audioPlayer: AVAudioPlayer!
    var selectSoundFileName: String?
    
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

        if !isList{
            counter = 1
        }
        
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
        
        if let newPosition = noteTextFeild.position(from: (noteTextFeild.selectedTextRange?.start)!, offset: -1){
            let range = noteTextFeild.textRange(from: newPosition, to: (noteTextFeild.selectedTextRange?.start)!)
            let character = noteTextFeild.text(in: range!)
            myChar = character
        }
        
        if myChar == "\n"{
            selectSoundFileName = "typewriterBell"
            
            
            playSound()
        } else if myChar != "\n"{
            selectSoundFileName = "typeKey"
            
            playSound()
        }
        
        if(myChar! == "\n" && isBullet && !isList){
            
            noteTextFeild.insertText("\t• ")
        }
        
        if(myChar! == "\n" && !isBullet && isList){
            
            noteTextFeild.insertText("\t\(counter). ")
            counter += 1
        }
        
    }
    
    
    @IBAction func listButton(_ sender: UIBarButtonItem) {
        
        isList = !isList
        
    }
    
    
    @IBAction func bulletButton(_ sender: UIBarButtonItem) {
        
        isBullet = !isBullet

    }
    
    
    @IBAction func expandButtonPressed(_ sender: Any) {

        if UIApplication.shared.statusBarOrientation != .portrait {
            if splitViewController?.preferredDisplayMode == .primaryHidden{
                splitViewController?.preferredDisplayMode = .allVisible
            } else{
                splitViewController?.preferredDisplayMode = .primaryHidden
            }
        }
        
        
        isBullet = !isBullet

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        noteTextFeild.delegate = self
        
        noteTextFeild.font = UIFont(name: "Courier", size: 25)
        
        noteTextFeild.scrollRangeToVisible(NSMakeRange(0, 0))
        noteTextFeild.isScrollEnabled = true
        
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
    
    func playSound(){
        
        let soundUrl = Bundle.main.url(forResource: selectSoundFileName, withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl!)
        }
        catch{
            print(error)
        }
        
        audioPlayer.play()
    }


}

