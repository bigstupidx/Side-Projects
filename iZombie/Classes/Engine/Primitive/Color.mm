//
//  Color.mm
//  iEngine
//
//  Created by Safiul Azam on 8/12/09.
//  Copyright 2009 None. All rights reserved.
//

#import "Color.h"

Color ColorMake(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) 
{
	Color color;
	color.red = red;
	color.green = green;
	color.blue = blue;
	color.alpha = alpha;
	
	return color;
}

Color ColorClone(Color color)
{
	return ColorMake(color.red, color.green, color.blue, color.alpha);
}