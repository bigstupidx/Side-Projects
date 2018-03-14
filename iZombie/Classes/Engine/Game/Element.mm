//
//  Element.mm
//  iEngine
//
//  Created by Safiul Azam on 7/14/09.
//  Copyright 2009 None. All rights reserved.
//

#import "Element.h"


@implementation Element

- (id)init {

	[super init];
	
	[self setName:@""];
	
	_properties = [[NSMutableDictionary alloc] init];
	
	return self;
}

-(NSString *) getName {
	
	return _name;
}

-(void) setName:(NSString *) name {
	
	_name = name;
}

-(NSMutableDictionary *) getProperties {

	return _properties;
}

-(void) addProperty:(NSString *) name value:(NSString *) value {

	[[self getProperties] setObject:value forKey:name];
}

-(void) replaceProperty:(NSString *) name value:(NSString *) value {

	[[self getProperties] setObject:value forKey:name];
}

-(void) removeProperty:(NSString *) name {

	[[self getProperties] removeObjectForKey:name];
}

-(void) removeAllProperties {

	[[self getProperties] removeAllObjects];
}

-(NSString *) getPropertyValue:(NSString *) name {

	return [[self getProperties] objectForKey:name];
}

-(void) dealloc {

	[_properties release];
	
	[super dealloc];
}

@end
