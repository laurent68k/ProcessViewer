//
//  NodeInfo.m
//
//  Created by Laurent on 02/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.


#import "NodeSystem.h"

@implementation NodeSystem

//---------------------------------------------------------------------------
- (id)initWithParent:(Node *)parent withDescription:(NSString *)theDescription{  
  
    if (self = [super initWithParent: parent]) {
    
		self->imageIcon = [[NSWorkspace sharedWorkspace] iconForFileType:@"txt"];
		self->description = theDescription; 
		
		[self->imageIcon retain];
		[self->description retain];
	}       
    
    return self;
}
//---------------------------------------------------------------------------
- (void)dealloc {

    [self->description release];
	[self->imageIcon release];

    [super dealloc];
}
//---------------------------------------------------------------------------
-(NSString *) label {

	return self->description;
}
//---------------------------------------------------------------------------
- (NSImage *) iconImageOfSize:(NSSize)size {
	
    NSImage		*image = nil;
    
	image = [self->imageIcon copy];
	[image setSize: size];
	
    return image;
}
//---------------------------------------------------------------------------

@end
