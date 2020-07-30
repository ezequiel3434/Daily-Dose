//
//  PurchaseManager.swift
//  Daily-Dose
//
//  Created by Ezequiel Parada Beltran on 29/07/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

typealias CompletionHandler = (_ success: Bool) -> ()


import Foundation
import StoreKit

class PurchaseManager: NSObject {
    static let instance = PurchaseManager()
    let IAP_REMOVE_ADS = "com.paradabeltran.daily.dose.remove.ads"
    
    var productsRequest: SKProductsRequest!
    var products = [SKProduct]()
    var transactionComplete: CompletionHandler?

    func fetchProducts(){
        let productIDs = NSSet(object: IAP_REMOVE_ADS) as! Set<String>
        productsRequest = SKProductsRequest(productIdentifiers: productIDs)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchaseRemoveAds( onComplete: @escaping CompletionHandler ){
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = onComplete
            let removeAdsProduct = products[0]
            let payment = SKPayment(product: removeAdsProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else  {
            onComplete(false)
        }
    }
    
    
    func restorePurchases( onComplete: @escaping CompletionHandler ){
        
        if SKPaymentQueue.canMakePayments() {
            transactionComplete = onComplete
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            onComplete(false)
        }
    
    }
    
}

extension PurchaseManager: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            print(response.products.debugDescription)
            products = response.products
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transsaction in transactions {
            switch transsaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transsaction)
                if transsaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    transactionComplete?(true)
                }
                
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transsaction)
                transactionComplete?(false)
                break
            case .restored:
               

                SKPaymentQueue.default().finishTransaction(transsaction)
                if transsaction.payment.productIdentifier == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    
                }
                
                 transactionComplete?(true)
                break
            default:
                transactionComplete?(false)
                break
            }
        }
    }
    
    
}
