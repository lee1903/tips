//
//  ViewController.swift
//  tips
//
//  Created by Brian Lee on 12/11/15.
//  Copyright © 2015 Brian Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

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
    
    var firstLoad = true
    var currency = "$$"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        let defaultTip = defaults.integerForKey("Default Tip")
        tipControl.selectedSegmentIndex = defaultTip
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        currency = formatter.currencySymbol
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billField.delegate = self
        
        initialStage()
        
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
        self.billField.becomeFirstResponder()
    }
    
    func initialStage(){
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
        let rawInput = NSString(string:billField.text!)
        var cleanInput = NSString(string:rawInput.substringFromIndex(1))
        cleanInput = cleanInput.stringByReplacingOccurrencesOfString(".", withString: "")
        let intValue = cleanInput.integerValue
        return intValue
    }
    
    @IBAction func beginEdit(sender: AnyObject) {
        if firstLoad{
            billField.text = "\(self.currency)0.00"
        }
    }
    
    @IBAction func tipSelectorValueChanged(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        if firstLoad && (valueOfBillField() != 0){
            secondStage()
        }
        let tipPercentages = [0.10, 0.15, 0.2, 0.25]
        let tipPercent = tipPercentages[tipControl.selectedSegmentIndex]
        
        let rawInput = NSString(string:billField.text!)
        var cleanInput = NSString(string:rawInput.substringFromIndex(1))
        cleanInput = cleanInput.stringByReplacingOccurrencesOfString(".", withString: "")
        let doubleInput = cleanInput.doubleValue
            
        let billAmount = currencyMask(doubleInput)
            
        let tip = billAmount * tipPercent
        let total = billAmount + tip
            
        tipLabel.text = String(format: "\(self.currency)%.2f", tip)
        totalLabel.text = String(format: "\(self.currency)%.2f", total)
        totalTwoLabel.text = String(format: "\(self.currency)%.2f", total/2)
        totalThreeLabel.text = String(format: "\(self.currency)%.2f", total/3)
        totalFourLabel.text = String(format: "\(self.currency)%.2f", total/4)
    }

    @IBAction func onTap(sender: AnyObject) {
        if !firstLoad{
            view.endEditing(true)
        }
    }
}

