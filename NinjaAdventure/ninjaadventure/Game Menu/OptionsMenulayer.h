//
//  OptionsMenulayer.h
//  Lightspeed
//
//  Created by Nelson Andre on 12-07-04.
//  Copyright (c) 2012 NetMatch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface OptionsMenuLayer : CCLayer
{    
    CCMenuItemImage * menuMusic;
    CCMenuItemImage * menuEffect;
    CCMenuItemImage * menuBack;
}

+(id) scene;

@end
