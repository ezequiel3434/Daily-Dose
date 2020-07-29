//
//  ViewController.swift
//  Daily-Dose
//
//  Created by Ezequiel Parada Beltran on 27/07/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }


}

