//
//  DataUtility.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUIImageView.h"
#import "UIImageManager.h"
#import "NSData+Base64.h"

@class DataUtility;

@interface DataUtility : NSObject 
{
}

+ (DataUtility *) getInstance; 

- (NSString *) getBase64EncodedString:(NSString *) string;
- (NSString *) getBase64DecodedString:(NSString *) string;

@end
