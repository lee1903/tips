//
//  ViewController.swift
//  tips
//
//  Created by Brian Lee on 12/11/15.
//  Copyright © 2015 Brian Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    
    //creates IBOutlets for views, labels, fields etc
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var billField: CustomTextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var costLabel: UITextField!
    @IBOutlet weak var gestureView: UIView!


    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var calculatorLabel: UITextField!
    
    @IBOutlet weak var totalTwoLabel: UILabel!
    @IBOutlet weak var totalThreeLabel: UILabel!
    @IBOutlet weak var totalFourLabel: UILabel!
    
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var billView: UIView!
    @IBOutlet weak var tipView: UIView!
    
    var firstLoad = true//variable for whether to first stage is loaded or not
    var currency = "$$"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTip = defaults.integerForKey("Default Tip")
        tipControl.selectedSegmentIndex = defaultTip//sets tip control to default tip in settings
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()//retrieves default currency from user settings
        currency = formatter.currencySymbol
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.delegate = self
        
        initialStage()//loads initial stage
        
        //adds gesture listeners to my view for gesture commands; on top of bill field
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.gestureView.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.gestureView.addGestureRecognizer(swipeUp)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "respondToTapGesture:")
        tapGesture.numberOfTapsRequired = 1
        self.gestureView.addGestureRecognizer(tapGesture)
        
        self.billField.becomeFirstResponder()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTip = defaults.integerForKey("Default Tip")
        tipControl.selectedSegmentIndex = defaultTip
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            //sets stage accordingly when swipe up or down
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Down:
                if(!firstLoad){
                    returnfirstStage()
                }
            case UISwipeGestureRecognizerDirection.Up:
                if(firstLoad){
                    secondStage()
                }
            default:
                break
            }
        }
    }
    
    func respondToTapGesture(gesture: UIGestureRecognizer){
        self.billField.becomeFirstResponder()//tapping on gesture view (esentially tapping bill field) loads keyboard
    }
    
    func initialStage(){
        //sets values and animations for initial stage
        self.tipView.alpha = 0
        self.costLabel.alpha = 0
        self.titleLabel.alpha = 1
        self.calculatorLabel.alpha = 1
        
        self.calculatorView.frame.origin.y = self.calculatorView.frame.origin.y + 300
        self.titleLabel.frame.origin.y = self.titleLabel.frame.origin.y + 550
        self.calculatorLabel.frame.origin.y = self.calculatorLabel.frame.origin.y + 450
        UIView.animateWithDuration(0.5, animations: {
            self.titleLabel.frame.origin.y = self.titleLabel.frame.origin.y - 550
            self.calculatorLabel.frame.origin.y = self.calculatorLabel.frame.origin.y - 450
            self.calculatorView.frame.origin.y = self.calculatorView.frame.origin.y - 300
        })
    }
    
    func returnfirstStage(){
        //sets values and animations for when returning to first stage from second stage
        resetFields()
        firstLoad = true
        view.endEditing(true)
        billField.becomeFirstResponder()
        UIView.animateWithDuration(0.4, animations: {
            self.billField.text = "\(self.currency)0.00"
            self.costLabel.alpha = 0
            self.titleLabel.frame.origin.y = self.titleLabel.frame.origin.y + 300
            self.calculatorLabel.frame.origin.y = self.calculatorLabel.frame.origin.y + 300
            self.titleLabel.alpha = 1
            self.calculatorLabel.alpha = 1
            self.calculatorView.frame.origin.y = self.calculatorView.frame.origin.y + 170
            self.tipView.alpha = 0
        })
    }
    
    func secondStage(){
        //sets values and animations for when transitioning to second stage
        firstLoad = false
        UIView.animateWithDuration(0.30, animations: {
            self.titleLabel.frame.origin.y = self.titleLabel.frame.origin.y - 300
            self.calculatorLabel.frame.origin.y = self.calculatorLabel.frame.origin.y - 300
            self.titleLabel.alpha = 0
            self.calculatorLabel.alpha = 0
            self.calculatorView.frame.origin.y = self.calculatorView.frame.origin.y - 170
        })
        UIView.animateWithDuration(0.4, animations: {
            self.tipView.alpha = 1
            self.costLabel.alpha = 1
        })
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //uses delegate to restrict how many digits in the bill field
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        if newLength < 1{
            return false
        }
        return newLength <= 8
    }
    
    func resetFields(){
        //resets all fields
        let billAmount = 0.0
        
        let tip = 0.0
        let total = billAmount + tip
        
        tipLabel.text = String(format: "\(self.currency)%.2f", tip)
        totalLabel.text = String(format: "\(self.currency)%.2f", total)
        totalTwoLabel.text = String(format: "\(self.currency)%.2f", total/2)
        totalThreeLabel.text = String(format: "\(self.currency)%.2f", total/3)
        totalFourLabel.text = String(format: "\(self.currency)%.2f", total/4)
    }
    
    func currencyMask(d: Double) -> Double{
        //cleans user input, forces into the format $0.00
        var str = ""
        if(d > 9 && d < 100){
            let i:Int = Int(d)
            str = "\(self.currency)0.\(i)"
        }
        else if(d < 10 && d >= 0){
            let i:Int = Int(d)
            str = "\(self.currency)0.0\(i)"
        }
        else{
            var i:Int = Int(d)
            let a = i % 10
            i = i / 10
            let b = i % 10
            i = i / 10
            str = "\(self.currency)\(i).\(b)\(a)"
        }
        billField.text = str
        return NSString(string:(str as NSString).substringFromIndex(1)).doubleValue
    }
    
    func valueOfBillField() -> Int{
        //retrieves the value of the bill field with disregard to decimals
        let rawInput = NSString(string:billField.text!)
        var cleanInput = NSString(string:rawInput.substringFromIndex(1))
        cleanInput = cleanInput.stringByReplacingOccurrencesOfString(".", withString: "")
        let intValue = cleanInput.integerValue
        return intValue
    }
    
    @IBAction func beginEdit(sender: AnyObject) {
        //when beginning to edit, if first stage loaded, reset bill field
        if firstLoad{
            billField.text = "\(self.currency)0.00"
        }
    }
    
    @IBAction func tipSelectorValueChanged(sender: AnyObject) {
        //when clicking on tip selector, hides keyboard
        view.endEditing(true)
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        if firstLoad && (valueOfBillField() != 0){
            secondStage()//loads second stage when user inputs numbers in first stage
        }
        let tipPercentages = [0.10, 0.15, 0.2, 0.25]//sets tip percentages
        let tipPercent = tipPercentages[tipControl.selectedSegmentIndex]
        
        let rawInput = NSString(string:billField.text!)
        var cleanInput = NSString(string:rawInput.substringFromIndex(1))
        cleanInput = cleanInput.stringByReplacingOccurrencesOfString(".", withString: "")
        let doubleInput = cleanInput.doubleValue
            
        let billAmount = currencyMask(doubleInput)
            
        let tip = billAmount * tipPercent
        let total = billAmount + tip
        
        //loads all labels
        tipLabel.text = String(format: "\(self.currency)%.2f", tip)
        totalLabel.text = String(format: "\(self.currency)%.2f", total)
        totalTwoLabel.text = String(format: "\(self.currency)%.2f", total/2)
        totalThreeLabel.text = String(format: "\(self.currency)%.2f", total/3)
        totalFourLabel.text = String(format: "\(self.currency)%.2f", total/4)
    }

    @IBAction func onTap(sender: AnyObject) {
        if !firstLoad{
            //tapping outside bill field hides keyboard
            view.endEditing(true)
        }
    }
}

