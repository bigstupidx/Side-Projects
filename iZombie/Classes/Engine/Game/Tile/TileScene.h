//
//  TileScene.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Layer.h"
#import "TileMap.h"
#import "MyTileLayer.h"
#import "GraphicsUtility.h"

@interface TileScene : Layer 
{
	@private
	TileMap *_tileMap;	
	MyTileLayer *_topTileLayer;
	MyTileLayer *_bottomTileLayer;
	BOOL _wireframe;	
	Color _wireframeColor;
	CGFloat _wireframeThickness;
}

- (id) initWithTileMap:(TileMap *) tileMap;

- (TileMap *) getTileMap;

- (MyTileLayer *) getTopTileLayer;

- (MyTileLayer *) getBottomTileLayer;

- (Color) getWireframeColor;
- (void) setWireframeColor:(Color) color;

- (CGFloat) getWireframeThickness;
- (void) setWireframeThickness:(CGFloat) thickness;

- (BOOL) isWireframe;
- (void) setWireframe:(BOOL) wireframe;

@end
