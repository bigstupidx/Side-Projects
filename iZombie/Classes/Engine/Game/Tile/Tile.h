//
//  Tile.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Index.h"
#import "Element.h"

@interface Tile : Element {

	@private
	CGSize _size;
	CGPoint _center;
	Index _index;	
	BOOL _accessible;
}

- (id) initWithSize:(CGSize) size :(CGPoint) center :(Index) index;

- (CGSize) getSize;

- (CGPoint) getCenter;

- (Index) getIndex;

- (BOOL) isAccessible;
- (void) setAccessible:(BOOL) accessible;

@end
