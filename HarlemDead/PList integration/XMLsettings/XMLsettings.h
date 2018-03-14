//
//  XMLsettings.h
//  Jeff Sherk
//
//  Created by Jeff Sherk on 7/10/12.
//  Copyright (c) 2012 Jeff Sherk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Base64.h"

@interface XMLsettings : NSObject

+(NSString*)getstring:(NSString*)varName;
+(NSInteger)getinteger:(NSString*)varName;
+(BOOL)getbool:(NSString*)varName;
+(float)getfloat:(NSString*)varName;

+(void)setstring:(NSString*)varName:(NSString*)varSet;
+(void)setinteger:(NSString*)varName:(NSInteger)varSet;
+(void)setbool:(NSString*)varName:(BOOL)varSet;
+(void)setfloat:(NSString*)varName:(float)varSet;

+(void)retrieveLocalXML;
+(void)retrieveRemoteXML;
+(void)preventConnectionTimerAction;
+(void)connection:(NSURLConnection *)connection  didFailWithError:(NSError *)error;
+(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data;
+(void)connectionDidFinishLoading:(NSURLConnection *)connection;
+(void)xmlToDict:(NSData*)retrievedData:(BOOL)base64encoded;

@end
