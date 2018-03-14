//
//  Font.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Font.h"

@implementation Font

- (id) initWithFilename:(NSString *) filename
{
	[super init];
	
	_filename = filename;	
    [_filename retain];
	_characters = [[NSMutableArray alloc]init];
	_maximumCharacterSize = CGSizeMake(0, 0);
	_resize = 0.0;
    
    _contents = [[FileUtility getInstance] getFileAsText:filename];
    [_contents retain];
    
    [[LogUtility getInstance] print:_contents];
		
	if(_xmlParser != nil)
        [_xmlParser release];
    
    _xmlParser = [[NSXMLParser alloc] initWithData:[_contents dataUsingEncoding:NSUTF8StringEncoding]];
    [_xmlParser setDelegate:self];
    [_xmlParser parse];
	
	return self;
}

- (NSString *) getName
{
	return _name;
}

- (CGFloat) getSize
{
	return _size;
}

- (Texture *) getTexture
{
	return [[TextureManager getInstance] getTexture:_imageFilename];
}

- (CGFloat) getInterCharacterSpace
{
	return _interCharacterSpace;
}

- (CGFloat) getInterWordSpace
{
	return _interWordSpace;
}

- (CGFloat) getInterLineSpace
{
	return _interLineSpace;
}

- (NSArray *) getCharacters
{
	return (NSArray *) _characters;
}

- (CGFloat) getResize
{
	return _resize;
}

- (void) setResize:(CGFloat) resize
{
	_resize = resize < 0 ? 0 : resize;
	
	_maximumCharacterSize.width = 0;
	_maximumCharacterSize.height = 0;
	
	for(NSInteger i = 0; i < [_characters count]; i++)
	{
		Character *character = [_characters objectAtIndex:i];
				
		if([character getFrame].size.width > _maximumCharacterSize.width)
			_maximumCharacterSize.width = [character getFrame].size.width;
		
		if([character getFrame].size.height > _maximumCharacterSize.height)
			_maximumCharacterSize.height = [character getFrame].size.height;
	}
}

- (CGSize) getMaximumCharacterSize
{
	return _maximumCharacterSize;
}

- (CGSize) getCharacterSize:(NSString *) character
{
	for(NSInteger i = 0; i < [_characters count]; i++)
	{
		Character *characterObject = [_characters objectAtIndex:i];
		
		if([character isEqualToString:[characterObject getCharacter]])
			return [characterObject getFrame].size;
	}
	
	return CGSizeMake(NSNotFound, NSNotFound);
}

- (void) drawCharacter:(NSString *) character :(CGPoint) position
{
	CGFloat xScale = [[self getTexture] getScale].x;
	CGFloat yScale = [[self getTexture] getScale].y;
	
	CGFloat scale = [self getResize] / [self getSize];
	[[self getTexture] setScale:CGPointMake(scale, scale)];
	
	CGFloat rotate = [[self getTexture] getRotate];
	[[self getTexture] setRotate:0];
	
	//CGFloat alpha = [[self getTexture] getAlpha];
	//[[self getTexture] setAlpha:1];
	
	for(NSInteger i = 0; i < [_characters count]; i++)
	{
		Character *characterObject = [_characters objectAtIndex:i];
		
		if([character isEqualToString:[characterObject getCharacter]])
		{
			[[self getTexture] draw:position :[characterObject getFrame]];
			break;
		}
	}	
	
	[[self getTexture] setScale:CGPointMake(xScale, yScale)];
	[[self getTexture] setRotate:rotate];
	//[[self getTexture] setAlpha:alpha];
}

- (void) parserDidStartDocument:(NSXMLParser *) parser 
{
    [[LogUtility getInstance] printMessage:@"parserDidStartDocument"];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [[LogUtility getInstance] printMessage:@"didStartElement"];
    
    if([elementName isEqualToString:@"font"])
    {
        _name = [attributeDict objectForKey:@"name"];
        [_name retain];
        [[LogUtility getInstance] printMessage:_name];
        
        _imageFilename = [attributeDict objectForKey:@"image"];
        [_imageFilename retain];
        [[LogUtility getInstance] printMessage:_imageFilename];
        
        _size = [[attributeDict objectForKey:@"size"] floatValue];
        [[LogUtility getInstance] printMessage:[[NSNumber numberWithFloat:_size] stringValue]];
        
        _interCharacterSpace = [[attributeDict objectForKey:@"intercharacterspace"] floatValue];
        [[LogUtility getInstance] printMessage:[[NSNumber numberWithFloat:_interCharacterSpace] stringValue]];
        
        _interWordSpace = [[attributeDict objectForKey:@"interwordspace"] floatValue];
        [[LogUtility getInstance] printMessage:[[NSNumber numberWithFloat:_interWordSpace] stringValue]];
        
        _interLineSpace = [[attributeDict objectForKey:@"interlinespace"] floatValue];
        [[LogUtility getInstance] printMessage:[[NSNumber numberWithFloat:_interLineSpace] stringValue]];
    }
    else if([elementName isEqualToString:@"char"])
    {
        // Character.
		NSString *character = [attributeDict objectForKey:@"character"];
		[[LogUtility getInstance] printMessage:character];
		
		// X.
		CGFloat x = [[attributeDict objectForKey:@"x"] integerValue];
		[[LogUtility getInstance] printMessage:[[NSNumber numberWithInteger:x] stringValue]];
		
		// Y.
		CGFloat y = [[attributeDict objectForKey:@"y"] integerValue];
		[[LogUtility getInstance] printMessage:[[NSNumber numberWithInteger:x] stringValue]];
		
		// Width.
		CGFloat width = [[attributeDict objectForKey:@"width"] floatValue];
		[[LogUtility getInstance] printMessage:[[NSNumber numberWithInteger:width] stringValue]];
		
		// Height.
		CGFloat height = [[attributeDict objectForKey:@"height"] floatValue];
		[[LogUtility getInstance] printMessage:[[NSNumber numberWithInteger:height] stringValue]];
		
		Character *characterObject = [[Character alloc] initWithFont:self :character :CGRectMake(x, y, width, height)];
		[_characters addObject:characterObject];
		
		[self setResize:[self getSize]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
}


- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [[LogUtility getInstance] printMessage:@"didEndElement"];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [[LogUtility getInstance] printMessage:@"parserDidStartDocument"];
}

-(void) dealloc {
	
	[_name release];
    [_contents release];
	[_imageFilename release];
    
    [_characters removeAllObjects];
    [_characters release];
	
    [_xmlParser release];
    
    [[LogUtility getInstance] printMessage:@"Font - dealloc"];
    
	[super dealloc];	
}

@end
