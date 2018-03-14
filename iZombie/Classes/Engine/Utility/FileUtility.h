//
//  FileUtility.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FileUtility;

@interface FileUtility : NSObject 
{
}

+ (FileUtility *) getInstance; 

- (NSString *) getFileAsText:(NSString *) filename ;

- (NSString *) getFileAsText:(NSString *) filename :(NSStringEncoding) encoding;

@end
