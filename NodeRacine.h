//
//  NodeInfo.h
//
//  Created by Laurent on 02/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.

#import <Cocoa/Cocoa.h>
#import "Node.h"

@interface NodeRacine : Node {

	@private

		NSString			*name;
}

-(id)			initWithParent:(Node *)parent withLabel:(NSString *)theLabel;
-(id)			initWithParent:(Node *)parent withLabel:(NSString *)theLabel withImage:(NSImage *)theImage;

-(NSString *)	label;

@end
