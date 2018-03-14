//
//  Preferences.mm
//
//  Created by Safiul Azam on 8/26/09.
//  Copyright 2009 None. All rights reserved.
//

#import "Preferences.h"

static Preferences *_preferences = nil;

@implementation Preferences

- (id) init 
{
	[super init];
		
	return self;
}

+ (Preferences *) getInstance 
{
	if(_preferences == nil)
		_preferences = [[Preferences alloc] init];
	
	return _preferences;
}

- (id) getValue:(NSString *) key {
	
	NSData *object = [[NSUserDefaults standardUserDefaults] objectForKey:(NSString *) key];
	
	return [NSKeyedUnarchiver unarchiveObjectWithData:object];
}

- (void) setValue:(id) value :(NSString *) key {

	NSData *data = (NSData *) [NSKeyedArchiver archivedDataWithRootObject:value];
	
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) removeValue:(NSString *) key {

	[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) dealloc 
{
	[super dealloc];
}

@end
