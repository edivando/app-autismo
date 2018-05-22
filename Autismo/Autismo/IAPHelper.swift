//
//  IAPHelper.swift
//  Autismo
//
//  Created by Flávio Tabosa on 11/23/15.
//  Copyright © 2015 J7ss. All rights reserved.
//

import UIKit
import StoreKit



class IAPHelper: NSObject,SKProductsRequestDelegate,SKPaymentTransactionObserver {
    
    
    typealias WillSet = (currentValue:String?,tobeValue:String?)->()
    typealias DidSet = (oldValue:Set<String>?,currentValue:Set<String>?)->()
    
    
    
    let IAPHelperProductPurchasedNotification = "IAPHelperProductPurchasedNotification"
    
    var productsRequest:SKProductsRequest!
    var productIdentifiers: Set<String>!
    
    
    var products:[SKProduct]!
    
    var purchasedProductsObservers:[String:DidSet] = [String:DidSet]()
    
    var purchasedProductIdentifiers: Set<String>! = nil{
        
        didSet{
            for (_,observer) in purchasedProductsObservers{
                
                observer(oldValue: oldValue,currentValue: purchasedProductIdentifiers)
            }
        }
    }
    
    
    class var sharedInstance: IAPHelper {
        struct Static {
            static var instance: IAPHelper?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = IAPHelper()
        }
        
        return Static.instance!
    }
    
    
    
    
    override init(){
        super.init()
        self.productIdentifiers = Set<String>()
        for i in 1...10{
            self.productIdentifiers.insert("com.bepid.Autismo.Donation\(i)")
        }
        
        // Check for previously purchased products
        self.purchasedProductIdentifiers = Set<String>()
        
        self.startRequest()
        for productIdentifier in productIdentifiers{
            //print("nao comprou \(productIdentifier)")
        }
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    func checkIfBought(productIdentifier:String)->Bool{
        return  NSUserDefaults.standardUserDefaults().boolForKey(productIdentifier as String)
        
    }
    
    
    func restoreCompletedTransactions(){
        
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
        
    }
    
    
    func startRequest(){
        
        let p = self.productIdentifiers as Set<NSObject>
        //print("\(p.count)  \(p.first!)")
        self.productsRequest = SKProductsRequest(productIdentifiers: self.productIdentifiers)
        
        
        self.productsRequest.delegate = self
        productsRequest.start()
        
    }
    
    func buyProductWithIdentifier(identifier:String){
        for product in products{
            if product.productIdentifier == identifier{
                buyProduct(product)
            }
        }
    }
    
    
    func buyProduct(product:SKProduct){
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
        
        
    }
    
    func productPurchased(productIdentifier:String)->Bool{
        return self.purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    
    func provideContentForproductIdentifier(productIdentifier:String){
        //HERE Probably not set Bool true
        self.purchasedProductIdentifiers.insert(productIdentifier)
//        NSUserDefaults.standardUserDefaults().setBool(true, forKey: productIdentifier)
//        NSUserDefaults.standardUserDefaults().synchronize()
        //NSNotificationCenter.defaultCenter().postNotificationName(IAPHelperProductPurchasedNotification, object: productIdentifier, userInfo: nil)
        
        
    }
    
    //MARK: SKProductsRequest delegate methods
    
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        
        productsRequest = nil
        
    }
    //br.com.$(PRODUCT_NAME:rfc1034identifier)
    
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        productsRequest = nil
        
        let skProducts = response.products
        
        if skProducts.count > 0{
            
            self.products = response.products
            
        }
        
        for skProduct in skProducts {
            
            //print("\(skProduct.productIdentifier) \(skProduct.localizedTitle) \(skProduct.price.floatValue)")
        }
        
        
    }
    
    //MARK: TransactionObserver methods
    
    
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState
            {
            case .Purchased:
                //self.completeTransaction(transaction);
                self.completeTransation(transaction)
                break
            case .Failed:
                //[self failedTransaction:transaction];
                self.failedTransation(transaction)
                break
            case .Restored:
                //[self restoreTransaction:transaction];
                self.restoreTransation(transaction)
                break
            default:
                break
            }
        }
    }
    
    func completeTransation(transaction:SKPaymentTransaction){
        
        self.provideContentForproductIdentifier(transaction.payment.productIdentifier)
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    func failedTransation(transaction:SKPaymentTransaction){
        if let error = transaction.error{
            if (error.code != SKErrorPaymentCancelled)
            {
                //print("Transaction error: \(error.localizedDescription)")
            }
            
        }
        
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    func restoreTransation(transaction:SKPaymentTransaction){
        
        if let identifier = self.productIdentifiers.first as String?{
            if transaction.payment.productIdentifier == identifier{
                self.provideContentForproductIdentifier(transaction.payment.productIdentifier)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            }
        }
        
        
        
        
        
    }
    
    
}