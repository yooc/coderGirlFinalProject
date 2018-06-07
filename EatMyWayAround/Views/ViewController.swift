//
//  ViewController.swift
//  EatMyWayAround
//
//  Created by Courtney Yoo on 5/9/18.
//  Copyright © 2018 Courtney Yoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    @IBAction func searchNearbyButton(_ sender: UIButton) {
//        performSegue(withIdentifier: "searchSegue", sender: sender)
//    }
//
//    @IBAction func myListButton(_ sender: UIButton) {
//        performSegue(withIdentifier: "myListSegue", sender: sender)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Segue: \(segue.identifier)")
    }
}

