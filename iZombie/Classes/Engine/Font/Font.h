//
//  Font.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Texture.h"
#import "TextureManager.h"
#import "LogUtility.h"
#import "Character.h"
#import "FileUtility.h"

@interface Font : NSObject<NSXMLParserDelegate> {

	@private
	NSString *_filename;
    NSString *_contents;
	NSMutableArray *_characters;
	CGSize _maximumCharacterSize;
	
	NSString *_name;
	CGFloat _size;
	CGFloat _resize;
	NSString *_imageFilename;
	CGFloat _interCharacterSpace;
	CGFloat _interWordSpace;
	CGFloat _interLineSpace;
    
    NSXMLParser *_xmlParser;
}

- (id) initWithFilename:(NSString *) filename;

- (NSString *) getName;

- (CGFloat) getSize;

- (Texture *) getTexture;

- (CGFloat) getInterCharacterSpace;

- (CGFloat) getInterWordSpace;

- (CGFloat) getInterLineSpace;

- (NSArray *) getCharacters;

- (CGFloat) getResize;

- (void) setResize:(CGFloat) resize;

- (CGSize) getMaximumCharacterSize;

- (CGSize) getCharacterSize:(NSString *) character;

- (void) drawCharacter:(NSString *) character :(CGPoint) position;

@end
