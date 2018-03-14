//
//  Element.h
//  iEngine
//
//  Created by Safiul Azam on 7/14/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Element : NSObject {

	@private
	NSString *_name;
	NSMutableDictionary *_properties;
}

-(NSString *) getName;
-(void) setName:(NSString *) name;

-(NSMutableDictionary *) getProperties;
-(void) addProperty:(NSString *) name value:(NSString *) value;
-(void) replaceProperty:(NSString *) name value:(NSString *) value;
-(void) removeProperty:(NSString *) name;
-(void) removeAllProperties;
-(NSString *) getPropertyValue:(NSString *) name;

@end
