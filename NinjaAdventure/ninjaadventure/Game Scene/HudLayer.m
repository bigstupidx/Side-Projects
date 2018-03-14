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
        //Draw a DPad
        _dPad = [SimpleDPad dPadWithFile:@"pd_dpad.png" radius:64];
        _dPad.position = ccp(64.0, 64.0);
        _dPad.opacity = 100;
        [self addChild:_dPad];
        
        //Meng: show healthBar
        _hBar = [HealthBar healthBarShow];
        _hBar.position = ccp(375, 10);
        [self addChild:_hBar];

        //Meng: show score
        _gScore = [Score scoreShow];
        _gScore.position = ccp(350, 280);
        [self addChild:_gScore];
        
    }
    return self;
}

@end
