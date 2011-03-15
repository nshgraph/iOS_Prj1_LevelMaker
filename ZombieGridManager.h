//
//  ZombieGridManager.h
//  Zombies_Leveler
//
//  Created by Nathan Holmberg on 6/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ZombieGridManagerDelegate.h"
#import "ZombieGridCellTypes.h"


@interface ZombieGridManager : NSObject {
	
	NSView* mBaseView;
	
	NSMutableArray* mCellArray;
	NSMutableArray* mEdgeArray;
	
	CGSize mGridDimensions;
	CGSize mCellSize;
	CGPoint mCellOffset;
	
	CGPoint mPlayer1Spawn;
	CGPoint mPlayer2Spawn;
	CGPoint mPlayer3Spawn;
	CGPoint mPlayer4Spawn;
	
	NSMutableArray* mZombieGroups;
	
	id <ZombieGridManagerDelegate> mDelegate;
}

@property (nonatomic, assign) id <ZombieGridManagerDelegate> delegate;
@property (nonatomic, readonly) CGSize cellDims;
@property (nonatomic, readonly) CGSize cellSize;
@property (nonatomic, readonly) CGPoint cellOffset;
@property (nonatomic, readonly) int maxPlayers;
@property (nonatomic, readonly) NSArray* playerSpawnPoints;
@property (nonatomic, readonly) NSArray* zombieSpawnPoints;



-(id) initWithView:(NSView*) base_view;

-(void)createGridOfSize:(CGSize) dim withCellsOfSize:(CGSize) cell_size andCellOffset:(CGPoint) cell_offset;

-(void)setEdgeWeightsFromArray:(NSArray*) array;

-(NSArray*)edgesAsArrays;

-(void)setImageSize:(CGSize) image_size;

-(ZombieCellType) getTypeForCell:(CGPoint) cell;

-(void)changeTypeForCell:(CGPoint) cell toType:(ZombieCellType) type;

-(float) getWeightForEdge:(NSInteger) edge;

-(void)changeWeightForEdge:(NSInteger) edge toWeight:(float) weight;

-(IBAction)cellSelector:(id) sender;

@end
