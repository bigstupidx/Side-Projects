//
//  GameoverLayer.h
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-05.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import "CCLayer.h"

@interface GameoverLayer : CCLayer{
    int highScore;
}

- (void) setScore: (int) s;
- (void) saveScoreToGameCenter;
@end
