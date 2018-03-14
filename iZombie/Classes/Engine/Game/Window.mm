//
//  Window.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Window.h"


@implementation Window

- (id) initWithFrame:(CGRect) frame 
{
	[super initWithFrame:frame];
    
    //[self setMultipleTouchEnabled:YES];
					
	return self;
}

- (void) onCreateSurface
{
	[super onCreateSurface];	
	[self onCreateRenderer];
}

- (void) onChangeSurface
{
	[super onChangeSurface];	
	[self onChangeRenderer];
}

- (void) onDrawFrame 
{
	[super onDrawFrame];	
	[self onDrawRenderer];
}

- (void) onCreateRenderer
{
}

- (void) onChangeRenderer
{
}

- (void) onDrawRenderer
{
}

- (void) touchesBegan:(NSSet*) touches withEvent:(UIEvent*) event {
	
	[super touchesBegan:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];

	if ([touch view] == self) {
        
        NSArray *allTouches = [touches allObjects];
        
        NSMutableArray *positions = [[[NSMutableArray alloc] init] autorelease];
        for(NSInteger i = 0; i < [allTouches count]; i++)
        {
            CGPoint position = [[allTouches objectAtIndex:i] locationInView:self];
            position.x += -[self frame].size.width / 2;
            position.y += -[self frame].size.height / 2;
            
            [positions addObject:[NSValue valueWithCGPoint:position]];
        }
        
        [self onTouchesBegin:positions :[touches count]];
	}
}

- (void) touchesMoved:(NSSet*) touches withEvent:(UIEvent*) event {
	
	[super touchesMoved:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];

	if ([touch view] == self) {
        
        NSArray *allTouches = [touches allObjects];
        
        NSMutableArray *positions = [[[NSMutableArray alloc] init] autorelease];
        for(NSInteger i = 0; i < [allTouches count]; i++)
        {
            CGPoint position = [[allTouches objectAtIndex:i] locationInView:self];
            position.x += -[self frame].size.width / 2;
            position.y += -[self frame].size.height / 2;
            
            [positions addObject:[NSValue valueWithCGPoint:position]];
        }
        
        [self onTouchesMove:positions :[touches count]];
	}
}

- (void) touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event {
	
	[super touchesEnded:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];

	if ([touch view] == self) {
        
        NSArray *allTouches = [touches allObjects];
        
        NSMutableArray *positions = [[[NSMutableArray alloc] init] autorelease];
        for(NSInteger i = 0; i < [allTouches count]; i++)
        {
            CGPoint position = [[allTouches objectAtIndex:i] locationInView:self];
            position.x += -[self frame].size.width / 2;
            position.y += -[self frame].size.height / 2;
            
            [positions addObject:[NSValue valueWithCGPoint:position]];
        }
        
        [self onTouchesEnd:positions :[touches count]];
	}
}

- (void) onTouchesBegin:(NSArray *) positions :(NSInteger) count;
{
    
}

- (void) onTouchesMove:(NSArray *) positions :(NSInteger) count
{
    
}

- (void) onTouchesEnd:(NSArray *) positions :(NSInteger) count
{
    
}

- (void) dealloc 
{
	[super dealloc];
}

@end
