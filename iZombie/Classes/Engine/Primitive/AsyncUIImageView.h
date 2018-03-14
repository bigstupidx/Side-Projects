//
//  AsyncUIImageView.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Preferences.h"

static NSString *FACEBOOK_DOT_COM = @"facebook.com";

@interface AsyncUIImageView : UIImageView 
{
	UIActivityIndicatorView *_activity;
	
	NSString *_url;
	
	NSURLConnection *_connection;
	
	NSMutableData *_data;
}

- (id) loadImageFromURL:(NSString *) url :(CGRect) frame;

- (void) setActivityIndicatorStyle:(UIActivityIndicatorViewStyle) style;

@end
