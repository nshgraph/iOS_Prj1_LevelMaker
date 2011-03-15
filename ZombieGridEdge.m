//
//  ZombieGridEdge.m
//  Zombies_Leveler
//
//  Created by Nathan Holmberg on 6/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZombieGridEdge.h"


@implementation ZombieGridEdge


-(id) initWithButton:(NSButton*) button
{
	self = [super init];
	if( self )
	{
		mButton = button;
		[mButton retain];
		
		[mButton setTitle:@""];
		[mButton setBezelStyle:NSSmallSquareBezelStyle];
		[mButton setWantsLayer:YES];
		
		mFilter = [CIFilter filterWithName:@"CIColorMatrix"];
		mFilter.name = @"colour";
		[mFilter retain];
		[mFilter setDefaults];
		[mButton.layer setFilters: [NSArray arrayWithObject: mFilter]];
		
		mEdgeWeight = 0.0;
	}
	return self;
}
-(void) dealloc
{
	[mFilter release];
	[mButton removeFromSuperview];
	[mButton release];
	
	[super dealloc];
}

-(void) setEdgeWeight:(float) edgeWeight
{
	mEdgeWeight = edgeWeight;
	[mButton.layer setValue:[CIVector vectorWithX:-edgeWeight Y: -edgeWeight Z: -edgeWeight W: 0] forKeyPath:@"filters.colour.inputBiasVector"];
}

-(float) edgeWeight
{
	return mEdgeWeight;
}


@end
