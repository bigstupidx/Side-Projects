//
//  Sprite.h
//  iEngine
//
//  Created by Safiul Azam on 6/30/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "Layer.h"
#import "LayerContainer.h"
#import "FrameSet.h"
#import "FrameAnimation.h"
#import "Sprite.h"
#import "MathUtility.h"


@interface MovableSprite : Sprite {

    NSInteger _speed;
    CGPoint _velocity;
    CGFloat _direction;
    NSMutableArray *_path;
    BOOL _progress;
}

-(id) initWithSize:(CGSize) size;

- (NSInteger) getSpeed;
- (void) setSpeed:(NSInteger) speed;

- (CGPoint) getVelocity;
- (void) setVelocity:(CGPoint) velocity;

- (CGFloat) getDirection;
- (void) setDirection:(CGFloat) direction;

- (NSArray *) getPath;
- (void) setPath:(NSArray *) path;

- (BOOL) isProgress;

- (void) start;
- (void) onStart;

- (void) resume;
- (void) onResume;

- (void) stop;
- (void) onStop;

- (void) pause;
- (void) onPause;

- (void) onError;

- (void) onProgress;
- (void) onTurn;
- (void) onComplete;

@end

