//
//  Zombie_Leveler_Controller.m
//  Zombies_Leveler
//
//  Created by Nathan Holmberg on 6/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Zombie_Leveler_Controller.h"

#import "ZombieGridManager.h"

#import "ZombieLevelUtils.h"


@implementation Zombie_Leveler_Controller


-(void)awakeFromNib
{
	mGridManager = [[ZombieGridManager alloc] initWithView: mZombieGridView];
	mGridManager.delegate = self;
	
	[mCellInfoBox setHidden:YES];
	[mEdgeInfoBox setHidden:YES];
}

-(void) dealloc
{
	[mGridManager release];
	[super dealloc];
}

-(void)OpenBackgroundFileFromPath:(NSString*) path
{
	NSRange image_index = [path rangeOfString:@"/" options: NSBackwardsSearch];
	image_index.location += 1;
	image_index.length = [path length] - image_index.location;
	[mImageNameLabel setStringValue: [path substringWithRange: image_index]];
	
	NSImage* image = [[[NSImage alloc] initWithContentsOfFile: path] autorelease];
	[mImageView setImage: image];
	
	
	CGRect old_rect = [mImageView frame];
	CGSize newSize = [image size];
	newSize.width += 20;
	newSize.height += 20;
	
	old_rect.origin.y += (old_rect.size.height - newSize.height);
	old_rect.size = newSize;
	
	
	[mImageView setFrame: old_rect];
	
	[mGridManager setImageSize: [image size]];
	
	
}

-(IBAction)OpenBackgroundFileButton:(id) sender
{
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg setAllowsMultipleSelection: NO];
	NSArray* types = [NSArray arrayWithObject:@"png"];
	[openDlg setAllowedFileTypes: types];
	
	if( [openDlg runModal] == NSOKButton )
	{
		NSArray* files = [openDlg filenames];
		if( files && [files count] > 0 )
		{
			[self OpenBackgroundFileFromPath:[files objectAtIndex:0] ];
		}
		
	}
}

-(IBAction)CreateGrid:(id) sender
{
	int dim_x = [mDimensionsX intValue];
	int dim_y = [mDimensionsY intValue];
	
	float cell_size_x = [mCellSizeX floatValue];
	float cell_size_y = [mCellSizeY floatValue];
	
	float first_cell_x = [mFirstCellOffsetX floatValue];
	float first_cell_y = [mFirstCellOffsetY floatValue];
	
	// some simple sanity checking
	if( dim_x <= 0 || dim_y <= 0 || 
	   cell_size_x <= 0 || cell_size_y <= 0 ||
	   first_cell_x <= 0 || first_cell_y <= 0  )
		return;
	
	[mGridManager createGridOfSize:CGSizeMake(dim_x,dim_y) 
		   withCellsOfSize:CGSizeMake(cell_size_x,cell_size_x)
			 andCellOffset:CGPointMake(first_cell_x,first_cell_y)];
}


-(void) CellSelected:(CGPoint) cell
{
	[mCellInfoBox setHidden:NO];
	[mEdgeInfoBox setHidden:YES];
	
	mSelectedCell = cell;
	
	int type = [mGridManager getTypeForCell: cell];
	
	[mCellTypeBox selectItemAtIndex: type];
}

-(IBAction)SelectCellType:(id) sender
{
	int selected_index = [mCellTypeBox indexOfSelectedItem];
	
	[mGridManager changeTypeForCell: mSelectedCell toType: selected_index];
}

-(void) EdgeSelected:(NSInteger) edge
{
	[mCellInfoBox setHidden:YES];
	[mEdgeInfoBox setHidden:NO];
	
	mSelectedEdge = edge;
	
	float weight = [mGridManager getWeightForEdge: edge];
	
	[mEdgeWeightSlider setFloatValue: weight];
}

-(IBAction)SelectEdgeWeight:(id) sender
{
	float value = [mEdgeWeightSlider floatValue];
	
	[mGridManager changeWeightForEdge: mSelectedEdge toWeight: value];
}

-(void) ParseLevelFromFile:(NSString*) file
{
	CGPoint setting;
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
	// name of level
	if( [dict valueForKey:@"LevelName"] != nil )
		[mLevelNameText setStringValue: [dict valueForKey:@"LevelName"] ];
	// offset to play tile
	
	if( [dict valueForKey:@"OffsetToFirstPlayTile"] != nil )
	{
		setting  = [ZombieLevelUtils parseSettingIntoCGPoint: [dict valueForKey:@"OffsetToFirstPlayTile"]];
		[mFirstCellOffsetX setStringValue:[NSString stringWithFormat:@"%i",(int)setting.x]];
		[mFirstCellOffsetY setStringValue:[NSString stringWithFormat:@"%i",(int)setting.y]];
	}
	// number of play tiles
	
	if( [dict valueForKey:@"NumberOfPlayTiles"] != nil )
	{
		setting  = [ZombieLevelUtils parseSettingIntoCGPoint: [dict valueForKey:@"NumberOfPlayTiles"]];
		[mDimensionsX setStringValue:[NSString stringWithFormat:@"%i",(int)setting.x]];
		[mDimensionsY setStringValue:[NSString stringWithFormat:@"%i",(int)setting.y]];
	}
	// size of play tiles
	if( [dict valueForKey:@"SizeOfPlayTile"] != nil )
	{
		setting  = [ZombieLevelUtils parseSettingIntoCGPoint: [dict valueForKey:@"SizeOfPlayTile"]];
		[mCellSizeX setStringValue:[NSString stringWithFormat:@"%f",(float)setting.x]];
		[mCellSizeY setStringValue:[NSString stringWithFormat:@"%f",(float)setting.y]];
	}
	// Make the grid
	[self CreateGrid:self];
	
	
	// ap points per player
	if( [dict valueForKey:@"APPointsPerPlayer"] != nil )
		[mPlayerNumAPPointsText setStringValue: [[dict valueForKey:@"APPointsPerPlayer"] stringValue]];
	// ap points that carry
	if( [dict valueForKey:@"APPointsPerPlayerThatCarry"] != nil )
		[mPlayerAPPointsCarryText setStringValue: [[dict valueForKey:@"APPointsPerPlayerThatCarry"] stringValue]];
	
	if( [dict valueForKey:@"PlayerSpawnPoints"] != nil )
	{
		NSArray* player_spawn = [dict valueForKey:@"PlayerSpawnPoints"];
		int spawn_index = ZombieCell_Player1SpawnPoint;
		for( int i=0; i < [player_spawn count]; i++ )
		{
			setting  = [ZombieLevelUtils parseSettingIntoCGPoint: [player_spawn objectAtIndex:i]];
			[mGridManager changeTypeForCell: setting toType: spawn_index + i];
		}
	}
	
	// number of zombies
	if( [dict valueForKey:@"NumberOfZombiesInitial"] != nil )
		[mZombiesInitialText setStringValue: [[dict valueForKey:@"NumberOfZombiesInitial"] stringValue]];
	// number of zombies per turn
	if( [dict valueForKey:@"NumberOfZombiesPerTurn"] != nil )
		[mZombiesPerTurnText setStringValue: [[dict valueForKey:@"NumberOfZombiesPerTurn"] stringValue]];
	// max zombies per player
	if( [dict valueForKey:@"MaxZombiesPerPlayer"] != nil )
		[mZombiesMaxPerPlayerText setStringValue: [[dict valueForKey:@"MaxZombiesPerPlayer"] stringValue]];
	// ap points per zombie
	if( [dict valueForKey:@"APPointsPerZombie"] != nil )
		[mZombiesNumAPPointsText setStringValue: [[dict valueForKey:@"APPointsPerZombie"] stringValue]];
	
	if( [dict valueForKey:@"ZombieSpawnPoints"] != nil )
	{
		NSArray* zombie_spawn = [dict valueForKey:@"ZombieSpawnPoints"];
		int spawn_index = ZombieCell_ZombieGroup1SpawnPoint;
		for( int i=0; i < [zombie_spawn count]; i++ )
		{
			NSArray* zombie_spawn_inner = [zombie_spawn objectAtIndex:i];
			for( int j=0; j < [zombie_spawn_inner count]; j++ )
			{
				setting  = [ZombieLevelUtils parseSettingIntoCGPoint: [zombie_spawn_inner objectAtIndex:j]];
				[mGridManager changeTypeForCell: setting toType: spawn_index + i]; // yes that should be i
			}
		}
	}
	
	if( [dict valueForKey:@"EdgeWeights"] != nil )
		[mGridManager setEdgeWeightsFromArray: [dict valueForKey:@"EdgeWeights"]];
}

-(void) SaveLevelToFile:(NSString*) file
{
	NSNumber* number;
	NSArray* array_in;
	NSMutableArray* array_out;
	NSMutableDictionary *rootObj = [NSMutableDictionary dictionaryWithCapacity:10];
	// name of level
	[rootObj setObject:[mLevelNameText stringValue] forKey:@"LevelName"];
	// offset to play tile
	[rootObj setObject:[ZombieLevelUtils stringCoordinateForPoint: mGridManager.cellOffset] forKey:@"OffsetToFirstPlayTile"];
	// number of play tiles
	[rootObj setObject:[ZombieLevelUtils stringCoordinateForSize: mGridManager.cellDims] forKey:@"NumberOfPlayTiles"];
	// size of play tiles
	[rootObj setObject:[ZombieLevelUtils stringCoordinateForSize: mGridManager.cellSize] forKey:@"SizeOfPlayTile"];
	
	// max players
	number = [NSNumber numberWithInt:mGridManager.maxPlayers];
	[rootObj setObject: number forKey:@"MaxPlayers"];
	// ap points per player
	number = [NSNumber numberWithInt:[mPlayerNumAPPointsText intValue]];
	[rootObj setObject: number forKey:@"APPointsPerPlayer"];
	// ap points that carry
	number = [NSNumber numberWithInt:[mPlayerAPPointsCarryText intValue]];
	[rootObj setObject: number forKey:@"APPointsPerPlayerThatCarry"];
	// player spawn points
	array_in = mGridManager.playerSpawnPoints;
	array_out = [NSMutableArray arrayWithCapacity:[array_in count]];
	for( int i=0;i<[array_in count];i++ )
	{
		[array_out addObject: [ZombieLevelUtils stringCoordinateForPoint: [[array_in objectAtIndex:i] pointValue]]]; 
	}
	[rootObj setObject:array_out forKey:@"PlayerSpawnPoints"];
	
	// number of zombies
	number = [NSNumber numberWithInt:[mZombiesInitialText intValue]];
	[rootObj setObject: number forKey:@"NumberOfZombiesInitial"];
	// number of zombies per turn
	number = [NSNumber numberWithInt:[mZombiesPerTurnText intValue]];
	[rootObj setObject: number forKey:@"NumberOfZombiesPerTurn"];
	// max zombies per player
	number = [NSNumber numberWithInt:[mZombiesMaxPerPlayerText intValue]];
	[rootObj setObject: number forKey:@"MaxZombiesPerPlayer"];
	// ap points per zombie
	number = [NSNumber numberWithInt:[mZombiesNumAPPointsText intValue]];
	[rootObj setObject: number forKey:@"APPointsPerZombie"];
	// zombie spawn points
	array_in = mGridManager.zombieSpawnPoints;
	array_out = [NSMutableArray arrayWithCapacity:[array_in count]];
	for( int i=0;i<[array_in count];i++ )
	{
		NSArray* array_in_interior = [array_in objectAtIndex:i];
		if( [array_in_interior count] > 0 )
		{
			NSMutableArray* array_out_interior = [NSMutableArray arrayWithCapacity:[array_in_interior count]];
		
			for( int j=0;j<[array_in_interior count];j++ )
			{
				[array_out_interior addObject: [ZombieLevelUtils stringCoordinateForPoint: [[array_in_interior objectAtIndex:j] pointValue]]]; 
			}
			[array_out addObject:array_out_interior];
		}
	}
	[rootObj setObject:array_out forKey:@"ZombieSpawnPoints"];
	
	NSArray* edges = [mGridManager edgesAsArrays];
	[rootObj setObject:edges forKey:@"EdgeWeights"];
	
	
	// Actually write out the file
	[rootObj writeToFile:file atomically:YES];
}

-(IBAction)OpenLevel:(id) sender
{
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg setAllowsMultipleSelection: NO];
	NSArray* types = [NSArray arrayWithObject:@"plist"];
	[openDlg setAllowedFileTypes: types];
	
	if( [openDlg runModal] == NSOKButton )
	{
		NSArray* files = [openDlg filenames];
		if( files && [files count] > 0 )
		{
			[self ParseLevelFromFile: [files objectAtIndex:0]];
		}
		
	}
	
}

-(IBAction)SaveLevel:(id) sender
{
	NSSavePanel* saveDlg = [NSSavePanel savePanel];
	NSArray* types = [NSArray arrayWithObject:@"plist"];
	[saveDlg setAllowedFileTypes: types];
	 if( [saveDlg runModal] == NSOKButton )
	 {
		 NSString* save_name = [saveDlg filename];
		 [self SaveLevelToFile: save_name];
	 }
}

@end
