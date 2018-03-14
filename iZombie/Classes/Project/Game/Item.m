//
//  Avatar.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Item.h"

@implementation Item

-(id) init
{
    [super init];
    
    [self setName:@""];
    [self setThumbFilename:@""];
    [self setImageFilename:@""];
    [self setPrice:0];
    [self setOwn:NO];
    
    return self;
}

-(NSString *) getName
{
    return _name;
}

-(void) setName:(NSString *) name
{
    _name = name;
    [_name retain];
}

-(NSString *) getThumbFilename
{
    return _thumbFilename;
}

-(void) setThumbFilename:(NSString *) filename
{
    _thumbFilename = filename;
    [_thumbFilename retain];
}

-(NSString *) getImageFilename
{
    return _imageFilename;
}

-(void) setImageFilename:(NSString *) filename
{
    _imageFilename = filename;
    [_imageFilename retain];
}

-(NSInteger) getPrice
{
    return [_price intValue];
}

-(void) setPrice:(NSInteger) price
{
    _price = [NSNumber numberWithInt:price];
    [_price retain];
}

-(BOOL) isOwn
{
    if([_own intValue] == 0)
        return NO;
    
    return YES;
}

-(void) setOwn:(BOOL) own
{
    _own = [NSNumber numberWithInt:(own ? 1 : 0)];
    [_own retain];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	
	if( self != nil )
	{
		//decode properties, other class vars
		_name = [[decoder decodeObjectForKey:@"name"] retain];
		_thumbFilename = [[decoder decodeObjectForKey:@"thumbFilename"] retain];
        _imageFilename = [[decoder decodeObjectForKey:@"imageFilename"] retain];
        _price = [[decoder decodeObjectForKey:@"price"] retain];
        _own = [[decoder decodeObjectForKey:@"own"] retain];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	//Encode properties, other class variables, etc
	[encoder encodeObject:_name forKey:@"name"];
	[encoder encodeObject:_thumbFilename forKey:@"thumbFilename"];
    [encoder encodeObject:_imageFilename forKey:@"imageFilename"];
    [encoder encodeObject:_price forKey:@"price"];
    [encoder encodeObject:_own forKey:@"own"];
}

-(void) dealloc
{
    [_name release];
    [_thumbFilename release];
    [_imageFilename release];
    [_price release];
    [_own release];
    
    [[LogUtility getInstance] printMessage:@"Item - dealloc"];
    
    [super dealloc];
}

@end
