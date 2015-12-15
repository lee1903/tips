//
//  MyTextField.swift
//  tips
//
//  Created by Brian Lee on 12/12/15.
//  Copyright © 2015 Brian Lee. All rights reserved.
//

import Foundation

class MyTextField: UITextField {
    override func caretRectForPosition(position: UITextPosition!) -> CGRect{
        return CGRect.zeroRect
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
