//
//  NodeInfo.m
//
//  Created by Laurent on 02/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.


#import "NodeRacine.h"

@implementation NodeRacine

//---------------------------------------------------------------------------
- (id)initWithParent:(Node *)parent withLabel:(NSString *)theLabel {  
	
    if (self = [super initWithParent: parent]) {
		
		self->imageIcon = nil;
		self->name = theLabel; 
		
		[self->name retain];
	}       
    
    return self;
}
//---------------------------------------------------------------------------
- (id)initWithParent:(Node *)parent withLabel:(NSString *)theLabel withImage:(NSImage *)theImage {  
  
    if (self = [super initWithParent: parent]) {
    
		self->imageIcon = theImage;
		self->name = theLabel; 
		
		[self->imageIcon retain];
		[self->name retain];
	}       
    
    return self;
}
//---------------------------------------------------------------------------
- (void)dealloc {

    [self->name release];
	if( self->imageIcon != nil ) {
		[self->imageIcon release];
	}
	[self->imageIcon release];

    [super dealloc];
}
//---------------------------------------------------------------------------
-(NSString *) label {

	return self->name;
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
