//
//  LayerContainer.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LayerContainer.h"

@implementation LayerContainer

- (id) initWithSize:(CGSize) size 
{
	[super initWithSize:size];
	
	_childs = [[NSMutableArray alloc] init];
	
	return self;
}

-(NSArray *) getChilds {
	
	return (NSArray *) _childs;
}

-(NSInteger) getCountChilds {
	
	return [_childs count];
}

-(Layer *) getChild:(NSInteger) index {
	
	return [_childs objectAtIndex:index];
}

-(void) addChild:(Layer *) child {
    
	if([child getParent] != nil)
		[[child getParent] removeChild:child];
    
	[child setParent:self];
	[_childs addObject:child];
}

-(void) replaceChild:(NSInteger) index :(Layer *) child {
	
	Layer *temporaryChild = [[self getChilds] objectAtIndex:index];
	
	[temporaryChild setParent:nil];
	
	if([child getParent] != nil)
		[[child getParent] removeChild:child];
	
	[child setParent:self];
	
	[_childs replaceObjectAtIndex:index withObject:child];
}

-(void) removeChild:(Layer *) child {
	
	[child setParent:nil];
	
	[_childs removeObject:child];
}

-(void) removeAllChilds {
	
	for(NSInteger i = 0; i < [self getCountChilds]; i++)
		[[self getChild:i] setParent:nil];
	
	[_childs removeAllObjects];
}

-(void) dealloc {
    
	[_childs release];
	
	[super dealloc];	
}

@end
