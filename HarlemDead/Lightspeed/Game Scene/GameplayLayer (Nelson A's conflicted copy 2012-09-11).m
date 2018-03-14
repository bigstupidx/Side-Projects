#import "GameplayLayer.h"
#import "Globals.h"
#import "PauseScene.h"
#import "MenuScene.h"
#import "RestartScene.h"
#import "MultiGameOverScene.h"

#import "GameoverLayer.h"

#import <mach/mach_time.h>

#import "SimpleAudioEngine.h"

#import "AdsManager.h"

//------------------------------- Nextpeer SDK ---------------------------------//
// STEP2 - PART 1
// Nextpeer: Be sure to include the main Nextpeer header
#import "Nextpeer/Nextpeer.h"
//------------------------------------------------------------------------------//

#define RANDOM_SEED() srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF))

@interface GameplayLayer (Private) <UIAlertViewDelegate>

-(void)constructLayer;

- (void)initEnemies;
- (void)resetEnemies;
- (void)resetScore;

-(void) sendTop:(CCNode*) node;

- (void)addExplosionAtPosition:(CGPoint)explosionPoint;
- (void)addBlindingStarAtPosition:(CGPoint)starPoint;
- (void)gotBlindingStar:(NSNotification *)notification;

- (void)updateScoreTo:(NSUInteger)newScore;
- (void)updateShieldsTo:(NSUInteger)newShields;
- (void)decreaseShields;
- (void)increaseFuel;

- (void)initFishBonus;
- (void)resetFishBonus;

- (void)initSharkBonus;
- (void)resetSharkBonus;

- (void)resetPlayer;

- (void)startGame;
- (void)finishGameWithMenu;
- (void)finishGame;

- (void)jump;

- (void)update:(ccTime)dt;
- (void)incScore:(ccTime)dt;
-(void) incScoreBy: (int) value;
- (void)decFuel:(ccTime)dt;

@end


@implementation GameplayLayer

#define kFPS 60

#define kNumClouds			14
#define kNumPlatforms		10

#define kNumMaxSharksInGame	2
#define kMinPlatformStep	50
#define kMaxPlatformStep	300
#define kPlatformTopPadding 5

#define kSpriteManager 1001
#define kPlayerTag 1002
#define kScoreLabel 1003

#define kCloudsStartTag 2001
#define kPlatformsStartTag 3001 
#define kFishBonusStartTag 4001
#define kSharkBonusStartTag 5001

#define kMinFishStep	15

//(these sizes are percentages of the screen width)
#define MAINSHIP_SIZE 0.15f
#define FUELBAR_SIZE 0.6f
#define SMALL_ENEMY_SIZE 0.10f
#define SMALL_ENEMY_SIZE_VARIATION 0.02f
#define LARGE_ENEMY_SIZE 0.2f
#define POWERUP_SIZE 0.08f

#define LARGE_ENEMY_SPEED 20.0f
#define LARGE_ENEMY_SPEED_VARIATION 5.0f

#define SMALL_ENEMY_SPEED 40.0f
#define SMALL_ENEMY_SPEED_VARIATION 20.0f

#define POWERUP_SPEED   30.0f
#define POWERUP_SPEED_VARIATION 5.0f

#define FUEL_POINT_BONUS 50

#define SMALL_ENEMY_TAG 12
#define LARGE_ENEMY_TAG 13
#define POWERUP_TAG 14

#define kLargeEnemyCount 2
#define kSmallEnemyCount 4

#define kCollisionArea 30


#pragma mark -
#pragma mark Public Callbacks

-(id) init
{
	if ((self=[super init]) ) {
		
		RANDOM_SEED();
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(gotBlindingStar:) name: NOTIFICATION_GOT_BLIND_ATTACK object: nil];
	}
	
    _maxNumberOfClouds = kNumClouds;
    _maxNumberOfPlatforms = kNumPlatforms;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _maxNumberOfClouds *= 2;
        _maxNumberOfPlatforms *= 2;
    }
    
	[self constructLayer];
	[self startGame];
    
    
    if (![Nextpeer isCurrentlyInTournament])
        [[AdsManager sharedAdsManager] startBannerAd];
	return self;
}

-(void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[super dealloc];
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}


#pragma mark -
#pragma mark Private Callbacks

-(void)constructLayer {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //initialize the manager of the sprites and set the position to be zero
    //this is what we use to keep track of the sprites positions
    spriteManager = [CCNode node];
	[spriteManager setPosition:ccp(0,0)];
    [self addChild:spriteManager z:4 tag:kSpriteManager];
    
    
    
    //create the fuel bar border
    CCSprite* fuelBorder = [CCSprite spriteWithFile:@"EmptyBar.png"];
    [self addChild:fuelBorder z:11 tag:-5];
    
    
    //add the fuel bar to the border
    fuelBar = [CCProgressTimer progressWithFile:@"BlueBar.png"];
    fuelBar.type = kCCProgressTimerTypeHorizontalBarLR;
    fuelBar.percentage = 100.0;
    
    [self addChild:fuelBar z:10 tag:1];
    
    [fuelBorder setScale:(winSize.width*FUELBAR_SIZE)/([fuelBorder contentSize].width)];
    [fuelBar setScale:(winSize.width*FUELBAR_SIZE)/([fuelBar contentSize].width)];
    
    CGPoint fuelBarPos = ccp(winSize.width*0.3f, winSize.height*0.03f);
    [fuelBorder setPosition:fuelBarPos];
    [fuelBar setPosition:fuelBarPos];
	
	actor = [CCSprite spriteWithFile:@"spaceship.png"];
	
    //scale to match window size
    [actor setScale:(winSize.width*MAINSHIP_SIZE)/([actor contentSize].width)];

    [self addChild:actor];
    
    
    
    
    [self initEnemies];
    [self initPowerups];
    
	int labelFontSize = 20;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        labelFontSize = 30;
    }
    scoreLabel = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"futurafont.ttf" fontSize:labelFontSize];
    [self addChild:scoreLabel z:5];
    scoreLabel.position = ccp(winSize.width*0.25,winSize.height*0.85);

    shieldLabel = [CCLabelTTF labelWithString:@"Shields: 5" fontName:@"futurafont.ttf" fontSize:labelFontSize];
    [self addChild:shieldLabel z:5];
    shieldLabel.position = ccp(winSize.width*0.75,winSize.height*0.85);
    	
	[self schedule:@selector(update:)];
	
    //increase the score twice a second
    [self schedule:@selector(incScore:) interval:0.1];
    
    [self schedule:@selector(decFuel:) interval:0.1];
    
	self.isTouchEnabled = YES;
	self.isAccelerometerEnabled = YES;
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kFPS)];
}
-(void) initEnemies{
    
    enemyArray = [[CCArray alloc] initWithCapacity:30];
   
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    for(int i = 1; i<=4;i++)
    {
        CCSprite* enemySprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"enemys%d.png", i]];
        enemySprite.tag = SMALL_ENEMY_TAG;
        [enemySprite setScale:(winSize.width*SMALL_ENEMY_SIZE ) /([enemySprite contentSize].width)];
        [enemyArray addObject:enemySprite];
        [self addChild:enemySprite];
        
        
    }
    
    for(int i = 1; i<=2;i++)
    {
        NSString* fileName = [NSString stringWithFormat:@"enemyl%d.png", i];
        CCSprite* enemySprite = [CCSprite spriteWithFile:fileName];
        enemySprite.tag = LARGE_ENEMY_TAG;
        [enemySprite setScale:(winSize.width*LARGE_ENEMY_SIZE)/([enemySprite contentSize].width)];
        [enemyArray addObject:enemySprite];
        [self addChild:enemySprite];
    }
}

-(void) initPowerups{
    
    powerupArray = [[CCArray alloc] initWithCapacity:30];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //add the two powerups
    CCSprite* bonus1 = [CCSprite spriteWithFile:@"bonus1.png"];
    CCSprite* bonus2 = [CCSprite spriteWithFile:@"bonus2.png"];
    bonus1.tag = POWERUP_TAG;
    bonus2.tag = POWERUP_TAG;
    [powerupArray addObject:bonus1];
    [powerupArray addObject:bonus2];
    [bonus1 setScale:(winSize.width*POWERUP_SIZE)/([bonus1 contentSize].width)];
    [bonus2 setScale:(winSize.width*POWERUP_SIZE)/([bonus2 contentSize].width)];
    [self addChild:bonus1];
    
    [self addChild:bonus2];
}


-(void) resetPowerups {
    
    CCSprite* powerup;
    CCARRAY_FOREACH(powerupArray, powerup)
    {
        //[powerup stopAllActions];
        //id tintRed = [CCTintBy actionWithDuration:0.2 red:-200 green:-100 blue:-100];
        //id tintBack = [tintRed reverse];
        
        //CCSequence* flashSeq = [CCSequence actions:tintRed,tintBack, nil];
        //CCRepeat* repeatFlash = [CCRepeatForever actionWithAction:flashSeq];
        
        //[powerup runAction:repeatFlash];
        
        [self sendTop:powerup];
    }
}

-(void) resetEnemies {

    CCSprite* enemySprite;
    CCARRAY_FOREACH(enemyArray, enemySprite)
    {
        [self sendTop:enemySprite];
    }
}

#pragma mark -
#pragma mark Game Handling Callbacks

- (void)startGame {
	gGameSuspended = NO;
    _ee_platform = FALSE; // once per game
	
	_isMultiplayerGame = [Nextpeer isCurrentlyInTournament];
	gameOver = false;
    [self resetEnemies];
	[self resetPlayer];
    [self resetPowerups];
	[self resetScore];
	
	//if (_isMultiplayerGame)
	//	[self resetSharkBonus];
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)gameShouldFinish {
	gGameShouldEndAndRetun = TRUE;
	gGameSuspended = FALSE;
}

//the player has died

- (void)finishGameWithMenu {
	
	// If the game is in tournament then don't go to game over screen simply decrease score and blow up
	if (_isMultiplayerGame) {
        if (actor.opacity > 0)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"GameOver.mp3"];
            [actor setOpacity:0];//set to invisible
            [actor removeAllChildrenWithCleanup:TRUE];//remove the flame
            
            //add an explosion
            CCParticleExplosion* explosion = [CCParticleExplosion node];
            
            explosion.startSize = 2.0f;
            CGPoint expPos = ccp(actor.boundingBox.size.width/2,actor.boundingBox.size.height/2);
            
            
            [explosion setPosition:expPos];
            [actor addChild:explosion];
            
            explosion.startColor = ccc4FFromccc4B(ccc4(230, 150, 50, 230));
            explosion.endColor = ccc4FFromccc4B(ccc4(100, 0, 0, 200));
            explosion.startColorVar = ccc4FFromccc4B(ccc4(20, 100, 0, 0));
            explosion.endColorVar = ccc4FFromccc4B(ccc4(5, 5, 5, 0));
            explosion.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
            explosion.speed = 30.0;
            explosion.speedVar = 15.0;
            explosion.life = 1.0;
            explosion.lifeVar = 0.2;
            explosion.autoRemoveOnFinish = YES;
            
            id resetPlayAction = [CCCallFunc actionWithTarget:self selector:@selector(resetPlayer)];
            
            CCSequence* resetSeq = [CCSequence actions:[CCActionInterval actionWithDuration:1.0], resetPlayAction, nil];
            
            [self runAction:resetSeq];
            [self incScoreBy:-500];
            
            id tintBy = [CCTintTo actionWithDuration:0.5 red:255 green:0 blue:0];
            id tintBack = [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255];
            
            CCSequence* tintSeq = [CCSequence actions:tintBy, tintBack, nil];
            
            [scoreLabel runAction:tintSeq];
        }
	}
    //a single player game
	else {
        if (!gameOver)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"GameOver.mp3"];
            gameOver = true;
        }
        CCScene* gameoverScene = [CCScene node];
        GameoverLayer* gameoverLayer = [GameoverLayer node];
        [gameoverLayer setScore:_score];
        [gameoverScene addChild:gameoverLayer z:100];
        
		[[CCDirector sharedDirector] pushScene: 
		 [CCTransitionFade transitionWithDuration:0.5 
											scene:gameoverScene
										withColor:ccSkyBlue]];
	}
    
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)finishGame {
	
	[Nextpeer reportForfeitForCurrentTournament];
	
	[[CCDirector sharedDirector] replaceScene: 
	 [CCTransitionFade transitionWithDuration:0.5 
										scene:[MenuScene node]
									withColor:ccSkyBlue]];
	
	gGameSuspended = YES;
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	
}



-(void) sendTop:(CCNode*) node
{
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //child is out of bounds and needs to be reset to the top of the screen
    CGFloat xPos = CCRANDOM_MINUS1_1()*winSize.width*0.5f + winSize.width*0.5f;
    CGFloat yPos = CCRANDOM_0_1()*winSize.height*0.3f + winSize.height;
    [node setPosition:ccp(xPos, yPos)];

    CGFloat enemySpeed = 30.0f;
    
    [node removeAllChildrenWithCleanup:TRUE];
    CGFloat flameSpeed = 1.5f;
    if (node.tag == SMALL_ENEMY_TAG)
    {
        enemySpeed = SMALL_ENEMY_SPEED + (CCRANDOM_MINUS1_1() * SMALL_ENEMY_SPEED_VARIATION);
        
        float randSize = SMALL_ENEMY_SIZE + (CCRANDOM_MINUS1_1() * SMALL_ENEMY_SIZE_VARIATION);
        
        [node setScale:(winSize.width*randSize)/([node contentSize].width)];
        
        
        
    }
    else if (node.tag == LARGE_ENEMY_TAG)
    {
        enemySpeed = LARGE_ENEMY_SPEED + (CCRANDOM_MINUS1_1() * LARGE_ENEMY_SPEED_VARIATION); 
    }
    else if (node.tag == POWERUP_TAG)
    {
        enemySpeed = POWERUP_SPEED + (CCRANDOM_MINUS1_1() * POWERUP_SPEED_VARIATION);
        
        CCAnimation* animation = [CCAnimation animation];
        float animationSpeed = 0.6;
        int animationNumber = (int) (CCRANDOM_0_1()*3 + 1);
        for( int i=1;i<=3;i++)
            [animation addFrameWithFilename: [NSString stringWithFormat:@"%dbonus%d.png", animationNumber, i]];
        
        id action = [CCAnimate actionWithDuration:animationSpeed animation:animation restoreOriginalFrame:NO];
        id action_back = [action reverse];
        
        CCRepeatForever* repeatAnimation = [CCRepeatForever actionWithAction:[CCSequence actions: action, action_back, nil]];
        [node runAction:repeatAnimation];
    }
    
    if (node.tag == SMALL_ENEMY_TAG || node.tag == LARGE_ENEMY_TAG)
    {
        CCSprite* fire = [CCSprite spriteWithFile:@"fire1_ 01.png"]; 
        CCAnimation* fireAnimation = [CCAnimation animation];
        for( int i=1;i<=25;i++)
            [fireAnimation addFrameWithFilename: [NSString stringWithFormat:@"fire1_ %02d.png", i]];
        
        
        
        id fireAction = [CCAnimate actionWithDuration:flameSpeed animation:fireAnimation restoreOriginalFrame:NO];
        [fire runAction:[CCRepeatForever actionWithAction:fireAction]];
        
        [fire setScaleX:0.6f];
        [fire setScaleY:-0.3f];
        //[fire setColor:ccc3(150, 150, 255)];
        
        [fire setOpacity:230];
        //[fire setRotation:180];
        [fire setPosition:ccp(node.contentSize.width/2,-node.contentSize.height*0.05)];
        [node addChild:fire z:-1];
    }
    
    CCMoveBy* moveAction = [CCMoveBy actionWithDuration:0.2 position:ccp(0,-enemySpeed)];
    CCRepeatForever* repeatAction = [CCRepeatForever actionWithAction:moveAction];
    //[node stopAllActions];
    [node runAction:repeatAction];
}

-(void) incScoreBy: (int) value
{
    
    if (gameOver)
        return;
    
    _score+=value;
    if (_score < 0)
        _score = 0;
    
    [self updateScoreTo:_score];
}

-(void) incScore:(ccTime) dt{
    if(gameOver)
        return;
    _score+=1;
    [self updateScoreTo:_score];
}

-(void) decFuel:(ccTime)dt{
    _player_fuel-=1.0;
    
    if (_player_fuel < 0)
    {
        _player_fuel = 0;
        //GG
        [self finishGameWithMenu];
    }
        if (_player_fuel > 100)
        _player_fuel = 100;
    
    fuelBar.percentage = _player_fuel;
    
}

- (void)update:(ccTime)dt {
	
	if(gGameShouldEndAndRetun) {
		[self finishGame];
		gGameShouldEndAndRetun = FALSE;
		return;
	}
	
    if (gGameShouldRestart) {
		[self startGame];
		gGameShouldRestart = FALSE;
		return;
	}
    
    if(gGameSuspended) return;
    
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
    _player_pos.x += _player_vel.x * dt;
    
    CGSize actor_size = actor.contentSize;
	float max_x = winSize.width+actor_size.width/2;
	float min_x = -actor_size.width/2;
    
    if(_player_pos.x>max_x) _player_pos.x = min_x;
	if(_player_pos.x<min_x) _player_pos.x = max_x;
    
    CGRect levelBounds = CGRectMake(0, 0, winSize.width, winSize.height);
    //reset the enemies if they go off the screen
    
    
 
    CCNode* child;
    CCARRAY_FOREACH(children_, child)
    {
        
        if (!CGRectIntersectsRect(child.boundingBox, levelBounds))
        {
            [self sendTop:child];
            //if (child.tag == LARGE_ENEMY_TAG){
            // [[SimpleAudioEngine sharedEngine] playEffect:@"FlyBy.mp3"];
            //}
        }
    
        if (child.tag == LARGE_ENEMY_TAG)
        {
            if (ABS(child.position.y - actor.position.y) < 5)
            {
                [[SimpleAudioEngine sharedEngine] playEffect:@"FlyBy.mp3"];
                
            }
            
        }
        
        if (child!=actor)
        {
            //check for collision with actor
            
            CGFloat distance = ccpDistance(child.position, actor.position);
            
            if (distance < actor.boundingBox.size.width*0.8f)
            {
                //collision has occurred
                // CGRect intersection = CGRectIntersection(child.boundingBox, actor.boundingBox);
                [self sendTop:child];
                if (child.tag == POWERUP_TAG){
                    //increase the fuel!
                    [self increaseFuel];
                    
                    
                    
                }
                else if (child.tag == LARGE_ENEMY_TAG || child.tag == SMALL_ENEMY_TAG) {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"HitPlanet.mp3"];
                    [self decreaseShields];
                    
                }
            }
        }
        
        
    }
    
	actor.position = _player_pos;
}

- (void)resetScore {	
	[self updateScoreTo:0];
	
     
	[scoreLabel setVisible:TRUE];
}

- (void)updateScoreTo:(NSUInteger)newScore {
	
	_score = newScore;
	
	[scoreLabel setString:[NSString stringWithFormat:@"Score: %d",_score]];
    
    if ([Nextpeer isCurrentlyInTournament]) {
        [Nextpeer reportScoreForCurrentTournament:_score];
    }
    
}

- (void) updateShieldsTo:(NSUInteger)newShields {
    _shields = newShields;
    
    [shieldLabel setString:[NSString stringWithFormat:@"Shields: %d",_shields]];
}

- (void) decreaseShields
{
    _shields--;
    shieldLabel.color = ccc3(255,255,255);
    
    if (_shields < 0)
    {
        _shields = 0;
        [self finishGameWithMenu];
    }
    else {
      
        if (_shields == 1)
        {
            
            shieldLabel.color = ccc3(255, 255, 0);
        }
        else if (_shields == 0)
        {
            shieldLabel.color = ccc3(255,0, 0);
        }
        
        if ([actor numberOfRunningActions] <= 0)
        {
            //make the screen flash red
            id tintRed = [CCTintBy actionWithDuration:0.2 red:0 green:-100 blue:-100];
            id tintBack = [tintRed reverse];
            
            CCSequence* flashSeq = [CCSequence actions:tintRed,tintBack, nil];
            CCRepeat* repeatFlash = [CCRepeat actionWithAction:flashSeq times:4];
            
            [actor runAction:repeatFlash];
           
            //shake the player up a bit
            /*CGFloat leftRotation = 20 + CCRANDOM_0_1() * 20;
            CGFloat rightRotation = 20 + CCRANDOM_0_1() * 20;
            CCRotateTo* rotLeft = [CCRotateTo actionWithDuration:0.1 angle:leftRotation];
            CCRotateTo* rotBack1 = [CCRotateTo actionWithDuration:0.1 angle:0];
            CCRotateTo* rotRight = [CCRotateTo actionWithDuration:0.1 angle:rightRotation];
            CCRotateTo* rotBack2 = [CCRotateTo actionWithDuration:0.1 angle:0];
            CCSequence* rotSequence = [CCSequence actions:rotLeft, rotBack1, rotRight, rotBack2, nil];
            [actor runAction:rotSequence];*/
        }
    }
    [self updateShieldsTo:_shields];
    
    
    //may need to call gameover here.
}

- (void) increaseFuel
{    
    
    _player_fuel+=15;
    if (_player_fuel > 100)
    {
        _player_fuel = 100.0;
    }
    
    fuelBar.percentage = _player_fuel;
    [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_pick.mp3"];
    
    
    [self incScoreBy:FUEL_POINT_BONUS];
    
    id tintBy = [CCTintTo actionWithDuration:0.5 red:0 green:255 blue:0];
    id tintBack = [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255];
    
    CCSequence* tintSeq = [CCSequence actions:tintBy, tintBack, nil];
    
    
    
                 
    [scoreLabel runAction:tintSeq];
    
    
    /*CCLabelTTF* powerLabel = [CCLabelTTF labelWithString:@"+20" fontName:@"futurafont.ttf" fontSize:10]; 
    powerLabel.color = ccc3(0, 200, 0);
    powerLabel.position = actor.position;
    [self addChild:powerLabel];
    
    id moveUpAction = [CCMoveBy actionWithDuration:1.0 position:ccp(0,50)];
    id removeMySprite = [CCCallFuncND actionWithTarget:powerLabel
                                               selector:@selector(removeFromParentAndCleanup:)
                                                   data:(void*)NO];
    
    CCSequence* seq = [CCSequence actions:moveUpAction, removeMySprite, nil];
    [powerLabel runAction:seq];*/
}

- (void)resetPlayer {
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    
	[actor setVisible:TRUE];
	[actor setOpacity:255];
	_player_pos.x = winSize.width/2;
	_player_pos.y = winSize.height*0.18f;
	actor.position = _player_pos;
	
	_player_vel.x = 0;
	_player_vel.y = 0;
	
	_player_acc.x = 0;
    
    _player_fuel = 100.0;//player starts with 100% fuel
    fuelBar.percentage = 100.0;
    _shields = 5;//player starts with five shields
    
    //add the tail flame
    CCParticleSun* emitter = [CCParticleSun node];
    [actor addChild:emitter z:-1];
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
    emitter.gravity = ccp(0,-100);
    emitter.startSize = 8;
    emitter.speed = 30;
    //emitter.rotation = 90;
    emitter.angle = -90;
    emitter.angleVar = 20;
    emitter.life = 0.3;
    emitter.lifeVar = 0.2;
    CGPoint flamePosition = ccp(0,0);//actor.position;
    flamePosition.y+=actor.contentSize.height*0.4;
    flamePosition.x+=actor.contentSize.width*0.5;
    [emitter setPosition:flamePosition];
    
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	float accel_filter = 0.1f;
	_player_vel.x = _player_vel.x * accel_filter + acceleration.x * (1.0f - accel_filter) * 500.0f;
}


- (void) ccTouchesBegan: (NSSet *)touches withEvent:(UIEvent *)event {
	
	if ([[CCDirector sharedDirector] isPaused])
		return;
	
	ccColor3B col;
	col.r = 176;
	col.g = 226;
	col.b = 255;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pausestart.mp3"];
	PauseScene *menuScene = [PauseScene node];
	[[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:0.5 scene:menuScene withColor:col]];
}

@end
