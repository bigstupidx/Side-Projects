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


@interface Sprite : LayerContainer {

	NSMutableArray *_frameSets;
	NSMutableArray *_frameAnimations;
	NSInteger _activeFrameAnimationIndex;
}

-(id) initWithSize:(CGSize) size;

-(NSArray *) getFrameSets;
-(NSInteger) getCountFrameSets;
-(NSInteger) getFrameSetIndex:(FrameSet *) frameSet;
-(FrameSet *) getFrameSet:(NSInteger) index;
-(void) addFrameSet:(FrameSet *) frameSet;
-(void) replaceFrameSet:(NSInteger) index :(FrameSet *) frameSet;
-(void) removeFrameSet:(FrameSet *) frameSet;
-(void) removeAllFrameSets;

-(NSArray *) getFrameAnimations;
-(NSInteger) getCountFrameAnimations;
-(NSInteger) getFrameAnimationIndex:(FrameAnimation *) frameAnimation;
-(NSInteger) getFrameAnimationIndexByName:(NSString *) name;
-(FrameAnimation *) getFrameAnimation:(NSInteger) index;
-(void) addFrameAnimation:(FrameAnimation *) frameAnimation;
-(void) replaceFrameAnimation:(NSInteger) index :(FrameAnimation *) frameAnimation;
-(void) removeFrameAnimation:(FrameAnimation *) frameAnimation;
-(void) removeAllFrameAnimations;
-(NSInteger) getActiveFrameAnimationIndex;
-(void) setActiveFrameAnimationIndex:(NSInteger) index;
-(FrameAnimation *) getActiveFrameAnimation;

-(BOOL) isCollideWith:(Sprite *) with;
-(BOOL) isTouchWith:(CGPoint) with;

@end

