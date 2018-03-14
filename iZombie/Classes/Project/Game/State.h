//
//  State.h
//  Goftware
//
//  Created by Muhammed Safiul Azam on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	StateNone,
	StateIdle,
	StateWalk,
	StateFire,
    StateWalkFire,
    StateHit,
    StateDoorEnter,
    StateDoorWait,
    StateDoorPreExit,
    StateDoorExit
} State;