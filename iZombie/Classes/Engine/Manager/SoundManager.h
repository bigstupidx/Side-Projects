//
//  SoundManager.h
//  iEngine
//
//  Created by Safiul Azam on 7/13/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundEngine.h"

@class SoundManager;

@interface SoundManager : NSObject {

	@private
    NSInteger _index;
    UInt32 _identities[1024];
    NSMutableDictionary *_sounds;
    NSString *_musicFilename;
    BOOL _sound;
    BOOL _music;
    BOOL _vibrate;
}

+(SoundManager *) getInstance; 

-(BOOL) isSound;
-(void) setSound:(BOOL) sound;

-(void) loadSound:(NSString *) filename;
-(void) unloadSound:(NSString *) filename;

-(void) playSound:(NSString *) filename;
-(void) stopSound:(NSString *) filename;

-(BOOL) isMusic;
-(void) setMusic:(BOOL) music;

-(void) loadMusic:(NSString *) filename;
-(void) unloadMusic;

-(void) playMusic;
-(void) stopMusic;

-(BOOL) isVibrate;
-(void) setVibrate:(BOOL) vibrate;

-(void) vibrate;

-(void) tearDown;

@end
