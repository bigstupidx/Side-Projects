//
//  MemoryConsumer.h
//
//  Created by Robert Neagu on 2/4/11.
//  Copyright 2011 TotalSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoryItem.h"

@class MemoryItem;

@interface MemoryConsumer : NSObject {
	NSMutableArray *storage;
	bool consuming;
	int identifier;
}

-(void) start;

-(void) stop;

-(void) consume;

-(void) free;

-(int) getFreeMB;

@end
