//
//  Avatar.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogUtility.h"

@interface Item : NSObject
{
    @private
    NSString *_name;
    NSString *_thumbFilename;
    NSString *_imageFilename;
    NSNumber *_price;
    NSNumber *_own;
}

-(id)initWithCoder:(NSCoder *) decoder;

-(NSString *) getName;
-(void) setName:(NSString *) name;

-(NSString *) getThumbFilename;
-(void) setThumbFilename:(NSString *) filename;

-(NSString *) getImageFilename;
-(void) setImageFilename:(NSString *) filename;

-(NSInteger) getPrice;
-(void) setPrice:(NSInteger) price;

-(BOOL) isOwn;
-(void) setOwn:(BOOL) own;

@end
