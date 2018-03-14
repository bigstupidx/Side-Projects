//
//  UIUtility.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIUtility.h"

static UIUtility *_uiUtility = nil;

@implementation UIUtility

- (id) init 
{
	[super init];
	
	return self;
}

+ (UIUtility *) getInstance 
{
	if(_uiUtility == nil)
		_uiUtility = [[UIUtility alloc] init];
	
	return _uiUtility;
}

- (UIAlertView *) showAlert:(NSString *) title :(NSString *) message :(id) delegate :(NSString *) cancel :(NSArray *) other 
{
	UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:nil] autorelease];
	
	if(other != nil)
		for(NSInteger i = 0; i < [other count]; i++) {
			
			NSString *button = (NSString *) [other objectAtIndex:i];
			
			if(![button isEqualToString:@""])
				[alert addButtonWithTitle:button];
		}
	
	return alert;
}

- (UIAlertView *) showAlertWithImage:(NSString *) title :(NSString *) image :(NSString *) message :(id) delegate :(NSString *) cancel :(NSArray *) other 
{
	
	message = (message == nil ? @"" : message);
	
	message = [(cancel == nil ? @"\n\n\n" : @"\n\n\n\n\n") stringByAppendingString:message];
	
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:nil];
	
	AsyncUIImageView *asyncUIImageView = [[AsyncUIImageView alloc] loadImageFromURL:image :CGRectMake(12, 12, 260, 95)];
	[asyncUIImageView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[alert addSubview:asyncUIImageView];	
	[asyncUIImageView release];
	
	if(other != nil)
		for(NSInteger i = 0; i < [other count]; i++) {
			
			NSString *button = (NSString *) [other objectAtIndex:i];
			
			if(![button isEqualToString:@""])
				[alert addButtonWithTitle:button];
		}
	
	return alert;
}

-(NSArray *) showAlertWithTextField:(NSString *) title :(NSString *) message :(id) delegate :(NSString *) cancel :(NSString *) other :(BOOL) responder {
	
    title = [title stringByAppendingString:@"\n\n\n\n"];
    
	UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:title message:@"" delegate:delegate cancelButtonTitle:cancel otherButtonTitles:nil] autorelease];
	
	UITextField *textField = [[[UITextField alloc] initWithFrame:CGRectMake(14, 55, 255, 28)] autorelease];
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.borderStyle = UITextBorderStyleRoundedRect;
	textField.text = message;
	textField.delegate = delegate;	
	[alert addSubview:textField];
	[textField release];
	
	if(other != nil)
		if(![other isEqualToString:@""])
			[alert addButtonWithTitle:other];
	
	if(responder == YES)
		[textField becomeFirstResponder];
	
	return [NSArray arrayWithObjects:alert, textField, nil];
}

- (void) dealloc 
{
	[super dealloc];
}

@end
