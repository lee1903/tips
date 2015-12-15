//
//  SettingsViewController.swift
//  tips
//
//  Created by Brian Lee on 12/11/15.
//  Copyright © 2015 Brian Lee. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()//sets default tip on segmented control
        let defaultTip = defaults.integerForKey("Default Tip")
        defaultTipControl.selectedSegmentIndex = defaultTip
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()//stores default tip into settings
        defaults.setInteger(defaultTipControl.selectedSegmentIndex, forKey: "Default Tip")
        defaults.synchronize()
        self.dismissViewControllerAnimated(true, completion: nil)//dismisses controller
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
