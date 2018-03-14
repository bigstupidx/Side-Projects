//
//  MathUtility.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MathUtility;

@interface MathUtility : NSObject 
{
}

+ (MathUtility *) getInstance;

- (NSInteger) getRandomNumber:(NSInteger) max;

- (NSInteger) getRandomNumber:(NSInteger) min :(NSInteger) max;

- (CGFloat)  getDegreeToRadian:(CGFloat) degree;

- (CGFloat) getDistanceBetweenPoints:(CGPoint) point1 :(CGPoint) point2;

- (CGFloat) getAngleBetweenHorizontalAxisAndPoint:(CGPoint) point;

- (CGRect) getIntersectionBetweenRectangles:(CGRect) rectangle1 :(CGRect) rectangle2;

@end
