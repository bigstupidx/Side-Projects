//
//  UIImageManager.h
//  iEngine
//
//  Created by Safiul Azam on 7/22/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogUtility.h"

@class UIImageManager;

@interface UIImageManager : NSObject {

	@private
	NSMutableDictionary *_uiImages;
}

+ (UIImageManager *) getInstance; 

- (NSArray *) getUIImages;
- (NSInteger) getCountUIImages;
- (UIImage *) getUIImage:(NSString *) filename;
- (NSArray *) getUIImages:(NSString *) filename index:(NSInteger) index length:(NSInteger) length;
- (void) releaseUIImage:(NSString *) filename;
- (void) releaseAllUIImages;

@end
