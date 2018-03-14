//
//  Robot.m
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Fruit.h"
#import "Globals.h"
//#import "SimpleAudioEngine.h"

@implementation Fruit

-(id)init
{
    if ((self = [super init]))
    {
        [self appleInit];
    }
    return self;
}

-(void)appleInit
{
    self.centerToBottom_apple = 13.0;
    self.centerToSides_apple = 13.0;
    
    //Meng: get system time
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSString* str = [formatter stringFromDate:date];
    seconds_current = str.intValue;
    
    if(seconds_current==0)
    {
        seconds_last = 59;
    }
    else if(seconds_current>0)
    {
        seconds_last = seconds_current-1;
    }
    
    seconds_during=0;
    _fruitStatus=YES;
    
    //[[SimpleAudioEngine sharedEngine] playEffect:@"pd_botdeath.caf"];
}

-(void)appleDropInX: (int) applePositionX
                InY: (int) applePositionY
{
    // Create bounding boxes
    self.hitBox_apple = [self createBoundingBoxWithOrigin:ccp(applePositionX-self.centerToSides_apple, applePositionY-self.centerToBottom_apple) size:CGSizeMake(self.centerToSides_apple * 2, self.centerToBottom_apple * 2)];
    
    
    fruit_apple = [CCSprite spriteWithFile:@"fruit01.png"];
    fruit_apple.position = ccp(applePositionX,applePositionY);
    [self addChild:fruit_apple z:3];
    
    [self scheduleUpdate];
}

-(void)eaten
{
    [fruit_apple setTexture:[[CCTextureCache sharedTextureCache] addImage:@"fruit01_empty.png"]];
    
    if(gNinjaHitPoints_Current<100)
    {
        gNinjaHitPoints_Current +=10;
    }
    _fruitStatus=NO;
    //[[SimpleAudioEngine sharedEngine] playEffect:@"pd_botdeath.caf"];
}

-(BoundingBox)createBoundingBoxWithOrigin:(CGPoint)origin size:(CGSize)size {
    BoundingBox boundingBox;
    boundingBox.original.origin = origin;
    boundingBox.original.size = size;
    boundingBox.actual.origin = ccpAdd(position_, ccp(boundingBox.original.origin.x, boundingBox.original.origin.y));
    boundingBox.actual.size = size;
    return boundingBox;
}

-(void)update:(ccTime)dt
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ss"];
    
    NSString* str = [formatter stringFromDate:date];
    
    seconds_current = str.intValue;
    
    if(seconds_current!=seconds_last)
    {
        seconds_last = seconds_current;
        seconds_during++;
    }
    
    if(seconds_during==5)
    {
        fruit_apple.opacity = 100;
    }
    
    if(seconds_during==8)
    {
        [fruit_apple setTexture:[[CCTextureCache sharedTextureCache] addImage:@"fruit01_empty.png"]];
        _fruitStatus=NO;
        
        [self unscheduleUpdate];
    }
}

@end
