//
//  SimpleDPad.m
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HealthBar.h"


@implementation HealthBar

+(id)healthBarShow{
    return [[self alloc] initHealthBar];
}

-(id)initHealthBar{
    if ((self = [super init])) {
        
        healthBar = [CCSprite spriteWithFile:@"ninjaHealth100.png"];
        healthBar.position = ccp(0,0);
        [self addChild:healthBar z:3];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)dt {
    
    if(gNinjaHitPoints_Last != gNinjaHitPoints_Current)
    {
        [self removeChild:healthBar cleanup:YES];
        
        healthBar = [CCSprite spriteWithFile:[NSString stringWithFormat:@"ninjaHealth%d.png", gNinjaHitPoints_Current]];
        healthBar.position = ccp(0,0);
        [self addChild:healthBar z:3];
        
        gNinjaHitPoints_Last = gNinjaHitPoints_Current;
    }
}


@end
