//
//  Scroller.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Layer.h"
#import "Texture.h"

@interface Scroller : Layer
{
    @private
    CGPoint _limit;
    CGPoint _scroll;
    Texture *_texture;
}

-(id)initWithSize:(CGSize) size :(Texture *) texture;
-(Texture *) getTexture;

-(void) scroll:(CGPoint) distance;

@end
