//
//  TextureManager.h
//  iEngine
//
//  Created by Safiul Azam on 7/13/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Texture.h"

@class TextureManager;

@interface TextureManager : NSObject {

	@private
	NSMutableDictionary *_textures;
}

+ (TextureManager *) getInstance; 

- (NSArray *) getTextures;
- (NSInteger) getCountTextures;
- (Texture *) getTexture:(NSString *) filename;
- (NSArray *) getTextures:(NSString *) filename index:(NSInteger) index length:(NSInteger) length;
- (void) renewAllTextures;
- (void) releaseTexture:(NSString *) filename;
- (void) releaseAllTextures;

@end
