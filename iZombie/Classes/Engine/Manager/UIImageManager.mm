//
//  UIImageManager.mm
//  iEngine
//
//  Created by Safiul Azam on 7/22/09.
//  Copyright 2009 None. All rights reserved.
//

#import "UIImageManager.h"

static UIImageManager *_uiImageManager = nil;

@implementation UIImageManager

- (id) init 
{
	[super init];
	
	_uiImages = [[NSMutableDictionary alloc] init];
	
	return self;
}

+ (UIImageManager *) getInstance 
{
	if(_uiImageManager == nil)
		_uiImageManager = [[UIImageManager alloc] init];
	
	return _uiImageManager;
}

- (NSArray *) getUIImages
{
	return [_uiImages allValues];
}
- (NSInteger) getCountUIImages
{
	return [[self getUIImages] count]; 
}

- (UIImage *) getUIImage:(NSString *) filename {

	if([_uiImages objectForKey:filename] == nil) {
	
		NSString *extension = [filename pathExtension];
	
		NSString *name = [filename substringWithRange:NSMakeRange(0, [filename length] - [extension length] - 1 /*.*/)];
		
		NSString *local = [[NSBundle mainBundle] pathForResource:name ofType:extension];
	
		NSData *data = [NSData dataWithContentsOfFile:local];
		
		[_uiImages setObject:[UIImage imageWithData:data] forKey:filename];
	}
	
	return (UIImage *) [_uiImages objectForKey:filename];
}

- (NSArray *) getUIImages:(NSString *) filename index:(NSInteger) index length:(NSInteger) length {
	
	NSMutableArray *images = [[[NSMutableArray alloc] init] autorelease];
	
	for(NSInteger i = index; i < index + length; i++) {
				
		NSString *name = [filename stringByReplacingOccurrencesOfString:@"#" withString:[[NSNumber numberWithInt:i] stringValue]];
		
		[images addObject:[self getUIImage:name]];
	}
	
	return (NSArray *) images;
}

- (void) releaseUIImage:(NSString *) filename
{
	UIImage *uiImage = [self getUIImage:filename];
	[_uiImages removeObjectForKey:filename];
	[uiImage release];
}

- (void) releaseAllUIImages {
	
	NSArray *keys = [_uiImages allKeys];
	
	for(NSInteger i = 0; i < [keys count]; i++)
	{
		NSString *key = [keys objectAtIndex:i];
		[self releaseUIImage:key];
	}
	
	[_uiImages removeAllObjects];
	
	[[LogUtility getInstance] print:@"UIImageManager release all textures."];
}

- (void) dealloc 
{
	[self releaseAllUIImages];
	
	[[LogUtility getInstance] print:@"UIImageManager release."];
	
	[_uiImages release];
	
	[super dealloc];
}

@end
