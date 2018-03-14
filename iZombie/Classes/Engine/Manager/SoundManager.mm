//
//  TextureManager.mm
//  iEngine
//
//  Created by Safiul Azam on 7/13/09.
//  Copyright 2009 None. All rights reserved.
//

#import "SoundManager.h"

static SoundManager *_soundManager = nil;

@implementation SoundManager

- (id) init 
{
	[super init];
    
    AudioSessionInitialize (NULL,NULL,NULL,NULL);
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    int audio_ret = AudioSessionSetProperty( kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    audio_ret |= AudioSessionSetActive(YES);
    
    SoundEngine_Initialize(44100);
    SoundEngine_SetEffectsVolume(1.0);
    SoundEngine_SetMasterVolume(1.0);
    
    _sounds = [[NSMutableDictionary alloc] init];
    
    _index = 0;
    
    _musicFilename = nil;
    
    _sound = YES;
    _music = YES;
    _vibrate = YES;
	
	return self;
}

+ (SoundManager *) getInstance 
{
	if(_soundManager == nil)
		_soundManager = [[SoundManager alloc] init];
	
	return _soundManager;
}

-(void) loadSound:(NSString *) filename
{
    NSString *extension = [filename pathExtension];
	
	NSString *address = [filename substringWithRange:NSMakeRange(0, [filename length] - ([extension length] + 1))];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:address ofType:extension];
    
    SoundEngine_LoadEffect([path UTF8String], &_identities[_index]);
    
    [_sounds setValue:[NSNumber numberWithInt:_index] forKey:filename];
    
    _index++;
}

-(void) unloadSound:(NSString *) filename
{
    NSNumber *identity = [_sounds objectForKey:filename];
    
    if(identity == nil)
        return;
    
    UInt32 index = [identity intValue];
    
    SoundEngine_UnloadEffect(_identities[index]);
    
    [_sounds removeObjectForKey:filename];
}

-(void) playSound:(NSString *) filename
{
    if(![self isSound])
        return;
    
    NSNumber *identity = [_sounds objectForKey:filename];
    
    if(identity == nil)
        return;
    
    UInt32 index = [identity intValue];
    
    SoundEngine_StartEffect(_identities[index]);
}

-(void) stopSound:(NSString *) filename
{
    NSNumber *identity = [_sounds objectForKey:filename];
    
    if(identity == nil)
        return;
    
    UInt32 index = [identity intValue];
    
    SoundEngine_StopEffect(_identities[index], YES);
}

-(BOOL) isSound
{
    return _sound;
}

-(void) setSound:(BOOL) sound
{
    _sound = sound;
}

-(BOOL) isMusic
{
    return _music;
}

-(void) setMusic:(BOOL) music
{
    _music = music;
    
    if(!_music)
        [self stopMusic];
}

-(void) loadMusic:(NSString *) filename
{
    if(_musicFilename != nil)
        [_musicFilename release];
    
    _musicFilename = filename;
    [_musicFilename retain];
    
    NSString *extension = [filename pathExtension];
	
	NSString *address = [filename substringWithRange:NSMakeRange(0, [filename length] - ([extension length] + 1))];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:address ofType:extension];
    
    SoundEngine_LoadBackgroundMusicTrack([path UTF8String], YES, YES);
}

-(void) unloadMusic
{
    _musicFilename = nil;
    
    SoundEngine_UnloadBackgroundMusicTrack();
}

-(void) playMusic
{
    if(![self isMusic])
        return;
    else if(_musicFilename == nil)
        return;
    
    [self stopMusic];
    
    NSString *filename = [NSString stringWithString:_musicFilename];
    [self loadMusic:filename];
    
    SoundEngine_StartBackgroundMusic();
}

-(void) stopMusic
{
    SoundEngine_StopBackgroundMusic(NO);
    SoundEngine_UnloadBackgroundMusicTrack();
}

-(BOOL) isVibrate
{
    return _vibrate;
}

-(void) setVibrate:(BOOL) vibrate
{
    _vibrate = vibrate;
}

-(void) vibrate
{
    if(![self isVibrate])
        return;
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

-(void) tearDown
{
    SoundEngine_Teardown();
}

- (void) dealloc 
{	
    if(_musicFilename != nil)
        [_musicFilename release];
    
    [self tearDown];
    
	[super dealloc];
}

@end
