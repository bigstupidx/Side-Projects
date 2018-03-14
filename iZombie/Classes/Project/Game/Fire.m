//
//  Avatar.m
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Fire.h"

static NSMutableArray *_fires = nil;

@implementation Fire
-(id) init
{
    [super init];
    
    [[Fire getInstances] addObject:self];
    
    return self;
}

-(id) initWithCoder:(NSCoder *) decoder
{
    [super initWithCoder:decoder];
    
    _flameFilename = [[decoder decodeObjectForKey:@"flameFilename"] retain];
    
    [[Fire getInstances] addObject:self];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:_flameFilename forKey:@"flameFilename"];
}

+(NSMutableArray *) getInstances
{
    if(_fires == nil)
        _fires = [[NSMutableArray alloc] init];
    
    return _fires;
}

+(void) removeAllInstances
{
    [_fires removeAllObjects];
    _fires = nil;
}

+(void) reset
{
    for(NSInteger i = 0; i < [[Fire getInstances] count]; i++)
    {
        Fire *fire = [[Fire getInstances] objectAtIndex:i];
        [fire setOwn:(i == 0)];
    }
}

+(void) save
{
    [[Preferences getInstance] setValue:_fires :KEY_FIRES];
}

-(NSString *) getFlameFilename
{
    return _flameFilename;
}

-(void) setFlameFilename:(NSString *) filename
{
    _flameFilename = filename;
    [_flameFilename retain];
}

-(void) dealloc
{
    [_flameFilename release];
    
    [[LogUtility getInstance] printMessage:@"Fire - dealloc"];
    
    [super dealloc];
}

@end
