//
//  NodeInfo.m
//
//  Created by Laurent on 04/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.


#import "Node.h"

@implementation Node

@synthesize isLeaf;

//---------------------------------------------------------------------------
- (id)initWithParent:(Node *)parent {  
  
    if (self = [super init]) {
    
        self->nodeParent = parent;	
        self->childNodes = [[NSMutableArray alloc] init];
	}           
    return self;
}
//---------------------------------------------------------------------------
- (void)dealloc {

	[self->childNodes release];  
    [super dealloc];
}

//---------------------------------------------------------------------------
- (void)removeChild {

    [self->childNodes removeAllObjects];
}
//---------------------------------------------------------------------------
-(NSMutableArray *) childNodes {

	return self->childNodes;
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

-(NSString *) label {
	
	return @"noname";
}
//---------------------------------------------------------------------------
-(NSImage *) iconImage {
	
	return self->imageIcon;
}
//---------------------------------------------------------------------------
- (NSImage *) iconImageOfSize:(NSSize)size {
            
    return nil;
}
//---------------------------------------------------------------------------

@end
