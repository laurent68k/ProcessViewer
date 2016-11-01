//
//  PSProcessViewer.m
//
//  Created by Laurent Favard on 02/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.

//#include <stdlib.h>
#import "PSProcessViewer.h"

@implementation PSProcessViewer

//---------------------------------------------------------------------------
//	Méthode surchargée init
-(id) init {
	
	self = [super init];
	
	self->workspace = [NSWorkspace sharedWorkspace];

	self->soundAdded = [NSSound soundNamed:@"Glass.aiff"];
	self->soundRemoved = [NSSound soundNamed:@"Basso.aiff"];

	[self->soundAdded retain];
	[self->soundRemoved retain];

	return self;
}
//---------------------------------------------------------------------------
//	Méthode surchargée init
-(id) initWithDelegate:(id)theDelegate {
	
	self = [super init];
	
	self->delegate = theDelegate;
	
	self->workspace = [NSWorkspace sharedWorkspace];
	self->processInfo = [NSProcessInfo processInfo];
	self->host = [NSHost currentHost];
	
	NSNotificationCenter *  center;
	center = [self->workspace notificationCenter];
	
	[center addObserver:self selector:@selector(willLaunchApplication:) name:NSWorkspaceWillLaunchApplicationNotification object:nil ];
	
	[center addObserver:self selector:@selector(didLaunchApplication:) name:NSWorkspaceDidLaunchApplicationNotification object:nil ];
	[center addObserver:self selector:@selector(didTerminateApplication:) name:NSWorkspaceDidTerminateApplicationNotification object:nil ];
	[center addObserver:self selector:@selector(didHideApplicationNotification:) name:NSWorkspaceDidHideApplicationNotification object:nil ];
	[center addObserver:self selector:@selector(didUnhideApplicationNotification:) name:NSWorkspaceDidUnhideApplicationNotification object:nil ];
	
	[center addObserver:self selector:@selector(didRenameVolumeNotification:) name:NSWorkspaceDidRenameVolumeNotification object:nil ];
	[center addObserver:self selector:@selector(didMountNotification:) name:NSWorkspaceDidMountNotification object:nil ];
	[center addObserver:self selector:@selector(didUnmountNotification:) name:NSWorkspaceDidUnmountNotification object:nil ];
	
	self->soundAdded = [NSSound soundNamed:@"toto"];
	self->soundRemoved = [NSSound soundNamed:@"toto"];

	[self->soundAdded retain];
	[self->soundRemoved retain];

	return self;
}
//---------------------------------------------------------------------------
-(void) dealloc {
	
	[self->soundAdded release];
	[self->soundRemoved release];

	[super dealloc];
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

-(void)	displayProcesses {
		
	NSArray			*appsList = [self->workspace runningApplications];
	for(int index = 0; index < appsList.count; index++ ) {
		
		NSRunningApplication	*runningApp = (NSRunningApplication *)[appsList objectAtIndex: index ];
			
		if( [self->delegate respondsToSelector:@selector(addProcessus:)] ) {
			
			[self->delegate performSelector:@selector(addProcessus:) withObject:runningApp];
		}
	}
}
//---------------------------------------------------------------------------
-(void) displayVolumes {

	NSArray			*volumeList = [self->workspace mountedLocalVolumePaths];
	for(int index = 0; index < volumeList.count; index++ ) {
		
		if( [self->delegate respondsToSelector:@selector(addVolume:)] ) {
			
			[self->delegate performSelector:@selector(addVolume:) withObject: [volumeList objectAtIndex: index ] ];
		}
	}
}
//---------------------------------------------------------------------------
-(void) displayRemovableMedias {

	NSArray			*mediasList = [self->workspace mountedRemovableMedia];
	for(int index = 0; index < mediasList.count; index++ ) {
		
		if( [self->delegate respondsToSelector:@selector(addMounted:)] ) {
			
			[self->delegate performSelector:@selector(addMounted:) withObject: [mediasList objectAtIndex: index ] ];
		}
	}
}
//---------------------------------------------------------------------------
-(void) displayMacSystem {
		
	NSString	*osName = [NSString stringWithFormat:@"Operating System: %@", self->processInfo.operatingSystemName];
	NSString	*osVersion = [NSString stringWithFormat:@"OS Version: %@ (Code:%d)", self->processInfo.operatingSystemVersionString, self->processInfo.operatingSystem ];
	NSString	*hostname = [NSString stringWithFormat:@"Host Name: %@", self->processInfo.hostName ];
	NSString	*coreText = [NSString stringWithFormat:@"Core Processor Count: %d", self->processInfo.processorCount ];
	NSString	*physMemory = [NSString stringWithFormat:@"Physical Memory: %ld GB", self->processInfo.physicalMemory >> 30 ];
	
	if( [self->delegate respondsToSelector:@selector(addSystem:)] ) {
		
		[self->delegate performSelector:@selector(addSystem:) withObject:hostname];
		[self->delegate performSelector:@selector(addSystem:) withObject:osName];
		[self->delegate performSelector:@selector(addSystem:) withObject:osVersion];
		[self->delegate performSelector:@selector(addSystem:) withObject:coreText];
		[self->delegate performSelector:@selector(addSystem:) withObject:physMemory];
	}
}
//---------------------------------------------------------------------------
-(void) displayHost {
	
	NSArray		*addrList = [self->host addresses];
	for(int index = 0; index < addrList.count; index++ ) {
		
		NSString	*address = [NSString stringWithFormat:@"IP address: %@", [addrList objectAtIndex: index]];
		
		if( [self->delegate respondsToSelector:@selector(LogDeviceText:)] ) {
			
			[self->delegate performSelector:@selector(LogDeviceText:) withObject:address];
		}		
	}
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

//Posted when the Finder is about to launch an application
-(void) willLaunchApplication:(NSNotification *)note {

	NSLog(@"launched %@ (%@)\n", [[note userInfo] objectForKey:@"NSApplicationBundleIdentifier"], [[note userInfo] objectForKey:@"NSApplicationProcessIdentifier"]);
	
	NSRunningApplication	*runningApp = [[note userInfo] objectForKey:@"NSWorkspaceApplicationKey"];
	
	if( [self->delegate respondsToSelector:@selector(willLaunchApplication:)] ) {
			
		[self->delegate performSelector:@selector(willLaunchApplication:) withObject:runningApp];
	}
}
//---------------------------------------------------------------------------
//	Posted when a new application has started up.
-(void)didLaunchApplication:(NSNotification *)note {
	
	[self->soundAdded play];
	
	NSLog(@"launched %@ (%@)\n", [[note userInfo] objectForKey:@"NSApplicationBundleIdentifier"], [[note userInfo] objectForKey:@"NSApplicationProcessIdentifier"]);
	
	NSRunningApplication	*runningApp = [[note userInfo] objectForKey:@"NSWorkspaceApplicationKey"];
	
	if( [self->delegate respondsToSelector:@selector(didLaunchApplication:)] ) {
			
		[self->delegate performSelector:@selector(didLaunchApplication:) withObject:runningApp];
	}
}
//---------------------------------------------------------------------------
//Posted when an application finishes executing.
-(void)didTerminateApplication:(NSNotification *)note {
	
	[self->soundRemoved play];

	NSLog(@"terminated %@ (%@)\n", [[note userInfo] objectForKey:@"NSApplicationBundleIdentifier"], [[note userInfo] objectForKey:@"NSApplicationProcessIdentifier"]);

	NSRunningApplication	*runningApp = [[note userInfo] objectForKey:@"NSWorkspaceApplicationKey"];
	
	if( [self->delegate respondsToSelector:@selector(didTerminateApplication:)] ) {
			
		[self->delegate performSelector:@selector(didTerminateApplication:) withObject:runningApp];
	}
}
//---------------------------------------------------------------------------
//Posted when the Finder hide an application
-(void) didHideApplicationNotification:(NSNotification *)note {

	NSLog(@"Hide %@ (%@)\n", [[note userInfo] objectForKey:@"NSApplicationBundleIdentifier"], [[note userInfo] objectForKey:@"NSApplicationProcessIdentifier"]);

	NSRunningApplication	*runningApp = [[note userInfo] objectForKey:@"NSWorkspaceApplicationKey"];
	
	if( [self->delegate respondsToSelector:@selector(didHideApplicationNotification:)] ) {
			
		[self->delegate performSelector:@selector(didHideApplicationNotification:) withObject:runningApp];
	}
}
//---------------------------------------------------------------------------
//Posted when the Finder unhide an application
-(void) didUnhideApplicationNotification:(NSNotification *)note {

	NSLog(@"Unhide %@ (%@)\n", [[note userInfo] objectForKey:@"NSApplicationBundleIdentifier"], [[note userInfo] objectForKey:@"NSApplicationProcessIdentifier"]);

	NSRunningApplication	*runningApp = [[note userInfo] objectForKey:@"NSWorkspaceApplicationKey"];
	
	if( [self->delegate respondsToSelector:@selector(didUnhideApplicationNotification:)] ) {
			
		[self->delegate performSelector:@selector(didUnhideApplicationNotification:) withObject:runningApp];
	}
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
//Posted when a volume changes its name and/or mount path. 
-(void) didRenameVolumeNotification:(NSNotification *)note {

	NSString	*volume = [[note userInfo] objectForKey:@"NSDevicePath"];
	NSLog(@"Volume rename %@ \n", volume);

	if( [self->delegate respondsToSelector:@selector(didRenameVolumeNotification:)] ) {
			
		[self->delegate performSelector:@selector(didRenameVolumeNotification:) withObject:volume];
	}
}
//---------------------------------------------------------------------------
//Posted when a new device has been mounted.
-(void) didMountNotification:(NSNotification *)note {

	NSString	*volume = [[note userInfo] objectForKey:@"NSDevicePath"];
	NSLog(@"Mount %@ \n", volume);

	if( [self->delegate respondsToSelector:@selector(didMountNotification:)] ) {
			
		[self->delegate performSelector:@selector(didMountNotification:) withObject:volume];
	}
}
//---------------------------------------------------------------------------
//Posted when the Finder is about to unmount a device.
-(void) didUnmountNotification:(NSNotification *)note {

	NSString	*volume = [[note userInfo] objectForKey:@"NSDevicePath"];
	NSLog(@"Unmount %@ \n", volume);

	if( [self->delegate respondsToSelector:@selector(didUnmountNotification:)] ) {
			
		[self->delegate performSelector:@selector(didUnmountNotification:) withObject:volume];
	}
}

@end
