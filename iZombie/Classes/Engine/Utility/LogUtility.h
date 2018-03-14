//
//  LogUtility.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Index.h"

@class LogUtility;

@interface LogUtility : NSObject 
{
	BOOL _permission;
}

+ (LogUtility *) getInstance;

- (BOOL) isPermission;
- (void) setPermission:(BOOL) permission;

- (void) print:(NSString *) message;
- (void) printMessage:(NSString *) message;
- (void) printFloat:(CGFloat) value;
- (void) printIndex:(Index) index;
- (void) printPoint:(CGPoint) point;
- (void) printSize:(CGSize) size;
- (void) printRectangle:(CGRect) rectangle;

@end
