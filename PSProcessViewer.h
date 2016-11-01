//
//  PSProcessViewer.m
//
//  Created by Laurent Favard on 02/11/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.

@interface PSProcessViewer : NSObject {
	
	@private

	@protected
	
		NSWorkspace		*workspace;
		NSProcessInfo	*processInfo;
		NSHost			*host;
	
		NSSound			*soundAdded;
		NSSound			*soundRemoved;

		id				delegate;
}


-(id)			initWithDelegate:(id)theDelegate;

-(void)			displayProcesses;
-(void)			displayVolumes;
-(void)			displayRemovableMedias;
-(void)			displayMacSystem;
-(void)			displayHost;


-(void)			willLaunchApplication:(NSNotification *)note;
-(void)			didLaunchApplication:(NSNotification *)note;
-(void)			didTerminateApplication:(NSNotification *)note;
-(void)			didHideApplicationNotification:(NSNotification *)note;
-(void)			didUnhideApplicationNotification:(NSNotification *)note;

-(void)			didRenameVolumeNotification:(NSNotification *)note;
-(void)			didMountNotification:(NSNotification *)note;
-(void)			didUnmountNotification:(NSNotification *)note;

@end
