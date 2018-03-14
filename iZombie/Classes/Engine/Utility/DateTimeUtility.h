//
//  DateTimeUtility.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <time.h>
#import <sys/time.h>
#import <sys/timeb.h>

@class DateTimeUtility;

@interface DateTimeUtility : NSObject {

	@private
	long _currentTimeMillisecondsOffset;
	CGFloat _currentTimeMillisecondsSpeed;
}

+ (DateTimeUtility *) getInstance;

- (NSString *) getDateTime:(NSString *) format;

- (long) getCurrentTimeMillisecondsOffset;
- (void) setCurrentTimeMillisecondsOffset:(long) offset;

- (CGFloat) getCurrentTimeMillisecondsSpeed;
- (void) setCurrentTimeMillisecondsSpeed:(CGFloat) speed;

- (long) getCurrentTimeMilliseconds;

@end
