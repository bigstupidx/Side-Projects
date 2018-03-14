//
//  Character.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Font.h"
#import "LogUtility.h"

@class Font;

@interface Character : NSObject {

	@private
	Font *_font;
	NSString *_character;
	CGRect _frame;
}

- (id) initWithFont:(Font *) font :(NSString *) character :(CGRect) frame;

- (NSString *) getCharacter;

- (CGRect) getFrame;

@end
