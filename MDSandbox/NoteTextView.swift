//
//  NoteTextView.swift
//  MDSandbox
//
//  Created by ian schoenrock on 11/22/18.
//  Copyright © 2018 ian schoenrock. All rights reserved.
//

import UIKit

var GlobalDeletedChar: String?

class NoteTextView: UITextView{
    
    var myChar: String?
    
    
    override public func deleteBackward() {
        
        if let forwardPosition = self.position(from: (self.selectedTextRange?.start)!, offset: -1){
            let range = self.textRange(from: forwardPosition, to: (self.selectedTextRange?.start)!)
            let character = self.text(in: range!)
            GlobalDeletedChar = character
        }
        
        //print(myChar)
        
        //var model = DetailModel(_deletedChar: myChar!)
        
        if GlobalDeletedChar == "\n" {
            print("It Works")
            print("TextView Deleted Char: \(GlobalDeletedChar)")
        }
        // do something for every backspace
        super.deleteBackward()
    }
}
