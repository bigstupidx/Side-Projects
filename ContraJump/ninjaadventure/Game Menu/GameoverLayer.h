//
//  GameoverLayer.h
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-05.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//
#import <GameKit/GameKit.h>

#import "cocos2d.h"

@interface GameoverLayer : CCLayer{
    
}

- (void) setScore: (int) s;
- (void) saveScoreToGameCenter: (int) score;
@end
