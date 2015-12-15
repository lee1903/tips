//
//  MyTextField.swift
//  tips
//
//  Created by Brian Lee on 12/12/15.
//  Copyright © 2015 Brian Lee. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    //creates subclass of UITextfield that hides cursor and disables copy and paste
    override func caretRectForPosition(position: UITextPosition) -> CGRect{
        return CGRect.zero
    }
    
    override func selectionRectsForRange(range: UITextRange) -> [AnyObject]{
        return []
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        // Disable copy, select all, paste
        if action == Selector("copy:") || action == Selector("selectAll:") || action == Selector("paste:") {
            return false
        }
        // Default
        return super.canPerformAction(action, withSender: sender)
    }
}
