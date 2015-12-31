//
//  ViewController.swift
//  时间选择
//
//  Created by Chakery on 15/12/30.
//  Copyright © 2015年 Chakery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ChoiceTimeViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func pushClickEvent(sender: AnyObject) {
        let vc = ChoiceTimeView()
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
    }

    func timeDidSelected(time: NSDate, timeLong: Double) {
        print(time)
        print(timeLong)
    }
}

