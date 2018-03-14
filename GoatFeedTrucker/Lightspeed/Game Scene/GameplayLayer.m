#import "GameplayLayer.h"
#import "Globals.h"
#import "PauseScene.h"
#import "StarParticleLayer.h"

#import "GameoverLayer.h"

#import "MainMenuLayer.h"

#import "SimpleAudioEngine.h"

#import "AdsManager.h"
#import "ShipNode.h"
#import "PowerupNode.h"
#import "EnemyNode.h"
#import "InGameInstLayer.h"

#define RANDOM_SEED() srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF))
#define FRENZY_SOUND_TAG 145
enum
{
    zLASERS,
    zENEMIES,
    zACTOR,
    
};


@interface GameplayLayer (Private) <UIAlertViewDelegate>

-(void)constructLayer;

- (void)initEnemies;
- (void)resetEnemies;
- (void)resetScore;

-(void) sendTop:(CCNode*) node;

- (void)updateScoreTo:(NSUInteger)newScore;
- (void)updateShieldsTo:(NSUInteger)newShields;
- (void)decreaseShields;
- (void)increaseFuel;

- (void)resetPlayer;

- (void)startGame;
- (void)finishGameWithMenu;
- (void)finishGame;

- (void)update:(ccTime)dt;
- (void)incScore:(ccTime)dt;
-(void) incScoreBy: (int) value;
- (void)decFuel:(ccTime)dt;

@end


@implementation GameplayLayer

#define kFPS 10

//(these sizes are percentages of the screen width)
#define MAINSHIP_SIZE 0.13f
#define FUELBAR_SIZE 0.4f
#define SMALL_ENEMY_SIZE 0.10f
#define SMALL_ENEMY_SIZE_VARIATION 0.02f
#define LARGE_ENEMY_SIZE 0.2f
#define POWERUP_SIZE 0.08f

#define LASER_SIZE 0.15f

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
#define LASER_TAG 15

#define kLargeEnemyCount 2
#define kSmallEnemyCount 4


#pragma mark -
#pragma mark Public Callbacks


+ (id) scene
{
    CCScene* currScene = [CCScene node];
    currScene.tag = 1;//to specify that we are in game and pause screen shoudl show up
    
    // Gameplay Layer
    GameplayLayer *gameplayLayer = [GameplayLayer node];
    [currScene addChild:gameplayLayer z:kGameplayLayerZValue];
    
    // Particle System Layer
    StarParticleLayer *particleLayer = [StarParticleLayer node];
    [currScene addChild:particleLayer z:kStarParticleSystemLayerZValue];
    return currScene;
}

-(id) init
{
	if ((self=[super init]) ) {
		
		laserManager = [CCNode node];
        [self addChild:laserManager];
        [self constructLayer];
        [self startGame];
        
        //start the banner ad
        [[AdsManager sharedAdsManager] startBannerAd];
	}
	
	
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
    
     //the speed of everything is relative to the size of the window for ipod
    speedAdjustment = winSize.width / 320;
    
    guiLayer = [CCLayer node];
    [self addChild:guiLayer z: 2];
    //create the fuel bar border
    CCSprite* fuelBorder = [CCSprite spriteWithFile:@"EmptyBar.png"];
    [guiLayer addChild:fuelBorder z:11 tag:-5];
    
    
    //add the fuel bar to the border
    fuelBar = [CCProgressTimer progressWithFile:@"BlueBar.png"];
    fuelBar.type = kCCProgressTimerTypeHorizontalBarLR;
    fuelBar.percentage = 100.0;
    
    [guiLayer addChild:fuelBar z:10 tag:1];
    
    [fuelBorder setScale:(winSize.width*FUELBAR_SIZE)/([fuelBorder contentSize].width)];
    [fuelBar setScale:(winSize.width*FUELBAR_SIZE)/([fuelBar contentSize].width)];
    
    CGPoint fuelBarPos = ccp(winSize.width*0.75f, winSize.width*0.13f);
    [fuelBorder setPosition:fuelBarPos];
    [fuelBar setPosition:fuelBarPos];
	
	actor = [CCSprite spriteWithFile:@"spaceship.png"];
	
    //scale to match window size
    [actor setScale:(winSize.width*MAINSHIP_SIZE)/([actor contentSize].width)];

    [self addChild:actor z:zACTOR];
    
    [self initEnemies];
    [self initPowerups];
    
    NSString* pauseButtonFile = @"pausebutton.png";
    CCSprite* scoreSprite, *shieldSprite;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        scoreSprite= [CCSprite spriteWithFile:@"scoregui-hd.png"];
        shieldSprite = [CCSprite spriteWithFile:@"shieldgui-hd.png"];
        pauseButtonFile = @"pausebutton-hd.png";
    }
    else
    {
        scoreSprite= [CCSprite spriteWithFile:@"scoregui.png"];
        shieldSprite = [CCSprite spriteWithFile:@"shieldgui.png"];
    }
    
    int guiOpacity = 100;
    [scoreSprite setOpacity:guiOpacity];
    [shieldSprite setOpacity:guiOpacity];
    
    
    CCMenuItemImage* pauseButton = [CCMenuItemImage itemFromNormalImage:pauseButtonFile selectedImage:pauseButtonFile target:self selector:@selector(pauseGameCallBack:)];
    
    [pauseButton setPosition:ccp(pauseButton.contentSize.width*0.5, pauseButton.contentSize.height*0.5)];
    
    CCMenu* guiMenu = [CCMenu menuWithItems:pauseButton, nil];
    [guiLayer addChild:guiMenu];
    [guiMenu setPosition:ccp(0,0)];
    
    
    [guiLayer addChild:scoreSprite z:5];
    [guiLayer addChild:shieldSprite z:5];
    scoreSprite.position = ccp(winSize.width*0.25,winSize.height*0.85);
    shieldSprite.position = ccp(winSize.width*0.75,winSize.height*0.85);
    
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:FONT_NAME fontSize:FS_SCORETEXT];
    [scoreSprite addChild:scoreLabel z:5];
    scoreLabel.position = ccp(scoreSprite.contentSize.width*0.5,scoreSprite.contentSize.height*0.35);

    shieldLabel = [CCLabelTTF labelWithString:@"5" fontName:FONT_NAME fontSize:FS_SCORETEXT];
    [shieldSprite addChild:shieldLabel z:5];
    shieldLabel.position = ccp(shieldSprite.contentSize.width*0.5,shieldSprite.contentSize.height*0.35);
	multiplier=1;
    multLabel = [CCLabelTTF labelWithString:@"1x" fontName:FONT_NAME fontSize:FS_SCORETEXT*1.5f];
    multLabel.position = ccp(winSize.width*0.5, shieldSprite.position.y);
    
    [guiLayer addChild:multLabel z:100];
    
	[self schedule:@selector(update:)];
	
    //increase the score twice a second
    [self schedule:@selector(incScore:) interval:0.1];
    
    //decrease the fuel by 1 at an interval of :
    [self schedule:@selector(decFuel:) interval:0.15];
    
	self.isTouchEnabled = YES;
	self.isAccelerometerEnabled = YES;
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kFPS)];
    
    
    //add the instructions layer if needed
    //save score internally
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* instShownKey = @"showninst";
    
    int numTimesShown = [[defaults valueForKey: instShownKey] intValue];
    
    if (numTimesShown < 20)
    {
        [defaults setInteger:(numTimesShown+1) forKey:instShownKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [guiLayer setVisible:FALSE];
        //show the instructions layer!
        [self addInstLayer];
    }
}


- (void) addInstLayer
{
    CCLayer* instLayer = [CCLayer node];
    [instLayer setTag:898];
    [self addChild:instLayer z:100];
    CCMenuItem *gobackItem;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //if we are dealing with iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (winSize.height > 960/2)
        {
            
            CGPoint pos = ccp(0, (1136 - 960)/2/2);
            [self setPosition:pos];
        }
        winSize = CGSizeMake(640*0.5, 960*0.5);
        
        CGSize menuItemSize = CGSizeMake(208, 84);
        
        CCSprite* background = [CCSprite spriteWithFile:@"lg-iginst.png"];
        [instLayer addChild:background z:-1];
        background.position = ccp(winSize.width/2, winSize.height/2);
        
        gobackItem = [CCMenuItem itemWithTarget:self selector:@selector(startFromInst:)];
        [gobackItem setContentSize:menuItemSize];
        [gobackItem setPosition:ccp(winSize.width*0.31, winSize.height*0.1)];
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CCSprite* background = [CCSprite spriteWithFile:@"lg-iginst-ipad.png"];
        CGSize menuItemSize = CGSizeMake(466, 184);
        [instLayer addChild:background z:-1];
        background.position = ccp(winSize.width/2, winSize.height/2);
        
        gobackItem = [CCMenuItem itemWithTarget:self selector:@selector(startFromInst:)];
        [gobackItem setContentSize:menuItemSize];
        [gobackItem setPosition:ccp(winSize.width*0.31, winSize.height*0.1)];
    }
    
    CCMenu *menu = [CCMenu menuWithItems:gobackItem, nil];
    [menu setPosition: ccp(0, 0)];
    
    [instLayer addChild:menu];
    
    [[CCDirector sharedDirector] pause];//pause the game
}

- (void) startFromInst: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:MENU_CHANGE_SOUND];
    [self removeChildByTag:898 cleanup:YES];
    [[CCDirector sharedDirector] resume];
    [guiLayer setVisible:true];
}

-(void) initEnemies{
    
    enemyArray = [[CCArray alloc] initWithCapacity:30];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    for(int i = 1; i<=4;i++)
    {
        EnemyNode* enemySprite = [EnemyNode spriteWithFile:[NSString stringWithFormat:@"enemys%d.png", i]];
        enemySprite.tag = SMALL_ENEMY_TAG;
        [enemySprite setScale:(winSize.width*SMALL_ENEMY_SIZE ) /([enemySprite contentSize].width)];
        [enemyArray addObject:enemySprite];
        [enemySprite setShields:5];
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
	
	gameOver = false;
    
    
    [self resetEnemies];
	[self resetPlayer];
    [self resetPowerups];
	[self resetScore];
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)gameShouldFinish {
	gGameShouldEndAndRetun = TRUE;
	gGameSuspended = FALSE;
}

//the player has died

-(void) addExplosionAt: (CGPoint) expPos
{
    //add an explosion
    CCParticleExplosion* explosion = [CCParticleExplosion node];
    
    explosion.startSize = 2.0f;
    
    [explosion setPosition:expPos];
    [self addChild:explosion];
    
    explosion.startColor = ccc4FFromccc4B(ccc4(230, 150, 50, 230));
    explosion.endColor = ccc4FFromccc4B(ccc4(100, 0, 0, 200));
    explosion.startColorVar = ccc4FFromccc4B(ccc4(20, 100, 0, 0));
    explosion.endColorVar = ccc4FFromccc4B(ccc4(5, 5, 5, 0));
    explosion.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
    explosion.speed = 30.0;
    explosion.speedVar = 15.0;
    explosion.life = 0.7;
    explosion.lifeVar = 0.2;
    explosion.autoRemoveOnFinish = YES;
}

- (void) addExplosion: (CCSprite*) sprite
{
    //add an explosion
    CCParticleExplosion* explosion = [CCParticleExplosion node];
    
    explosion.startSize = 2.0f;
    CGPoint expPos =ccp(0,0);//= ccp(sprite.boundingBox.size.width/2,sprite.boundingBox.size.height/2);
    
    expPos = ccpAdd(expPos, sprite.position);
    [explosion setPosition:expPos];
    [self addChild:explosion];
    
    explosion.startColor = ccc4FFromccc4B(ccc4(230, 150, 50, 230));
    explosion.endColor = ccc4FFromccc4B(ccc4(100, 0, 0, 200));
    explosion.startColorVar = ccc4FFromccc4B(ccc4(20, 100, 0, 0));
    explosion.endColorVar = ccc4FFromccc4B(ccc4(5, 5, 5, 0));
    explosion.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
    explosion.speed = 40.0;
    explosion.speedVar = 15.0;
    explosion.life = 0.4;
    explosion.lifeVar = 0.2;
    explosion.autoRemoveOnFinish = YES;
}

- (void)finishGameWithMenu {
	
    if (!gameOver)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"GameOver.mp3"];
        gameOver = true;
        
        
        actor.visible = FALSE;
        id explodeAction = [CCCallFuncND actionWithTarget:self selector:@selector(addExplosion:) data:actor];
        
        id killTime = [CCActionInterval actionWithDuration:1.0];
        
        id showGameOverScreen = [CCCallBlock actionWithBlock:^{
            CCScene* gameoverScene = [CCScene node];
            GameoverLayer* gameoverLayer = [GameoverLayer node];
            [gameoverLayer setScore:_score];
            [gameoverScene addChild:gameoverLayer z:100];
            [[CCDirector sharedDirector] replaceScene:
             [CCTransitionFade transitionWithDuration:0.5
                                                scene:gameoverScene
                                            withColor:ccBLACK]];
        }];
        
        [actor runAction:[CCSequence actions:explodeAction, killTime, showGameOverScreen, nil]];
    }

	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

-(void) gameoverCallback: (id) sender
{
    
}

-(void) sendTop:(CCNode*) node
{
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    //child is out of bounds and needs to be reset to the top of the screen
    CGFloat xPos = CCRANDOM_MINUS1_1()*winSize.width*0.5f + winSize.width*0.5f;
    CGFloat yPos = CCRANDOM_0_1()*winSize.height*0.3f + winSize.height+node.contentSize.height;
    [node setPosition:ccp(xPos, yPos)];

    CGFloat enemySpeed = 30.0f;
    [node stopAllActions];
    [node removeAllChildrenWithCleanup:TRUE];
    [node setVisible:YES];
    CGFloat flameSpeed = 1.5f;
    
    speedAdjustment = 1.0;
    if (node.tag == SMALL_ENEMY_TAG)
    {
        enemySpeed = speedAdjustment * SMALL_ENEMY_SPEED + (CCRANDOM_MINUS1_1() * SMALL_ENEMY_SPEED_VARIATION);
        
        float randSize = SMALL_ENEMY_SIZE + (CCRANDOM_MINUS1_1() * SMALL_ENEMY_SIZE_VARIATION);
        
        [node setScale:(winSize.width*randSize)/([node contentSize].width)];
    }
    else if (node.tag == LARGE_ENEMY_TAG)
    {
        enemySpeed = speedAdjustment * LARGE_ENEMY_SPEED + (CCRANDOM_MINUS1_1() * LARGE_ENEMY_SPEED_VARIATION); 
    }
    else if (node.tag == POWERUP_TAG)
    {
        enemySpeed = speedAdjustment * POWERUP_SPEED + (CCRANDOM_MINUS1_1() * POWERUP_SPEED_VARIATION);
        
        //make the powerup glow
        //run the shiny action on them
        [node runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
                                                           [CCTintTo actionWithDuration:0.75 red:255 green:255 blue:255],
                                                           [CCTintTo actionWithDuration:0.75 red:150 green:150 blue:255],
                                                           nil]]];
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
        
        [((CCSprite*) node) setColor:ccWHITE];
    }
    
    /*CCMoveBy* moveAction = [CCMoveBy actionWithDuration:0.2 position:ccp(0,-enemySpeed)];
    CCRepeatForever* repeatAction = [CCRepeatForever actionWithAction:moveAction];
    //[node stopAllActions];
    [node runAction:repeatAction];*/
    
    CGPoint endOfScreen = ccp(xPos,-winSize.height*0.1 - node.contentSize.height);
    
    CCMoveTo* moveAction = [CCMoveTo actionWithDuration:180*(1/enemySpeed) position:endOfScreen];
    [node runAction:moveAction];
}

-(void) incScoreBy: (int) value
{
    
    if (gameOver)
        return;
    
    id tintBy = [CCTintTo actionWithDuration:0.5 red:200 green:255 blue:200];
    id tintBack = [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255];
    
    CCSequence* tintSeq = [CCSequence actions:tintBy, tintBack, nil];
    
    id scaleUp = [CCScaleTo actionWithDuration:0.5 scale:1.3];
    id scaleDown = [CCScaleTo actionWithDuration:0.5 scale:1.0];
    id sequence = [CCSequence actions:scaleUp, scaleDown, nil];
    
    
    id spawn = [CCSpawn actions:tintSeq, sequence, nil];
    [scoreLabel runAction:spawn];

    
    _score+=value;
    if (_score < 0)
        _score = 0;
    
    [self updateScoreTo:_score];
}

-(void) incScore:(ccTime) dt{
    if(gameOver)
        return;
    _score+=1*multiplier;
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

- (void) resetMultiplier
{
    multiplier = 1;
    powerupCount = 1;
    [multLabel setColor:ccWHITE];
    [multLabel setString:@"1x"];
    [multLabel stopAllActions];
    [multLabel setScale:1.0];
    [self stopActionByTag:FRENZY_SOUND_TAG];
}

- (void)update:(ccTime)dt {
	
    if (gGameShouldRestart) {
		[self startGame];
		gGameShouldRestart = FALSE;
		return;
	}
    
    if(gGameSuspended) return;
    
    
    if (shootingDelay > 0)
        shootingDelay--;
    
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
    _player_pos.x += _player_vel.x * dt;
    
    CGSize actor_size = actor.contentSize;
	float max_x = winSize.width+actor_size.width/2;
	float min_x = -actor_size.width/2;
    
    if(_player_pos.x>max_x) _player_pos.x = min_x;
	if(_player_pos.x<min_x) _player_pos.x = max_x;
    
    EnemyNode* enemy;
    CCARRAY_FOREACH(enemyArray, enemy)
    {
        if (enemy.position.y < -10 - enemy.contentSize.height)
        {
            [self sendTop:enemy];
        }
        
        if (enemy.visible)
        {
            //if it's big play that crappy fly by sound
            if (enemy.tag == LARGE_ENEMY_TAG)
            {
                if (ABS(enemy.position.y - actor.position.y) < 5)
                {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"FlyBy.mp3"];
                }
            }
            
            //check for collisions with actor
            CGFloat distance = ccpDistance(enemy.position, actor.position);
            
            //if (distance < actor.boundingBox.size.width*0.8f)
            CGRect newBounds = enemy.boundingBox;
            newBounds.origin.x+=newBounds.size.width*0.1;
            newBounds.origin.y+=newBounds.size.height*0.1;
            newBounds.size.width*=0.2;
            newBounds.size.height*=0.2;
                
            //if (CGRectIntersectsRect(enemy.boundingBox, actor.boundingBox))
            if (CGRectIntersectsRect(newBounds, actor.boundingBox))
            {
                [[SimpleAudioEngine sharedEngine] playEffect:@"HitPlanet.mp3"];
                [self decreaseShields];
                
                [self resetMultiplier];
                
                [self addExplosion:enemy];
                //child.visible = FALSE;
                id sendTop = [CCCallBlock actionWithBlock:^{
                    [self sendTop:enemy];
                }];
                [self runAction:sendTop];
            }
        }
                
    }
    
    
    CCSprite* laser;
    CCARRAY_FOREACH(laserManager.children, laser)
    {
        int smallDecrease = 170;
        int largeDecrease = 90;
        CCARRAY_FOREACH(enemyArray, enemy)
        {
            //destroy the enemy
            //CGFloat distance = ccpDistance(enemyChild.position, child.position);
            if (enemy.visible && CGRectIntersectsRect(enemy.boundingBox, laser.boundingBox))
            {
                    int g = enemy.color.g - (enemy.tag == LARGE_ENEMY_TAG ? largeDecrease : smallDecrease);
                    int b = enemy.color.b - (enemy.tag == LARGE_ENEMY_TAG ? largeDecrease : smallDecrease);
                    
                    id removeLaserAction = [CCCallFunc actionWithTarget:laser selector:@selector(removeFromParentAndCleanup:)];
                    [laser runAction:removeLaserAction];
                    
                    if (g < 0)
                    {
                        // id explodeAction = [CCCallFuncND actionWithTarget:self selector:@selector(addExplosion:) data:enemy];
                        
                        //id sendTopAction = [CCCallFuncND actionWithTarget:self selector:@selector(sendTop:) data:enemy];
                        
                        //id explosionSequence = [CCSequence actions:explodeAction, nil];
                        
                        //[self runAction:explosionSequence];
                        
                        [self addExplosion:enemy];
                        
                        [self incScoreBy:50];
                        
                        float pitchShift = 0;
                        if (enemy.tag == SMALL_ENEMY_TAG)
                            pitchShift+=0.5f;
                        [[SimpleAudioEngine sharedEngine] playEffect:@"npcshipdie.caf" pitch:1.0+pitchShift pan:1.0 gain:1.0];
                        
                        [self runAction: [CCCallBlock actionWithBlock:^{
                            [enemy setVisible:FALSE];
                        }]];
                        
                    }
                    else
                    {
                        //int shields = enemy.shields;
                        [self runAction: [CCCallBlock actionWithBlock:^{
                         [enemy runAction:[CCTintTo actionWithDuration:0.1 red:255 green:g blue:b]];
                         }]];
                        
                    }
            }
        }
    }

    
    
    CCSprite* powerup;
    CCARRAY_FOREACH(powerupArray, powerup)
    {
        if (powerup.position.y < -10 - powerup.contentSize.height)
        {
            [self sendTop:powerup];
            [self resetMultiplier];
        }
        
        if (actor.visible)
        {
            if (CGRectIntersectsRect(powerup.boundingBox, actor.boundingBox))
            {
                [self increaseFuel];
                //child.visible = FALSE;
                id sendTop = [CCCallBlock actionWithBlock:^{
                    [self sendTop:powerup];
                }];
                [self runAction:sendTop];
            }
        }
    }

    
    /*CCARRAY_FOREACH(laserManager.children, child)
    {
        if (child.tag == LASER_TAG)
        {
            //go through all of the enemies and see if its equal
            
            CCNode* enemyChild;
            CCARRAY_FOREACH(children_, enemyChild)
            {
    
                CCSprite* enemySprite = (CCSprite*) enemyChild;
                
                int smallDecrease = 170;
                int largeDecrease = 90;
                //destroy the enemy
                //CGFloat distance = ccpDistance(enemyChild.position, child.position);
                if (CGRectIntersectsRect(enemySprite.boundingBox, child.boundingBox))
                {
                    if (enemySprite.tag == LARGE_ENEMY_TAG || enemySprite.tag == SMALL_ENEMY_TAG)
                    {
                        int g = enemySprite.color.g - (enemySprite.tag == LARGE_ENEMY_TAG ? largeDecrease : smallDecrease);
                        int b = enemySprite.color.b - (enemySprite.tag == LARGE_ENEMY_TAG ? largeDecrease : smallDecrease);
                        
                        if (g < 0)
                        {
                            id explodeAction = [CCCallFuncND actionWithTarget:self selector:@selector(addExplosion:) data:enemySprite];
                            
                            id sendTopAction = [CCCallFuncND actionWithTarget:self selector:@selector(sendTop:) data:enemySprite];
                            
                            id explosionSequence = [CCSequence actions:explodeAction, sendTopAction, nil];
                            
                            [self runAction:explosionSequence];
                            
                            [self incScoreBy:50];
                            
                            float pitchShift = 0;
                            if (enemySprite.tag == SMALL_ENEMY_TAG)
                                pitchShift+=0.5f;
                            [[SimpleAudioEngine sharedEngine] playEffect:@"npcshipdie.caf" pitch:1.0+pitchShift pan:1.0 gain:1.0];
                            
                        }
                        else
                        {
                            [enemySprite setColor:ccc3(255, g, b)];
                        }
                        //have the laser remove itself
                        id removeLaserAction = [CCCallFunc actionWithTarget:child selector:@selector(removeFromParentAndCleanup:)];
                        [child runAction:removeLaserAction];
                    }
                    
                }
            }
            
        }
    }*/
    
    
    
	actor.position = _player_pos;
}

- (void)resetScore {	
	[self updateScoreTo:0];
	
     
	[scoreLabel setVisible:TRUE];
}

- (void)updateScoreTo:(NSUInteger)newScore {
	
	_score = newScore;
	
	[scoreLabel setString:[NSString stringWithFormat:@"%d",_score]];

}

- (void) updateShieldsTo:(NSUInteger)newShields {
    _shields = newShields;
    
    [shieldLabel setString:[NSString stringWithFormat:@"%d",_shields]];
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
    
    //add the score multiplier
    if (powerupCount < 8)
    {
        powerupCount++;
        
        int greenValue = 55 * (multiplier / 4.0f);
        
        [multLabel setColor:ccc3(200-greenValue, 200+greenValue, 200-greenValue)];
        
        if (powerupCount <= 1)
        {
            multiplier = 1;
        }
        if (powerupCount <= 3)
        {
            multiplier = 2;
        }
        else if (powerupCount <= 5)
        {
            multiplier = 3;
        }
        else if (powerupCount <= 7)
        {
            multiplier = 4;
        }
        if (powerupCount == 8)
        {
            multiplier = 5;
            id scaleUp = [CCScaleTo actionWithDuration:0.5 scale:2.5];
            id scaleDown = [CCScaleTo actionWithDuration:0.5 scale:1.1];
            
            [multLabel runAction:[CCRepeatForever actionWithAction:[CCSequence actions:scaleUp, scaleDown, nil]]];
            
            id frenzySound = [CCCallBlock actionWithBlock:^{
                [[SimpleAudioEngine sharedEngine] playEffect:@"frenzymode.mp3" pitch:1.0 pan:1.0 gain:0.8f];
            }];
            
            id pause = [CCActionInterval actionWithDuration:1.0];
            CCSequence* frenzySequence = [CCSequence actions:frenzySound, pause, nil];
            CCRepeatForever* totalAction = [CCRepeatForever actionWithAction:frenzySequence];
            totalAction.tag =FRENZY_SOUND_TAG;
            [self runAction:totalAction];
        }
            
    }
    
    
    
    [multLabel setString:[NSString stringWithFormat:@"%dx",multiplier]];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"getpowerup.wav" pitch:1.0 + (powerupCount-1)*0.3f pan:1.0 gain:1.0];
    
    [self incScoreBy:FUEL_POINT_BONUS];
    
}

- (void)resetPlayer {
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
    shootingDelay = 0;
    [self resetMultiplier];
    [multLabel setColor:ccWHITE];
    [multLabel setString:@"1x"];
    [multLabel stopAllActions];
    [multLabel setScale:1.0];
    [self stopActionByTag:FRENZY_SOUND_TAG];
    
    
	[actor setVisible:TRUE];
	[actor setOpacity:255];
	_player_pos.x = winSize.width/2;
	_player_pos.y = winSize.height*0.22f;
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
    flamePosition.y+=actor.contentSize.height*0.1;
    flamePosition.x+=actor.contentSize.width*0.5;
    [emitter setPosition:flamePosition];
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	float accel_filter = 0.1f;

	_player_vel.x = _player_vel.x * accel_filter + acceleration.x * (1.0f - accel_filter) * 500.0f;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        _player_vel.x*=speedAdjustment;
    }
}


-(void) pauseGameCallBack: (id) sender
{
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


- (void) ccTouchesEnded: (NSSet *)touches withEvent:(UIEvent *)event {
	
	if ([[CCDirector sharedDirector] isPaused])
		return;
	
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    //if (shootingDelay > 0)
    //    return;
    
    //shootingDelay = 15;
    
    //add the laser beam
    if (!gameOver)
    {
        CCSprite* laserBeam = [CCSprite spriteWithFile:@"lasers.png"];
        CGPoint laserPosition = ccpAdd(actor.position, ccp(0,laserBeam.contentSize.height*0.5));
        [laserBeam setPosition:laserPosition];
        [laserManager addChild:laserBeam z:zLASERS];
        
        [laserBeam setTag:LASER_TAG];
        id laserMove = [CCMoveBy actionWithDuration:0.7 position:ccp(0,winSize.width*0.7f)];
        id laserRemove = [CCCallFunc actionWithTarget:laserBeam selector:@selector(removeFromParentAndCleanup:)];
        
        [laserBeam runAction:[CCSequence actions:laserMove, laserRemove, nil]];
        
        [laserBeam setScale:(winSize.width*MAINSHIP_SIZE)/([actor contentSize].width)];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"laser3.caf"];
    }
	/*ccColor3B col;
	col.r = 176;
	col.g = 226;
	col.b = 255;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pausestart.mp3"];
	PauseScene *menuScene = [PauseScene node];
	[[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:0.5 scene:menuScene withColor:col]];*/
}

@end
