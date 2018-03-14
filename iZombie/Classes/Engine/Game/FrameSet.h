//
//  FrameSet.h
//  iEngine
//
//  Created by Safiul Azam on 6/30/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Texture.h"
#import "Element.h"
#import "LogUtility.h"

@interface FrameSet : Element 
{
	@private
	NSInteger _firstFrameIndex;
	CGSize _frameSize;
	Texture *_texture;
}

- (id) initWithFirstFrameIndex:(NSInteger) firstFrameIndex :(CGSize) frameSize :(Texture *) texture; 

-(NSInteger) getFirstFrameIndex;

-(CGSize) getFrameSize;

-(Texture *) getTexture;

-(NSInteger) getCountFrames;

-(BOOL) isFrameExist:(NSInteger) index;

-(void) draw:(NSInteger) frameIndex position:(CGPoint) position;

@end
