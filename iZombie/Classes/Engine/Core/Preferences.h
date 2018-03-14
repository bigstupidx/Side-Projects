//
//  Preferences.h
//
//  Created by Safiul Azam on 8/26/09.
//  Copyright 2009 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Preferences;

@interface Preferences : NSObject 
{
}

+ (Preferences *) getInstance;

- (id) getValue:(NSString *) key;
- (void) setValue:(id) value :(NSString *) key;
- (void) removeValue:(NSString *) key;

@end
