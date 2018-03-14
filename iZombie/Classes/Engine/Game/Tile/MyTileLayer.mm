//
//  TileLayer.mm
//  iEngine
//
//  Created by Safiul Azam on 7/11/09.
//  Copyright 2009 None. All rights reserved.
//

#import "MyTileLayer.h"


@implementation MyTileLayer

-(id) initWithTileMap:(TileMap *) tileMap {

	[super initWithSize:[tileMap getSize]];
		
	_tileMap = tileMap;
	[_tileMap retain];
    
    _depthSort = NO;
    _depthSortLayers = [[NSMutableArray alloc] init];
		
	_tileSprites = [[NSMutableArray alloc] init];
	
	for(NSInteger i = 0; i < [_tileMap getMapSize].height; i++) {
	
		NSMutableArray *tileSpritesRow = [[[NSMutableArray alloc] init] autorelease];
		
		for(NSInteger j = 0; j < [_tileMap getMapSize].width; j++) {
			
			Index index = IndexMake(j, i);
			Tile *tile = [[self getTileMap] getTileAtIndex:index];
			
			TileSprite *tileSprite = [[[TileSprite alloc] initWithSize:[_tileMap getTileSize]] autorelease];
			[tileSprite setCenter:[tile getCenter]];
			[tileSpritesRow addObject:tileSprite];			
		}
		
		[_tileSprites addObject:tileSpritesRow];
	}
	
	return self;
}

- (TileMap *) getTileMap
{
	return _tileMap;
}

- (BOOL) isDepthSort 
{
    return _depthSort;
}

- (void) setDepthSort:(BOOL) sort
{
    _depthSort = sort;
}

-(NSArray *) getTileSprites {

	return _tileSprites;
}

-(TileSprite *) getTileSprite:(Index) index {
	
	return [[_tileSprites objectAtIndex:index.row] objectAtIndex:index.column];
}

-(NSArray *) getTileSets:(Index) index {

	return [[self getTileSprite:index] getFrameSets];
}

-(NSInteger) getCountTileSets:(Index) index {

	return [[self getTileSprite:index] getCountFrameSets];
}

-(NSInteger) getTileSetIndex:(Index) index :(TileSet *) tileSet {

	return [[self getTileSprite:index] getFrameSetIndex:tileSet];
}

-(TileSet *) getTileSet:(Index) index :(NSInteger) location {

	return (TileSet *) [[self getTileSprite:index] getFrameSet:location];
}

-(void) addTileSet:(Index) index :(TileSet *) tileSet {

	[[self getTileSprite:index] addFrameSet:tileSet];
}

-(void) addTileSet:(TileSet *) tileSet {

	for(NSInteger i = 0; i < [[self getTileMap] getMapSize].height; i++)
		for(NSInteger j = 0; j < [[self getTileMap] getMapSize].width; j++)
			[self addTileSet:IndexMake(j, i) :tileSet];
}

-(void) replaceTileSet:(Index) index :(NSInteger) location :(TileSet *) tileSet {

	[[self getTileSprite:index] replaceFrameSet:location :tileSet];
}

-(void) replaceTileSet:(NSInteger) index :(TileSet *) tileSet {
	
	for(NSInteger i = 0; i < [[self getTileMap] getMapSize].height; i++)
		for(NSInteger j = 0; j < [[self getTileMap] getMapSize].width; j++)
			[self replaceTileSet:IndexMake(j, i) :index :tileSet];
}

-(void) removeTileSet:(Index) index :(TileSet *) tileSet {

	[[self getTileSprite:index] removeFrameSet:tileSet];
}

-(void) removeTileSet:(TileSet *) tileSet {

	for(NSInteger i = 0; i < [[self getTileMap] getMapSize].height; i++)
		for(NSInteger j = 0; j < [[self getTileMap] getMapSize].width; j++)
			[self removeTileSet:IndexMake(j, i) :tileSet];
}

-(void) removeAllTileSets:(Index) index {

	[[self getTileSprite:index] removeAllFrameSets];
}

-(void) removeAllTileSets {
	
	for(NSInteger i = 0; i < [[self getTileMap] getMapSize].height; i++)
		for(NSInteger j = 0; j < [[self getTileMap] getMapSize].width; j++)
			[self removeAllTileSets:IndexMake(j, i)];
}

-(NSArray *) getTileAnimations:(Index) index {

	return [[self getTileSprite:index] getFrameAnimations];
}

-(NSInteger) getCountTileAnimations:(Index) index {

	return [[self getTileSprite:index] getCountFrameAnimations];
}

-(NSInteger) getTileAnimationIndex:(Index) index :(TileAnimation *) tileAnimation {

	return [[self getTileSprite:index] getFrameAnimationIndex:tileAnimation];
}

-(TileAnimation *) getTileAnimation:(Index) index :(NSInteger) location {

	return (TileAnimation *) [[self getTileSprite:index] getFrameAnimation:location];
}

-(void) addTileAnimation:(Index) index :(TileAnimation *) tileAnimation {

	[[self getTileSprite:index] addFrameAnimation:tileAnimation];
}

-(void) addTileAnimation:(TileAnimation *) tileAnimation {
	
	for(NSInteger i = 0; i < [[self getTileMap] getMapSize].height; i++)
		for(NSInteger j = 0; j < [[self getTileMap] getMapSize].width; j++)
			[self addTileAnimation:IndexMake(j, i) :tileAnimation];
}

-(void) replaceTileAnimation:(Index) index :(NSInteger) location :(TileAnimation *) tileAnimation {

	[[self getTileSprite:index] replaceFrameAnimation:location :tileAnimation];
}

-(void) replaceTileAnimation:(NSInteger) index :(TileAnimation *) tileAnimation {
	
	for(NSInteger i = 0; i < [[self getTileMap] getMapSize].height; i++)
		for(NSInteger j = 0; j < [[self getTileMap] getMapSize].width; j++)
			[self replaceTileAnimation:IndexMake(j, i) :index :tileAnimation];
}

-(void) removeTileAnimation:(Index) index :(TileAnimation *) tileAnimation {

	[[self getTileSprite:index] removeFrameAnimation:tileAnimation];
}

-(void) removeTileAnimation:(TileAnimation *) tileAnimation {
	
	for(NSInteger i = 0; i < [[self getTileMap] getMapSize].height; i++)
		for(NSInteger j = 0; j < [[self getTileMap] getMapSize].width; j++)
			[self removeTileAnimation:IndexMake(j, i) :tileAnimation];
}

-(void) removeAllTileAnimations:(Index) index {

	[[self getTileSprite:index] removeAllFrameAnimations];
}

-(void) removeAllTileAnimations {

	for(NSInteger i = 0; i < [[self getTileMap] getMapSize].height; i++)
		for(NSInteger j = 0; j < [[self getTileMap] getMapSize].width; j++)
			[self removeAllTileAnimations:IndexMake(j, i)];
}

-(NSInteger) getActiveTileAnimationIndex:(Index) index {

	return [[self getTileSprite:index] getActiveFrameAnimationIndex];
}

-(void) setActiveTileAnimationIndex:(Index) index :(NSInteger) location {

	[[self getTileSprite:index] setActiveFrameAnimationIndex:location];
}

-(TileAnimation *) getActiveTileAnimation:(Index) index {

	return (TileAnimation *) [[self getTileSprite:index] getActiveFrameAnimation];
}

-(void) draw {
	
	if(![self isVisible])
		return;
    
	[super draw];
		
	glPushMatrix();
	glTranslatef([self getCenter].x, [self getCenter].y, 0.0);	
	
	// Flip.
	if([self getFlip] != FlipNone) {
		
		if([self getFlip] == FlipHorizontal)
			glRotatef(180.0, 0.0, 1.0, 0.0);
		else if([self getFlip] == FlipVertical)
			glRotatef(180.0, 1.0, 0.0, 0.0);
		else {
			
			glRotatef(180.0, 0.0, 1.0, 0.0);
			glRotatef(180.0, 1.0, 0.0, 0.0);
		}
	}
		
	glScalef([self getScale].x, [self getScale].y, 0);
	glRotatef([self getRotate], 0.0, 0.0, 1.0);	
    
    // Remove all layers.
    [_depthSortLayers removeAllObjects];
		
	for(NSInteger i = 0; i < [[self getTileMap] getMapSize].height; i++) {
	
		NSMutableArray *tilesRow = [_tileSprites objectAtIndex:i];
		
		for(NSInteger j = 0; j < [[self getTileMap] getMapSize].width; j++) {
		
			Index index = IndexMake(j, i);
			Tile *tile = [[self getTileMap] getTileAtIndex:index];
			
			TileSprite *tileSprite = [tilesRow objectAtIndex:j];
			[tileSprite setCenter:[tile getCenter]];
            
            [_depthSortLayers addObject:tileSprite];
        }
	}
	
	for(NSInteger i = 0; i < [self getCountChilds]; i++) {
		
		Layer *child = (Layer *) [self getChild:i];
        [_depthSortLayers addObject:child];
    }
    
    for(NSInteger i = 0; i < [_depthSortLayers count]; i++) {
            
        Layer *child = (Layer *) [_depthSortLayers objectAtIndex:i];
        [child draw];
    }
    
    // Remove all layers.
    [_depthSortLayers removeAllObjects];
	
	glPopMatrix();
}

- (void) dealloc 
{
	[_tileMap release];	
	[_tileSprites release];
    [_depthSortLayers release];
    
    [[LogUtility getInstance] printMessage:@"TileLayer - dealloc"];
	
	[super dealloc];
}

@end
