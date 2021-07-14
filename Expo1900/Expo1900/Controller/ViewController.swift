//
//  Expo1900 - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet private weak var mainTitle: UILabel!
    @IBOutlet private weak var mainImage: UIImageView!
    @IBOutlet private weak var mainVisitor: UILabel!
    @IBOutlet private weak var mainLocation: UILabel!
    @IBOutlet private weak var mainDuration: UILabel!
    @IBOutlet private weak var mainDescription: UILabel!
    
    override func viewDidLoad() {
        guard let data = NSDataAsset(name: "exposition_universelle_1900")?.data else { return }
        let decodedData = try? JSONDecoder().decode(ExhibitionExplanation.self, from: data)
        self.mainTitle.text = decodedData?.title
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: decodedData?.visitors ?? 00))!
        self.mainVisitor.text = "방문객 : \(result) 명"
        self.mainLocation.text = "개최지 : \(decodedData?.location ?? "-")"
        self.mainDuration.text = "개최 기간 : \(decodedData?.duration ?? "-")"
        self.mainDescription.text = decodedData?.description
        self.mainImage.image = UIImage(named: "poster")
    }

    
}

