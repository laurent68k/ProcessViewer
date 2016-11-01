//
//  PreviewWndController.m
//
//  Created by Laurent on 02/12/11.
//	Updated on: 05/12/2011
//
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - October 5, 2011.

#include <stdlib.h>

#import "NodeRacine.h"
#import "NodeProcessus.h"
#import "NodeSystem.h"
#import "NodeMounted.h"
#import "NodeVolume.h"

#import "PreviewWndController.h"
#import	"Constants.h"

@implementation PreviewWndController

-(id) init {
	
	self = [super init];
		
	return self;
}
//---------------------------------------------------------------------------
-(void) dealloc {
			
    [super dealloc];
}
//---------------------------------------------------------------------------
- (void)awakeFromNib
{
	[[self window] setTitle: DTL_WINDOW__TITLE];
	
	[self->tfName setStringValue:@""];
	[self->tfInfo1 setStringValue:@""];
	[self->tfInfo2 setStringValue:@""];
	[self->tfInfo3 setStringValue:@""];
	
	//	Register for item change
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationItemChange:) name:NOTIFICATION_ID object:nil];

}
//---------------------------------------------------------------------------
- (void)windowWillClose:(NSNotification *)note {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ID object:nil];
}

//---------------------------------------------------------------------------
//	
//---------------------------------------------------------------------------

-(NSString *) dateToString:(NSDate *)aDate {
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSString		*stringDate;
	
	[dateFormatter setDateStyle: kCFDateFormatterLongStyle ];		//	NSDateFormatterShortStyle equal to kCFDateFormatterShortStyle.
	[dateFormatter setTimeStyle: kCFDateFormatterMediumStyle ];		//	NSDateFormatterShortStyle equal to kCFDateFormatterShortStyle.

	stringDate = [dateFormatter stringFromDate:aDate];
	
	[dateFormatter release];
	return stringDate;
}
//---------------------------------------------------------------------------
-(void) notificationItemChange:(NSNotification*)notification {

	Node	*node = (Node *)[[notification userInfo] objectForKey: KEY_OBJECT_NOTIFICATION ];
	
	if( [node isKindOfClass:[NodeRacine class]] ) {
		
		[self->tfName setStringValue: [NSString stringWithFormat:@"Folder: %@", [node label]]];
		[self->tfInfo1 setStringValue: @""];
		[self->tfInfo2 setStringValue: @""];
		[self->tfInfo3 setStringValue: @""];
	}
	else if( [node isKindOfClass:[NodeProcessus class]] ) {
		
		[self->tfName setStringValue: [NSString stringWithFormat:@"Application: %@", [node label]]];

		[self->tfInfo1 setStringValue: [NSString stringWithFormat:@"bundleURL: %@", [((NodeProcessus *)node).application bundleURL]]];
		[self->tfInfo2 setStringValue: [NSString stringWithFormat:@"executableURL: %@", [((NodeProcessus *)node).application executableURL]]];
		[self->tfInfo3 setStringValue: [NSString stringWithFormat:@"Lunched at: %@", [self dateToString: [((NodeProcessus *)node).application launchDate]]]];
	} 
	else if( [node isKindOfClass:[NodeMounted class]] ) {
		
		[self->tfName setStringValue: [NSString stringWithFormat:@"Removable: %@", [node label]]];
		[self->tfInfo1 setStringValue: @""];
		[self->tfInfo2 setStringValue: @""];
		[self->tfInfo3 setStringValue: @""];
	} 
	else if( [node isKindOfClass:[NodeVolume class]] ) {
		
		[self->tfName setStringValue: [NSString stringWithFormat:@"Volume: %@", [node label]]];
		[self->tfInfo1 setStringValue: @""];
		[self->tfInfo2 setStringValue: @""];
		[self->tfInfo3 setStringValue: @""];
	} 
	else if( [node isKindOfClass:[NodeSystem class]] ) {
		
		[self->tfName setStringValue: [node label]];
		[self->tfInfo1 setStringValue: @""];
		[self->tfInfo2 setStringValue: @""];
		[self->tfInfo3 setStringValue: @""];
	} 
	else {
	
		[self->tfName setStringValue:@""];
		[self->tfInfo1 setStringValue: @""];
		[self->tfInfo2 setStringValue: @""];
		[self->tfInfo3 setStringValue: @""];
	}
	
	[self->imageIcon setImage:[node iconImage]];
	
}
//---------------------------------------------------------------------------

@end
