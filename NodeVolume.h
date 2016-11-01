//
//  NodeInfo.h
//
//  Created by Laurent on 02/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.

#import <Cocoa/Cocoa.h>
#import "Node.h"

@interface NodeVolume : Node {

	@private

		NSString			*path;
}

-(id)			initWithParent:(Node *)parent withPath:(NSString *)thePath;
-(NSString *)	label;

@end
