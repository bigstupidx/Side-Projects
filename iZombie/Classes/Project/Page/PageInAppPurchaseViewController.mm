

#import "PageInAppPurchaseViewController.h"
#import "GameKitHelper.h"
#import "Flurry.h"
#import "InAppPurchaseManager.h"


@implementation PageInAppPurchaseViewController

- (void)viewDidLoad {
    
	[super viewDidLoad];
    
    _imageViewInAppPurchaseBackground.backgroundColor = [UIColor clearColor];
    
    
    
    bool axePurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"axe purchase"] boolValue];
    if (axePurchased)
    {
        _axePurchase.hidden = YES;
    }
    
    bool hammerPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hammer purchase"] boolValue];
    if (hammerPurchased)
    {
        _hammerPurchase.hidden = YES;
    }
    
    bool chainsawPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"chainsaw purchase"] boolValue];
    if (chainsawPurchased)
    {
        _chainsawPurchase.hidden = YES;
    }
    
    bool machineGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"machinegun purchase"] boolValue];
    if (machineGunPurchased)
    {
        _machineGunPurchase.hidden = YES;
    }
    
    bool laserGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"laser purchase"] boolValue];
    if (laserGunPurchased)
    {
        _laserGunPurchase.hidden = YES;
    }
    
    bool everythingPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"everything purchase"] boolValue];
    if (everythingPurchased)
    {
        _axePurchase.hidden = YES;
        _hammerPurchase.hidden = YES;
        _chainsawPurchase.hidden = YES;
        _machineGunPurchase.hidden = YES;
        _laserGunPurchase.hidden = YES;
        _allWeaponPurchase.hidden = YES;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:true forKey:@"we are in purchase page"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {
    
    
}

-(IBAction) axePurchaseTapped:(id) sender
{
    bool axePurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"axe purchase"] boolValue];
    if (!axePurchased)
    {
        [[InAppPurchaseManager sharedInAppManager] purchaseAxe];
    }
    
    axePurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"axe purchase"] boolValue];
    if (axePurchased)
    {
        _axePurchase.hidden = YES;
    }
}

-(IBAction) hammerPurchaseTapped:(id) sender
{
    bool hammerPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hammer purchase"] boolValue];
    if (!hammerPurchased)
    {
        [[InAppPurchaseManager sharedInAppManager] purchaseHammer];
    }

    hammerPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hammer purchase"] boolValue];
    if (hammerPurchased)
    {
        _hammerPurchase.hidden = YES;
    }
}

-(IBAction) chainsawPurchaseTapped:(id) sender
{
    bool chainsawPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"chainsaw purchase"] boolValue];
    if (!chainsawPurchased)
    {
        [[InAppPurchaseManager sharedInAppManager] purchaseChainsaw];   
    }

    
    chainsawPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"chainsaw purchase"] boolValue];
    if (chainsawPurchased)
    {
        _chainsawPurchase.hidden = YES;
    }
}

-(IBAction) machineGunPurchaseTapped:(id) sender
{
    bool machineGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"machinegun purchase"] boolValue];
    if (!machineGunPurchased)
    {
       [[InAppPurchaseManager sharedInAppManager] purchaseMachinegun];   
    }

    machineGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"machinegun purchase"] boolValue];
    if (machineGunPurchased)
    {
        _machineGunPurchase.hidden = YES;
    }
}

-(IBAction) laserGunPurchaseTapped:(id) sender
{
    bool laserGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"laser purchase"] boolValue];
    if (!laserGunPurchased)
    {
      [[InAppPurchaseManager sharedInAppManager] purchaseLaser];   
    }

    laserGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"laser purchase"] boolValue];
    if (laserGunPurchased)
    {
        _laserGunPurchase.hidden = YES;
    }
}

-(IBAction) allWeaponPurchaseTapped:(id) sender
{
    bool everythingPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"everything purchase"] boolValue];
    if (!everythingPurchased)
    {
       [[InAppPurchaseManager sharedInAppManager] purchaseEverything];   
    }

    everythingPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"everything purchase"] boolValue];
    if (everythingPurchased)
    {
        _axePurchase.hidden = YES;
        _hammerPurchase.hidden = YES;
        _chainsawPurchase.hidden = YES;
        _machineGunPurchase.hidden = YES;
        _laserGunPurchase.hidden = YES;
        _allWeaponPurchase.hidden = YES;
    }
}

-(IBAction) restoreTapped:(id) sender {
    [Flurry logEvent:@"RestoreButton"];
    
    //restore the completedtransactions
	[[InAppPurchaseManager sharedInAppManager] restoreCompletedTransactions];
}

-(IBAction) okTapped:(id) sender {
    PageMainViewController *pageMainViewController = (PageMainViewController *) [self getParent];
	[pageMainViewController gotoPage:PageMarket parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
}


-(void) axePurchaseStatusUpdate
{
    bool axePurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"axe purchase"] boolValue];
    if (axePurchased)
    {
        _axePurchase.hidden = YES;
    }

}

-(void) hammerPurchaseStatusUpdate
{
    bool hammerPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hammer purchase"] boolValue];
    if (hammerPurchased)
    {
        _hammerPurchase.hidden = YES;
    }
}

-(void) chainsawPurchaseStatusUpdate
{
    bool chainsawPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"chainsaw purchase"] boolValue];
    if (chainsawPurchased)
    {
        _chainsawPurchase.hidden = YES;
    }
}

-(void) machineGunPurchaseStatusUpdate
{
    bool machineGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"machinegun purchase"] boolValue];
    if (machineGunPurchased)
    {
        _machineGunPurchase.hidden = YES;
    }
}

-(void) laserGunPurchaseStatusUpdate
{
    bool laserGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"laser purchase"] boolValue];
    if (laserGunPurchased)
    {
        _laserGunPurchase.hidden = YES;
    }
}

-(void) allWeaponPurchaseStatusUpdate
{
    bool everythingPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"everything purchase"] boolValue];
    if (everythingPurchased)
    {
        _axePurchase.hidden = YES;
        _hammerPurchase.hidden = YES;
        _chainsawPurchase.hidden = YES;
        _machineGunPurchase.hidden = YES;
        _laserGunPurchase.hidden = YES;
        _allWeaponPurchase.hidden = YES;
    }
}


- (void)dealloc {
    
    [[LogUtility getInstance] printMessage:@"PageMenuViewController - dealloc"];
    
    [super dealloc];
}


@end
