//
//  AStar.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AStarNode.h"
#import "MathUtility.h"


@interface AStar : NSObject {

	@private
	NSMutableArray *_nodes;
}

- (NSArray *) getNodes;
- (NSInteger) getCountNodes;
- (AStarNode *) getNode:(NSInteger) index;
- (void) addNode:(AStarNode *) node;
- (void) addNodes:(NSArray *) nodes;
- (void) removeNode:(AStarNode *) node;
- (void) removeNodes:(NSArray *) nodes;
- (void) removeAllNodes;
- (BOOL) isNodeExists:(AStarNode *) node;

- (NSArray *) getShortestPath:(AStarNode *) source :(AStarNode *) destination;

@end
