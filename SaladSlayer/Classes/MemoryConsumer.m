//
//  MemoryConsumer.m
//
//  Created by Robert Neagu on 2/4/11.
//  Copyright 2011 TotalSoft. All rights reserved.
//

#import "MemoryConsumer.h"
#import <mach/mach.h> 
#import <mach/mach_host.h>

@implementation MemoryConsumer

natural_t  freeMemoryGet(void) {
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
	
    host_page_size(host_port, &pagesize);
	
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics");
	
    natural_t   mem_free = vm_stat.free_count * pagesize;
	
    return mem_free;
}

-(id) init {
	if (self = [super init]) {
		//Initiate vars
		storage = [[NSMutableArray alloc] init];
		consuming = FALSE;
		identifier = 0;
		
		//Notification listener
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
		
		//Consume
		[self consume];
	}

	return self;
}

-(void) start {
	consuming = TRUE;
}

-(void) stop {
	consuming = FALSE;
}

-(void) consume {
	//Get free ram
	int freeMB = [self getFreeMB];
	
	//Debug
	NSLog(@"MemoryConsumer - Free Ram: %i MB", freeMB);
	
	if (consuming) {
		//Allocate memory
		MemoryItem *item = [[MemoryItem alloc] initWithIdentifier: identifier Megabytes: freeMB > 10 ? 20 : 2];
		[storage insertObject: item atIndex: [storage count]];
		[item release];
		
		//Increment identifier 
		identifier++;		
	}
	
	//Schedule
	[self performSelector: @selector(consume) withObject:nil afterDelay: 1.0];
}

-(void) free {
	//Remove all objects in storage
	[storage removeAllObjects];
	
	//Reset
	identifier = 0;
}

#pragma mark Utils

-(int) getFreeMB {
	int freeMB = freeMemoryGet();
	return freeMB / (1024 * 1024);
}

#pragma mark Memory management

-(void)didReceiveMemoryWarning {
	//Debug
	NSLog(@"MemoryConsumer - Memory warning received!");
		
	//Reset
	consuming = FALSE;
}

-(void) dealloc {
	//No more notifications
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	//Remove all objects in storage
	[storage removeAllObjects];
	[storage release];
	storage = nil;
	
	//Super
	[super dealloc];
}

@end
