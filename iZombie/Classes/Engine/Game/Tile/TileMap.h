//
//  TileMap.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Orientation.h"
#import "Index.h"
#import "Tile.h"
#import "LogUtility.h"


@interface TileMap : Element {

	@private
	Orientation _orientation;
	CGSize _mapSize;
	CGSize _tileSize;
	CGSize _size;
	
	NSMutableArray *_tiles;
}

- (id) initWithOrientation:(Orientation) orientation :(CGSize) mapSize :(CGSize) tileSize;

- (Orientation) getOrientation;

- (CGSize) getMapSize;

- (CGSize) getTileSize;

- (CGSize) getSize;

- (BOOL) isTileExistsAtIndex:(Index) index;
- (BOOL) isTileExistsAtPosition:(CGPoint) position;

- (Tile *) getTileAtIndex:(Index) index;

- (BOOL) isTileAccessibleAtIndex:(Index) index;
- (void) setTileAccessibleAtIndex:(Index) index :(BOOL) accessible;

- (BOOL) isTileAccessibleAtPosition:(CGPoint) position;
- (void) setTileAccessibleAtPosition:(CGPoint) position :(BOOL) accessible;

- (CGPoint) getTileCenter:(Index) index;

- (Index) getTileIndexAtPosition:(CGPoint) position;

- (NSArray *) getTilesAccessible;

@end
