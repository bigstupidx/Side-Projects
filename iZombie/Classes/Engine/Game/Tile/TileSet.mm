//
//  TileSet.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TileSet.h"


@implementation TileSet

-(void) dealloc
{
    [[LogUtility getInstance] printMessage:@"TileSet - dealloc"];
    
    [super dealloc];
}

@end
