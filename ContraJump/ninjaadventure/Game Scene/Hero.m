//
//  Hero.m
//  ninjaAdventure1
//
//  Created by Meng Li on 2013-01-11.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Hero.h"
#import "SimpleAudioEngine.h"

@implementation Hero

-(id)init {
    if ((self = [super initWithSpriteFrameName:@"stand_1_1.png"])) {
        int i;
        
        //idle animation
        CCArray *idleFrames;
        CCAnimation *idleAnimation;
        //Meng: 0 degree
        idleFrames = [CCArray arrayWithCapacity:2];
        for (i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"stand_3_%d.png", i+1]];
            [idleFrames addObject:frame];
        }
        idleAnimation = [CCAnimation animationWithSpriteFrames:[idleFrames getNSArray] delay:1.0/8.0];
        self.idleAction_0_degree = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:idleAnimation]];
        
        //Meng: 45 degree
        idleFrames = [CCArray arrayWithCapacity:2];
        for (i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"stand_2_%d.png", i+1]];
            [idleFrames addObject:frame];
        }
        idleAnimation = [CCAnimation animationWithSpriteFrames:[idleFrames getNSArray] delay:1.0/8.0];
        self.idleAction_45_degree = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:idleAnimation]];
        
        //Meng: 90 degree
        idleFrames = [CCArray arrayWithCapacity:2];
        for (i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"stand_1_%d.png", i+1]];
            [idleFrames addObject:frame];
        }
        idleAnimation = [CCAnimation animationWithSpriteFrames:[idleFrames getNSArray] delay:1.0/8.0];
        self.idleAction_90_degree = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:idleAnimation]];
        
        /*
        // attack animation
        CCArray *attackFrames = [CCArray arrayWithCapacity:2];
        for (i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ninja_attackSword_%d.png", i+1]];
            [attackFrames addObject:frame];
        }
        CCAnimation *attackAnimation = [CCAnimation animationWithSpriteFrames:[attackFrames getNSArray] delay:1.0/12.0];
        self.attackAction = [CCSequence actions:[CCAnimate actionWithAnimation:attackAnimation], [CCCallFunc actionWithTarget:self selector:@selector(idle)], nil];
        */
        
        // walk animation
        CCArray *walkFrames;
        CCAnimation *walkAnimation;
        
        //Meng: 0 degree shooting
        walkFrames = [CCArray arrayWithCapacity:3];
        for (i = 0; i < 3; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"walk_3_%d.png", i+1]];
            [walkFrames addObject:frame];
        }
        walkAnimation = [CCAnimation animationWithSpriteFrames:[walkFrames getNSArray] delay:1.0/12.0];
        self.walkAction_0_degree_shoot = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnimation]];
        
        //Meng: 45 degree shooting        
        walkFrames = [CCArray arrayWithCapacity:3];
        for (i = 0; i < 3; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"walk_2_%d.png", i+1]];
            [walkFrames addObject:frame];
        }
        walkAnimation = [CCAnimation animationWithSpriteFrames:[walkFrames getNSArray] delay:1.0/12.0];
        self.walkAction_45_degree_shoot = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnimation]];
        
        //Meng: 90 degree shooting
        walkFrames = [CCArray arrayWithCapacity:3];
        for (i = 0; i < 3; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"walk_1_%d.png", i+1]];
            [walkFrames addObject:frame];
        }
        walkAnimation = [CCAnimation animationWithSpriteFrames:[walkFrames getNSArray] delay:1.0/12.0];
        self.walkAction_90_degree_shoot = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnimation]];
        
        /*
        //hurt animation
        CCArray *hurtFrames = [CCArray arrayWithCapacity:2];
        for (i = 0; i < 2; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ninja_hurt_%d.png", i+1]];
            [hurtFrames addObject:frame];
        }
        CCAnimation *hurtAnimation = [CCAnimation animationWithSpriteFrames:[hurtFrames getNSArray] delay:1.0/12.0];
        self.hurtAction = [CCSequence actions:[CCAnimate actionWithAnimation:hurtAnimation], [CCCallFunc actionWithTarget:self selector:@selector(idle)], nil];
        */
        
        /*
        //knocked out animation
        CCArray *knockedOutFrames = [CCArray arrayWithCapacity:3];
        for (i = 0; i < 3; i++) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ninja_die_%d.png", i+1]];
            [knockedOutFrames addObject:frame];
        }
        CCAnimation *knockedOutAnimation = [CCAnimation animationWithSpriteFrames:[knockedOutFrames getNSArray] delay:1.0/12.0];
        self.knockedOutAction = [CCSequence actions:[CCAnimate actionWithAnimation:knockedOutAnimation], [CCBlink actionWithDuration:2.0 blinks:10.0], nil];
         */
        
        
        self.centerToBottom = 39.0;
        self.centerToSides = 29.0;
        self.hitPoints = HEALTH_POINTS_HERO_NINJA;
        self.damage = DAMAGE_POINTS_HERO_NINJA;
        self.walkSpeed = WALKSPEED_HERO_NINJA;
        
        //Meng added.The two global variables below are used for showing Ninja Health Bar.
        gNinjaHitPoints_Last = HEALTH_POINTS_HERO_NINJA;
        gNinjaHitPoints_Current = HEALTH_POINTS_HERO_NINJA;
        
        //Meng added. This variables indicates how much scores does players get.
        gGameScore=0;
        gGameScore_Last=0;
        
        // Create bounding boxes
        self.hitBox = [self createBoundingBoxWithOrigin:ccp(-self.centerToSides, -self.centerToBottom) size:CGSizeMake(self.centerToSides * 2, self.centerToBottom * 2)];
        self.attackBox = [self createBoundingBoxWithOrigin:ccp(self.centerToSides, -10) size:CGSizeMake(80, 20)];
    }
    return self;
}

-(void)knockout {
    [super knockout];
    [[SimpleAudioEngine sharedEngine] playEffect:@"pd_herodeath.caf"];
}

@end
