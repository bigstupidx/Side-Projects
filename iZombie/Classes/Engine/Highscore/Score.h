//
//  Score.h
//  Poppers
//
//  Created by Safiul Azam on 7/26/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogUtility.h"


@interface Score : NSObject<NSCoding> {

	NSString *_name;
	NSNumber *_score;
    NSString *_information;
    NSInteger sorter;
}

- (id)initWithName:(NSString *) name :(NSNumber *) score;
- (id)initWithName:(NSString *) name :(NSNumber *) score :(NSString *) information;

- (NSString *) getName;
- (NSNumber *) getScore;
- (NSString *) getInformation;



@end
