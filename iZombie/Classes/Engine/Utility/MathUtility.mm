//
//  MathUtility.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MathUtility.h"

static MathUtility *_mathUtility = nil;

@implementation MathUtility

- (id) init 
{
	[super init];
	
	srand(time(nil));
		
	return self;
}

+ (MathUtility *) getInstance 
{
	if(_mathUtility == nil)
		_mathUtility = [[MathUtility alloc] init];
	
	return _mathUtility;
}

- (NSInteger) getRandomNumber:(NSInteger) max 
{
	return [[MathUtility getInstance] getRandomNumber:0 :max];
}

- (NSInteger) getRandomNumber:(NSInteger) min :(NSInteger) max 
{
	return min + (rand() % ((max - min) + 1));
}

- (CGFloat)  getDegreeToRadian:(CGFloat) degree
{
	return (degree * M_PI) / 180;
}

- (CGFloat) getRadianToDegree:(CGFloat) radian
{
	return(radian * 180) / M_PI;
}

- (CGFloat) getDistanceBetweenPoints:(CGPoint) point1 :(CGPoint) point2
{
	return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2));
}

- (CGFloat) getAngleBetweenHorizontalAxisAndPoint:(CGPoint) point
{
	CGFloat angle = [[MathUtility getInstance] getRadianToDegree:atan2(point.y, point.x)];
	angle = angle < 0 ? 360 + angle : angle;
	
	return angle;
}

- (CGRect) getIntersectionBetweenRectangles:(CGRect) rectangle1 :(CGRect) rectangle2
{	
	CGFloat left = fmax(rectangle1.origin.x, rectangle2.origin.x);
	CGFloat top = fmax(rectangle1.origin.y, rectangle2.origin.y);
	CGFloat right = fmax(rectangle1.origin.x + rectangle1.size.width, rectangle2.origin.x + rectangle2.size.width);
	CGFloat bottom = fmax(rectangle1.origin.y + rectangle1.size.height, rectangle2.origin.y + rectangle2.size.height);
	
	if(right < left || bottom < top)
		return CGRectMake(0, 0, 0, 0);
	
	return CGRectMake(left, top, right - left, bottom - top);
}

- (void) dealloc 
{
	[super dealloc];
}

@end
