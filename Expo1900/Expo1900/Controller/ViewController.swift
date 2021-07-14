//
//  Expo1900 - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet private weak var mainTitle: UILabel!
    @IBOutlet private weak var mainVisitor: UILabel!
    @IBOutlet private weak var mainLocation: UILabel!
    @IBOutlet private weak var mainDuration: UILabel!
    @IBOutlet private weak var mainDescription: UILabel!
    
    override func viewDidLoad() {
        guard let explanation : NSDataAsset = NSDataAsset(name: "exposition_universelle_1900") else { return }
        
    }

    
}

