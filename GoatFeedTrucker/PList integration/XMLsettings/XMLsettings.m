//
//  XMLsettings.m
//  Jeff Sherk
//
//  Created by Jeff Sherk on 7/10/12.
//  Copyright (c) 2012 Jeff Sherk. All rights reserved.
//

#import "XMLsettings.h"

NSString* remoteServer = @"http://content.iwebss.com/test/XMLsettings_1.0.0.xml";

BOOL preventConnection = NO;
NSTimer* preventConnectionTimer;
NSData* dataRetrievedLocal = nil;
NSMutableData* dataRetrievedRemote = nil;
NSMutableData* dataCopy = nil;

@implementation XMLsettings

////////////////////////////////////////////////////////////////////////////
/*
Add the following files to Xcode project:
 XMLsettings_default.xml
 XMLsettings.h
 XMLsettings.m
 NSData+Base64.h (optional: only needed if XML file is base64 encoded)
 NSData+Base64.m (optional: only needed if XML file is base64 encoded)

Modify XMLsettings_default.xml with your own default/startup settings. These
 settings will be used until the first time a remote file is download.

Modify remoteServer string to point to your server with your XML/PLIST file. 
 
Add #import "XMLsettings.h" to AppDelegate.h file

Add [XMLsettings retrieveLocalXML]; as the first line
 of didFinishLaunchingWithOptions in AppDelegate.m

Add [XMLsettings retrieveRemoteXML]; anywhere
 in applicationDidBecomeActive in AppDelegate.m

To retrieve a setting, use:
 myBool = [XMLsettings getbool:@"my_var_name"];
 myInt = [XMLsettings getinteger:@"my_var_name"];
 myFloat = [XMLsettings getfloat:@"my_var_name"];
 myString = [XMLsettings getstring:@"my_var_name"];
 
To manually overide a setting (until next remote file retrieval), use:
 [XMLsettings setbool:@"my_var_name":YES];
 [XMLsettings setinteger:@"my_var_name":2];
 [XMLsettings setfloat:@"my_var_name":3.3];
 [XMLsettings setstring:@"my_var_name":@"hello world"];
 
NOTES:
- XML files are parsed and then values are stored in NSUserDefaults, so you 
  can GET and SET values directly using that method instead. The GET and SET
  methods are just helpers to make it easier for lazy programmers like me.
 
- If you try to GET a var_name that has not been set yet, you will only get a
  WARNING in the log window (no error will be thrown), and each data type will
  still return a value as follows:
   BOOL = NO
   Integer = 0
   Float = 0.0
   String = nil

- If you try to GET an NSNumber var_name that was stored as an NSString, you
  will only get a WARNING in the log window (no error will be thrown), and
  the NSString will just be converted to an NSNumber. Same applies if you
  try to GET an NSString var_name that was stored as an NSNumber.
 
SAMPLE CODE: 
 Here is some sample code you can try... notice the warnings that are
 generated the first time you call the GET methods. And notice there are
 no warnings the second time you run the code because the var_names have
 now been set.
 
 //sample code
 [XMLsettings retrieveLocalXML];
 
 [XMLsettings retrieveRemoteXML];
 
 NSInteger test1 = [XMLsettings getinteger:@"new1"];
 NSLog(@"integer: %i", test1);
 [XMLsettings setinteger:@"new1" :22];
 test1 = [XMLsettings getinteger:@"new1"];
 NSLog(@"integer: %i", test1);
 
 float test2 = [XMLsettings getfloat:@"new2"];
 NSLog(@"float: %f", test2);
 [XMLsettings setfloat:@"new2" :3.3];
 test2 = [XMLsettings getfloat:@"new2"];
 NSLog(@"float: %f", test2);
 
 BOOL test3 = [XMLsettings getbool:@"new3"];
 NSLog(@"boolean: %i", test3);
 [XMLsettings setbool:@"new3" :YES];
 test3 = [XMLsettings getbool:@"new3"];
 NSLog(@"boolean: %i", test3);
 [XMLsettings setbool:@"new3" :YES];
 
 NSString* test4 = [XMLsettings getstring:@"new4"];
 NSLog(@"string: %@", test4);
 [XMLsettings setstring:@"new4" :@"hi"];
 test4 = [XMLsettings getstring:@"new4"];
 NSLog(@"string: %@", test4);
 
*/
////////////////////////////////////////////////////////////////////////////

////TO DO: How to call init automatically on boot up and then callretrieveLocalXML automatically
+(id)init {
    NSLog(@"[XMLsettings] INIT");
    
    self = [super init];
    if (self) {

    }
    return self;
}

+(void)retrieveLocalXML{
    NSLog(@"[XMLsettings] retrieveLocalXML");
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"retrieveLocalXMLfinished"] boolValue] == TRUE) {
        NSLog(@"[XMLsettings] retrieveLocalXML already finished... skipping");
        
    } else {
        NSURL* localPathToXMLsettings = [[NSBundle mainBundle] URLForResource:@"XMLsettings_defaults" withExtension:@"xml"];
        if (localPathToXMLsettings != NULL) {
            NSError* error = nil;
            NSURLResponse* response = nil;
            dataRetrievedLocal = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:localPathToXMLsettings cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0] returningResponse:&response error:&error];
            if (dataRetrievedLocal == nil) {
                if (error) {
                    NSLog(@"[XMLsettings] retrieveLocalXML dataRetrieved is NIL with ERROR: %@", error);
                } else {
                    NSLog(@"[XMLsettings] retrieveLocalXML dataRetrieved is NIL");
                }
            } else {
                //NSLog(@"[XMLsettings] dataRetrievedLocal: %@", dataRetrievedLocal);
                [self xmlToDict:dataRetrievedLocal:NO]; //Retrieve XML data and put in NSDictionary
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:1] forKey:@"retrieveLocalXMLfinished"];
                
            }
            NSLog(@"[XMLsettings] retrieveLocalXML finished");
            
        } else {
            NSLog(@"[XMLsettings] retrieveLocalXML WARNING: XMLsettings_defaults.xml file is missing");
            
        }
    }
}

+(void)retrieveRemoteXML{
    NSLog(@"[XMLsettings] retrieveRemoteXML");
    
    //Retrieve file from server
    if (preventConnection == YES) {
        NSLog(@"[XMLsettings] retrieveRemoteXML preventConnection enabled");
    } else {
        NSLog(@"[XMLsettings] retrieveRemoteXML connectionWithRequest");
        
        [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:remoteServer] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0] delegate:self]; //Remote server
        
        preventConnection = YES; //Prevent server connection until timer runs out
        preventConnectionTimer = [[NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(preventConnectionTimerAction) userInfo:nil repeats:NO] retain]; //This prevents back to back attempts to connect to server
    }
    
    dataRetrievedRemote = [[NSMutableData alloc] init];
}

+(void)preventConnectionTimerAction{
    NSLog(@"[XMLsettings] retrieveRemoteXML preventConnection released");
    preventConnection = NO; //Allow remote server connection again
    [preventConnectionTimer invalidate];
    preventConnectionTimer = nil;
}

+(void)connection:(NSURLConnection *)connection  didFailWithError:(NSError *)error {
    NSLog(@"[XMLsettings] retrieveRemoteXML connectionError: %@", error);
}

+(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data{
    NSLog(@"[XMLsettings] retrieveRemoteXML connectionDidReceiveData: %i", [_data length]);
    [dataRetrievedRemote appendData:_data];
}

+(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if ([dataRetrievedRemote length] == 0) {
        NSLog(@"[XMLsettings] retrieveRemoteXML WARNING: NO DATA: connectionDidFinishLoading: 0 bytes of data received");    
    } else {
        NSLog(@"[XMLsettings] retrieveRemoteXML connectionDidFinishLoading: %i bytes of data received", [dataRetrievedRemote length]);
        [self xmlToDict:dataRetrievedRemote:NO];
    }
}

+(void)xmlToDict:(NSData*)retrievedData:(BOOL)base64encoded{
    NSLog(@"[XMLsettings] retrieveXML xmlToDict");
    
    dataCopy = [retrievedData mutableCopy];
    
    //Decode from base64 (optional)
    if (base64encoded == YES) {
        dataCopy = [[NSData dataFromBase64String:[[NSString alloc] initWithData:retrievedData encoding:NSUTF8StringEncoding]] mutableCopy];
        if ([dataCopy length] == 0) {
            NSLog(@"[XMLsettings] retrieveXML WARNING: data not base64 encoded");
            return;
        }
    } 
    
    NSDictionary *dictServer = nil;
    CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)dataCopy, kCFPropertyListImmutable, NULL);
    
    if ([(id)plist isKindOfClass:[NSDictionary class]]) {
		dictServer = [(NSDictionary *)plist autorelease];
        //NSLog(@"[XMLsettings] retrieveXML DICTIONARY: %@", [dictServer description]);
        
	} else {
        if (plist) {
            CFRelease(plist);
        }
		dictServer = nil;
        NSLog(@"[XMLsettings] retrieveXML WARNING: data error (bad file or server error)");
	}
    
    if (dictServer) {
        NSLog(@"[XMLsettings] retrieveXML saving to defaults");

        //Loop thru dict and save in nsuserdefaults so can retrieve at next startup.
        for(id key in dictServer) {
            [[NSUserDefaults standardUserDefaults] setObject:[dictServer objectForKey:key] forKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize]; //This will force save the values to NSUserDefaults immediately
        
        //NSLog(@"[XMLsettings] retrieveXML NSUserDefaults %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    }
}

//////// GET ////////

+(NSString*)getstring:(NSString*)varName{
    //NSLog(@"[XMLsettings] get string");
    
    NSString* retVal = nil;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:varName] == nil) {
        NSLog(@"[XMLsettings] getstring WARNING: returning nil because no key named: %@", varName);
    
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:varName] isKindOfClass:[NSNumber class]]) {
        NSLog(@"[XMLsettings] getstring WARNING: returning NSString from NSNumber for key named: %@", varName);
        retVal = [[NSUserDefaults standardUserDefaults] objectForKey:varName];
    
    } else {
        retVal = [[NSUserDefaults standardUserDefaults] objectForKey:varName];   
    
    }
    
    return retVal;
}

+(NSInteger)getinteger:(NSString*)varName{
    //NSLog(@"[XMLsettings] get integer: %@", varName);
    
    NSInteger retVal = 0;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:varName] == nil) {
        NSLog(@"[XMLsettings] getinterger WARNING: returning 0 because no key named: %@", varName);
    
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:varName] isKindOfClass:[NSString class]]) {
        NSLog(@"[XMLsettings] getinteger WARNING: returning NSInteger from NSString for key named: %@", varName);
        retVal = [[[NSUserDefaults standardUserDefaults] objectForKey:varName] intValue];
    
    } else {
        retVal = [[[NSUserDefaults standardUserDefaults] objectForKey:varName] intValue];
    
    }

    return retVal;
}

+(BOOL)getbool:(NSString*)varName{
    //NSLog(@"[XMLsettings] get bool: %@", varName);

    BOOL retVal = NO;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:varName] == nil) {
        NSLog(@"[XMLsettings] getbool WARNING: returning NO because no key named: %@", varName);
    
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:varName] isKindOfClass:[NSString class]]) {
        NSLog(@"[XMLsettings] getbool WARNING: returning BOOL from NSString for key named: %@", varName);
        retVal = [[[NSUserDefaults standardUserDefaults] objectForKey:varName] boolValue];
    
    } else {
        retVal = [[[NSUserDefaults standardUserDefaults] objectForKey:varName] boolValue];
    
    }
    
    return retVal;
}

+(float)getfloat:(NSString*)varName{
    //NSLog(@"[XMLsettings] get float: %@", varName);

    float retVal = 0.0;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:varName] == nil) {
        NSLog(@"[XMLsettings] getfloat WARNING: returning 0.0 because no key named: %@", varName);
    
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:varName] isKindOfClass:[NSString class]]) {
        NSLog(@"[XMLsettings] getfloat WARNING: returning FLOAT from NSString for key named: %@", varName);
        retVal = [[[NSUserDefaults standardUserDefaults] objectForKey:varName] floatValue];
    
    } else {
        retVal = [[[NSUserDefaults standardUserDefaults] objectForKey:varName] floatValue];
    
    }
    
    return retVal;
}


//////// SET ////////

+(void)setstring:(NSString*)varName:(NSString*)varSet{
    //NSLog(@"[XMLsettings] set string");
    [[NSUserDefaults standardUserDefaults] setObject:varSet forKey:varName];
    [[NSUserDefaults standardUserDefaults] synchronize]; //This will force save the values to NSUserDefaults immediately
}

+(void)setinteger:(NSString*)varName:(NSInteger)varSet{
    //NSLog(@"[XMLsettings] set integer");
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:varSet] forKey:varName];
    [[NSUserDefaults standardUserDefaults] synchronize]; //This will force save the values to NSUserDefaults immediately
}

+(void)setbool:(NSString*)varName:(BOOL)varSet{
    //NSLog(@"[XMLsettings] set bool");
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:varSet] forKey:varName];
    [[NSUserDefaults standardUserDefaults] synchronize]; //This will force save the values to NSUserDefaults immediately
}

+(void)setfloat:(NSString*)varName:(float)varSet{
    //NSLog(@"[XMLsettings] set float");
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:varSet] forKey:varName];
    [[NSUserDefaults standardUserDefaults] synchronize]; //This will force save the values to NSUserDefaults immediately
}

@end
