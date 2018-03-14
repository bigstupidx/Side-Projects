#import "cocos2d.h"

@interface GameplayLayer : CCLayer {
	
@private
	CGPoint _player_pos;
	CGPoint _player_vel;
	CGPoint _player_acc;	
	
    CCSprite* spriteManager;
    
    CCArray* enemyArray;
    CCArray* powerupArray;
    CCNode* laserManager;
    
    CCSprite* actor;
    CCProgressTimer* fuelBar;
    CGFloat _player_fuel;
    
    CCLayer* guiLayer;//where we keep all the HUD
    int shootingDelay;
    
    CCLabelTTF * scoreLabel;
    CCLabelTTF * shieldLabel;
    CCLabelTTF* multLabel;
    int multiplier;//the amount ot increase the score by
    int powerupCount;//the number of consecutive powerups
    float playerShields;
    
	
	int _score;
    int _shields;
	
    CGFloat speedAdjustment;
    BOOL gameOver;
}

+ (id) scene;

- (void) dealloc;
- (void) constructLayer;
- (void) initPowerups;
- (void) initEnemies;
- (void) resetPowerups;
- (void) resetEnemies;
- (void) startGame;
- (void) gameShouldFinish;
- (void) finishGameWithMenu;
- (void) finishGame;
- (void) sendTop:(CCNode*) node;
- (void) incScore:(ccTime) dt;
- (void) decFuel:(ccTime)dt;
- (void) update:(ccTime)dt ;
- (void) resetScore ;
- (void) updateScoreTo:(NSUInteger)newScore ;
- (void) updateShieldsTo:(NSUInteger)newShields;
- (void) decreaseShields;
- (void) increaseFuel;
- (void) resetPlayer;
@end
