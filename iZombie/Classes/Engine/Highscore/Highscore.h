//
//  Highscore.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Preferences.h"
#import "Score.h"

@class Highscore;

@interface Highscore : NSObject
{
    @private
    
}

+(Highscore *) getInstance; 

-(NSArray *) getScores;
-(void) saveScore:(Score *) score;
-(void) removeAllScores;

@end
