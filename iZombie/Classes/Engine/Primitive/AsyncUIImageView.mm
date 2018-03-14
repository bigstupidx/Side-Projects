//
//  AsyncUIImageView.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncUIImageView.h"


@implementation AsyncUIImageView


- (id) loadImageFromURL:(NSString *) url :(CGRect) frame 
{
	[self init];
	
	self.frame = frame;
	
	self.contentMode = UIViewContentModeScaleAspectFit;
	
	_url = url;
	[_url retain];
	
	UIImage *image = [UIImage imageWithData:[[Preferences getInstance] getValue:_url]];
	
	if(image != nil)
	{
		self.image = image;
	}
	else
	{
		_activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];	
		CGFloat width = _activity.frame.size.width;
		CGFloat height = _activity.frame.size.height; 	
		CGFloat x = (self.frame.size.width - width) / 2;
		CGFloat y = (self.frame.size.height - height) / 2;
		_activity.frame = CGRectMake(x, y, width, height);
		[self addSubview:_activity];
		[_activity startAnimating];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];	
		_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
		_data = [[NSMutableData alloc] init];
	}


	return self;
}

- (void) setActivityIndicatorStyle:(UIActivityIndicatorViewStyle) style
{
	_activity.activityIndicatorViewStyle = style;
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data 
{	
	[_data appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection 
{
	self.image = [UIImage imageWithData:_data];
	
	NSRange range = [[_url lowercaseString] rangeOfString:[FACEBOOK_DOT_COM lowercaseString]];
	
	if(range.location == NSNotFound)
		[[Preferences getInstance] setValue:_data :_url];
	
	[_activity removeFromSuperview];
		
	[_data release];
	[_connection release];
}

- (void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error
{
	[_activity removeFromSuperview];
	
	[_data release];
	[_connection release];
}

- (void)dealloc 
{
	[_url release];
	
	if(_data != nil)
		[_data release];
	
	if(_connection != nil)
	{
		[_connection cancel];
		[_connection release];
	}
	
    // FIXME: Why is [super dealloc] commented?
	//[super dealloc];
}


@end
