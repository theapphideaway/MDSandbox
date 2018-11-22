//
//  DetailViewController.swift
//  MDSandbox
//
//  Created by ian schoenrock on 9/29/18.
//  Copyright © 2018 ian schoenrock. All rights reserved.
//


//Todo: backspace fully with list enabled

import UIKit
import AVFoundation

class DetailViewController: UIViewController, UITextViewDelegate, AVAudioPlayerDelegate{

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var noteTextFeild: NoteTextView!
    
    
    var masterViewController: MasterViewController?
    var model: DetailModel?
    var isBullet: Bool = false
    var isList: Bool = false
    var counter: Int = 1
    var addedChar: String?
    var deletedChar: String?
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
        
        
        //***********************************************************************************************
        if UIDevice.current.userInterfaceIdiom == .pad{
    
        let masterController = splitViewController?.viewControllers[0] as? UINavigationController
        let tableController = masterController?.visibleViewController as? UITableViewController
        let tableView: UITableView? = tableController?.tableView
        tableView?.reloadData()
            
        } else{
            masterViewController?.tableView.reloadData()
        }
        
        //***********************************************************************************************
        
        
        
        
        //***********************************************************************************************
        
        if let forwardPosition = noteTextFeild.position(from: (noteTextFeild.selectedTextRange?.start)!, offset: -1){
            let range = noteTextFeild.textRange(from: forwardPosition, to: (noteTextFeild.selectedTextRange?.start)!)
            let character = noteTextFeild.text(in: range!)
            addedChar = character
        }
        
        
//        if let backwardPosition = noteTextFeild.position(from: (noteTextFeild.selectedTextRange?.start)!, offset:0){
//            let range = noteTextFeild.textRange(from: backwardPosition, to: (noteTextFeild.selectedTextRange?.start)!)
//            let character = noteTextFeild.text(in: range!)
//            deletedChar = character
//        }
        
        
        
        print(" Detail Deleted Char: \(GlobalDeletedChar)")
        
        
        
        if GlobalDeletedChar != "\t"
        {
        
        if addedChar == "\n"{
            selectSoundFileName = "typewriterBell"
            
            
            playSound()
        } else if addedChar != "\n"{
            selectSoundFileName = "typeKey"
            
            playSound()
        }
        
        if(addedChar! == "\n" && isBullet && !isList){
            
            noteTextFeild.insertText("\t• ")
        }
        
        if(addedChar! == "\n" && !isBullet && isList){
            
            noteTextFeild.insertText("\t\(counter). ")
            counter += 1
        }
        
        print("Added Char\(addedChar)")
        
        //***********************************************************************************************
        }
        
    }
    
    
    @IBAction func listButton(_ sender: UIBarButtonItem) {
        
        if !isBullet{
            isList = !isList
        }
        
        
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



