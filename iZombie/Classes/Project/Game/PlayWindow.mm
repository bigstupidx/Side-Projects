//
//  PlayWindow.mm
//  iEngine
//
//  Created by Muhammed Safiul Azam on 11/6/09.
//  Copyright 2009 None. All rights reserved.
//

#import "PlayWindow.h"
#import <RevMobAds/RevMobAds.h>

static PlayWindow *_playWindow = nil;

static NSInteger ZOMBIE_MAXIMUM_COUNT = 5;
static NSInteger AREA_WIDTH = 0;
static NSInteger AREA_HEIGHT = 0;

@implementation PlayWindow

- (id) initWithFrame:(CGRect) frame :(PageBaseViewController *) viewController
{
	[super initWithFrame:frame];
    
    _baseViewController = viewController;
    
    [[DateTimeUtility getInstance] setCurrentTimeMillisecondsOffset:0];
    
    _stopMilliseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
    
    [self onPrepare];
    
    _running = NO;
    _saveScore = NO;
    _alertView = NO;
    
    _playWindow = self;
    
    _isLeftButtonTapped = NO;
    _isRightButtonTapped = NO;
    
    _nextZombieCreationTime = -1;
    _lastZombieCreationMilliseconds = -1;
    
    _messageAlpha = 0.0;
    
    _messageMilleseconds = -1;
    
    [self setMode:ModeNone];
    [self setMode:ModePlay];
    
    _level = [(NSNumber *) [[Preferences getInstance] getValue:KEY_PLAYER_LEVEL] intValue];
    Level *level = [[Level getInstances] objectAtIndex:_level];
    
    ZOMBIE_MAXIMUM_COUNT = [level getMaximumCountZombies];
    
    // Load in advance.
    for(int i = 1; i <= 10; i++)
    {
        NSString *filename = i <= 9 ? @"Death_0" : @"Death_";
        filename = [filename stringByAppendingString:[[NSNumber numberWithInt:i] stringValue]];
        filename = [filename stringByAppendingString:@".png"];
        [[TextureManager getInstance] getTexture:filename];
    }
    
    // TestFlight.
    NSString *checkPoint = @"Level ";
    checkPoint = [checkPoint stringByAppendingString:[[NSNumber numberWithInt:_level] stringValue]];
    //[TestFlight passCheckpoint:checkPoint];
    
	return self;
}

+(PlayWindow *) getInstance 
{
	return _playWindow;
}

+(void) destroyInstance
{
    [_playWindow release];
    _playWindow = nil;
}

- (void) onPrepare
{
    NSInteger index = [(NSNumber *)[[Preferences getInstance] getValue:KEY_PLAYER_LEVEL] integerValue];
    Level *level = (Level *) [[Level getInstances] objectAtIndex:index];
    
    NSString *tmxFilename = [level getTMXFilename];
    tmxFilename = [tmxFilename stringByAppendingString:@".tmx"];
    [tmxFilename retain];
    
    // Parse TMX.
    [[TMXUtility getInstance] loadFile:tmxFilename];
    
    NSString *backgroundFilename = [level getTMXFilename];
    backgroundFilename = [backgroundFilename stringByAppendingString:@"_Background.png"];
    if(backgroundFilename != nil)
    {
        [backgroundFilename retain];
        _backgroundTexture = [[TextureManager getInstance] getTexture:backgroundFilename];
    }
    
    // Background layer.
    _backgroundTileLayer = [[[TMXUtility getInstance] getTileLayers] objectAtIndex:0];
    [_backgroundTileLayer retain];
    CGFloat x = WINDOW_LEFT - [_backgroundTileLayer getPosition:CGPointMake(0, 0)].x;
    [_backgroundTileLayer setCenter:CGPointMake(x, [_backgroundTileLayer getCenter].y)];
    
    AREA_WIDTH = [_backgroundTileLayer getSize].width;
    AREA_HEIGHT = [_backgroundTileLayer getSize].height;
    
    PlayerBoundaryMinimum = WINDOW_LEFT + 75;
    PlayerBoundaryMaximum = WINDOW_LEFT + [_backgroundTileLayer getSize].width - 75;
    
    // Layer manager.
    _layerManager = [[LayerManager alloc] initWith:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)];
    [_layerManager addLayer:_backgroundTileLayer];
    
    // Create doors.
    TileMap *backgroundTileMap = [_backgroundTileLayer getTileMap];
    for(NSInteger i = 0; i < [backgroundTileMap getMapSize].height; i++)
    {
        for(NSInteger j = 0; j < [backgroundTileMap getMapSize].width; j++)
        {
            if(j == 0) continue;
            
            TileSprite *backgroundTileSprite = [_backgroundTileLayer getTileSprite:IndexMake(j, i)];
            FrameAnimation *backgroundTileAnimation = [backgroundTileSprite getActiveFrameAnimation];
            
            if([backgroundTileAnimation getFrame] == 1)
            {
                Door * door = [[Door alloc] initWithSize:CGSizeMake(DOOR_WIDTH, DOOR_HEIGHT)];
                
                for(NSInteger k = 1; k <= 2; k++)
                {
                    NSString *filename = @"Enter";
                    filename = [filename stringByAppendingString:@"_0"];
                    filename = [filename stringByAppendingString:[[NSNumber numberWithInt:k] stringValue]];
                    filename = [filename stringByAppendingString:@".png"];
                    
                    Texture *doorTexture = [[TextureManager getInstance] getTexture:filename];
                    FrameSet *doorFrameSet = [[[FrameSet alloc] initWithFirstFrameIndex:k :CGSizeMake(DOOR_WIDTH, DOOR_HEIGHT) :doorTexture] autorelease];
                    [door addFrameSet:doorFrameSet];
                }
                
                NSArray *doorSequence = [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];
                FrameAnimation *doorFrameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:doorSequence :250] autorelease];
                [door addFrameAnimation:doorFrameAnimation];
                
                CGPoint center = CGPointMake(0, 0);
                center.x += [_backgroundTileLayer getPosition:CGPointMake(0, 0)].x;
                center.x += (j * BACKGROUND_TILE_WIDTH) + [level getDoorCenter].x;
                center.y = [level getDoorCenter].y;               
                [door setCenter:center];
                
                [_layerManager addLayer:door];
            }
        }
    }
    
    // Zombies.
    _zombies = [[NSMutableArray alloc] init];
    
    // Create player.
    [self onCreatePlayer];
    
    // Create icons.
    _headIcon = [[Skeleton alloc] initWithSize:CGSizeMake(ICON_WIDTH, ICON_HEIGHT)];
    Texture *headIconTexture = [[TextureManager getInstance] getTexture:@"Icon_Head.png"];
    FrameSet *headIconFrameSet = [[[FrameSet alloc] initWithFirstFrameIndex:1 :CGSizeMake(ICON_WIDTH, ICON_HEIGHT) :headIconTexture] autorelease];
    [_headIcon addFrameSet:headIconFrameSet];
    NSArray *headIconSequence = [NSArray arrayWithObject:[NSNumber numberWithInt:1]];
    FrameAnimation *headIconFrameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:headIconSequence :-1] autorelease];
    [_headIcon addFrameAnimation:headIconFrameAnimation];
    CGFloat xCenter = -(WINDOW_WIDTH / 2) + (ICON_WIDTH / 2) + ICON_OFFSET;
    CGFloat yCenter = -(WINDOW_HEIGHT / 2) + (ICON_HEIGHT / 2) + ICON_OFFSET;
    [_headIcon setCenter:CGPointMake(xCenter, yCenter)];
    
    _lifeTexture = [[TextureManager getInstance] getTexture:@"Icon_Life.png"];
    _lifeMaximumTexutre = [[TextureManager getInstance] getTexture:@"Icon_Life_Maximum.png"];
    
    _fireIcon = [[Skeleton alloc] initWithSize:CGSizeMake(ICON_WIDTH, ICON_HEIGHT)];
    Texture *fireIconTexture = [[TextureManager getInstance] getTexture:@"Icon_Fire.png"];
    FrameSet *fireIconFrameSet = [[[FrameSet alloc] initWithFirstFrameIndex:1 :CGSizeMake(ICON_WIDTH, ICON_HEIGHT) :fireIconTexture] autorelease];
    [_fireIcon addFrameSet:fireIconFrameSet];
    NSArray *fireIconSequence = [NSArray arrayWithObject:[NSNumber numberWithInt:1]];
    FrameAnimation *fireIconFrameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:fireIconSequence :-1] autorelease];
    [_fireIcon addFrameAnimation:fireIconFrameAnimation];
    xCenter = 0;
    yCenter = -(WINDOW_HEIGHT / 2) + (ICON_HEIGHT / 2) + ICON_OFFSET;
    [_fireIcon setCenter:CGPointMake(xCenter, yCenter)];
    
    _font = [[Font alloc] initWithFilename:@"Font_Gill_Sans_Ultra_Bold.xml"];
	_text = [[Text alloc] initWithFont:_font :CGRectMake(-(WINDOW_WIDTH / 2), -(WINDOW_HEIGHT / 2), WINDOW_WIDTH, WINDOW_HEIGHT)];
    [_text setText:@"34"];
}

-(void) onCreatePlayer
{
    // Player.
    Player *player = [Player getInstance];
    
    [player setCenter:CGPointMake([_player getCenter].x, STREET_TOP)];
    
    [_layerManager addLayer:player];
    [_layerManager setFollow:player];
    [_layerManager setFollowArea:CGRectMake(WINDOW_LEFT, WINDOW_TOP, AREA_WIDTH, WINDOW_HEIGHT)];
    
    NSInteger level = [(NSNumber *)[[Preferences getInstance] getValue:KEY_PLAYER_LEVEL] integerValue];
    if(level == 0)
    {
        [player setMoney:0];
        [player setPoint:0];
    }
    else
    {
        NSInteger money = [(NSNumber *)[[Preferences getInstance] getValue:KEY_PLAYER_MONEY] integerValue];
        [player setMoney:money];
        
        NSInteger score = [(NSNumber *)[[Preferences getInstance] getValue:KEY_PLAYER_SCORE] integerValue];
        [player setPoint:score];
    }
}

-(void) onCreateZombie
{
    // Player.
    Zombie *zombie = [[Zombie alloc] initWithSize:CGSizeMake(150, 150)];
    
    NSInteger level = [(NSNumber *)[[Preferences getInstance] getValue:KEY_PLAYER_LEVEL] integerValue];
    NSArray *zombieFilenames = [(Level *) [[Level getInstances] objectAtIndex:level] getZombieFilenames];
    NSString *zombieFilename = [zombieFilenames objectAtIndex:[[MathUtility getInstance] getRandomNumber:[zombieFilenames count] - 1]];
    
    // Player frame set.
    for(int i = 1; i <= 6; i++)
    {
        NSString *filename = zombieFilename;
        filename = [filename stringByAppendingString:@"_0"];
        filename = [filename stringByAppendingString:[[NSNumber numberWithInt:i] stringValue]];
        filename = [filename stringByAppendingString:@".png"];
        
        Texture *texture = [[TextureManager getInstance] getTexture:filename];
        FrameSet *frameSet = [[[FrameSet alloc] initWithFirstFrameIndex:i :[texture getSize] :texture] autorelease];
        [zombie addFrameSet:frameSet];
    }
    
    // Zombie idle frame animation.
    NSMutableArray *idleSequence = [[[NSMutableArray alloc] init] autorelease];
    for(int i = 4; i <= 4; i++) [idleSequence addObject:[NSNumber numberWithInt:i]];
    FrameAnimation *idleFrameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:idleSequence :50] autorelease];
    [idleFrameAnimation setName:FRAME_ANIMATION_IDLE];
    [zombie addFrameAnimation:idleFrameAnimation];
    
    // Zombie walk frame animation.
    NSMutableArray *walkSequence = [[[NSMutableArray alloc] init] autorelease];
    for(int i = 1; i <= 6; i++) [walkSequence addObject:[NSNumber numberWithInt:i]];
    FrameAnimation *walkFrameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:walkSequence :50] autorelease];
    [walkFrameAnimation setName:FRAME_ANIMATION_WALK];
    [zombie addFrameAnimation:walkFrameAnimation];
    
    // Zombie hit frame animation.
    NSMutableArray *hitSequence = [[[NSMutableArray alloc] init] autorelease];
    for(int i = 1; i <= 6; i++) [hitSequence addObject:[NSNumber numberWithInt:i]];
    FrameAnimation *hitFrameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:hitSequence :50] autorelease];
    [hitFrameAnimation setName:FRAME_ANIMATION_HIT];
    [zombie addFrameAnimation:hitFrameAnimation];
    
    [zombie setHitPower:5];
    [zombie setMoney:5];
    [zombie setPoint:1];
    
    NSInteger x = [[Player getInstance] getCenter].x;
    
    if([self isCreateZombieOnLeft])
    {
        x -= WINDOW_WIDTH / 2 + [[MathUtility getInstance] getRandomNumber:WINDOW_WIDTH / 2];
        [zombie setDirection:DirectionRight];
    }
    else
    {
        x += WINDOW_WIDTH / 2 + [[MathUtility getInstance] getRandomNumber:WINDOW_WIDTH / 2];
        [zombie setDirection:DirectionLeft];
    }
    
    [zombie setCenter:CGPointMake(x, STREET_TOP)];
    
    [_layerManager addLayer:zombie];
    
    [zombie setState:StateWalk];
}

-(BOOL) isCreateZombieOnLeft
{
    //NSInteger MaximumZombieOnLeft = ceil(ZOMBIE_MAXIMUM_COUNT / 3);
    NSInteger MaximumZombieOnRight = ceil((ZOMBIE_MAXIMUM_COUNT * 2) / 3);
    
    NSInteger countZombieOnLeft = 0;
    NSInteger countZombieOnRight = 0;
    
    for(NSInteger i = 0; i < [[Zombie getInstances] count]; i++)
    {
        Zombie *zombie = [[Zombie getInstances] objectAtIndex:i];
        if([zombie getDirection] == DirectionRight)
            countZombieOnLeft++;
        else
            countZombieOnRight++;
    }
    
    if(MaximumZombieOnRight - countZombieOnRight > 0)
        return NO;
    
    return YES;
}

-(void) onZombies:(NSInteger) maximum
{
    // Create zombies.
    if([[DateTimeUtility getInstance] getCurrentTimeMilliseconds] - _lastZombieCreationMilliseconds >= _nextZombieCreationTime)
    {
        for(int i = 0; i < maximum - [[Zombie getInstances] count]; i++)
        {
            [self onCreateZombie];
            break;
        }
        
        _nextZombieCreationTime = [[MathUtility getInstance] getRandomNumber:ZOMBIE_CREATION_TIME_MINIMUM :ZOMBIE_CREATION_TIME_MAXIMUM];
        _lastZombieCreationMilliseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
    }
    
    for(int i = [[Zombie getInstances] count] - 1; i >= 0; i--)
    {
        Zombie *zombie = [[Zombie getInstances] objectAtIndex:i];
        [zombie artificialIntelligence];
        
        if(![zombie isAppear] && [_layerManager isInWindow:zombie])
            [zombie setAppear:YES];
        else if([zombie isAppear] && ![_layerManager isInWindow:zombie])
            [zombie setAppear:NO];
        
        BOOL isRemoveZombie = NO;
        
        // Only zombies on left.
        if([zombie getCenter].x < [[Player getInstance] getCenter].x)
        {
            NSInteger distance = abs([[Player getInstance] getCenter].x - [zombie getCenter].x);
            isRemoveZombie = distance > (WINDOW_WIDTH + WINDOW_WIDTH / 2) ? YES : NO;
        }
            
        if([zombie getLife] == 0 || (![zombie isAppear] && [zombie isPreviousAppear]) || isRemoveZombie)
        {
            // Remove after blood animation.
            if([zombie getCountChilds] == 0 || ![zombie isAppear])
            {
                if([_layerManager isInWindow:zombie])
                {
                    [self onCreateDeath:zombie];
            
                    // Get money and point.
                    [[Player getInstance] setPoint:[[Player getInstance] getPoint] + [zombie getPoint]];
                    
                    // 30% money by kill.
                    [[Player getInstance] setMoney:[[Player getInstance] getMoney] + [zombie getMoney] * 0.4];
                    
                    [self onCreateCoin:zombie];
                    
                    [[SoundManager getInstance] playSound:SOUND_DEATH];
                }
                    
                [_layerManager removeLayer:zombie];
                [zombie removeFromInstances];
                [zombie release];
            }
        }
    }
}

-(void) onCreateBlood:(Skeleton *) skeleton
{
    // Blood.
    Blood *blood = [[Blood alloc] initWithSize:CGSizeMake(150, 150)];
    
    // Blood frame set.
    for(int i = 1; i <= 3; i++)
    {
        NSString *filename = @"Blood_0";
        filename = [filename stringByAppendingString:[[NSNumber numberWithInt:i] stringValue]];
        filename = [filename stringByAppendingString:@".png"];
        
        Texture *texture = [[TextureManager getInstance] getTexture:filename];
        FrameSet *frameSet = [[[FrameSet alloc] initWithFirstFrameIndex:i :CGSizeMake(150, 150) :texture] autorelease];
        [blood addFrameSet:frameSet];
    }
    
    // Blood frame animation.
    NSMutableArray *idleSequence = [[[NSMutableArray alloc] init] autorelease];
    for(int i = 1; i <= 3; i++) [idleSequence addObject:[NSNumber numberWithInt:i]];
    FrameAnimation *frameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:idleSequence :100] autorelease];
    [blood addFrameAnimation:frameAnimation];
    
    if([skeleton getDirection] == DirectionLeft)
        [blood setFlip:FlipHorizontal];
    
    [skeleton addChild:blood];
    
    NSInteger height = [skeleton getSize].height * 0.75;
    NSInteger y = [[MathUtility getInstance] getRandomNumber:0 :height];
    y -= height / 2;
    
    [blood setCenter:CGPointMake([blood getCenter].x, y)];
}

-(void) onCreateDeath:(Skeleton *) skeleton
{
    // Death.
    Death *death = [[Death alloc] initWithSize:CGSizeMake(300, 300)];
    
    // Death frame set.
    for(int i = 1; i <= 10; i++)
    {
        NSString *filename = i <= 9 ? @"Death_0" : @"Death_";
        filename = [filename stringByAppendingString:[[NSNumber numberWithInt:i] stringValue]];
        filename = [filename stringByAppendingString:@".png"];
        
        Texture *texture = [[TextureManager getInstance] getTexture:filename];
        FrameSet *frameSet = [[[FrameSet alloc] initWithFirstFrameIndex:i :CGSizeMake(300, 300) :texture] autorelease];
        [death addFrameSet:frameSet];
    }
    
    // Death frame animation.
    NSMutableArray *idleSequence = [[[NSMutableArray alloc] init] autorelease];
    for(int i = 1; i <= 10; i++) [idleSequence addObject:[NSNumber numberWithInt:i]];
    FrameAnimation *frameAnimation = [[[FrameAnimation alloc] initWithFrameSequence:idleSequence :50] autorelease];
    [death addFrameAnimation:frameAnimation];
    
    if([skeleton getDirection] == DirectionLeft)
        [death setFlip:FlipHorizontal];
    
    [death setCenter:[skeleton getCenter]];
    [_layerManager addLayer:death];
}

-(void) onCreateCoin:(Zombie *) zombie
{
    Coin *coin = [[Coin alloc] initWithSize:CGSizeMake(72, 70)];
    [coin setMoney:[zombie getMoney] * 0.6];
    [coin setCenter:[zombie getCenter]];
    [_layerManager addLayer:coin];
}

-(void) onBloods
{
    for(int i = [[Blood getInstances] count] - 1; i >= 0; i--)
    {
        Blood *blood = [[Blood getInstances] objectAtIndex:i];
        
        if([[blood getActiveFrameAnimation] getFrameIndex] >= [[blood getActiveFrameAnimation] getCountFrameSequence] - 1)
        {
            Skeleton *parent = (Skeleton *) [blood getParent];
            [parent removeChild:blood];
            [blood removeFromInstances];
            [blood release];
        }
    }
}

-(void) onDeaths
{
    for(int i = [[Death getInstances] count] - 1; i >= 0; i--)
    {
        Death *death = [[Death getInstances] objectAtIndex:i];
        
        if([[death getActiveFrameAnimation] getFrameIndex] >= [[death getActiveFrameAnimation] getCountFrameSequence] - 1)
        {
            [_layerManager removeLayer:death];
            [death removeFromInstances];
            [death release];
        }
    }
}

-(void) onDoors
{
    for(int i = [[Door getInstances] count] - 1; i >= 0; i--)
    {
        Door *door = [[Door getInstances] objectAtIndex:i];
        
        if([door isUse] && ![door isVisible])
        {
            [_layerManager removeLayer:door];
            [door removeFromInstances];
            [door release];
        }
    }
}

-(void) onCreatePrize:(CGPoint) center
{
    Prize *prize = [[Prize alloc] initWithSize:CGSizeMake(ICON_WIDTH, ICON_HEIGHT) :_text];
    [prize setCenter:center];
    [_layerManager addLayer:prize];
}

-(void) onPrizes
{
    for(int i = [[Prize getInstances] count] - 1; i >= 0; i--)
    {
        Prize *prize = [[Prize getInstances] objectAtIndex:i];
        
        if([prize getAlpha] <= 0.0)
        {
            [_layerManager removeLayer:prize];
            [prize removeFromInstances];
            [prize release];
        }
    }
}

-(void) onCoins
{
    for(int i = [[Coin getInstances] count] - 1; i >= 0; i--)
    {
        Coin *coin = [[Coin getInstances] objectAtIndex:i];
        
        if(![coin isVisible])
        {
            [_layerManager removeLayer:coin];
            [coin removeFromInstances];
            [coin release];
        }
    }
}

-(BOOL) isExit
{
    CGPoint center = [[Player getInstance] getCenter];
    
    if(center.x >= WINDOW_LEFT + AREA_WIDTH - WINDOW_WIDTH / 2)
        return YES;
    
    return NO;
}

-(BOOL) isRunning
{
    return _running;
}

-(void) start
{
    if([self isRunning])
       return;
    
    long offset = _stopMilliseconds - [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
    offset += [[DateTimeUtility getInstance] getCurrentTimeMillisecondsOffset];
    [[DateTimeUtility getInstance] setCurrentTimeMillisecondsOffset:offset];
    
    [super start];
    
    _running = YES;
}

-(void) stop
{
    if(![self isRunning])
        return;
    
     _stopMilliseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
    
    [super stop];
    
    _running = NO;
}

-(void) pause
{
    [self stop];
    
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:1] :KEY_RESUME];
}

-(void) resume
{
    [self start];
    
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_RESUME];
}

-(void) onSaveScore
{
    bool axePurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"axe purchase"] boolValue];
    bool hammerPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"hammer purchase"] boolValue];
    bool chainsawPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"chainsaw purchase"] boolValue];
    bool machineGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"machinegun purchase"] boolValue];
    bool laserGunPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"laser purchase"] boolValue];
    bool everythingPurchased = [[[NSUserDefaults standardUserDefaults] valueForKey:@"everything purchase"] boolValue];
    
    
    if (axePurchased||hammerPurchased||chainsawPurchased||machineGunPurchased||laserGunPurchased||everythingPurchased)
    {
        //Meng: if player buys any weapon, then remove ads.
    }
    else
    {
        //[RevMobAds showPopupWithDelegate:nil];
    }
    
    NSArray *array = [[UIUtility getInstance] showAlertWithTextField:@"Your name?" :@"" :self :@"Cancel" :@"Ok" :YES];
    UIAlertView *alertView = [array objectAtIndex:0];
    _nameTextView = [array objectAtIndex:1];
    [_nameTextView retain];
    
    NSString *name = [[Preferences getInstance] getValue:KEY_PLAYER_NAME];
    if(name != nil)
        [_nameTextView setText:name];
    
    [alertView show];
    
    _alertView = YES;
}

-(void) onNextLevel
{
    PageMainViewController *pageMainViewController = (PageMainViewController *) [_baseViewController getParent];
    [pageMainViewController gotoPage:PageMenu parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
}

- (void)alertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if(buttonIndex == 1)
    {
        NSString *name = [_nameTextView text];
        [[Preferences getInstance] setValue:name :KEY_PLAYER_NAME];
        
        NSInteger point = [[Player getInstance] getPoint];
        [[Preferences getInstance] setValue:[NSNumber numberWithInt:point] :KEY_PLAYER_SCORE];
        
        NSString *date = [[DateTimeUtility getInstance] getDateTime:@"HH:mm"];
        
        Score *score = [[Score alloc] initWithName:name :[NSNumber numberWithInt:point] :date];
        [[Highscore getInstance] saveScore:score];
        [[GameKitHelper sharedGameKitHelper] submitScore:(int64_t)point category:@"zombie_kills"];

    }
    
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_RESUME];
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_PLAYER_LEVEL];
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_PLAYER_MONEY];
    [[Preferences getInstance] setValue:[NSNumber numberWithInt:0] :KEY_PLAYER_SCORE];
    
    PageMainViewController *pageMainViewController = (PageMainViewController *) [_baseViewController getParent];
    [pageMainViewController gotoPage:PageMenu parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
    
    _alertView = NO;
}

-(BOOL) isAlertView
{
    return _alertView;
}

-(void) playScream
{
    NSInteger random = [[MathUtility getInstance] getRandomNumber:1 :10];
    
    switch (random) {
        case 1:
            [[SoundManager getInstance] playSound:SOUND_SCREAM_01];
            break;
        case 2:
            [[SoundManager getInstance] playSound:SOUND_SCREAM_02];
            break;
        case 3:
            [[SoundManager getInstance] playSound:SOUND_SCREAM_03];
            break;
        case 4:
            [[SoundManager getInstance] playSound:SOUND_SCREAM_04];
            break;
        case 5:
            [[SoundManager getInstance] playSound:SOUND_SCREAM_05];
            break;
        case 6:
            [[SoundManager getInstance] playSound:SOUND_SCREAM_06];
            break;
        case 7:
            [[SoundManager getInstance] playSound:SOUND_SCREAM_07];
            break;
        case 8:
            [[SoundManager getInstance] playSound:SOUND_SCREAM_08];
            break;
        case 9:
            [[SoundManager getInstance] playSound:SOUND_SCREAM_09];
            break;
        case 10:
            [[SoundManager getInstance] playSound:SOUND_SCREAM_10];
            break;
        default:
            break;
    }
}

- (void) onCreateRenderer
{
    
}

- (void) onChangeRenderer
{
	
}

- (void) onDrawRenderer
{
	[self clear];
    
    if(_backgroundTexture != nil)
        [_backgroundTexture draw:CGPointMake(-WINDOW_WIDTH / 2, -WINDOW_HEIGHT / 2)];
    
    [_layerManager draw];
    
    if([self isExit] && [self getMode] != ModeSuccess)
        [self setMode:ModeSuccess];
    else if([[Player getInstance] getLife] <= 0 && [self getMode] != ModeFail)
        [self setMode:ModeFail];
    
    if([self getMode] == ModeSuccess || [self getMode] == ModeFail || [self getMode] == ModeMessage)
    {
        Color color;
        NSString *message;
        
        if([self getMode] == ModeSuccess)
        {   
            [[Player getInstance] moveRight];
            color = ColorMake(0.0, 0.0, 0.0, _messageAlpha += 0.025);
        }
        else
            color = ColorMake(1.0, 0.0, 0.0, _messageAlpha += 0.025);
        
        if(_messageAlpha >= 1.0)
        {
            _messageAlpha = 1.0;
            [self setMode:ModeMessage];
        }
        
        [[GraphicsUtility getInstance] drawRectangle:CGRectMake(WINDOW_LEFT, WINDOW_TOP, WINDOW_WIDTH, WINDOW_HEIGHT) :color];
        
        if([self getMode] == ModeMessage)
        {   
            message = PLAYER_EXIT_MESSAGE;
            
            // Level.
            if(_level == [[Level getInstances] count] - 1)
                message = GAME_COMPLETE_MESSAGE;
            
            if([self getPreviousMode] == ModeFail)
                message = PLAYER_DEAD_MESSAGE;
            
            [_text drawText:message :CGPointMake(0, -[_font getMaximumCharacterSize].height / 2) :AlignmentCenter];
            
            if(_messageMilleseconds < 0)
                _messageMilleseconds = [[DateTimeUtility getInstance] getCurrentTimeMilliseconds];
            else if([[DateTimeUtility getInstance] getCurrentTimeMilliseconds] - _messageMilleseconds > MESSAGE_TIME)
            {
                if([self getPreviousMode] == ModeSuccess)
                {
                    if(!_saveScore)
                    {
                        _saveScore = YES;
                        
                        if(_level < [[Level getInstances] count] - 1)
                        {
                            [[Preferences getInstance] setValue:[NSNumber numberWithInt:_level + 1] :KEY_PLAYER_LEVEL];
                    
                            [[Preferences getInstance] setValue:[NSNumber numberWithInt:[[Player getInstance] getMoney]] :KEY_PLAYER_MONEY];
                            [[Preferences getInstance] setValue:[NSNumber numberWithInt:[[Player getInstance] getPoint]] :KEY_PLAYER_SCORE];
                    
                            PageMainViewController *pageMainViewController = (PageMainViewController *) [_baseViewController getParent];
                            [pageMainViewController gotoPage:PageMarket parameters:[NSNumber numberWithInt:PageTransitionFadeIn]];
                            
                            // TestFlight.
                            NSString *checkPoint = @"Level ";
                            checkPoint = [checkPoint stringByAppendingString:[[NSNumber numberWithInt:_level] stringValue]];
                            checkPoint = [checkPoint stringByAppendingString:@" Success"];
                            //[TestFlight passCheckpoint:checkPoint];
                        }
                        else
                        {
                            [self onSaveScore];
                            
                            // TestFlight.
                            NSString *checkPoint = @"Level ";
                            checkPoint = [checkPoint stringByAppendingString:[[NSNumber numberWithInt:_level] stringValue]];
                            checkPoint = [checkPoint stringByAppendingString:@" Game Over"];
                            //[TestFlight passCheckpoint:checkPoint];
                        }
                    }
                }
                else if([self getPreviousMode] == ModeFail)
                {
                    if(!_saveScore)
                    {
                        _saveScore = YES;
                        [self onSaveScore];
                        
                        // TestFlight.
                        NSString *checkPoint = @"Level ";
                        checkPoint = [checkPoint stringByAppendingString:[[NSNumber numberWithInt:_level] stringValue]];
                        checkPoint = [checkPoint stringByAppendingString:@" Fail"];
                        //[TestFlight passCheckpoint:checkPoint];
                    }
                }
            }
        }
    }
    
    [_headIcon draw];
    [_fireIcon draw];
       
    
    // Draw life.
    CGFloat x = [_headIcon getCenter].x + [_headIcon getSize].width / 2 + ICON_OFFSET;
    CGFloat y = [_headIcon getCenter].y - [_lifeMaximumTexutre getSize].height / 2;
    [_lifeMaximumTexutre draw:CGPointMake(x, y)];
    
    if([[Player getInstance] getLife] > 0)
    {
        CGFloat life = [[Player getInstance] getLife];
        [_lifeTexture draw:CGPointMake(x, y) :CGRectMake(0, 0, life, [_lifeTexture getSize].height)];
    }
    
    // Draw money.
    NSInteger money = [[Player getInstance] getMoney];
    NSString *moneyString = @"$";
    moneyString = [moneyString stringByAppendingString:[[NSNumber numberWithInteger:money] stringValue]];
    NSInteger xMoney = (WINDOW_WIDTH / 2) - ICON_OFFSET;
    NSInteger yMoney = -(WINDOW_HEIGHT / 2) + ICON_OFFSET * 3 / 2;
    [_text drawText:moneyString :CGPointMake(xMoney, yMoney) :AlignmentRight];
    
    // Draw score.
    NSInteger score = [[Player getInstance] getPoint];
    NSString *scoreString = [[NSNumber numberWithInteger:score] stringValue];
    NSInteger xScore = (WINDOW_WIDTH / 2) - ICON_OFFSET;
    NSInteger yScore = -(WINDOW_HEIGHT / 2) + ICON_OFFSET * 3 / 2 + [_font getMaximumCharacterSize].height / 2 + ICON_OFFSET + 2;
    NSInteger fontSize = [_font getSize];
    [_font setResize:fontSize * 2 / 3];
    [_text drawText:scoreString :CGPointMake(xScore, yScore) :AlignmentRight];
    [_font setResize:fontSize];
    
    // Draw ammo.
    NSInteger ammo = [[Player getInstance] getAmmo];
    NSString *ammoString = @"";
    if(ammo <= 9) ammoString = [ammoString stringByAppendingString:@"0"];
    ammoString = [ammoString stringByAppendingString:[[NSNumber numberWithInteger:ammo] stringValue]];
    
    NSInteger xAmmo = [_fireIcon getCenter].x + ICON_OFFSET / 2;
    NSInteger yAmmo = [_fireIcon getCenter].y + ICON_OFFSET / 2;
    fontSize = [_font getSize];
    [_font setResize:fontSize * 2 / 3];
    [_text drawText:ammoString :CGPointMake(xAmmo, yAmmo)];
    [_font setResize:fontSize];
    
    [self onControls];
    
    [self onBloods];
    
    [self onDeaths];
    
    [self onDoors];
    
    [self onPrizes];
    
    [self onCoins];
    
    [self onZombies:ZOMBIE_MAXIMUM_COUNT];
    
}

-(Mode) getMode
{
    return _mode;
}

-(void) setMode:(Mode) mode
{
    [self setPreviousMode:[self getMode]];
    
    _mode = mode;
}

-(Mode) getPreviousMode
{
    return _previousMode;
}

-(void) setPreviousMode:(Mode) mode
{
    _previousMode = mode;
}

-(void) onControls
{
    if([self isExit])
        return;
    else if([[Player getInstance] getState] == StateDoorEnter || [[Player getInstance] getState] == StateDoorWait || [[Player getInstance] getState] == StateDoorPreExit || [[Player getInstance] getState] == StateDoorExit)
        return;
    
    if(_isLeftButtonTapped)
    {
        if([[Player getInstance] getCenter].x > PlayerBoundaryMinimum)
            [[Player getInstance] moveLeft];
    }
    else if(_isRightButtonTapped)
    {
        if([[Player getInstance] getCenter].x < PlayerBoundaryMaximum)
            [[Player getInstance] moveRight];
    }

    if(!_isLeftButtonTapped && !_isRightButtonTapped)
    {
        if([[Player getInstance] getState] == StateWalk)
            [[Player getInstance] setState:StateIdle];
    }
    
}

-(void) leftButtonTapped
{
    _isLeftButtonTapped = YES;
    
    
    [self rightButtonReleased];
}

-(void) leftButtonReleased
{
    _isLeftButtonTapped = NO;
}

-(void) rightButtonTapped
{
    _isRightButtonTapped = YES;
    
    [self leftButtonReleased];
}

-(void) rightButtonReleased
{
    _isRightButtonTapped = NO;
}

-(void) fireButtonTapped
{
    if([self getMode] == ModeSuccess || [self getMode] == ModeFail || [self getMode] == ModeMessage)
        return;
    else if([[Player getInstance] getState] == StateDoorEnter || [[Player getInstance] getState] == StateDoorWait || [[Player getInstance] getState] == StateDoorPreExit || [[Player getInstance] getState] == StateDoorExit)
        return;
    
    [[Player getInstance] fire];
    
    //[self leftButtonReleased];
    //[self rightButtonReleased];
}

-(void) hitButtonTapped
{
    if([self getMode] == ModeSuccess || [self getMode] == ModeFail || [self getMode] == ModeMessage)
        return;
    else if([[Player getInstance] getState] == StateDoorEnter || [[Player getInstance] getState] == StateDoorWait || [[Player getInstance] getState] == StateDoorPreExit || [[Player getInstance] getState] == StateDoorExit)
        return;
    
    [[Player getInstance] hit];
    
    //[self leftButtonReleased];
    //[self rightButtonReleased];
}

- (void) onTouchesBegin:(NSArray *) positions :(NSInteger) count;
{
    for(NSInteger i = 0; i < [positions count]; i++)
    {
        CGPoint position = [(NSNumber *) [positions objectAtIndex:i] CGPointValue];
        position.x += [_layerManager getWindow].origin.x;
        position.y += [_layerManager getWindow].origin.y;
        
        for(NSInteger j = 0; j < [[Door getInstances] count]; j++)
        {
            Door *door = [[Door getInstances] objectAtIndex:j];
            if(![door isUse])
            {
                if([[Player getInstance] isCollideDoor:door] && [door isTouchWith:position])
                {
                    if([[Player getInstance] getState] != StateDoorEnter && [[Player getInstance] getState] != StateDoorWait && [[Player getInstance] getState] != StateDoorPreExit && [[Player getInstance] getState] != StateDoorExit)
                    {
                        [door setUse:YES];
                        [[Player getInstance] setState:StateDoorEnter];
                    }
                }
            }
            else
            {
                if([[Player getInstance] isCollideDoor:door] && [door isTouchWith:position])
                {
                    if([[Player getInstance] getState] == StateDoorPreExit)
                    {
                        [door setVisible:NO];
                        [[Player getInstance] setState:StateDoorExit];
                    }
                }
            }
        }
    }
}

- (void) onTouchesMove:(NSArray *) positions :(NSInteger) count
{
}

- (void) onTouchesEnd:(NSArray *) positions :(NSInteger) count
{
}

- (void) dealloc 
{
    [_font release];
    [_text release];
    
    [_layerManager release];
    
    [_backgroundTileLayer release];
    
    [Player destroyInstance];
    [Blood destroyInstances];
    [Death destroyInstances];
    [Zombie destroyInstances];
    [Door destroyInstances];
    [Prize destroyInstances];
    
    [[LogUtility getInstance] printMessage:@"PlayWindow - dealloc"];
    
    [super dealloc];
}

@end
