//
//  LayerManager.h
//  iEngine
//
//  Created by Safiul Azam on 7/12/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "Layer.h"
#import "Element.h"
#import "Constants.h"

@interface LayerManager : NSObject {

	CGPoint _position;	
	CGRect _window;
    
    Layer *_follow;
    CGRect _followArea;
    
	NSMutableArray *_layers;
}

- (id)initWith:(CGRect) window;

-(CGPoint) getPosition;
-(void) setPosition:(CGPoint) position;

-(CGRect) getWindow;
-(void) setWindow:(CGRect) window;
-(void) moveWindow:(CGPoint) distance;
-(BOOL) isInWindow:(Layer *) layer;

-(NSMutableArray *) getLayers;
-(NSInteger) getCountLayers;
-(Layer *) getLayer:(NSInteger) index;
-(void) addLayer:(Layer *) layer;
-(void) replaceLayer:(NSInteger) index :(Layer *) layer;
-(void) removeLayer:(Layer *) layer;
-(void) removeAllLayers;

-(Layer *) getFollow;
-(void) setFollow:(Layer *) layer;
-(CGRect) getFollowArea;
-(void) setFollowArea:(CGRect) area;

-(void) draw;

@end
