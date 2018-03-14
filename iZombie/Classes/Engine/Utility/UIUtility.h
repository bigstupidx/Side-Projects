//
//  UIUtility.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUIImageView.h"
#import "UIImageManager.h"

@class UIUtility;

@interface UIUtility : NSObject 
{
}

+ (UIUtility *) getInstance; 

- (UIAlertView *) showAlert:(NSString *) title :(NSString *) message :(id) delegate :(NSString *) cancel :(NSArray *) other;

- (UIAlertView *) showAlertWithImage:(NSString *) title :(UIImage *) image :(NSString *) message :(id) delegate :(NSString *) cancel :(NSArray *) other;

-(NSArray *) showAlertWithTextField:(NSString *) title :(NSString *) message :(id) delegate :(NSString *) cancel :(NSString *) other :(BOOL) responder;


@end
