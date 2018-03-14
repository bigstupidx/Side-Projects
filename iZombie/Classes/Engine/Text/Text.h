//
//  Text.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alignment.h"
#import "Font.h"
#import "LogUtility.h"


@interface Text : NSObject {

	@private
	NSString *LINE_BREAK;
	NSString *WORD_SPACE;
	
	Font *_font;
	CGRect _frame;
	
	NSString *_text;
	NSString *_warpedText;
	Alignment _alignment;
	CGFloat _offset;
	NSInteger _scroll;
	CGFloat _fontResize;
}

- (id) initWithFont:(Font *) font :(CGRect) frame;

- (Font *) getFont;

- (CGRect) getFrame;
- (void) setFrame:(CGRect) frame;

- (NSString *) getText;
- (void) setText:(NSString *) text;

- (Alignment) getAlignment;
- (void) setAlignment:(Alignment) alignment;

- (CGFloat) getOffset;
- (void) setOffset:(CGFloat) offset;

- (NSInteger) getScroll;
- (void) setScroll:(NSInteger) scroll;
- (NSInteger) getRemainScroll;

- (CGSize) getTextSize:(NSString *) text;

- (void) drawText:(NSString *) text :(CGPoint) position;
- (void) drawText:(NSString *) text :(CGPoint) position :(Alignment) alignment;
- (void) draw;

@end
