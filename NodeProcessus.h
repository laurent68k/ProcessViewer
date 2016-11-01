//
//  NodeInfo.h
//
//  Created by Laurent on 02/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.

#import <Cocoa/Cocoa.h>
#import "Node.h"

@interface NodeProcessus : Node {

	@private

		NSString				*localizedName;
		NSString				*architecture;
		pid_t					processIdentifier;
	
		NSRunningApplication	*application;
}

@property(readonly)	NSRunningApplication	*application;

-(id)						initWithParent:(Node *)parent withApplication:(NSRunningApplication *)application;
-(NSString *)				label;

-(BOOL)						terminate;
-(BOOL)						forceTerminate;
-(BOOL)						hide;
-(BOOL)						unhide;

@end
