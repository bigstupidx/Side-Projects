//
//  Character.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Character.h"


@implementation Character

- (id) initWithFont:(Font *) font :(NSString *) character :(CGRect) frame
{
	[super init];
	
	_font = font;
	[_font retain];
	
	_character = character;
	[_character retain];
	
	_frame = frame;
	
	return self;
}

- (NSString *) getCharacter
{
	return _character;
}

- (CGRect) getFrame
{		
	CGFloat factor =  [_font getResize] / [_font getSize];
	
	CGFloat x = _frame.origin.x * factor;
	CGFloat y = _frame.origin.y * factor;
	CGFloat width = _frame.size.width * factor;
	CGFloat height = _frame.size.height * factor;
	
	return CGRectMake(x, y, width, height);
}

-(void) dealloc {
	
	[_font release];
	[_character release];
    
    [[LogUtility getInstance] printMessage:@"Character - dealloc"];
	
	[super dealloc];	
}

@end
