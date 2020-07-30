//
//  ViewController.swift
//  Daily-Dose
//
//  Created by Ezequiel Parada Beltran on 27/07/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeVC: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var removeAdsBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpAds()
        
        
        
        
        
        
        
    }
    @IBAction func restoreBtnPressed(_ sender: Any) {
        
        PurchaseManager.instance.restorePurchases { (success) in
            if success {
                self.setUpAds()
            }
        }
        
    }
    
    @IBAction func removedAdsPressed(_ sender: Any) {
        // show a loading spinner Activity indicator
        PurchaseManager.instance.purchaseRemoveAds { success in
            // dissmis spinner
            if success {
                self.bannerView.removeFromSuperview()
                self.removeAdsBtn.removeFromSuperview()
            } else {
                // show message to the user
            }
        }
    }
    
    
    func setUpAds() {
        if UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_REMOVE_ADS) {
            removeAdsBtn.removeFromSuperview()
            bannerView.removeFromSuperview()
        } else {
            
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
    }
    
}

