//
//  ZombieGridManager.m
//  Zombies_Leveler
//
//  Created by Nathan Holmberg on 6/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZombieGridManager.h"

#import "ZombieGridCell.h"
#import "ZombieGridEdge.h"

@implementation ZombieGridManager


@synthesize delegate = mDelegate;
@synthesize cellDims = mGridDimensions;
@synthesize cellSize = mCellSize;
@synthesize cellOffset = mCellOffset;



-(id) initWithView:(NSView*) base_view
{
	self = [super init];
	if( self )
	{
		mBaseView = base_view;
		[mBaseView retain];
		
		mCellArray = [[NSMutableArray alloc] init];
		mEdgeArray = [[NSMutableArray alloc] init];
		
		mPlayer1Spawn = CGPointMake(-1,-1);
		mPlayer2Spawn = CGPointMake(-1,-1);
		mPlayer3Spawn = CGPointMake(-1,-1);
		mPlayer4Spawn = CGPointMake(-1,-1);
		
		mZombieGroups = [[NSMutableArray alloc] init];
		// the four empty zombie groups
		[mZombieGroups addObject:[NSMutableArray arrayWithCapacity:1]];
		[mZombieGroups addObject:[NSMutableArray arrayWithCapacity:1]];
		[mZombieGroups addObject:[NSMutableArray arrayWithCapacity:1]];
		[mZombieGroups addObject:[NSMutableArray arrayWithCapacity:1]];
	}
	return self;
}

-(void) dealloc
{
	[mBaseView release];
	[mCellArray release];
	[mEdgeArray release];
	[mZombieGroups release];
	[super dealloc];
}


-(void)createGridOfSize:(CGSize) dim withCellsOfSize:(CGSize) cell_size andCellOffset:(CGPoint) cell_offset
{
	mGridDimensions = dim;
	mCellSize = cell_size;
	mCellOffset = cell_offset;
	
	[mCellArray removeAllObjects];
	
	[mEdgeArray removeAllObjects];
	
	cell_offset.x -= cell_size.width/2;
	cell_offset.y -= cell_size.height/2;
	
	int edge_size = 8;
	
	for( int i=0; i < dim.width; i++ )
	{
		for( int j=0; j < dim.height; j++ )
		{
			NSRect frame = NSMakeRect(i*cell_size.width + cell_offset.x + edge_size/2, j*cell_size.height + cell_offset.y + edge_size/2, cell_size.width - edge_size, cell_size.height - edge_size);
			NSButton* cell_button = [[[NSButton alloc] initWithFrame: frame] autorelease];
			
			[cell_button setTag:(i * dim.height) + j];
			[cell_button setTarget:self];
			[cell_button setAction:@selector(cellSelector:)];
			
			[mBaseView addSubview:cell_button];
			
			ZombieGridCell* grid_cell = [[[ZombieGridCell alloc] initWithButton: cell_button] autorelease];
			
			[mCellArray addObject:grid_cell];
		}
	}
	
	
	cell_offset.y += cell_size.height;
	
	int edge_count = 0;
	for( int i=0; i < dim.width; i++ )
	{
		for( int j=0; j < dim.height - 1; j++ )
		{
			NSRect frame = NSMakeRect(i*cell_size.width + cell_offset.x + edge_size/2, j*cell_size.height + cell_offset.y - edge_size/2, cell_size.width - edge_size, edge_size);
			NSButton* edge_button = [[[NSButton alloc] initWithFrame: frame] autorelease];
			
			[edge_button setTag:edge_count];
			[edge_button setTarget:self];
			[edge_button setAction:@selector(edgeSelector:)];
			
			[mBaseView addSubview:edge_button];
			
			ZombieGridEdge* grid_edge = [[[ZombieGridEdge alloc] initWithButton: edge_button] autorelease];
			
			[mEdgeArray addObject:grid_edge];
			
			edge_count++;
		}
	}
	
	cell_offset.x += cell_size.width;
	cell_offset.y -= cell_size.height;
	
	for( int i=0; i < dim.width - 1; i++ )
	{
		for( int j=0; j < dim.height; j++ )
		{
			NSRect frame = NSMakeRect(i*cell_size.width + cell_offset.x - edge_size/2, j*cell_size.height + cell_offset.y + edge_size/2, edge_size, cell_size.height - edge_size);
			NSButton* edge_button = [[[NSButton alloc] initWithFrame: frame] autorelease];
			
			[edge_button setTag:edge_count];
			[edge_button setTarget:self];
			[edge_button setAction:@selector(edgeSelector:)];
			
			[mBaseView addSubview:edge_button];
			
			ZombieGridEdge* grid_edge = [[[ZombieGridEdge alloc] initWithButton: edge_button] autorelease];
			
			[mEdgeArray addObject:grid_edge];
			
			edge_count++;
		}
	}
}


-(void)setEdgeWeightsFromArray:(NSArray*) array
{
	// incoming array will have proper structure so need to unbundle it.
	
	int edge_weight_count;
	
	NSArray* edges_on_y = [array objectAtIndex:0];
	for( int i=0; i < [edges_on_y count]; i++ )
	{
		NSArray* edges_on_y_x = [edges_on_y objectAtIndex:i];
		for( int j=0;j<[edges_on_y_x count]; j++ )
		{
			ZombieGridEdge* edge = [mEdgeArray objectAtIndex:edge_weight_count];
			edge.edgeWeight = [[edges_on_y_x objectAtIndex:j] floatValue];
			edge_weight_count++;
		}
	}
	
	
	NSArray* edges_on_x = [array objectAtIndex:1];
	for( int i=0; i < [edges_on_x count]; i++ )
	{
		NSArray* edges_on_x_y = [edges_on_x objectAtIndex:i];
		for( int j=0;j<[edges_on_x_y count]; j++ )
		{
			ZombieGridEdge* edge = [mEdgeArray objectAtIndex:edge_weight_count];
			edge.edgeWeight = [[edges_on_x_y objectAtIndex:j] floatValue];
			edge_weight_count++;
		}
	}
}

-(NSArray*)edgesAsArrays
{
	NSMutableArray* root_array = [NSMutableArray arrayWithCapacity:2];
	
	NSMutableArray* edges_on_y = [NSMutableArray arrayWithCapacity:mGridDimensions.height-1];
	int edge_weight_count = 0;
	for( int i=0; i < mGridDimensions.height-1; i++ )
	{
		NSMutableArray* edges_on_y_x = [NSMutableArray arrayWithCapacity:mGridDimensions.width];
		for( int j=0; j < mGridDimensions.width; j++ )
		{
			ZombieGridEdge* edge = [mEdgeArray objectAtIndex:edge_weight_count];
			[edges_on_y_x addObject: [NSNumber numberWithFloat:edge.edgeWeight]];
			edge_weight_count++;
		}
		[edges_on_y addObject:edges_on_y_x];
	}
	[root_array addObject:edges_on_y];
	
	NSMutableArray* edges_on_x = [NSMutableArray arrayWithCapacity:mGridDimensions.width-1];
	for( int i=0; i < mGridDimensions.width-1; i++ )
	{
		NSMutableArray* edges_on_x_y = [NSMutableArray arrayWithCapacity:mGridDimensions.height];
		for( int j=0; j < mGridDimensions.height; j++ )
		{
			ZombieGridEdge* edge = [mEdgeArray objectAtIndex:edge_weight_count];
			[edges_on_x_y addObject: [NSNumber numberWithFloat:edge.edgeWeight]];
			edge_weight_count++;
		}
		[edges_on_x addObject:edges_on_x_y];
	}
	[root_array addObject:edges_on_x];
	
	return root_array;
}

-(void)setImageSize:(CGSize) image_size
{
	
	CGRect old_rect = [mBaseView frame];
	CGSize newSize = image_size;
	newSize.width += 20;
	newSize.height += 20;
	
	old_rect.origin.y += (old_rect.size.height - newSize.height);
	old_rect.size = newSize;
	
	[mBaseView setFrame: old_rect];
}

-(IBAction)cellSelector:(id) sender
{
	NSButton* button_sender = sender;
	int tag = [button_sender tag];
	
	CGPoint cell = CGPointMake( tag / (int)mGridDimensions.height, tag % (int)mGridDimensions.height );
	
	[mDelegate CellSelected: cell];
}

-(IBAction)edgeSelector:(id) sender
{
	NSButton* button_sender = sender;
	int tag = [button_sender tag];

	[mDelegate EdgeSelected: tag];
}

-(ZombieCellType) getTypeForCell:(CGPoint) cell
{
	int index = (int)cell.x * mGridDimensions.height + cell.y;
	ZombieGridCell* grid_cell = [mCellArray objectAtIndex:index];
	
	return grid_cell.cellType;
}

-(void)changeTypeForCell:(CGPoint) cell toType:(ZombieCellType) type
{
	int index = (int)cell.x * mGridDimensions.height + cell.y;
	ZombieGridCell* grid_cell = [mCellArray objectAtIndex:index];
	
	
	if( grid_cell.cellType == ZombieCell_Player1SpawnPoint )
	{
		mPlayer1Spawn.x = -1;
	}
	else if( grid_cell.cellType == ZombieCell_Player2SpawnPoint )
	{
		mPlayer2Spawn.x = -1;
	}
	else if( grid_cell.cellType == ZombieCell_Player3SpawnPoint )
	{
		mPlayer3Spawn.x = -1;
	}
	else if( grid_cell.cellType == ZombieCell_Player4SpawnPoint )
	{
		mPlayer4Spawn.x = -1;
	}
	else if( grid_cell.cellType == ZombieCell_ZombieGroup1SpawnPoint )
	{
		NSMutableArray* array = [mZombieGroups objectAtIndex:0];
		for( int i=0; i < [array count]; i++)
			if( CGPointEqualToPoint([[array objectAtIndex:i] pointValue], cell ))
			{
				[array removeObjectAtIndex:i];
				break;
			}
	}
	else if( grid_cell.cellType == ZombieCell_ZombieGroup2SpawnPoint )
	{
		NSMutableArray* array = [mZombieGroups objectAtIndex:1];
		for( int i=0; i < [array count]; i++)
			if( CGPointEqualToPoint([[array objectAtIndex:i] pointValue],cell))
			{
				[array removeObjectAtIndex:i];
				break;
			}
	}
	else if( grid_cell.cellType == ZombieCell_ZombieGroup3SpawnPoint )
	{
		NSMutableArray* array = [mZombieGroups objectAtIndex:2];
		for( int i=0; i < [array count]; i++)
			if( CGPointEqualToPoint([[array objectAtIndex:i] pointValue],cell))
			{
				[array removeObjectAtIndex:i];
				break;
			}
	}
	else if( grid_cell.cellType == ZombieCell_ZombieGroup4SpawnPoint )
	{
		NSMutableArray* array = [mZombieGroups objectAtIndex:3];
		for( int i=0; i < [array count]; i++)
			if( CGPointEqualToPoint([[array objectAtIndex:i] pointValue],cell))
			{
				[array removeObjectAtIndex:i];
				break;
			}
	}
	
	if( type == ZombieCell_Player1SpawnPoint )
	{
		if( mPlayer1Spawn.x >= 0 )
			[self changeTypeForCell: mPlayer1Spawn toType: ZombieCell_EmptyCell];
		mPlayer1Spawn = cell;
	}
	else if( type == ZombieCell_Player2SpawnPoint )
	{
		if( mPlayer2Spawn.x >= 0 )
			[self changeTypeForCell: mPlayer2Spawn toType: ZombieCell_EmptyCell];
		mPlayer2Spawn = cell;
	}
	else if( type == ZombieCell_Player3SpawnPoint )
	{
		if( mPlayer3Spawn.x >= 0 )
			[self changeTypeForCell: mPlayer3Spawn toType: ZombieCell_EmptyCell];
		mPlayer3Spawn = cell;
	}
	else if( type == ZombieCell_Player4SpawnPoint )
	{
		if( mPlayer4Spawn.x >= 0 )
			[self changeTypeForCell: mPlayer4Spawn toType: ZombieCell_EmptyCell];
		mPlayer4Spawn = cell;
	}
	else if( type == ZombieCell_ZombieGroup1SpawnPoint )
	{
		NSMutableArray* array = [mZombieGroups objectAtIndex:0];
		[array addObject:[NSValue valueWithPoint: cell]];
	}
	else if( type == ZombieCell_ZombieGroup2SpawnPoint )
	{
		NSMutableArray* array = [mZombieGroups objectAtIndex:1];
		[array addObject:[NSValue valueWithPoint: cell]];
	}
	else if( type == ZombieCell_ZombieGroup3SpawnPoint )
	{
		NSMutableArray* array = [mZombieGroups objectAtIndex:2];
		[array addObject:[NSValue valueWithPoint: cell]];
	}
	else if( type == ZombieCell_ZombieGroup4SpawnPoint )
	{
		NSMutableArray* array = [mZombieGroups objectAtIndex:3];
		[array addObject:[NSValue valueWithPoint: cell]];
	}

	
	grid_cell.cellType = type;
}

-(float) getWeightForEdge:(NSInteger) edge
{
	ZombieGridEdge* grid_edge = [mEdgeArray objectAtIndex:edge];
	
	return grid_edge.edgeWeight;
}

-(void)changeWeightForEdge:(NSInteger) edge toWeight:(float) weight
{
	ZombieGridEdge* grid_edge = [mEdgeArray objectAtIndex:edge];
	grid_edge.edgeWeight = weight;
}

-(int) maxPlayers
{
	int count = 0;
	if(mPlayer1Spawn.x >= 0 )
		count++;
	if(mPlayer2Spawn.x >= 0 )
		count++;
	if(mPlayer3Spawn.x >= 0 )
		count++;
	if(mPlayer4Spawn.x >= 0 )
		count++;
	
	return count;
}

-(NSArray*) playerSpawnPoints
{
	NSMutableArray* spawn_points = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
	if(mPlayer1Spawn.x >= 0 )
		[spawn_points addObject:[NSValue valueWithPoint: mPlayer1Spawn]];
	if(mPlayer2Spawn.x >= 0 )
		[spawn_points addObject:[NSValue valueWithPoint: mPlayer2Spawn]];
	if(mPlayer3Spawn.x >= 0 )
		[spawn_points addObject:[NSValue valueWithPoint: mPlayer3Spawn]];
	if(mPlayer4Spawn.x >= 0 )
		[spawn_points addObject:[NSValue valueWithPoint: mPlayer4Spawn]];
	return spawn_points;
}

-(NSArray*) zombieSpawnPoints
{
	return mZombieGroups;
}

@end
