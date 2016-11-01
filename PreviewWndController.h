//
//  PreviewWndController.h
//
//  Created by Laurent on 02/12/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.

#import <Cocoa/Cocoa.h>

@interface PreviewWndController : NSWindowController {

	@protected

	//	GUI buttons and others
    IBOutlet NSImageView			*imageIcon; 
	IBOutlet NSTextField			*tfName;
	IBOutlet NSTextField			*tfInfo1;
	IBOutlet NSTextField			*tfInfo2;
	IBOutlet NSTextField			*tfInfo3;
}

-(void) notificationItemChange:(NSNotification*)notification;

@end
