//
//  Level.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogUtility.h"

@interface Level : NSObject
{
    @private
    NSString *_name;
    NSString *_tmxFilename;
    NSMutableArray *_zombieFilenames;
    NSInteger _maximumCountZombies;
    CGPoint _doorCenter;
}

+(NSMutableArray *) getInstances;
+(void) removeAllInstances;

-(NSString *) getName;
-(void) setName:(NSString *) name;

-(NSString *) getTMXFilename;
-(void) setTMXFilename:(NSString *) filename;

-(NSMutableArray *) getZombieFilenames;
-(void) setZombieFilenames:(NSMutableArray *) filenames;

-(NSInteger) getMaximumCountZombies;
-(void) setMaximumCountZombies:(NSInteger) count;

-(CGPoint) getDoorCenter;
-(void) setDoorCenter:(CGPoint) center;

@end
