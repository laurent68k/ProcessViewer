//
//  NodeInfo.m
//
//  Created by Laurent on 02/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.


#import "NodeMounted.h"

@implementation NodeMounted

//---------------------------------------------------------------------------
- (id)initWithParent:(Node *)parent withPath:(NSString *)thePath {  
  
    if (self = [super initWithParent: parent]) {
    		
		self->imageIcon = [[NSWorkspace sharedWorkspace] iconForFile:thePath];
		self->path = thePath; 
		
		[self->path retain];
		[self->imageIcon  retain];		
	}       
    
    return self;
}
//---------------------------------------------------------------------------
- (void)dealloc {

    [self->path release];
	[self->imageIcon release];
	
    [super dealloc];
}
//---------------------------------------------------------------------------
-(NSString *) label {

	return self->path;
}
//---------------------------------------------------------------------------
- (NSImage *) iconImageOfSize:(NSSize)size {
	
    NSImage		*image = nil;
    
    if( self->imageIcon == nil ) {
        self->imageIcon = [[NSWorkspace sharedWorkspace] iconForFileType:@"txt"];
    }
	
	image = [self->imageIcon copy];
	[image setSize: size];
	
    return image;
}
//---------------------------------------------------------------------------
-(BOOL)	eject {
	
	return [[NSWorkspace sharedWorkspace] unmountAndEjectDeviceAtPath: self->path];
}

@end
