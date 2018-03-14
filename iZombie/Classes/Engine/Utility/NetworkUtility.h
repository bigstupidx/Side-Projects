//
//  NetworkUtility.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@class NetworkUtility;

@interface NetworkUtility : NSObject 
{
}

+ (NetworkUtility *) getInstance; 

- (BOOL) isOnline;

@end
