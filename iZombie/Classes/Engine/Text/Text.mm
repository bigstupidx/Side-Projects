//
//  Text.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Text.h"


@implementation Text

- (id) initWithFont:(Font *) font :(CGRect) frame
{
	[super init];
	
	LINE_BREAK = @"\n";
	[LINE_BREAK retain];
	
	WORD_SPACE = @" ";
	[WORD_SPACE retain];
	
	_font = font;
	[_font retain];
	
	_frame = frame;
	
	_fontResize = [_font getResize];
	
	_text = nil;
	_warpedText = nil;
		
	return self;
}

- (Font *) getFont
{
	return _font;
}

- (CGRect) getFrame
{
	return _frame;
}

- (void) setFrame:(CGRect) frame
{
	_frame = frame;
	
	[self setText:[self getText]];
}

- (NSString *) getText
{
	return _text;
}

- (void) setText:(NSString *) text
{
	if(_text != nil)
		[_text release];
	
	_text = text;
	[_text retain];
	
	if(_warpedText != nil)
		[_warpedText release];
	_warpedText = nil;
	
	if(_text == nil)
		return;
	else if([_text length] == 0)
		return;
	
	_warpedText = @"";
	
	NSArray *lines = [_text componentsSeparatedByString:LINE_BREAK];
	
	for(NSInteger i = 0; i < [lines count]; i++)
	{
		NSString *line = [lines objectAtIndex:i];
		
		NSInteger lineWidth = 0;
		
		NSArray *words = [line componentsSeparatedByString:WORD_SPACE];
		
		for(NSInteger j = 0; j < [words count]; j++)
		{
			NSString *word = [words objectAtIndex:j];
			
			NSInteger wordWidth = (NSInteger) ([self getTextSize:word].width);
						
			if(lineWidth + wordWidth + [[self getFont] getInterWordSpace] > [self getFrame].size.width - [self getOffset] * 2)
			{
				_warpedText = [_warpedText stringByAppendingString:LINE_BREAK];
				lineWidth = 0;
			}
			
			_warpedText = [_warpedText stringByAppendingString:word];
			_warpedText = [_warpedText stringByAppendingString:WORD_SPACE];
			lineWidth += wordWidth + [[self getFont] getInterWordSpace];
		}
				
		if(i < [lines count] - 1)
			_warpedText = [_warpedText stringByAppendingString:LINE_BREAK];
	}
	
	[_warpedText retain];
}

- (Alignment) getAlignment;
{
	return _alignment;
}

- (void) setAlignment:(Alignment) alignment
{
	_alignment = alignment;
}

- (CGFloat) getOffset
{
	return _offset;
}

- (void) setOffset:(CGFloat) offset
{
	_offset = offset < 0 ? 0 : offset;
	
	[self setText:[self getText]];
}

- (NSInteger) getScroll
{
	return _scroll;
}

- (void) setScroll:(NSInteger) scroll
{
	[self check];
		
	if(scroll < 0)
		scroll = 0;
	else if(scroll > [self getScroll] + [self getRemainScroll])
		scroll = [self getScroll] + [self getRemainScroll];
	
	_scroll = scroll;
}

- (NSInteger) getRemainScroll
{
	[self check];
		
	CGFloat y = [self getFrame].origin.y + [self getOffset];
	
	NSArray *lines = [_warpedText componentsSeparatedByString:LINE_BREAK];
	
	for(NSInteger i = [self getScroll]; i < [lines count]; i++)
		if(y + [[self getFont] getMaximumCharacterSize].height > [self getFrame].size.height - [self getOffset] * 2)
			return [lines count] - i;
		else 
			y += [[self getFont] getMaximumCharacterSize].height + [[self getFont] getInterLineSpace];
	
	return 0;
}

- (CGSize) getTextSize:(NSString *) text
{
	[self check];
	
	CGFloat maximumWidth = 0;
	CGFloat maximumHeight = 0;
	
	NSArray *lines = [text componentsSeparatedByString:LINE_BREAK];
	
	// Maximum width.
	for(NSInteger i = 0; i < [lines count]; i++)
	{
		NSString *line = [lines objectAtIndex:i];
		
		CGFloat width = 0;
		
		for(NSInteger j = 0; j < [line length]; j++)
		{
			NSString *character = [line substringWithRange:NSMakeRange(j, 1)];
			CGSize characterSize = [[self getFont] getCharacterSize:character];
			
			if([character isEqualToString:WORD_SPACE])
				width += [[self getFont] getInterWordSpace];
			else if(characterSize.width != NSNotFound && characterSize.height != NSNotFound)
			{
				width += characterSize.width;
				
				if(j < [line length] - 1)
					width += [[self getFont] getInterCharacterSpace];
			}
			
			if(width > maximumWidth)
				maximumWidth = width;
		}
	}
		
	// Maximum height.
	if([lines count] > 0)
		maximumHeight = [lines count] * [[self getFont] getMaximumCharacterSize].height + ([lines count] - 1) * [[self getFont] getInterLineSpace];
	
	return CGSizeMake(maximumWidth, maximumHeight);
}


- (void) drawText:(NSString *) text :(CGPoint) position
{
	[self drawText:text :position :AlignmentLeft];
}

- (void) drawText:(NSString *) text :(CGPoint) position :(Alignment) alignment
{
	[self check];
	
	if([self getFont] == nil)
		return;
	else if(text == nil)
		return;
	else if([text length] == 0)
		return;
	
	CGFloat verticalSpace = 0;
	CGFloat horizontalSpace = 0;
	
	NSArray *lines = [text componentsSeparatedByString:LINE_BREAK];
	
	if([lines count] == 0)
		return;
	
	CGPoint temporaryPosition = position;
	
	for(NSInteger i = 0; i < [lines count]; i++)
	{
		NSString *line = [lines objectAtIndex:i];
		
		if(alignment == AlignmentLeft)
			temporaryPosition.x = position.x;
		else if(alignment == AlignmentRight)
			temporaryPosition.x = position.x - [self getTextSize:line].width;
		else 
			temporaryPosition.x = position.x - [self getTextSize:line].width / 2;
		
		for(NSInteger j = 0; j < [line length]; j++)
		{
			NSString *character = [line substringWithRange:NSMakeRange(j, 1)];
			
			CGSize characterSize = [[self getFont] getCharacterSize:character];
			
			CGFloat characterWidth = 0;
			
			if(characterSize.width == NSNotFound && characterSize.height == NSNotFound && ![character isEqualToString:WORD_SPACE])
				continue;
			
			characterWidth = [character isEqualToString:WORD_SPACE] ? [[self getFont] getInterWordSpace] : characterSize.width;
			
			if(![character isEqualToString:WORD_SPACE])
				[[self getFont] drawCharacter:character :temporaryPosition];
			
			if(j == [line length] - 1)
				horizontalSpace = 0;
			else 
				horizontalSpace = [character isEqualToString:WORD_SPACE] ? 0 : [[self getFont] getInterCharacterSpace];
			
			temporaryPosition.x += characterWidth + horizontalSpace;

		}
				
		if(i == [lines count] - 1)
			verticalSpace = 0;
		else 
			verticalSpace = [[self getFont] getInterLineSpace];
		
		temporaryPosition.y = position.y + [[self getFont] getMaximumCharacterSize].height + verticalSpace;
	}
}

- (void) draw
{
	[self check];
		
	if([self getFont] == nil)
		return;
	else if(_warpedText == nil)
		return;
	else if([_warpedText  length] == 0)
		return;
		
	CGPoint position = [self getFrame].origin;
	position.x += [self getOffset];
	position.y += [self getOffset];
	
	NSArray *lines = [_warpedText componentsSeparatedByString:LINE_BREAK];
	
	if([lines count] == 0)
		return;
		
	for(NSInteger i = [self getScroll]; i < [lines count] - [self getRemainScroll]; i++)
	{
		NSString *line = [lines objectAtIndex:i];
		
		if([self getFrame].origin.y + [self getOffset] - position.y + [self getTextSize:line].height > [self getFrame].size.height - [self getOffset] * 2)
			break;
		
		if([self getAlignment] == AlignmentLeft)
			position.x = position.x + [self getOffset];
		else if([self getAlignment] == AlignmentRight)
			position.x = [self getFrame].origin.x + [self getFrame].size.width - [self getOffset];
		else 
			position.x = [self getFrame].origin.x + [self getFrame].size.width / 2;
		
		[self drawText:line :position :[self getAlignment]];
		
		position.y = position.y + [self getTextSize:line].height + [[self getFont] getInterLineSpace];
	}
}

- (void) check
{
	if(_fontResize != [[self getFont] getResize])
	{
		_scroll = 0;
		_fontResize = [[self getFont] getResize];
		[self setText:[NSString stringWithString:[self getText]]];
	}
}

-(void) dealloc {
	
	[LINE_BREAK release];
	[WORD_SPACE release];
	
	[_text release];
	[_warpedText release];
	[_font release];
    
    [[LogUtility getInstance] printMessage:@"Text - dealloc"];
	
	[super dealloc];	
}


@end
