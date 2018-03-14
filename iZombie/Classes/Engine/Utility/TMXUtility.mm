//
//  TMXUtility.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TMXUtility.h"

static TMXUtility *_tmxUtility = nil;

@implementation TMXUtility

- (id) init 
{
	[super init];
    
    _xmlParser = nil;
    _elementName = nil;
    
    _tileSetName = nil;
    _tileSetFirstGID = 0;
    _tileSetTileWidth = 0;
    _tileSetTileHeight = 0;
    _tileSetImageSource = nil;
    
    _layerName = nil;
    _layerWidth = 0;
    _layerHeight = 0;
    _layerData = nil;
	
	return self;
}

+ (TMXUtility *) getInstance 
{
	if(_tmxUtility == nil)
		_tmxUtility = [[TMXUtility alloc] init];
	
	return _tmxUtility;
}

- (void) loadFile:(NSString *) filename
{
    _filename = filename;
    [_filename retain];
    
    _contents = [[FileUtility getInstance] getFileAsText:filename];
    [_contents retain];
    
    [[LogUtility getInstance] print:_contents];
    
    if(_tileSets != nil)
        [_tileSets release];
    
    _tileSets = [[NSMutableArray alloc] init];
    
    if(_tileLayers != nil)
        [_tileLayers release];
    
    _tileLayers = [[NSMutableArray alloc] init];
    
    if(_xmlParser != nil)
        [_xmlParser release];
    
    _xmlParser = [[NSXMLParser alloc] initWithData:[_contents dataUsingEncoding:NSUTF8StringEncoding]];
    [_xmlParser setDelegate:self];
    [_xmlParser parse];
}

- (NSString *) getMapVersion
{
    return _mapVersion;
}

- (NSString *) getMapOrientation 
{
    return _mapOrientation;
}

- (CGSize) getMapSize
{
    return _mapSize;
}

- (CGSize) getTileSize
{
    return _tileSize;
}

- (NSArray *) getTileSets
{
    return (NSArray *) _tileSets;
}

- (NSArray *) getTileLayers
{
    return (NSArray *) _tileLayers;
}

- (void) parserDidStartDocument:(NSXMLParser *) parser 
{
    [[LogUtility getInstance] printMessage:@"parserDidStartDocument"];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [[LogUtility getInstance] printMessage:@"didStartElement"];
    
    if([elementName isEqualToString:@"map"])
    {
        _mapVersion = [attributeDict objectForKey:@"version"];
        [[LogUtility getInstance] printMessage:_mapVersion];
        
        _mapOrientation = [attributeDict objectForKey:@"orientation"];
        [[LogUtility getInstance] printMessage:_mapOrientation];
        
        NSInteger width = [[attributeDict objectForKey:@"width"] integerValue];
        NSInteger height = [[attributeDict objectForKey:@"height"] integerValue];
        _mapSize = CGSizeMake(width, height);
        [[LogUtility getInstance] printSize:_mapSize];
        
        NSInteger tileWidth = [[attributeDict objectForKey:@"tilewidth"] integerValue];
        NSInteger tileHeight = [[attributeDict objectForKey:@"tileheight"] integerValue];
        _tileSize = CGSizeMake(tileWidth, tileHeight);
        [[LogUtility getInstance] printSize:_tileSize];
    }
    else if([elementName isEqualToString:@"tileset"])
    {
        _tileSetName = [attributeDict objectForKey:@"name"];
        [_tileSetName retain];
        [[LogUtility getInstance] printMessage:_tileSetName];
        
        _tileSetFirstGID = [[attributeDict objectForKey:@"firstgid"] integerValue];
        [[LogUtility getInstance] printMessage:[[NSNumber numberWithInt:_tileSetFirstGID] stringValue]];
        
        _tileSetTileWidth = [[attributeDict objectForKey:@"tilewidth"] integerValue];
        [[LogUtility getInstance] printMessage:[[NSNumber numberWithInt:_tileSetTileWidth] stringValue]];
        
        _tileSetTileHeight = [[attributeDict objectForKey:@"tileheight"] integerValue];
        [[LogUtility getInstance] printMessage:[[NSNumber numberWithInt:_tileSetTileHeight] stringValue]];
    }
    else if([elementName isEqualToString:@"image"])
    {
        _tileSetImageSource = [attributeDict objectForKey:@"source"];
        [_tileSetImageSource retain];
        [[LogUtility getInstance] printMessage:_tileSetImageSource];
    }
    else if([elementName isEqualToString:@"layer"])
    {
        _layerName = [attributeDict objectForKey:@"name"];
        [_layerName retain];
        [[LogUtility getInstance] printMessage:_layerName];
        
        _layerWidth = [[attributeDict objectForKey:@"width"] integerValue];
        [[LogUtility getInstance] printMessage:[[NSNumber numberWithInt:_layerWidth] stringValue]];
        
        _layerHeight = [[attributeDict objectForKey:@"height"] integerValue];
        [[LogUtility getInstance] printMessage:[[NSNumber numberWithInt:_layerHeight] stringValue]];
    }
    
    _elementName = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([_elementName isEqualToString:@"data"])
    {
        _layerData = string;
        [_layerData retain];
    
        [[LogUtility getInstance] printMessage:_layerData];
    }
}


- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"tileset"])
    {
        Texture *tileSetTexture = [[TextureManager getInstance] getTexture:_tileSetImageSource];
        CGSize tileSetTileSize = CGSizeMake(_tileSetTileWidth, _tileSetTileHeight);
    
        TileSet *tileSet = [[[TileSet alloc] initWithFirstFrameIndex:_tileSetFirstGID :tileSetTileSize :tileSetTexture] autorelease];
        [tileSet setName:_tileSetName];
        [_tileSets addObject:tileSet];
        
        // Erase.
        [_tileSetName release];
        _tileSetName = nil;
        _tileSetFirstGID = 0;
        _tileSetTileWidth = 0;
        _tileSetTileHeight = 0;
        [_tileSetImageSource release];
        _tileSetImageSource = nil;
    }
    else if([elementName isEqualToString:@"layer"])
    {
        Orientation orientation = OrientationOrthogonal;
        if([_mapOrientation isEqualToString:@"isometric"])
            orientation = OrientationIsometric;
        
        TileMap *tileMap = [[[TileMap alloc] initWithOrientation:orientation :_mapSize :_tileSize] autorelease];
        MyTileLayer *tileLayer = [[[MyTileLayer alloc] initWithTileMap:tileMap] autorelease];
        
        // Add TileSets.
        for(int i = 0; i < [_tileSets count]; i++)
            [tileLayer addTileSet:[_tileSets objectAtIndex:i]];
        
        [[LogUtility getInstance] printMessage:_layerData];
        
        const char *data = [[[DataUtility getInstance] getBase64DecodedString:_layerData] UTF8String];
        
        int index = 0;
        
        for(int i = 0; i < _layerHeight; i++)
        {
            for(int j = 0; j < _layerWidth; j++)
            {
                unsigned int frame = data[index] | data[index + 1] << 8 | data[index + 2] << 16 | data[index + 3] << 24;
                [[LogUtility getInstance] printFloat:frame];
                
                NSArray *sequence = [NSArray arrayWithObject:[NSNumber numberWithInt:frame]];
                TileAnimation *tileAnimation = [[[TileAnimation alloc] initWithFrameSequence:sequence :-1] autorelease];
                [tileLayer addTileAnimation:IndexMake(j, i) :tileAnimation];
                
                index += 4;
            }
        }
        
        [_tileLayers addObject:tileLayer];
        
        // Erase.
        [_layerName release];
        _layerName = nil;
        _layerWidth = 0;
        _layerHeight = 0;
        [_layerData release];
        _layerData = nil;
    }
    
    _elementName = nil;
    
    [[LogUtility getInstance] printMessage:@"didEndElement"];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [[LogUtility getInstance] printMessage:@"parserDidStartDocument"];
}

- (void) dealloc 
{
    [_filename release];
    [_contents release];
    
    [_tileSetName release];
    [_tileSetImageSource release];
    
    [_layerName release];
    [_layerData release];
    
    [_tileSets release];
    [_tileLayers release];
    
    [_xmlParser release];
    
	[super dealloc];
}

@end
