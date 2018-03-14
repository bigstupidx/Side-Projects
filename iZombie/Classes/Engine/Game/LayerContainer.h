//
//  LayerContainer.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Layer.h"

@class Layer;

@interface LayerContainer : Layer 
{
	@private
	NSMutableArray *_childs;
}

-(NSArray *) getChilds;
-(NSInteger) getCountChilds;
-(Layer *) getChild:(NSInteger) index;
-(void) addChild:(Layer *) child;
-(void) replaceChild:(NSInteger) index :(Layer *) child;
-(void) removeChild:(Layer *) child;
-(void) removeAllChilds;

@end
