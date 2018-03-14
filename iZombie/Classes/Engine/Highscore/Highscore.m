//
//  Highscore.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Highscore.h"

static Highscore *_highscore = nil;

static NSInteger COUNT_HIGHSCORE = 50;
static NSString *KEY_HIGHSCORE = @"KEY_HIGHSCORE";

@implementation Highscore
-(id) init
{
    [super init];
    
    return self;
}

+(Highscore *) getInstance
{
    if(_highscore == nil)
    {
        _highscore = [[Highscore alloc] init];
        
        if([[Preferences getInstance] getValue:KEY_HIGHSCORE] == nil) 
        {
            NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] init]];
            [[Preferences getInstance] setValue:archiveData :KEY_HIGHSCORE];
        }
    }
    
    return _highscore;
}

-(NSArray *) getScores
{
    NSMutableArray *scores = [[[NSMutableArray alloc] init] autorelease];
    
    NSData *data = [[Preferences getInstance] getValue:KEY_HIGHSCORE];
	NSMutableArray *unarchiveData = (NSMutableArray *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	for(NSInteger i = 0; i < [unarchiveData count]; i++) {
		
		Score *score = (Score *) [NSKeyedUnarchiver unarchiveObjectWithData:[unarchiveData objectAtIndex:i]];
		[scores addObject:score];
	}
    
    return scores;
}

-(void) saveScore:(Score *) score 
{
    NSData *data = [[Preferences getInstance] getValue:KEY_HIGHSCORE];
	NSMutableArray *unarchiveData = (NSMutableArray *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
	
	NSMutableArray *scores = [[[NSMutableArray alloc] init] autorelease];
	
	for(NSInteger i = 0; i < [unarchiveData count]; i++) {
		
		Score *score = (Score *) [NSKeyedUnarchiver unarchiveObjectWithData:[unarchiveData objectAtIndex:i]];
		[scores addObject:score];
	}
	
	[scores addObject:score];
	
	NSSortDescriptor *scoresSorter = [[[NSSortDescriptor alloc] initWithKey:@"sorter" ascending:NO] autorelease];
	[scores sortUsingDescriptors: [NSArray arrayWithObject:scoresSorter]];
	
	if([scores count] > COUNT_HIGHSCORE)
		scores = (NSMutableArray *) [scores subarrayWithRange:NSMakeRange(0, COUNT_HIGHSCORE)];
    
    NSMutableArray *save = [[[NSMutableArray alloc] init] autorelease];
    
    for(NSInteger i = 0; i < [scores count]; i++) {
        
        Score *score = [scores objectAtIndex:i];
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:score];
        [save addObject:archiveData];
    }
	
	NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:save];
	[[Preferences getInstance] setValue:archiveData :KEY_HIGHSCORE];
}

-(void) removeAllScores
{
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:[[NSMutableArray alloc] init]];
    [[Preferences getInstance] setValue:archiveData :KEY_HIGHSCORE];
}

-(void) dealloc
{
    [[LogUtility getInstance] printMessage:@"Highscore - dealloc"];
    
    [super dealloc];
}

@end
