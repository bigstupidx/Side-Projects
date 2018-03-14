//
//  HudLayer.h
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-10.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleDPad.h"
#import "HealthBar.h"
#import "Score.h"

@interface HudLayer : CCLayer {
    
}

@property(nonatomic,weak)SimpleDPad *dPad;
@property(nonatomic,weak)HealthBar  *hBar;
@property(nonatomic,weak)Score *gScore;

@end
