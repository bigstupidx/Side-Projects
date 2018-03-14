//
//  TileLayer.h
//  iEngine
//
//  Created by Safiul Azam on 7/11/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Layer.h"
#import "LayerContainer.h"
#import "TileSet.h"
#import "TileAnimation.h"
#import "Tile.h"
#import "TileMap.h"
#import "TileSprite.h"
#import "Index.h"

@interface MyTileLayer : LayerContainer
{
	@private
	TileMap *_tileMap;
	NSMutableArray *_tileSprites;
    
    BOOL _depthSort;
    NSMutableArray *_depthSortLayers;
}

- (id) initWithTileMap:(TileMap *) tileMap;

- (TileMap *) getTileMap;

- (BOOL) isDepthSort;
- (void) setDepthSort:(BOOL) sort;

- (NSArray *) getTileSprites;
- (TileSprite *) getTileSprite:(Index) index;

- (NSArray *) getTileSets:(Index) index;
- (NSInteger) getCountTileSets:(Index) index;
- (NSInteger) getTileSetIndex:(Index) index :(TileSet *) tileSet;
- (TileSet *) getTileSet:(Index) index :(NSInteger) location;
- (void) addTileSet:(Index) index :(TileSet *) tileSet;
- (void) addTileSet:(TileSet *) tileSet;
- (void) replaceTileSet:(Index) index :(NSInteger) location :(TileSet *) tileSet;
- (void) replaceTileSet:(NSInteger) index :(TileSet *) tileSet;
- (void) removeTileSet:(Index) index :(TileSet *) tileSet;
- (void) removeTileSet:(TileSet *) tileSet;
- (void) removeAllTileSets:(Index) index;
- (void) removeAllTileSets;

- (NSArray *) getTileAnimations:(Index) index;
- (NSInteger) getCountTileAnimations:(Index) index;
- (NSInteger) getTileAnimationIndex:(Index) index :(TileAnimation *) tileAnimation;
- (TileAnimation *) getTileAnimation:(Index) index :(NSInteger) location;
- (void) addTileAnimation:(Index) index :(TileAnimation *) tileAnimation;
- (void) addTileAnimation:(TileAnimation *) tileAnimation;
- (void) replaceTileAnimation:(Index) index :(NSInteger) location :(TileAnimation *) tileAnimation;
- (void) replaceTileAnimation:(NSInteger) index :(TileAnimation *) tileAnimation;
- (void) removeTileAnimation:(Index) index :(TileAnimation *) tileAnimation;
- (void) removeTileAnimation:(TileAnimation *) tileAnimation;
- (void) removeAllTileAnimations:(Index) index;
- (void) removeAllTileAnimations;
- (NSInteger) getActiveTileAnimationIndex:(Index) index;
- (void) setActiveTileAnimationIndex:(Index) index :(NSInteger) location;
- (TileAnimation *) getActiveTileAnimation:(Index) index;

@end
