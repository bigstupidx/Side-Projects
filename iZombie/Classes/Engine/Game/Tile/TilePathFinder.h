//
//  TilePathFinder.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TileScene.h"
#import "Tile.h"
#import "TileMap.h"
#import "AStarNode.h"
#import "AStar.h"


@interface TilePathFinder : NSObject 
{
	@private
	TileMap *_tileMap;
	NSMutableArray *_nodes;
	AStar *_aStar;
}

- (id) initWithTileMap:(TileMap *) tileMap;

- (TileMap *) getTileMap;

- (NSArray *) getShortestPath:(CGPoint) source :(CGPoint) destination;

@end
