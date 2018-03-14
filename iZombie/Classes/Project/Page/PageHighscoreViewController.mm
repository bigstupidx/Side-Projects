//
//  PageHighscoreViewController.mm
//  iEngine
//
//  Created by Muhammed Safiul Azam on 11/6/09.
//  Copyright 2009 None. All rights reserved.
//

#import "PageHighscoreViewController.h"


@implementation PageHighscoreViewController

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
    
    [self reload];
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

-(void) reload
{
    if(_scores != nil)
        [_scores release];
    _scores = nil;
    
    _scores = [[Highscore getInstance] getScores];
    [_scores retain];
    
    _scoresTableView.delegate = self;
	_scoresTableView.dataSource = self;
	_scoresTableView.rowHeight = 25;
    [_scoresTableView setSeparatorColor:[UIColor clearColor]];
    
    [_scoresTableView setNeedsDisplay];
	[_scoresTableView reloadData];	
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	
	if(_scores == nil)
		return 0;
	
	return [_scores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *identifier = [[NSNumber numberWithLong:[[DateTimeUtility getInstance] getCurrentTimeMilliseconds]] stringValue];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if(cell == nil)
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    
	cell.backgroundColor = [UIColor clearColor];
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	Score *score = (Score *) [_scores objectAtIndex:indexPath.row];
	
	UILabel *labelRank = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, tableView.rowHeight)] autorelease];
	labelRank.text = [[NSNumber numberWithInt:indexPath.row + 1] stringValue];
	labelRank.textAlignment = UITextAlignmentCenter;
	labelRank.backgroundColor = [UIColor clearColor];
    labelRank.textColor = [UIColor whiteColor];
    labelRank.font = [UIFont fontWithName:@"Ariel" size:14.0];
	[cell addSubview:labelRank];
	
	UILabel *labelName = [[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, tableView.rowHeight)] autorelease];
	labelName.text = [score getName];
	labelName.textAlignment = UITextAlignmentLeft;
	labelName.backgroundColor = [UIColor clearColor];
    labelName.textColor = [UIColor whiteColor];
    labelName.font = [UIFont fontWithName:@"Ariel" size:14.0];
	[cell addSubview:labelName];
	
    UILabel *labelDate = [[[UILabel alloc] initWithFrame:CGRectMake(270, 0, 100, tableView.rowHeight)] autorelease];
	labelDate.text = [score getInformation];
	labelDate.textAlignment = UITextAlignmentCenter;
	labelDate.backgroundColor = [UIColor clearColor];
    labelDate.textColor = [UIColor whiteColor];
    labelDate.font = [UIFont fontWithName:@"Ariel" size:14.0];
	[cell addSubview:labelDate];
    
	UILabel *labelScore = [[[UILabel alloc] initWithFrame:CGRectMake(380, 0, 100, tableView.rowHeight)] autorelease];
	labelScore.text = [[score getScore] stringValue];
	labelScore.textAlignment = UITextAlignmentCenter;
	labelScore.backgroundColor = [UIColor clearColor];
    labelScore.textColor = [UIColor whiteColor];
    labelScore.font = [UIFont fontWithName:@"Ariel" size:14.0];
	[cell addSubview:labelScore];
	
	return cell;
}


-(IBAction) backTapped:(id) sender {
	
	PageMainViewController *pageMainViewController = (PageMainViewController *) [self getParent];
	[pageMainViewController gotoPage:PageMenu parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
    
    [[SoundManager getInstance] playSound:SOUND_CLICK];
	
	NSLog(@"Back Tapped.");
}

-(IBAction) clearTapped:(id)sender {
    
    [[Highscore getInstance] removeAllScores];
    [self reload];
    
    [[SoundManager getInstance] playSound:SOUND_CLICK];
}

- (void)dealloc {
    
    if(_scores != nil)
        [_scores release];
    
    _scores = nil;
    
    [[LogUtility getInstance] printMessage:@"PageHighscoreViewController - dealloc"];
    
    [super dealloc];
}


@end
