//
//  InAppPurchaseManager.h
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-18.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "Globals.h"

extern BOOL AXE_PURCHASE_GETRESULT;
extern BOOL HAMMER_PURCHASE_GETRESULT;
extern BOOL CHAINSAW_PURCHASE_GETRESULT;
extern BOOL MACHINEGUN_PURCHASE_GETRESULT;
extern BOOL LASER_PURCHASE_GETRESULT;
extern BOOL EVERYTHING_PURCHASE_GETRESULT;

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{    
    SKProduct *purchaseAxe; //Meng added
    SKProduct *purchaseHammer; //Meng added
    SKProduct *purchaseChainsaw; //Meng added
    SKProduct *purchaseMachinegun; //Meng added
    SKProduct *purchaseLaser; //Meng added
    SKProduct *purchaseEverything; //Meng added

    SKProductsRequest *axeRequest; //Meng added
    SKProductsRequest *hammerRequest; //Meng added
    SKProductsRequest *chainsawRequest; //Meng added
    SKProductsRequest *machinegunRequest; //Meng added
    SKProductsRequest *laserRequest; //Meng added
    SKProductsRequest *allWeaponRequest; //Meng added
    
	BOOL storeDoneLoading_Axe; //Meng added
	BOOL storeDoneLoading_Hammer; //Meng added
	BOOL storeDoneLoading_Chainsaw; //Meng added
	BOOL storeDoneLoading_Machinegun; //Meng added
	BOOL storeDoneLoading_Laser; //Meng added
	BOOL storeDoneLoading_AllWeapon; //Meng added
}

+(InAppPurchaseManager *)sharedInAppManager;

- (void)requestAppStoreProductData_axe; //Meng added
- (void)requestAppStoreProductData_hammer; //Meng added
- (void)requestAppStoreProductData_chainsaw; //Meng added
- (void)requestAppStoreProductData_machinegun; //Meng added
- (void)requestAppStoreProductData_laser; //Meng added
- (void)requestAppStoreProductData_AllWeapon; //Meng added


- (void)loadStore_Axe; //Meng added
- (void)loadStore_Hammer; //Meng added
- (void)loadStore_Chainsaw; //Meng added
- (void)loadStore_Machinegun; //Meng added
- (void)loadStore_Laser; //Meng added
- (void)loadStore_AllWeapon; //Meng added


- (BOOL)storeLoaded_Axe; //Meng added
- (BOOL)storeLoaded_Hammer; //Meng added
- (BOOL)storeLoaded_Chainsaw; //Meng added
- (BOOL)storeLoaded_Machinegun; //Meng added
- (BOOL)storeLoaded_Laser; //Meng added
- (BOOL)storeLoaded_AllWeapon; //Meng added


- (BOOL)canMakePurchases;

- (void)purchaseAxe; //Meng added
- (void)purchaseHammer; //Meng added
- (void)purchaseChainsaw; //Meng added
- (void)purchaseMachinegun; //Meng added
- (void)purchaseLaser; //Meng added
- (void)purchaseEverything; //Meng added


- (void)restoreCompletedTransactions;


- (SKProduct *)getPurchaseAxe; //Meng added
- (SKProduct *)getPurchaseHammer; //Meng added
- (SKProduct *)getPurchaseChainsaw; //Meng added
- (SKProduct *)getPurchaseMachinegun; //Meng added
- (SKProduct *)getPurchaseLaser; //Meng added
- (SKProduct *)getPurchaseEverything; //Meng added


@end

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end