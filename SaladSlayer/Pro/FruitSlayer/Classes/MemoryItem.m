//
//  MemoryItem.m
//
//  Created by Robert Neagu on 2/4/11.
//  Copyright 2011 TotalSoft. All rights reserved.
//

#import "MemoryItem.h"

@implementation MemoryItem

@synthesize identifier;

-(id) initWithIdentifier: (int) ident Megabytes: (int )mb {
	if (self = [super init]) {
		self.identifier = ident;

		//Storage
		int maxIndex = mb * 50000;
		storage = [[NSMutableArray alloc] init];
		for (int i=0; i<maxIndex; i++) {
			NSNumber *n = [[NSNumber alloc] initWithInt: i];
			[storage insertObject: n atIndex: i];
			[n release];
		}
		
		NSLog(@"Created item %i", ident);
	}
	
	return self;
}

-(void) dealloc {
	//Release
	[storage removeAllObjects];
	[storage release];
	storage = nil;
	
	//Debug
	NSLog(@"Deallocated item %i", identifier);
	
	//Super
	[super dealloc];
}

@end
