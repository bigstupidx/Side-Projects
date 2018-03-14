//
//  TileMap.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TileMap.h"


@implementation TileMap

- (id) initWithOrientation:(Orientation) orientation :(CGSize) mapSize :(CGSize) tileSize
{
	[super init];
	
	_orientation = orientation;
	_mapSize = mapSize;
	_tileSize = tileSize;
	
	_size = CGSizeMake(_mapSize.width * _tileSize.width, _mapSize.height * _tileSize.height);
	
	_tiles = [[NSMutableArray alloc] init];
	
	for(NSInteger i = 0; i < _mapSize.height; i++)
	{
		NSMutableArray *tilesRow = [[NSMutableArray alloc] init];
	
		for(NSInteger j = 0; j < _mapSize.width; j++)
		{
			Index index = IndexMake(j, i);
			CGPoint center = [self getTileCenter:index];
			CGSize size = _tileSize;
			
			Tile *tile = [[Tile alloc] initWithSize:size :center :index];
			[tilesRow addObject:tile];
		}		
		
		[_tiles addObject:tilesRow];
	}
		
	return self;
}

- (Orientation) getOrientation
{
	return _orientation;
}

- (CGSize) getMapSize
{
	return _mapSize;
}

- (CGSize) getTileSize
{
	return _tileSize;
}

- (CGSize) getSize
{
	return _size;
}

- (NSArray *) getTiles
{
	return (NSArray *) _tiles;
}

- (BOOL) isTileExistsAtIndex:(Index) index
{
	if(index.row == NSNotFound || index.column == NSNotFound)
		return NO;
	else if(index.row < 0 || index.row >= [self getMapSize].height)
		return NO;
	else if(index.column < 0 || index.column >= [self getMapSize].width)
		return NO;
	
	return YES;
}

- (BOOL) isTileExistsAtPosition:(CGPoint) position
{
	Index index = [self getTileIndexAtPosition:position];
	
	return [self isTileExistsAtIndex:index];
}

- (Tile *) getTileAtIndex:(Index) index
{
	if(![self isTileExistsAtIndex:index])
		return nil;
	
	return [(NSArray *) [[self getTiles] objectAtIndex:index.row] objectAtIndex:index.column];
}

- (BOOL) isTileAccessibleAtIndex:(Index) index
{
	if(![self isTileExistsAtIndex:index])
		return NO;
	
	return [(Tile *) [self getTileAtIndex:index] isAccessible];	
}

- (void) setTileAccessibleAtIndex:(Index) index :(BOOL) accessible
{
	if(![self isTileExistsAtIndex:index])
		return;
	
	[(Tile *) [self getTileAtIndex:index] setAccessible:accessible];
}

- (BOOL) isTileAccessibleAtPosition:(CGPoint) position
{
	Index index = [self getTileIndexAtPosition:position];
	
	return [self isTileAccessibleAtIndex:index];
}

- (void) setTileAccessibleAtPosition:(CGPoint) position :(BOOL) accessible
{
	Index index = [self getTileIndexAtPosition:position];
	
	[self setTileAccessibleAtIndex:index :accessible];
}

- (CGPoint) getTileCenter:(Index) index
{
	if(![self isTileExistsAtIndex:index])
		return CGPointMake(NSNotFound, NSNotFound);
	
	CGFloat x = 0;
	CGFloat y = 0;
	
	if([self getOrientation] == OrientationIsometric)
	{
		CGPoint origin = CGPointMake([self getMapSize].height * [self getTileSize].width / 2, [self getTileSize].height / 2);
		
		x = (index.column - index.row) * [self getTileSize].width / 2 + origin.x;
		y = (index.column + index.row) * [self getTileSize].height / 2 + origin.y;
	}
	else
	{
		x = index.column * [self getTileSize].width + [self getTileSize].width / 2;
		y = index.row * [self getTileSize].height + [self getTileSize].height / 2;
	}
	
	x -= [self getSize].width / 2;
	y -= [self getSize].height / 2;
	
	return CGPointMake(x, y);
}

- (Index) getTileIndexAtPosition:(CGPoint) position
{
	if(position.x == NSNotFound || position.y == NSNotFound)
		return IndexMake(NSNotFound, NSNotFound);
	
	// Mod.
	position.x += [self getSize].width / 2;
	position.y += [self getSize].height / 2;
	
	NSInteger column = 0;
	NSInteger row = 0;
	
	if([self getOrientation] == OrientationIsometric)
	{
		CGFloat ratio = [self getTileSize].width / [self getTileSize].height;
		
		CGFloat x = position.x;
		CGFloat y = position.y;
		
		x -= [self getSize].width / 2;
		
		CGFloat mx = y + (NSInteger) (x / ratio);
		CGFloat my = y - (NSInteger) (x / ratio);
		
		column = (NSInteger) ((mx < 0 ? mx - [self getTileSize].height : mx) / [self getTileSize].height);
		row = (NSInteger) ((my < 0 ? my - [self getTileSize].height : my) / [self getTileSize].height);
		
	}
	else 
	{
		column = floor(position.x / [self getTileSize].width);
		row = floor(position.y / [self getTileSize].height);
	}
	
	// Mod.
	position.x -= [self getSize].width / 2;
	position.y -= [self getSize].height / 2;

	Index index = IndexMake(column, row);
	
	if(![self isTileExistsAtIndex:index])
		return IndexMake(NSNotFound, NSNotFound);
	
	return index;	
}

- (NSArray *) getTilesAccessible
{
	NSMutableArray *tiles = nil;
	
	for(NSInteger i = 0; i < [self getMapSize].height; i++)
		for(NSInteger j = 0; j < [self getMapSize].width; j++)
		{
			Index index = IndexMake(j, i);
			
			if([self isTileAccessibleAtIndex:index])
			{
				if(tiles == nil)
					tiles = [[NSMutableArray alloc] init];
				
				[tiles addObject:[self getTileAtIndex:index]];
			}
				
		}
	
	return (NSArray *) tiles;
}

- (void) dealloc 
{
    [[LogUtility getInstance] printMessage:@"TileMap - dealloc"];
    
	[super dealloc];
}

@end
