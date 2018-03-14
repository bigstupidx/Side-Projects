
@interface GameplayLayer : CCLayer {
	
@private
	CGPoint _player_pos;
	CGPoint _player_vel;
	CGPoint _player_acc;	
	
    CCSprite* spriteManager;
    
    CCArray* enemyArray;
    CCArray* powerupArray;
    
    
    CCSprite* actor;
    CCProgressTimer* fuelBar;
    CGFloat _player_fuel;
    
    
    CCLabelTTF * scoreLabel;
    CCLabelTTF * shieldLabel;
    float playerShields;
    
	float _currentPlatformY;
	int _currentPlatformTag;
	float _currentMaxPlatformStep;
	
	int _currentFishPlatformIndex;
	int _currentBonusType;
	
	NSUInteger _platformCount;
    
	int _score;
    int _shields;
	NSUInteger _totalFish;
	int _currentCloudTag;
	
	BOOL _isMultiplayerGame;
    BOOL _ee_platform;
	BOOL _sharkShowCount;
	int _currentSharkPlatformIndex;
	int _currentSharkType;
    
    NSUInteger _maxNumberOfClouds;
    NSUInteger _maxNumberOfPlatforms;
    
    BOOL gameOver;
}

-(void)dealloc;
-(void) constructLayer;
-(void) initPowerups;
-(void) initEnemies;
-(void) resetPowerups;
-(void) resetEnemies;
- (void)startGame;
- (void)gameShouldFinish;
- (void)finishGameWithMenu;
- (void)finishGame;
-(void) sendTop:(CCNode*) node;
-(void) incScore:(ccTime) dt;
-(void) decFuel:(ccTime)dt;
- (void)update:(ccTime)dt ;
- (void)resetScore ;
- (void)updateScoreTo:(NSUInteger)newScore ;
- (void) updateShieldsTo:(NSUInteger)newShields;
- (void) decreaseShields;
- (void) increaseFuel;
- (void)resetPlayer;
@end
