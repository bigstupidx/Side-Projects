//
//  InAppPurchaseManager.h
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-18.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *removeAdsProduct;
    SKProductsRequest *productsRequest;
	BOOL storeDoneLoading;
}

+(InAppPurchaseManager *)sharedInAppManager;


- (void)requestAppStoreProductData;
- (void)loadStore;
- (BOOL)storeLoaded;
- (BOOL)canMakePurchases;
- (void)purchaseRemoveAds;
- (void)restoreCompletedTransactions;
- (SKProduct *)getRemoveAdsProduct;

@end

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end