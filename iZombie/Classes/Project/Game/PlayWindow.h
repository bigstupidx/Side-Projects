//
//  PlayWindow.h
//  iEngine
//
//  Created by Muhammed Safiul Azam on 11/6/09.
//  Copyright 2009 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Window.h"
#import "LogUtility.h"
#import "TMXUtility.h"
#import "Texture.h"
#import "TilePathFinder.h"
#import "MovableSprite.h"
#import "LayerManager.h"
#import "Constants.h"
#import "Player.h"
#import "Zombie.h"
#import "Blood.h"
#import "Skeleton.h"
#import "Font.h"
#import "Text.h"
#import "Death.h"
#import "UIUtility.h"
#import "PageMainViewController.h"
#import "PageBaseViewController.h"
#import "Score.h"
#import "Highscore.h"
#import "Avatar.h"
#import "Fire.h"
#import "Hit.h"
#import "Level.h"
#import "Mode.h"
#import "Door.h"
#import "Prize.h"
#import "Scroller.h"
#import "Coin.h"
//#import "TestFlight.h"

@class Zombie;
@class PlayWindow;

@interface PlayWindow : Window<UIAlertViewDelegate>
{
    LayerManager *_layerManager;
    MyTileLayer *_backgroundTileLayer;
    Texture *_backgroundTexture;
    
    BOOL _isLeftButtonTapped;
    BOOL _isRightButtonTapped;
    
    Skeleton *_headIcon;
    Skeleton *_fireIcon;
    
    Texture *_lifeTexture;
    Texture *_lifeMaximumTexutre;
    
    Font *_font;
    Text *_text;
    
    long _nextZombieCreationTime;
    long _lastZombieCreationMilliseconds;
    
    NSInteger PlayerBoundaryMinimum;
    NSInteger PlayerBoundaryMaximum;
    
    CGFloat _messageAlpha;
    
    BOOL _running;
    
    BOOL _saveScore;
    
    long _stopMilliseconds;
    
    long _messageMilleseconds;
    
    NSInteger _level;
    
    UITextView *_nameTextView;
    
    PageBaseViewController *_baseViewController;
    
    Mode _mode;
    Mode _previousMode;
    
    BOOL _alertView;
}

- (id) initWithFrame:(CGRect) frame :(PageBaseViewController *) viewController;

+(PlayWindow *) getInstance;
+(void) destroyInstance;

-(void) onPrepare;

-(void) onCreatePlayer;

-(void) onCreateZombie;
-(void) onZombies:(NSInteger) maximum;
-(void) onCreateBlood:(Skeleton *) skeleton;
-(void) onBloods;
-(void) onCreateDeath:(Skeleton *) skeleton;
-(void) onDeaths;
-(void) onControls;
-(void) onDoors;
-(void) onCreatePrize:(CGPoint) center;
-(void) onPrizes;
-(void) onCreateCoin:(Zombie *) zombie;
-(void) onCoins;

-(void) leftButtonTapped;
-(void) leftButtonReleased;

-(void) rightButtonTapped;
-(void) rightButtonReleased;

-(void) fireButtonTapped;
-(void) hitButtonTapped;

-(BOOL) isExit;
-(BOOL) isCreateZombieOnLeft;

-(BOOL) isRunning;

-(void) pause;
-(void) resume;

//-(void) onSave;

-(Mode) getMode;
-(void) setMode:(Mode) mode;

-(Mode) getPreviousMode;
-(void) setPreviousMode:(Mode) mode;

-(BOOL) isAlertView;

-(void) playScream;

@end
