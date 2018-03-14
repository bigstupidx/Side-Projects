//
//  Color.h
//  iEngine
//
//  Created by Safiul Azam on 8/12/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>

struct Color 
{
	CGFloat red;
	CGFloat green;
	CGFloat blue;
	CGFloat alpha;
};

typedef struct Color Color;

Color ColorMake(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

Color ColorClone(Color color);