//
//  Audio.h
//

#import "SimpleIphoneAudio.h"
#import "ChannelSource.h"

@class SimpleIphoneAudio;
@class ChannelSource;

@interface Audio : NSObject {
	//Toggle
	bool sfxSetting;
	bool musicSetting;
	
	//Volume
	float sfxVolume;
	float musicVolume;
	
	//Other
	bool musicPlaying;
	NSString *musicKey;
	NSMutableDictionary *activeSounds;
}

//Properties
@property (nonatomic) bool sfxSetting;
@property (nonatomic) bool musicSetting;

@property (nonatomic) bool musicPlaying;
@property (nonatomic, retain) NSString *musicKey;

//Singleton

+ (Audio *)sharedAudio;

//Sound effects control

-(void) playSound: (NSString *) key;

-(void) playSound: (NSString *) key Loop: (bool) loop;

-(void) stopSound: (NSString *) key;

-(void) stopLoopSounds;

-(void) stopAllSounds;

//Music control

-(void) playMusic: (NSString *) key;

-(void) playMusic: (NSString *) key Loop:(bool) loop;

-(void) stopMusic;

-(void) fadeInMusic;

-(void) fadeOutMusic;

//General control

-(void) stopEverything;

//Settings

-(void) setMusicSetting: (bool) value;

-(bool) canPlayMusic;

-(void) suspendMusic;

-(void) resumeMusic;

-(void) setSFXSetting: (bool) value;

//Memory

-(void) freeCacheSFX;

@end