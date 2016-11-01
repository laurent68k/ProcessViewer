//
//  MainWndController.m
//
//  Created by Laurent on 02/11/11.
//	Updated on: 05/12/2011
//
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.

#include <stdlib.h>

#import "BrowserCell.h"
#import "NodeRacine.h"
#import "NodeProcessus.h"
#import "NodeSystem.h"
#import "NodeMounted.h"
#import "NodeVolume.h"

#import "MainWndController.h"
#import	"Constants.h"

@implementation MainWndController

-(id) init {
	
	self = [super init];
		
	self->rootNode = nil;

	self->nodeSystem = nil;
	self->nodeMounted = nil;
	self->nodeProcessus = nil;
	self->nodeVolume = nil;

	self->processViewer = [[PSProcessViewer alloc] initWithDelegate:self];
	
	return self;
}
//---------------------------------------------------------------------------
-(void) dealloc {
		
	[self->nodeSystem release];
	[self->nodeMounted  release];
	[self->nodeProcessus release];
	[self->nodeVolume release];
	
	[self->processViewer release];
	
    [super dealloc];
}
//---------------------------------------------------------------------------
- (void)awakeFromNib
{
	[[self window] setTitle: APP_WINDOW__TITLE];
	
	[[NSWorkspace sharedWorkspace] hideOtherApplications];

	[self->tfName setStringValue:@""];
	
    [self->browser setCellClass: [BrowserCell class]];
    [self->browser setTarget:self];
    [self->browser setAction:@selector(browserSingleClick:)];
    [self->browser setDoubleAction:@selector(browserDoubleClick:)];
    
    // Configure the number of columns
    [self->browser setMaxVisibleColumns: 2];
    [self->browser setMinColumnWidth:NSWidth([self->browser bounds])/(CGFloat) 3];   
	
	[self->browser loadColumnZero];
}
//---------------------------------------------------------------------------
- (void)windowWillClose:(NSNotification *)note {
	
	[NSApp terminate: self ];
}
//---------------------------------------------------------------------------
-(void) addProcessus: (id)object {
	
	NSRunningApplication	*application = (NSRunningApplication *)object;
	
	Node	*node = [[NodeProcessus alloc] initWithParent:self->rootNode withApplication:application];
	node.isLeaf = true;
	
	[self->nodeProcessus.childNodes addObject: node];
}
//---------------------------------------------------------------------------
-(void) addMounted: (id)message {
	
	NSString	*text = (NSString *)message;
	
	Node	*node = [[NodeMounted alloc] initWithParent:self->rootNode withPath: text];
	node.isLeaf = true;
	
	[self->nodeMounted.childNodes addObject: node];
}
//---------------------------------------------------------------------------
-(void) addSystem: (id)message {
	
	NSString	*text = (NSString *)message;
	
	Node	*node = [[NodeSystem alloc] initWithParent:self->rootNode withDescription: text];
	node.isLeaf = true;
	
	[self->nodeSystem.childNodes addObject: node];
}
//---------------------------------------------------------------------------
-(void) addVolume: (id)message {
	
	NSString	*text = (NSString *)message;
	
	Node	*node = [[NodeVolume alloc] initWithParent:self->rootNode withPath: text];
	node.isLeaf = true;
	
	[self->nodeVolume.childNodes addObject: node];
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

-(void) loadTree {

	if( self->rootNode == nil ) {		
		self->rootNode = [[NodeRacine alloc] initWithParent:nil withLabel:@"root"];

		if( self->nodeSystem == nil ) {
			self->nodeSystem =  [[NodeRacine alloc] initWithParent:self->rootNode withLabel:@"System" withImage:[[NSWorkspace sharedWorkspace] iconForFileType:@"txt"] ];
		}
		
		if( self->nodeVolume == nil ) {
			self->nodeVolume = [[NodeRacine alloc] initWithParent:self->rootNode withLabel:@"Volumes" withImage:[[NSWorkspace sharedWorkspace] iconForFileType:@"dmg"] ];
		}

		if( self->nodeMounted == nil ) {
			self->nodeMounted = [[NodeRacine alloc] initWithParent:self->rootNode withLabel:@"Removables" withImage:[[NSWorkspace sharedWorkspace] iconForFileType:@"dmg"] ];
		}
		
		if( self->nodeProcessus == nil ) {
			self->nodeProcessus = [[NodeRacine alloc] initWithParent:self->rootNode withLabel:@"Applications" withImage:[[NSWorkspace sharedWorkspace] iconForFile:@"/System/Library/CoreServices/Finder.app"] ];
		}
		
		[self->rootNode.childNodes addObject: nodeSystem ];
		[self->rootNode.childNodes addObject: nodeVolume];
		[self->rootNode.childNodes addObject: nodeMounted ];
		[self->rootNode.childNodes addObject: nodeProcessus ];

		[self->processViewer displayMacSystem];
	
	}
	else {
		
		[self->nodeMounted removeChild];
		[self->nodeProcessus removeChild];	
		[self->nodeVolume removeChild];
	}
	[self->processViewer displayProcesses];
	[self->processViewer displayRemovableMedias];
	[self->processViewer displayVolumes];

}
//---------------------------------------------------------------------------
-(void) sendNotification:(Node *)node {

	//	Send to the Notification center the node selected
	NSDictionary	*userInfo = [NSDictionary dictionaryWithObject:node forKey: KEY_OBJECT_NOTIFICATION];
	NSNotification	*notification = [NSNotification notificationWithName:NOTIFICATION_ID object:self userInfo:userInfo];

	[[NSNotificationCenter defaultCenter] postNotification: notification];
}
//---------------------------------------------------------------------------
-(void) arrangeGUI:(Node *)node {

	if( [node isKindOfClass:[NodeRacine class]] ) {
		
		[self->tfName setStringValue: [NSString stringWithFormat:@"Folder: %@", [node label]]];
	}
	else if( [node isKindOfClass:[NodeProcessus class]] ) {
		
		[self->tfName setStringValue: [NSString stringWithFormat:@"Application: %@", [node label]]];
	} 
	else if( [node isKindOfClass:[NodeMounted class]] ) {
		
		[self->tfName setStringValue: [NSString stringWithFormat:@"Removable: %@", [node label]]];
	} 
	else if( [node isKindOfClass:[NodeVolume class]] ) {
		
		[self->tfName setStringValue: [NSString stringWithFormat:@"Volume: %@", [node label]]];
	} 
	else if( [node isKindOfClass:[NodeSystem class]] ) {
		
		[self->tfName setStringValue: [node label]];

	} 
	else {
	
		[self->tfName setStringValue:@""];
	}
	
	//	Send to the Notification center the node selected
	[self sendNotification:node];
	
	[self->imageIcon setImage:[node iconImageOfSize:NSMakeSize(128,128)]];
	
	if( [node isKindOfClass:[NodeProcessus class]] ) {
	
		[self->btTerminate setEnabled: true];
		[self->btForceTerminate	setEnabled: true];
		[self->btHide setEnabled: true];
		[self->btUnhide	setEnabled: true];	
		
		[self->btEject setEnabled: false];	
	}
	else if( [node isKindOfClass:[NodeMounted class]] ) {
	
		[self->btTerminate setEnabled: false];
		[self->btForceTerminate	setEnabled: false];
		[self->btHide setEnabled: false];
		[self->btUnhide	setEnabled: false];	
		
 		[self->btEject setEnabled: true];	
	}
	else /*if( [node isKindOf:[NodeSystem class]] )*/ {
	
		[self->btTerminate setEnabled: false];
		[self->btForceTerminate	setEnabled: false];
		[self->btHide setEnabled: false];
		[self->btUnhide	setEnabled: false];	
		
 		[self->btEject setEnabled: false];	
	}
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

- (Node *)parentNodeInfoForColumn:(NSInteger)column {

    Node	*result;
    if (column == 0) {
       
		[self loadTree];
        result = self->rootNode;
    } 
    else {
        // Find the selected item leading up to this column and grab its FSNodeInfo stored in that cell
        BrowserCell *selectedCell = [self->browser selectedCellInColumn:column-1];
        result = [selectedCell node];
    }
    return result;
}
//---------------------------------------------------------------------------
// Use lazy initialization, since we don't want to touch the file system too much.
- (NSInteger)browser:(NSBrowser *)sender numberOfRowsInColumn:(NSInteger)column {

	Node *parentNode = [self parentNodeInfoForColumn:column];
    
    return [[parentNode childNodes] count];
}
//---------------------------------------------------------------------------
- (void)browser:(NSBrowser *)sender willDisplayCell:(BrowserCell *)cell atRow:(NSInteger)row column:(NSInteger)column {

    Node *parentNode = [self parentNodeInfoForColumn:column];
    Node *currentNode = [[parentNode childNodes] objectAtIndex:row];
    
    [cell setNode:currentNode];
    [cell loadCellContents];
}
//---------------------------------------------------------------------------
- (void)updateCurrentPreviewImage:(id)sender {

    NSArray *selectedCells = [sender selectedCells];
    
    if ([selectedCells count] == 1) {

        BrowserCell *lastSelectedCell = [selectedCells objectAtIndex:[selectedCells count] - 1];
        
        Node *node = [lastSelectedCell node];
        
        [self arrangeGUI: node];
	} 
    else {
		//	Pas de multi-sélection
    }
}
//---------------------------------------------------------------------------
- (IBAction)browserSingleClick:(id)sender {

    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateCurrentPreviewImage:) object:sender];
    [self performSelector:@selector(updateCurrentPreviewImage:) withObject:sender afterDelay:0.3];    
}
//---------------------------------------------------------------------------
- (IBAction)browserDoubleClick:(id)sender {

    [self browserSingleClick: sender];
}
//---------------------------------------------------------------------------
-(void) reselectBest:(id)object {

 	NSInteger lastRow = [self->browser selectedRowInColumn: 0];
	
	[self->browser loadColumnZero];
	[self->browser selectRow:lastRow inColumn:0];

	[self->imageIcon setImage:nil];
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

-(void) willLaunchApplication:(id)object {

	NSRunningApplication	*application = (NSRunningApplication *)object;
	
	[self->tfInformation setStringValue:[NSString stringWithFormat:@"Finder is about to launch: %@...", application.localizedName]];
}
//---------------------------------------------------------------------------
-(void) didLaunchApplication:(id)object {

	NSRunningApplication	*application = (NSRunningApplication *)object;
	
	[self->tfInformation setStringValue:[NSString stringWithFormat:@"New application launched: %@", application.localizedName]];
	
	[self reselectBest:nil];
}
//---------------------------------------------------------------------------
-(void) didTerminateApplication:(id)object {

	NSRunningApplication	*application = (NSRunningApplication *)object;
	
	[self->tfInformation setStringValue:[NSString stringWithFormat:@"Application terminated: %@", application.localizedName]];

	[self reselectBest:nil];
}
//---------------------------------------------------------------------------
-(void) didHideApplicationNotification:(id)object {

	NSRunningApplication	*application = (NSRunningApplication *)object;
	
	[self->tfInformation setStringValue:[NSString stringWithFormat:@"Application hided: %@", application.localizedName]];
}
//---------------------------------------------------------------------------
-(void) didUnhideApplicationNotification:(id)object {

	NSRunningApplication	*application = (NSRunningApplication *)object;
	
	[self->tfInformation setStringValue:[NSString stringWithFormat:@"Application unhided: %@", application.localizedName]];
}
//---------------------------------------------------------------------------
-(void) didRenameVolumeNotification:(id)message {

	NSString	*text = (NSString *)message;
	[self->tfInformation setStringValue:[NSString stringWithFormat:@"Volume renamed: %@", text]];

	[self reselectBest:nil];
}
//---------------------------------------------------------------------------
-(void) didMountNotification:(id)message {

	NSString	*text = (NSString *)message;
	[self->tfInformation setStringValue:[NSString stringWithFormat:@"Volume mounted: %@", text]];

	[self reselectBest:nil];
}
//---------------------------------------------------------------------------
-(void) didUnmountNotification:(id)message {

	NSString	*text = (NSString *)message;
	[self->tfInformation setStringValue:[NSString stringWithFormat:@"Volume unmounted: %@", text]];

	[self reselectBest:nil];
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

- (IBAction) ejectButton:(id)sender {
	
	Node	*node;
	
	BrowserCell *selectedCell = [self->browser selectedCellInColumn: 1];
	node = [selectedCell node];
	
	if( [node isKindOfClass:[NodeMounted class]] ) {
		
		BOOL done = [(NodeMounted *)node eject];
		if( !  done ) {
			NSRunInformationalAlertPanel(APP_WINDOW__TITLE, [NSString stringWithFormat:@"Unable to unmount the device %@", node.label], @"OK", NULL, NULL);
		}
		else {
			[self reselectBest:nil];			
		}
	}
}
//---------------------------------------------------------------------------
- (IBAction) hideButton:(id)sender {
	
	Node	*node;
	
	BrowserCell *selectedCell = [self->browser selectedCellInColumn: 1];
	node = [selectedCell node];
	
	if( [node isKindOfClass:[NodeProcessus class]] ) {
		
		BOOL error = [(NodeProcessus *)node hide];
		if( error ) {
			NSRunInformationalAlertPanel(APP_WINDOW__TITLE, @"Failed to unhide this application", @"OK", NULL, NULL);
		}
	}
}
//---------------------------------------------------------------------------
- (IBAction) unhideButton:(id)sender {

	Node	*node;
	
	BrowserCell *selectedCell = [self->browser selectedCellInColumn: 1];
	node = [selectedCell node];
	
	if( [node isKindOfClass:[NodeProcessus class]] ) {
		
		BOOL error = [(NodeProcessus *)node unhide];
		if( error ) {
			NSRunInformationalAlertPanel(APP_WINDOW__TITLE, @"Failed to unhide this application", @"OK", NULL, NULL);
		}
	}
}
//---------------------------------------------------------------------------
- (IBAction) terminateButton:(id)sender {
	
	Node	*node;
	
	BrowserCell *selectedCell = [self->browser selectedCellInColumn: 1];
	node = [selectedCell node];
	
	if( [node isKindOfClass:[NodeProcessus class]] ) {
		
		BOOL done = [(NodeProcessus *)node terminate];
		if( ! done ) {
			NSRunInformationalAlertPanel(APP_WINDOW__TITLE, @"Failed to terminate this application", @"OK", NULL, NULL);
		}
		else {	
			[self performSelector:@selector(reselectBest:) withObject:nil afterDelay:0.5];    
			//[self reselectBest];			
		}
	}
}
//---------------------------------------------------------------------------
- (IBAction) foreTerminateButton:(id)sender {
	
	Node	*node;
	
	BrowserCell *selectedCell = [self->browser selectedCellInColumn: 1];
	node = [selectedCell node];
	
	if( [node isKindOfClass:[NodeProcessus class]] ) {
		
		BOOL done = [(NodeProcessus *)node forceTerminate];
		if( ! done ) {
			NSRunInformationalAlertPanel(APP_WINDOW__TITLE, @"Failed to force to terminate this application", @"OK", NULL, NULL);
		}
		else {
			[self reselectBest:nil];			
		}
	}	
}
//---------------------------------------------------------------------------

@end
