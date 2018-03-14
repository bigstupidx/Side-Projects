#import "InAppPurchaseManager.h"
#import "Flurry.h"
#import "Globals.h"

//#import "AdsManager.h"
@implementation InAppPurchaseManager

static InAppPurchaseManager *_sharedInAppManager = nil;

+ (InAppPurchaseManager *)sharedInAppManager
{
	@synchronized([InAppPurchaseManager class])
	{
		if (!_sharedInAppManager)
			[[self alloc] init];
		
		return _sharedInAppManager;
	}
	// to avoid compiler warning
	return nil;
}

+(id)alloc
{
	@synchronized([InAppPurchaseManager class])
	{
		NSAssert(_sharedInAppManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInAppManager = [super alloc];
		return _sharedInAppManager;
	}
	// to avoid compiler warning
	return nil;
}

-(id) init
{
	storeDoneLoading_Axe = NO;
	storeDoneLoading_Hammer = NO;
	storeDoneLoading_Chainsaw = NO;
	storeDoneLoading_Machinegun = NO;
	storeDoneLoading_Laser = NO;
	storeDoneLoading_AllWeapon = NO;
    
	return self;
}

- (void) dealloc
{
    [purchaseAxe release];
	[purchaseHammer release];
	[purchaseChainsaw release];
	[purchaseMachinegun release];
	[purchaseLaser release];
	[purchaseEverything release];
    
	[super dealloc];
}

- (BOOL) storeLoaded_Axe
{
	return storeDoneLoading_Axe;
}

- (BOOL) storeLoaded_Hammer
{
	return storeDoneLoading_Hammer;
}

- (BOOL) storeLoaded_Chainsaw
{
	return storeDoneLoading_Chainsaw;
}

- (BOOL) storeLoaded_Machinegun
{
	return storeDoneLoading_Machinegun;
}

- (BOOL) storeLoaded_Laser
{
	return storeDoneLoading_Laser;
}

- (BOOL) storeLoaded_AllWeapon
{
	return storeDoneLoading_AllWeapon;
}

- (void)requestAppStoreProductData_axe
{
     NSSet * productIdentifiers = [NSSet setWithObjects: INAPPPURCHASE_AXE_ID, nil ];
     axeRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
     axeRequest.delegate = self;
     [axeRequest start];
}


- (void)requestAppStoreProductData_hammer
{
    //Meng: request for hammer
    NSSet * productIdentifiers = [NSSet setWithObjects: INAPPPURCHASE_HAMMER_ID, nil ];
    hammerRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    hammerRequest.delegate = self;
    [hammerRequest start];
}

- (void)requestAppStoreProductData_chainsaw
{
    //Meng: request for chainsaw
    NSSet * productIdentifiers = [NSSet setWithObjects: INAPPPURCHASE_CHAINSAW_ID, nil ];
    chainsawRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    chainsawRequest.delegate = self;
    [chainsawRequest start];
}

- (void)requestAppStoreProductData_machinegun
{
    //Meng: request for machinegun
    NSSet * productIdentifiers = [NSSet setWithObjects: INAPPPURCHASE_MACHINEGUN_ID, nil ];
    machinegunRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    machinegunRequest.delegate = self;
    [machinegunRequest start];
}

- (void)requestAppStoreProductData_laser
{
    //Meng: request for laser
    NSSet * productIdentifiers = [NSSet setWithObjects: INAPPPURCHASE_LASER_ID, nil ];
    laserRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    laserRequest.delegate = self;
    [laserRequest start];
}

- (void)requestAppStoreProductData_AllWeapon
{
    //Meng: request for all weapons
    NSSet * productIdentifiers = [NSSet setWithObjects: INAPPPURCHASE_EVERYTHING_ID, nil ];
    allWeaponRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    allWeaponRequest.delegate = self;
    [allWeaponRequest start];
}

#pragma mark In-App Product Accessor Methods

- (SKProduct *)getPurchaseAxe
{
	return purchaseAxe;
}

- (SKProduct *)getPurchaseHammer
{
	return purchaseHammer;
}

- (SKProduct *)getPurchaseChainsaw
{
	return purchaseChainsaw;
}

- (SKProduct *)getPurchaseMachinegun
{
	return purchaseMachinegun;
}

- (SKProduct *)getPurchaseLaser
{
	return purchaseLaser;
}

- (SKProduct *)getPurchaseEverything
{
	return purchaseEverything;
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
	for (SKProduct *inAppProduct in products)
	{
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_AXE_ID])
        {
			purchaseAxe = [inAppProduct retain];
            storeDoneLoading_Axe = YES;
        }
        
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_HAMMER_ID])
        {
			purchaseHammer = [inAppProduct retain];
            storeDoneLoading_Hammer = YES;
        }
        
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_CHAINSAW_ID])
        {
			purchaseChainsaw = [inAppProduct retain];
            storeDoneLoading_Chainsaw = YES;
        }
        
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_MACHINEGUN_ID])
        {
			purchaseMachinegun = [inAppProduct retain];
            storeDoneLoading_Machinegun = YES;
        }
        
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_LASER_ID])
        {
			purchaseLaser = [inAppProduct retain];
            storeDoneLoading_Laser = YES;
        }
        
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_EVERYTHING_ID])
        {
			purchaseEverything = [inAppProduct retain];
            storeDoneLoading_AllWeapon = YES;
        }
	}
	   
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@\r\n" , invalidProductId);
        
        for (SKProduct *inAppProduct in products)
        {
            if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_AXE_ID])
            {
                storeDoneLoading_Axe = NO;
            }
            
            if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_HAMMER_ID])
            {
                storeDoneLoading_Hammer = NO;
            }
            
            if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_CHAINSAW_ID])
            {
                storeDoneLoading_Chainsaw = NO;
            }
            
            if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_MACHINEGUN_ID])
            {
                storeDoneLoading_Machinegun = NO;
            }
            
            if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_LASER_ID])
            {
                storeDoneLoading_Laser = NO;
            }
            
            if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_EVERYTHING_ID])
            {
                storeDoneLoading_AllWeapon = NO;
            }
        }
    }
    
    // finally release the reqest we alloc/init’ed in requestlevelUpgradeProductData
    
 	for (SKProduct *inAppProduct in products)
	{
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_AXE_ID])
        {
			[axeRequest release];
        }
        
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_HAMMER_ID])
        {
			[hammerRequest release];
        }
        
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_CHAINSAW_ID])
        {
			[chainsawRequest release];
        }
        
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_MACHINEGUN_ID])
        {
			[machinegunRequest release];
        }
        
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_LASER_ID])
        {
			[laserRequest release];
        }
        
        if([inAppProduct.productIdentifier isEqualToString:INAPPPURCHASE_EVERYTHING_ID])
        {
			[allWeaponRequest release];
        }
	}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

//
// call this method once on startup
//

- (void)loadStore_Axe
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestAppStoreProductData_axe];
    
}

- (void)loadStore_Hammer
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestAppStoreProductData_hammer];
    
}

- (void)loadStore_Chainsaw
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestAppStoreProductData_chainsaw];
    
}

- (void)loadStore_Machinegun
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestAppStoreProductData_machinegun];
    
}

- (void)loadStore_Laser
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestAppStoreProductData_laser];
    
}

- (void)loadStore_AllWeapon
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestAppStoreProductData_AllWeapon];
}


//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//

- (void)purchaseAxe{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:INAPPPURCHASE_AXE_ID];
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


- (void)purchaseHammer{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:INAPPPURCHASE_HAMMER_ID];
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseChainsaw{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:INAPPPURCHASE_CHAINSAW_ID];
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseMachinegun{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:INAPPPURCHASE_MACHINEGUN_ID];
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseLaser{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:INAPPPURCHASE_LASER_ID];
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchaseEverything{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:INAPPPURCHASE_EVERYTHING_ID];
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// Restore completed transactions
- (void) restoreCompletedTransactions
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if([transaction.payment.productIdentifier isEqualToString:INAPPPURCHASE_AXE_ID])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"purchaseAxeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if([transaction.payment.productIdentifier isEqualToString:INAPPPURCHASE_HAMMER_ID])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"purchaseHammerTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if([transaction.payment.productIdentifier isEqualToString:INAPPPURCHASE_CHAINSAW_ID])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"purchaseChainsawTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if([transaction.payment.productIdentifier isEqualToString:INAPPPURCHASE_MACHINEGUN_ID])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"purchaseMachinegunTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if([transaction.payment.productIdentifier isEqualToString:INAPPPURCHASE_LASER_ID])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"purchaseLaserTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if([transaction.payment.productIdentifier isEqualToString:INAPPPURCHASE_EVERYTHING_ID])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"purchaseEverythingTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:INAPPPURCHASE_AXE_ID])
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Success!"
                                                         message:@"Axe has been purchased"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
        
        //  [[AdsManager sharedAdsManager] saveAdRemovalStatus]; //Meng: this is not a cocos2d game, so I cannot use AdsManager file.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:true forKey:@"axe purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [Flurry logEvent:@"Purchase Axe"];
    }
    
    if ([productId isEqualToString:INAPPPURCHASE_HAMMER_ID])
    { 
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Success!"
                                                         message:@"Hammer has been purchased"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
        
        //  [[AdsManager sharedAdsManager] saveAdRemovalStatus]; //Meng: this is not a cocos2d game, so I cannot use AdsManager file.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:true forKey:@"hammer purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [Flurry logEvent:@"Purchase Hammer"];
    }
    
    if ([productId isEqualToString:INAPPPURCHASE_CHAINSAW_ID])
    { 
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Success!"
                                                         message:@"Chainsaw has been purchased"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
        
        //  [[AdsManager sharedAdsManager] saveAdRemovalStatus]; //Meng: this is not a cocos2d game, so I cannot use AdsManager file.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:true forKey:@"chainsaw purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [Flurry logEvent:@"Purchase Chainsaw"];
    }
    
    if ([productId isEqualToString:INAPPPURCHASE_MACHINEGUN_ID])
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Success!"
                                                         message:@"Machine gun has been purchased"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
        
        //  [[AdsManager sharedAdsManager] saveAdRemovalStatus]; //Meng: this is not a cocos2d game, so I cannot use AdsManager file.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:true forKey:@"machinegun purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [Flurry logEvent:@"Purchase Machinegun"];
    }
    
    if ([productId isEqualToString:INAPPPURCHASE_LASER_ID])
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Success!"
                                                         message:@"Laser has been purchased"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
        
        //  [[AdsManager sharedAdsManager] saveAdRemovalStatus]; //Meng: this is not a cocos2d game, so I cannot use AdsManager file.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:true forKey:@"laser purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [Flurry logEvent:@"Purchase Laser"];
    }
    
    
    if ([productId isEqualToString:INAPPPURCHASE_EVERYTHING_ID])
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Success!"
                                                         message:@"All weapon has been purchased"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
        
        //  [[AdsManager sharedAdsManager] saveAdRemovalStatus]; //Meng: this is not a cocos2d game, so I cannot use AdsManager file.
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:true forKey:@"everything purchase"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [Flurry logEvent:@"Purchase Everything"];
        
    }
}


//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
		NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
		
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;

        }
    }
}

@end

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    [numberFormatter release];
    return formattedString;
}

@end