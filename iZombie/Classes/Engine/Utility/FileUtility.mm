//
//  FileUtility.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FileUtility.h"

static FileUtility *_fileUtility = nil;

@implementation FileUtility

- (id) init 
{
	[super init];
	
	return self;
}

+ (FileUtility *) getInstance 
{
	if(_fileUtility == nil)
		_fileUtility = [[FileUtility alloc] init];
	
	return _fileUtility;
}

- (NSString *) getFileAsText:(NSString *) filename 
{
	return [self getFileAsText:filename :NSASCIIStringEncoding];
}

- (NSString *) getFileAsText:(NSString *) filename :(NSStringEncoding) encoding {
	
	NSString *extension = [filename pathExtension];
	
	NSString *name = [filename substringWithRange:NSMakeRange(0, [filename length] - ([extension length] + 1))];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:extension];
	
	return [NSString stringWithContentsOfFile:path encoding:encoding error:nil];
}

- (void) dealloc 
{
	[super dealloc];
}

@end
