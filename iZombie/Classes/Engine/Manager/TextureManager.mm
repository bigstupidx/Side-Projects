//
//  TextureManager.mm
//  iEngine
//
//  Created by Safiul Azam on 7/13/09.
//  Copyright 2009 None. All rights reserved.
//

#import "TextureManager.h"

static TextureManager *_textureManager = nil;

@implementation TextureManager

- (id) init 
{
	[super init];
	
	_textures = [[NSMutableDictionary alloc] init];
	
	return self;
}

+ (TextureManager *) getInstance 
{
	if(_textureManager == nil)
		_textureManager = [[TextureManager alloc] init];
	
	return _textureManager;
}

- (NSArray *) getTextures {
		
	return [_textures allValues];	
}

- (NSInteger) getCountTextures {
	
	return [[self getTextures] count];
}

- (Texture *) getTexture:(NSString *) filename {
	
	if([_textures objectForKey:filename] == nil) {
	
		Texture *texture = [[Texture alloc] initWithFilename:filename];
		
		[_textures setValue:texture forKey:filename];
	}
			
	return (Texture *) [_textures objectForKey:filename];
}

- (NSArray *) getTextures:(NSString *) filename index:(NSInteger) index length:(NSInteger) length {
	
	NSMutableArray *textures = [[[NSMutableArray alloc] init] autorelease];
	
	for(NSInteger i = index; i < index + length; i++) {
		
		NSString *name = [filename stringByReplacingOccurrencesOfString:@"#" withString:[[NSNumber numberWithInt:i] stringValue]];
		
		[textures addObject:[self getTexture:name]];
	}
	
	return (NSArray *) textures;
}

- (void) renewAllTextures
{
	NSArray *textures = [self getTextures];
	
	for(NSInteger i = 0; i < [textures count]; i++)
		[(Texture *) [textures objectAtIndex:i] renew];
}

- (void) releaseTexture:(NSString *) filename
{
	Texture *texture = [self getTexture:filename];
	[_textures removeObjectForKey:filename];
	[texture release];
}

- (void) releaseAllTextures {
	
	NSArray *keys = [_textures allKeys];
	
	for(NSInteger i = 0; i < [keys count]; i++)
	{
		NSString *key = [keys objectAtIndex:i];
		[self releaseTexture:key];
	}
	
	[_textures removeAllObjects];
	
	[[LogUtility getInstance] print:@"TextureManager release all textures."];
}

- (void) dealloc 
{
	[self releaseAllTextures];
	
	[[LogUtility getInstance] print:@"TextureManager release."];
		
	[_textures release];
	
	[super dealloc];
}

@end
