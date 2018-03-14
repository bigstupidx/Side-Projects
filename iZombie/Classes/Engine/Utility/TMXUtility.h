//
//  TMXUtility.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUIImageView.h"
#import "UIImageManager.h"
#import "FileUtility.h"
#import "Texture.h"
#import "TextureManager.h"
#import "TileSet.h"
#import "DataUtility.h"
#import "TileMap.h"
#import "Orientation.h"
#import "MyTileLayer.h"

@class TMXUtility;

@interface TMXUtility : NSObject <NSXMLParserDelegate>
{
    NSString *_filename;
    NSString *_contents;
    
    NSString *_mapVersion;
    NSString *_mapOrientation;
    CGSize _mapSize;
    CGSize _tileSize;
    
    NSMutableArray *_tileSets;
    NSMutableArray *_tileLayers;
    
    NSXMLParser *_xmlParser;
    
    NSString *_elementName;
    
    NSString *_tileSetName;
    NSInteger _tileSetFirstGID;
    NSInteger _tileSetTileWidth;
    NSInteger _tileSetTileHeight;
    NSString *_tileSetImageSource;
    
    NSString *_layerName;
    NSInteger _layerWidth;
    NSInteger _layerHeight;
    NSString *_layerData;
}

+ (TMXUtility *) getInstance; 

- (void) loadFile:(NSString *) filename;

- (NSString *) getMapVersion;
- (NSString *) getMapOrientation;
- (CGSize) getMapSize;
- (CGSize) getTileSize;

- (NSArray *) getTileSets;
- (NSArray *) getTileLayers;

@end
