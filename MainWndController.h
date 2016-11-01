//
//  MainWndController.h
//
//  Created by Laurent on 02/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.

#import <Cocoa/Cocoa.h>
#import "Node.h"
#import "PSProcessViewer.h"

@interface MainWndController : NSWindowController {

	@protected

	//	GUI buttons and others
    IBOutlet NSBrowser				*browser;
    IBOutlet NSImageView			*imageIcon; 
	IBOutlet NSTextField			*tfName;
	IBOutlet NSTextField			*tfInformation;
	
	IBOutlet NSButton				*btTerminate;
	IBOutlet NSButton				*btForceTerminate;
	IBOutlet NSButton				*btHide;
	IBOutlet NSButton				*btUnhide;

	IBOutlet NSButton				*btEject;

	Node							*rootNode;
	Node							*nodeSystem;
	Node							*nodeMounted;
	Node							*nodeProcessus;	
	Node							*nodeVolume;
	
	PSProcessViewer					*processViewer;
}

//	Methods GUI binded to IB
-(IBAction) ejectButton:(id)sender;
-(IBAction) hideButton:(id)sender;
-(IBAction) unhideButton:(id)sender;
-(IBAction) terminateButton:(id)sender;
-(IBAction) foreTerminateButton:(id)sender;

@end
