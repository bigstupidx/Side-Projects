//
//  HudLayer.m
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-10.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HudLayer.h"


@implementation HudLayer

-(id)init {
    if ((self = [super init])) {
        
        //Meng: show healthBar
       // _hBar = [HealthBar healthBarShow];
       // _hBar.position = ccp(210, 0);
       // [self addChild:_hBar];

        //Meng: show score
        _gScore = [Score scoreShow];
        _gScore.position = ccp(190, 390);
        [self addChild:_gScore];
        
    }
    return self;
}

@end
