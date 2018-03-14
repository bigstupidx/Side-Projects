//
//  Index.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

struct Index 
{
	NSInteger row;
	NSInteger column;
};

typedef struct Index Index;

Index IndexMake(NSInteger column, NSInteger row);

Index IndexClone(Index index);
