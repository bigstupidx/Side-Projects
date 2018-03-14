//
//  SimpleDPad.h
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Globals.h"

@interface Score : CCSprite {
    CCSprite *scoresValue;
    CCSprite *highScoresValue;
    BOOL celebrateState;
}

+(id)scoreShow;
-(id)initScore;

@end
