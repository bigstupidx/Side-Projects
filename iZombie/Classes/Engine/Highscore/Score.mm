//
//  Score.mm
//  Poppers
//
//  Created by Safiul Azam on 7/26/09.
//  Copyright 2009 None. All rights reserved.
//

#import "Score.h"


@implementation Score

- (id)initWithName:(NSString *) name :(NSNumber *) score
{
    [self initWithName:name :score :nil];
    
    return self;
}

- (id)initWithName:(NSString *) name :(NSNumber *) score :(NSString *) information {

	[super init];
	
	if(name == nil)
        name = @"";
    
	_name = name;
	_name = [_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([_name length] == 0)
        _name = @"Unknown";
    
	if(score < 0)
        score = 0;
    _score = score;
    
    _information = information;
	
	sorter = [_score intValue];
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	
	if( self != nil )
	{
		//decode properties, other class vars
		_name = [[decoder decodeObjectForKey:@"name"] retain];
		_score = [[decoder decodeObjectForKey:@"score"] retain];
        _information = [[decoder decodeObjectForKey:@"information"] retain];
		
		sorter = [_score intValue];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	//Encode properties, other class variables, etc
	[encoder encodeObject:_name forKey:@"name"];
	[encoder encodeObject:_score forKey:@"score"];
    [encoder encodeObject:_information forKey:@"information"];
}

- (NSString *) getName {

	return _name;
}

- (NSNumber *) getScore {

	return _score;
}

- (NSString *) getInformation {
    
	return _information;
}

- (void)dealloc {
	
	[[LogUtility getInstance] printMessage:@"Score - dealloc"];
	
	[super dealloc];
}

@end
