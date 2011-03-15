//
//  ZombieGridCell.m
//  Zombies_Leveler
//
//  Created by Nathan Holmberg on 6/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZombieGridCell.h"

#import "ZombieGridCellTypes.h"

@implementation ZombieGridCell

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
		mButton.layer.opacity = 0.0;
		mFilter = [CIFilter filterWithName:@"CIColorMatrix"];
		mFilter.name = @"colour";
		[mFilter retain];
		[mFilter setDefaults];
		[mButton.layer setFilters: [NSArray arrayWithObject: mFilter]];
		
		mCellType = ZombieCell_EmptyCell;
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

-(NSInteger) cellType
{
	return mCellType;
}
	

-(void) setCellType:(NSInteger) type;
{
	[mButton.layer setValue:[CIVector vectorWithX:0 Y: 0 Z: 0 W: 0] forKeyPath:@"filters.colour.inputBiasVector"];
	mCellType = type;
	switch( type )
	{
		case ZombieCell_EmptyCell:
			[mButton setTitle:@""];
			mButton.layer.opacity = 0.0;
			[[mButton cell] setBackgroundColor:[NSColor grayColor]];
			break;
		case ZombieCell_Player1SpawnPoint:
			[mButton setTitle:@"P1"];
			mButton.layer.opacity = 0.75;
			[mButton.layer setValue:[CIVector vectorWithX:0 Y: 1 Z: 0 W: 0] forKeyPath:@"filters.colour.inputBiasVector"];
			break;
		case ZombieCell_Player2SpawnPoint:
			[mButton setTitle:@"P2"];
			mButton.layer.opacity = 0.75;
			[mButton.layer setValue:[CIVector vectorWithX:1 Y: 0 Z: 0 W: 0] forKeyPath:@"filters.colour.inputBiasVector"];
			break;
		case ZombieCell_Player3SpawnPoint:
			[mButton setTitle:@"P3"];
			mButton.layer.opacity = 0.75;
			[mButton.layer setValue:[CIVector vectorWithX:0 Y: 0 Z: 1 W: 0] forKeyPath:@"filters.colour.inputBiasVector"];
			break;
		case ZombieCell_Player4SpawnPoint:
			[mButton setTitle:@"P4"];
			[mButton.layer setValue:[CIVector vectorWithX:0 Y: 1 Z: 1 W: 0] forKeyPath:@"filters.colour.inputBiasVector"];
			mButton.layer.opacity = 0.75;
			break;
			
		case ZombieCell_ZombieGroup1SpawnPoint:
			[mButton setTitle:@"Z1"];
			mButton.layer.opacity = 0.75;
			[mButton.layer setValue:[CIVector vectorWithX:0 Y: -0.5 Z: -0.5 W: 0] forKeyPath:@"filters.colour.inputBiasVector"];
			break;
		case ZombieCell_ZombieGroup2SpawnPoint:
			[mButton setTitle:@"Z2"];
			mButton.layer.opacity = 0.75;
			[mButton.layer setValue:[CIVector vectorWithX:-0.5 Y: 0 Z: -0.5 W: 0] forKeyPath:@"filters.colour.inputBiasVector"];
			break;
		case ZombieCell_ZombieGroup3SpawnPoint:
			[mButton setTitle:@"Z3"];
			mButton.layer.opacity = 0.75;
			[mButton.layer setValue:[CIVector vectorWithX:-0.5 Y: -0.5 Z: 0 W: 0] forKeyPath:@"filters.colour.inputBiasVector"];
			break;
		case ZombieCell_ZombieGroup4SpawnPoint:
			[mButton setTitle:@"Z4"];
			mButton.layer.opacity = 0.75;
			[mButton.layer setValue:[CIVector vectorWithX:-0.5 Y: 0 Z: 0 W: 0] forKeyPath:@"filters.colour.inputBiasVector"];
			break;
		default: 
			break;
	}
}


@end
