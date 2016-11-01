//
//  NodeInfo.m
//
//  Created by Laurent on 02/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.


#import "NodeProcessus.h"

@implementation NodeProcessus 

@synthesize	application;

//---------------------------------------------------------------------------
- (id)initWithParent:(Node *)parent withApplication:(NSRunningApplication *)app {  
  
    if (self = [super initWithParent: parent]) {
    
		switch (app.executableArchitecture) {
			case NSBundleExecutableArchitectureI386:
				self->architecture = [NSString stringWithFormat:@"i386 32 bits"];
				break;
			case NSBundleExecutableArchitecturePPC:
				self->architecture = [NSString stringWithFormat:@"PPC 32 bits"];
				break;
			case NSBundleExecutableArchitectureX86_64:
				self->architecture = [NSString stringWithFormat:@"x86 64bits"];
				break;
			case NSBundleExecutableArchitecturePPC64:
				self->architecture = [NSString stringWithFormat:@"PPC 64 bits"];
				break;
			default:
				self->architecture = [NSString stringWithFormat:@"Unknow"];
				break;
		}
		
		self->localizedName = app.localizedName, 
		self->processIdentifier = app.processIdentifier;
		self->imageIcon = app.icon;
		
		self->application = app;
		
		[self->localizedName retain];
		[self->imageIcon  retain];	
		[self->application retain];
	}       
    
    return self;
}
//---------------------------------------------------------------------------
- (void)dealloc {

    [self->localizedName release];
	[self->architecture release];
	[self->application release];
	[self->imageIcon release];
	
    [super dealloc];
}
//---------------------------------------------------------------------------
-(NSString *) label {

	return self->localizedName;
}

//---------------------------------------------------------------------------
- (NSImage *) iconImageOfSize:(NSSize)size {
	
    NSImage		*image = nil;
    
    if( self->imageIcon == nil ) {
        self->imageIcon = [[NSWorkspace sharedWorkspace] iconForFileType:@"app"];
    }
	
	image = [self->imageIcon copy];
	[image setSize: size];
	
    return image;
}
//---------------------------------------------------------------------------
-(BOOL) terminate {
	
	if( self->application != nil ) {
	
		return [self->application terminate];
	}
	return false;
}
//---------------------------------------------------------------------------
-(BOOL) forceTerminate {
	
	if( self->application != nil ) {
		
		return [self->application forceTerminate];
	}
	return false;
}
//---------------------------------------------------------------------------
-(BOOL) hide {
	
	if( self->application != nil ) {
		
		return [self->application hide];
	}
	return false;
}
//---------------------------------------------------------------------------
-(BOOL) unhide {
	
	if( self->application != nil ) {
		
		return [self->application unhide];
	}
	return false;
}

@end
