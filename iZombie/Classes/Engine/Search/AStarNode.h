//
//  AStarNode.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AStarNode;

@interface AStarNode : NSObject {

	@private
	AStarNode *_parent;
	CGPoint _position;
	NSMutableArray *_neighbors;
	CGFloat _distance;
	BOOL _accessible;
}

- (id) initWithPosition:(CGPoint) position;

- (AStarNode *) getParent;
- (void) setParent:(AStarNode *) parent;

- (CGPoint) getPosition;
- (void) setPosition:(CGPoint) position;

- (CGFloat) getDistance;
- (void) setDistance:(CGFloat) distance;

- (BOOL) isAccessible;
- (void) setAccessible:(BOOL) accessible;

- (NSArray *) getNeighbors;
- (NSInteger) getCountNeighbors;
- (AStarNode *) getNeighbor:(NSInteger) index;
- (void) addNeighbor:(AStarNode *) neighbor;
- (void) removeNeighbor:(AStarNode *) neighbor;
- (void) removeNeighbors:(NSArray *) neighbors;
- (void) removeAllNeighbors;
- (BOOL) isNeighborExists:(AStarNode *) neighbor;

@end
