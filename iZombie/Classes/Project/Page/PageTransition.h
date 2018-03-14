//
//  PageTransition.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	
	PageTransitionNone,
	PageTransitionSlideLeft,
	PageTransitionSlideRight,
	PageTransitionFlipLeft,
	PageTransitionFlipRight,
	PageTransitionCurlUp,
	PageTransitionCurlDown,
	PageTransitionFadeIn,
	PageTransitionFadeOut
	
} PageTransition;
