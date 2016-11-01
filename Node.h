//
//  NodeInfo.h
//
//  Created by Laurent on 04/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.

#import <Cocoa/Cocoa.h>

@interface Node : NSObject {

	@protected

		NSImage				*imageIcon;
	
		Node				*nodeParent; 
		NSMutableArray		*childNodes;
	    BOOL				isLeaf;
}

@property(nonatomic,readwrite)	BOOL isLeaf;

-(id)				initWithParent:(Node *)parent;
-(void)				removeChild;
-(NSMutableArray *) childNodes;

-(NSString *)	label;
-(NSImage *)	iconImage; 
-(NSImage *)	iconImageOfSize:(NSSize)size; 

@end
