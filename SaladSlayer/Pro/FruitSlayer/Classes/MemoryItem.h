//
//  MemoryItem.h
//
//  Created by Robert Neagu on 2/4/11.
//  Copyright 2011 TotalSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MemoryItem : NSObject {
	int identifier;
	NSMutableArray *storage;
}

@property (nonatomic) int identifier;

-(id) initWithIdentifier: (int) ident Megabytes: (int )mb;

@end
