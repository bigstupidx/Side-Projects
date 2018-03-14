//
//  Audio.m
//  

#import "Audio.h"
#import "SimpleIphoneAudio.h"
#import "IphoneAudioSupport.h"
#import "ChannelSource.h"

#define PRELOAD_EFFECTS 1
#define DEFAULT_VOLUME 1.0
#define MIN_VOLUME 0.0

@implementation Audio

@synthesize musicPlaying;
@synthesize musicKey;

#pragma mark Singleton implementation

static Audio *sharedAudioInstance = nil;

+ (Audio *)sharedAudio
{
    @synchronized(self)
	{
        if (sharedAudioInstance == nil) {
            sharedAudioInstance = [[self alloc] init];
        }
    }

    return sharedAudioInstance;
}
 
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
	{
        if (sharedAudioInstance == nil) {
            sharedAudioInstance = [super allocWithZone:zone];
            return sharedAudioInstance;  // assignment and return on first allocation
        }
    }

    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release
{
    // do nothing
}

- (id)autorelease
{
    return self;
}

#pragma mark Instance management

@synthesize sfxSetting;
@synthesize musicSetting;

-(id) init {
	if (self = [super init]) {
		activeSounds = [[NSMutableDictionary alloc] init];
		
		//Set default preferences
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		if (![userDefaults objectForKey:@"optionMusic"]) {
			[userDefaults setBool:YES forKey:@"optionMusic"];
			[userDefaults synchronize];
		}
		if (![userDefaults objectForKey:@"optionSFX"]) {
			[userDefaults setBool:YES forKey:@"optionSFX"];
			[userDefaults synchronize];
		}
		
		//Default volume
		sfxVolume = DEFAULT_VOLUME;
		musicVolume = DEFAULT_VOLUME;
		
		//Read recorded preferences
		musicSetting = [userDefaults boolForKey:@"optionMusic"];
		sfxSetting = [userDefaults boolForKey:@"optionSFX"];
		
		//General options
        [SimpleIphoneAudio sharedInstance].allowIpod = YES;
        [SimpleIphoneAudio sharedInstance].honorSilentSwitch = YES;
		[SimpleIphoneAudio sharedInstance].effectsVolume = sfxVolume;
		[SimpleIphoneAudio sharedInstance].bgVolume = musicVolume;
		
#if PRELOAD_EFFECTS        
		//Get file manager
		NSFileManager *fileManager=[[NSFileManager alloc] init];
		NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath: [[NSBundle mainBundle] resourcePath]];
		
		//Enumerate files
		NSString *filename;
		while (filename = [directoryEnumerator nextObject]) {
			//Is it a sound file
			if ([filename rangeOfString: @".wav"].location != NSNotFound )
				[[SimpleIphoneAudio sharedInstance] preloadEffect: filename];
		}
		//Release file manage
		[fileManager release];
#endif
	}
	
	//Return object
	return self;
}

#pragma mark Sound effects control

-(void) playSound: (NSString *) key {
	[self playSound: key Loop: FALSE];
}

-(void) playSound: (NSString *) key Loop: (bool) loop {
	if (!sfxSetting)
		return;
	
	//Get loopsound
	id crtSound = [[SimpleIphoneAudio sharedInstance] playEffect: [NSString stringWithFormat: @"%@.wav", key] loop: loop];
	
	//Add loopsound to dictionary
	[activeSounds setObject: crtSound forKey: key];	
}

-(void) stopSound: (NSString *) key {
	if (!sfxSetting)
		return;
	
	if ([activeSounds objectForKey: key] != nil)
		[[activeSounds objectForKey: key] stop];
}

-(void) stopLoopSounds {
	if (!sfxSetting)
		return;
	
	[[SimpleIphoneAudio sharedInstance] stopLoopingEffects];
}

-(void) stopAllSounds {
	if (!sfxSetting)
		return;
	
	[[SimpleIphoneAudio sharedInstance] stopAllEffects];
}

#pragma mark Music control

-(void) playMusic: (NSString *) key {
	[self playMusic: key Loop: FALSE];
} 

-(void) playMusic:(NSString *)key Loop:(bool) loop {	
	//Save music play state for resume
	self.musicPlaying = TRUE;
	self.musicKey = key;
	
	if (!musicSetting)
		return;
	
	//Play background music
	[[SimpleIphoneAudio sharedInstance] playBg: [NSString stringWithFormat: @"%@.mp3", key] loop: loop];
	
	//Volume
	musicVolume = DEFAULT_VOLUME;
}

-(void) stopMusic {
	//Save music play state for resume
	self.musicPlaying = FALSE;
	self.musicKey = nil;

	if (!musicSetting)
		return;

	//Stop background music
	[[SimpleIphoneAudio sharedInstance] stopBg];
	
	//Volume
	musicVolume = DEFAULT_VOLUME;
}

-(void) fadeInMusic {
	/*
	 
	if (!musicSetting)
		return;
	
	if (self.musicPlaying) {
		//Increment volume
		musicVolume += 0.05;
		
		//Finish fade
		if (musicVolume >= DEFAULT_VOLUME) {
			musicVolume = DEFAULT_VOLUME;
		} else {
			[self performSelector:@selector(fadeInMusic) withObject:nil afterDelay:0.10];
		}
		
		//Apply volume
		[SimpleIphoneAudio sharedInstance].bgVolume = musicVolume;
	}
	 
	 */
}

-(void) fadeOutMusic {
	/*
	 
	if (!musicSetting)
		return;
	
	if (self.musicPlaying) {
		//Decrement volume
		musicVolume -= 0.05;
		
		//Finish fade
		if (musicVolume <= MIN_VOLUME) {			
			//Stop music
			[self stopMusic];
		} else {
			[self performSelector:@selector(fadeOutMusic) withObject:nil afterDelay:0.10];
		}
		
		//Apply volume
		[SimpleIphoneAudio sharedInstance].bgVolume = musicVolume;
	}
	 
	*/
}

-(void) stopEverything {
	//Flags
	self.musicPlaying = FALSE;
	self.musicKey = nil;	
	
	[[SimpleIphoneAudio sharedInstance] stopEverything];
}

#pragma mark Sound settings

-(void) setSFXSetting: (bool) value {
	//Save state
	sfxSetting = value;
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool: sfxSetting forKey: @"optionSFX"];
	[userDefaults synchronize];
	
	//Stop sounds
	if (value == FALSE)
		[[SimpleIphoneAudio sharedInstance] stopAllEffects];
}

-(void) setMusicSetting: (bool) value {
	//Save state
	musicSetting = value;
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool: musicSetting forKey: @"optionMusic"];
	[userDefaults synchronize];
	
	//Stop background
	if (value == FALSE)
		[[SimpleIphoneAudio sharedInstance] stopBg];
}

-(bool) canPlayMusic {
	return (![IphoneAudioSupport sharedInstance].ipodPlaying);
}

-(void) suspendMusic {
	//Turn off music setting, but do not save in user defaults
	musicSetting = FALSE;
	[[SimpleIphoneAudio sharedInstance] stopBg];
	
	//Turn off hardware setting so that iPod player can be started if necessary
	[SimpleIphoneAudio sharedInstance].useHardwareIfAvailable = NO;
}

-(void) resumeMusic {
	//Try to get background music to use hardware decoders (it will use software decoder if iPod is playing)
	[SimpleIphoneAudio sharedInstance].useHardwareIfAvailable = YES;
	
	//Restore music setting
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	musicSetting = [userDefaults boolForKey:@"optionMusic"];
	if (![self canPlayMusic]) {
		musicSetting = FALSE;
	}
	
	//DebugLog(@"%s musicSetting = %d, musicPlaying = %d", __PRETTY_FUNCTION__, musicSetting, musicPlaying);
	
	if (musicSetting == TRUE && musicPlaying == TRUE) {
		[[SimpleIphoneAudio sharedInstance] playBg: [NSString stringWithFormat: @"%@.mp3", musicKey] loop: TRUE];
	}
}

#pragma mark Memory

-(void) freeCacheSFX {
	SimpleIphoneAudio *simpleIphoneAudio = [SimpleIphoneAudio sharedInstance];
	
	//DebugLog(@"%s preloadCache count = %d, size = %d", __PRETTY_FUNCTION__, [simpleIphoneAudio preloadCacheCount], [simpleIphoneAudio preloadCacheSize]);
	
	[simpleIphoneAudio setPreloadCacheEnabled:NO];
	[simpleIphoneAudio setPreloadCacheEnabled:YES];
}

@end
