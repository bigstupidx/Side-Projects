//
//  PageMarketViewController.mm
//  iEngine
//
//  Created by Muhammed Safiul Azam on 11/6/09.
//  Copyright 2009 None. All rights reserved.
//

#import "PageMarketViewController.h"
#import "InAppPurchaseManager.h"

@implementation PageMarketViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
    
    //[[Preferences getInstance] setValue:[NSNumber numberWithInt:1000] :KEY_PLAYER_MONEY];
    
    _avatarTableView.backgroundColor = [UIColor clearColor];
    _fireTableView.backgroundColor = [UIColor clearColor];
    _hitTableView.backgroundColor = [UIColor clearColor];
    
    [self reloadAvatar];
    [self reloadFire];
    [self reloadHit];
    
    [self reloadMoney];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void) reloadAvatar
{
    _avatarTableView.delegate = self;
	_avatarTableView.dataSource = self;
	_avatarTableView.rowHeight = MARKET_ROW_HEIGHT;
    [_avatarTableView setSeparatorColor:[UIColor blackColor]];

    
    [_avatarTableView setNeedsDisplay];
	[_avatarTableView reloadData];	 
}

-(void) reloadFire
{
    _fireTableView.delegate = self;
	_fireTableView.dataSource = self;
	_fireTableView.rowHeight = MARKET_ROW_HEIGHT;
    [_fireTableView setSeparatorColor:[UIColor blackColor]];

    
    [_fireTableView setNeedsDisplay];
	[_fireTableView reloadData];	
}

-(void) reloadHit
{
    _hitTableView.delegate = self;
	_hitTableView.dataSource = self;
	_hitTableView.rowHeight = MARKET_ROW_HEIGHT;
    [_hitTableView setSeparatorColor:[UIColor blackColor]];

    
    [_hitTableView setNeedsDisplay];
	[_hitTableView reloadData];	
}

-(void) reloadMoney
{
    _moneyLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
    NSInteger money = [(NSNumber *) [[Preferences getInstance] getValue:KEY_PLAYER_MONEY] intValue];
    NSString *moneyString = @"$";
    moneyString = [moneyString stringByAppendingString:[[NSNumber numberWithInt:money] stringValue]]; 
    _moneyLabel.text = moneyString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([tableView isEqual:_avatarTableView])
        return [[Avatar getInstances] count];
    else if([tableView isEqual:_hitTableView])
        return [[Hit getInstances] count];
    else if([tableView isEqual:_fireTableView])
        return [[Fire getInstances] count];
    
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSString *identifier = [[NSNumber numberWithLong:[[DateTimeUtility getInstance] getCurrentTimeMilliseconds]] stringValue];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if(cell == nil)
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    
	cell.backgroundColor = [UIColor clearColor];
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImage *image = nil;
    Item *item = nil;
    
    BOOL isCheck = NO;
    NSNumber *identity = nil;
    
    if([tableView isEqual:_avatarTableView])
    {
        identity = [[Preferences getInstance] getValue:KEY_PLAYER_AVATAR];
        item = (Avatar *) [[Avatar getInstances] objectAtIndex:indexPath.row];
    }
    else if([tableView isEqual:_hitTableView])
    {
        identity = [[Preferences getInstance] getValue:KEY_PLAYER_HIT];
        item = (Hit *) [[Hit getInstances] objectAtIndex:indexPath.row];
    }
    else if([tableView isEqual:_fireTableView])
    {
        identity = [[Preferences getInstance] getValue:KEY_PLAYER_FIRE];
        item = (Fire *) [[Fire getInstances] objectAtIndex:indexPath.row];
    }
    
    if(identity != nil && [identity intValue] == indexPath.row)
    {
        isCheck = YES;   
    }

        
    image = [[UIImageManager getInstance] getUIImage:[item getThumbFilename]];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 146, 80)] autorelease];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
	[cell addSubview:imageView];
    
    UILabel *nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 146, 16)] autorelease];
    nameLabel.text = [item getName];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = UITextAlignmentLeft;
    [nameLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [cell addSubview:nameLabel];
    
    /*
    UILabel *priceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 146, 16)] autorelease];
    NSString *price = @"$";
    price = [price stringByAppendingString:[[NSNumber numberWithInt:[item getPrice]] stringValue]];
    priceLabel.text = price;
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.textAlignment = UITextAlignmentRight;
    priceLabel.font = [UIFont fontWithName:@"Arial" size:16];
    CGRect frame = priceLabel.frame;
    priceLabel.frame = CGRectMake(frame.origin.x, MARKET_ROW_HEIGHT - 16, frame.size.width, frame.size.height);
    [cell addSubview:priceLabel];
    */
    
   // if([item isOwn])
   //     priceLabel.hidden = YES;
    
    if(isCheck)
    {
        
        UIImage *checkImage = [[UIImageManager getInstance] getUIImage:@"Check.png"];
        checkImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)] autorelease];
        checkImageView.image = checkImage;
        checkImageView.contentMode = UIViewContentModeScaleAspectFit;
        CGRect frame = checkImageView.frame;
        checkImageView.frame = CGRectMake(100, 2, frame.size.width, frame.size.height);
        [cell addSubview:checkImageView];
        
        //Meng: we don't want to add a second character temporarily
        /*
        if(![tableView isEqual:_avatarTableView])
        {
            UIImage *checkImage = [[UIImageManager getInstance] getUIImage:@"Check.png"];
            checkImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)] autorelease];
            checkImageView.image = checkImage;
            checkImageView.contentMode = UIViewContentModeScaleAspectFit;
            frame = checkImageView.frame;
            checkImageView.frame = CGRectMake(100, 2, frame.size.width, frame.size.height);
            [cell addSubview:checkImageView];
        }
        else if([tableView isEqual:_avatarTableView])
        {
            //Meng:the "check" mark for the avatarTableView will add in the function below.
            UIImage *checkImage = [[UIImageManager getInstance] getUIImage:@"Check.png"];
            checkImageView_character = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
            checkImageView_character.image = checkImage;
            checkImageView_character.contentMode = UIViewContentModeScaleAspectFit;
            frame = checkImageView_character.frame;
            checkImageView_character.frame = CGRectMake(100, 2, frame.size.width, frame.size.height);
            [cell addSubview:checkImageView_character];
            
            cell_character = cell;
        }
         */
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *number = [NSNumber numberWithInteger:indexPath.row];
    
    NSInteger money = [(NSNumber *) [[Preferences getInstance] getValue:KEY_PLAYER_MONEY] intValue];
    
    if([tableView isEqual:_avatarTableView])
    {

        [[Preferences getInstance] setValue:number :KEY_PLAYER_AVATAR];
        
        //Meng: we don't want to add a second character temporarily.
        /*
        if([number intValue]==0)
        {
            [checkImageView_character removeFromSuperview];
            [checkImageView_character release];
            
            UIImage *checkImage = [[UIImageManager getInstance] getUIImage:@"Check.png"];
            checkImageView_character = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
            checkImageView_character.image = checkImage;
            checkImageView_character.contentMode = UIViewContentModeScaleAspectFit;
            checkImageView_character.frame = CGRectMake(100, indexPath.row, checkImageView_character.frame.size.width, checkImageView_character.frame.size.height);
            [cell_character addSubview:checkImageView_character];
        }
        else if([number intValue]==1)
        {
            [checkImageView_character removeFromSuperview];
            [checkImageView_character release];
            
            UIImage *checkImage = [[UIImageManager getInstance] getUIImage:@"Check.png"];
            checkImageView_character = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
            checkImageView_character.image = checkImage;
            checkImageView_character.contentMode = UIViewContentModeScaleAspectFit;
            checkImageView_character.frame = CGRectMake(100, indexPath.row+110, checkImageView_character.frame.size.width, checkImageView_character.frame.size.height);
            [cell_character addSubview:checkImageView_character];
        }
         */
    }
    else if([tableView isEqual:_hitTableView])
    {
        Hit *hit = [[Hit getInstances] objectAtIndex:[number intValue]];
    
        if([number intValue]<=1)
        {
            if(![hit isOwn])
            {
                if([hit getPrice] <= money)
                {
                    
                    NSArray *others = [NSArray arrayWithObjects:@"Yes", nil];
                    UIAlertView *alertView = [[UIUtility getInstance] showAlert:ARE_YOU_SURE_MESSAGE :nil :self :@"No" :others];
                    [alertView show];
                    
                    _buyIndex = number;
                    [_buyIndex retain];
                    
                    _buyItem = hit;
                    [_buyItem retain];
                }
                else
                {
                    UIAlertView *alertView = [[UIUtility getInstance] showAlert:@"" :NOT_ENOUGH_CURRENCY_MESSAGE :nil :@"Ok" :nil];
                    [alertView show];
                }
            }
            
            if([hit isOwn])
            {
                [[Preferences getInstance] setValue:number :KEY_PLAYER_HIT];
                
                [self reloadHit];
                [self reloadMoney];
            }
        }
        else
        {
            
            bool weaponPurchased;
            if([number intValue]==3)
            {
                weaponPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"axe purchase"] boolValue];
            }
            
            if([number intValue]==2)
            {
                weaponPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hammer purchase"] boolValue];
            }
            
            if([number intValue]==4)
            {
                weaponPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"chainsaw purchase"] boolValue];
            }
            
            bool allPurchased;
            allPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"everything purchase"] boolValue];
            
            if(![hit isOwn])
            {
                if (weaponPurchased||allPurchased)
                {
                    
                    NSArray *others = [NSArray arrayWithObjects:@"Yes", nil];
                    UIAlertView *alertView = [[UIUtility getInstance] showAlert:ARE_YOU_SURE_MESSAGE :nil :self :@"No" :others];
                    [alertView show];
                    
                    _buyIndex = number;
                    [_buyIndex retain];
                    
                    _buyItem = hit;
                    [_buyItem retain];
                    
                }
                else
                {
                    UIAlertView *alertView = [[UIUtility getInstance] showAlert:@"" :NOT_ENOUGH_CURRENCY_MESSAGE :nil :@"Ok" :nil];
                    [alertView show];
                    
                    PageMainViewController *pageMainViewController = (PageMainViewController *) [self getParent];
                    [pageMainViewController gotoPage:PageInAppPurchase parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
                }
            }
            
            if([hit isOwn])
            {
                [[Preferences getInstance] setValue:number :KEY_PLAYER_HIT];
                
                [self reloadHit];
                [self reloadMoney];
            }
        }
    }
    else if([tableView isEqual:_fireTableView])
    {
        Fire *fire = [[Fire getInstances] objectAtIndex:[number intValue]];
        
        if([number intValue]<=1)
        {
            if(![fire isOwn])
            {
                if([fire getPrice] <= money)
                {
                    NSArray *others = [NSArray arrayWithObjects:@"Yes", nil];
                    UIAlertView *alertView = [[UIUtility getInstance] showAlert:ARE_YOU_SURE_MESSAGE :nil :self :@"No" :others];
                    [alertView show];
                    
                    _buyIndex = number;
                    [_buyIndex retain];
                    
                    _buyItem = fire;
                    [_buyItem retain];
                }
                else
                {
                    UIAlertView *alertView = [[UIUtility getInstance] showAlert:@"" :NOT_ENOUGH_CURRENCY_MESSAGE :nil :@"Ok" :nil];
                    [alertView show];
                }
            }
            
            if([fire isOwn])
            {
                [[Preferences getInstance] setValue:number :KEY_PLAYER_FIRE];
                
                [self reloadFire];
                [self reloadMoney];
            }
        }
        else
        {
            
            bool weaponPurchased;
            if([number intValue]==2)
            {
                weaponPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"machinegun purchase"] boolValue];
            }
            
            if([number intValue]==3)
            {
                weaponPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"laser purchase"] boolValue];
            }
            
            bool allPurchased;
            allPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"everything purchase"] boolValue];
            
            if(![fire isOwn])
            {
                if (weaponPurchased||allPurchased)
                {
                    
                    NSArray *others = [NSArray arrayWithObjects:@"Yes", nil];
                    UIAlertView *alertView = [[UIUtility getInstance] showAlert:ARE_YOU_SURE_MESSAGE :nil :self :@"No" :others];
                    [alertView show];
                    
                    _buyIndex = number;
                    [_buyIndex retain];
                    
                    _buyItem = fire;
                    [_buyItem retain];
                    
                }
                else
                {
                    UIAlertView *alertView = [[UIUtility getInstance] showAlert:@"" :NOT_ENOUGH_CURRENCY_MESSAGE :nil :@"Ok" :nil];
                    [alertView show];
                    
                    PageMainViewController *pageMainViewController = (PageMainViewController *) [self getParent];
                    [pageMainViewController gotoPage:PageInAppPurchase parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
                }
            }
            
            if([fire isOwn])
            {
                [[Preferences getInstance] setValue:number :KEY_PLAYER_FIRE];
                
                [self reloadFire];
                [self reloadMoney];
            }
        }
    }
    
    [[SoundManager getInstance] playSound:SOUND_CLICK];
}

- (void)alertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    NSInteger money = [(NSNumber *) [[Preferences getInstance] getValue:KEY_PLAYER_MONEY] intValue];
    
    if(buttonIndex == 1)
    {
        if([_buyItem isKindOfClass:[Hit class]])
        {
            Hit *hit = (Hit *) _buyItem;
            
            money -= [hit getPrice];
            [[Preferences getInstance] setValue:[NSNumber numberWithInt:money] :KEY_PLAYER_MONEY];
            [hit setOwn:YES];
            
            [[Preferences getInstance] setValue:_buyIndex :KEY_PLAYER_HIT];
            
            [self reloadHit];
            [self reloadMoney];
        }
        else if([_buyItem isKindOfClass:[Fire class]])
        {
            Fire *fire = (Fire *) _buyItem;
            
            money -= [fire getPrice];
            [[Preferences getInstance] setValue:[NSNumber numberWithInt:money] :KEY_PLAYER_MONEY];
            [fire setOwn:YES];
            
            [[Preferences getInstance] setValue:_buyIndex :KEY_PLAYER_FIRE];
            
            [self reloadFire];
            [self reloadMoney];
        }
    }
    
    [_buyIndex release];
    [_buyItem release];
}

-(IBAction) backTapped:(id) sender {
	
    NSNumber *level = [[Preferences getInstance] getValue:KEY_PLAYER_LEVEL];
    
    if(level != nil && [level intValue] > 0)
        [[Preferences getInstance] setValue:[NSNumber numberWithInt:1] :KEY_RESUME];
    
	PageMainViewController *pageMainViewController = (PageMainViewController *) [self getParent];
	[pageMainViewController gotoPage:PageMenu parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
    
    [[SoundManager getInstance] playSound:SOUND_CLICK];
	
	NSLog(@"Back Tapped.");
}

-(IBAction) playTapped:(id)sender {
    
    PageMainViewController *pageMainViewController = (PageMainViewController *) [self getParent];
	[pageMainViewController gotoPage:PageLoad parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
    
    [[SoundManager getInstance] playSound:SOUND_CLICK];
}

- (void)dealloc 
{
    [[LogUtility getInstance] printMessage:@"PageMarketViewController - dealloc"];
    
    [super dealloc];
}


@end
