//
//  Robot.h
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ActionSprite.h"

@interface Fruit : CCSprite {
    CCSprite* fruit_apple;
    int seconds_current;
    int seconds_last;
    int seconds_during;
}

@property(nonatomic,assign)float centerToSides_apple;
@property(nonatomic,assign)float centerToBottom_apple;
@property(nonatomic,assign)BoundingBox hitBox_apple;

@property(nonatomic,assign)Boolean fruitStatus; //Yes: fruit has not been eaten;  No: fruit has been eaten


-(void)appleDropInX: (int) applePositionX InY: (int) applePositionY;
-(void)eaten;
@end
