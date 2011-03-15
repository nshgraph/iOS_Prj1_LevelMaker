//
//  Zombie_Leveler_Controller.h
//  Zombies_Leveler
//
//  Created by Nathan Holmberg on 6/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ZombieGridManagerDelegate.h"

@class ZombieGridManager;

@interface Zombie_Leveler_Controller : NSViewController<ZombieGridManagerDelegate> {
	IBOutlet NSTextField* mLevelNameText;
	
	IBOutlet NSTextField* mImageNameLabel;
	IBOutlet NSImageView* mImageView;
	
	IBOutlet NSTextField* mDimensionsX;
	IBOutlet NSTextField* mDimensionsY;
	IBOutlet NSTextField* mCellSizeX;
	IBOutlet NSTextField* mCellSizeY;
	IBOutlet NSTextField* mFirstCellOffsetX;
	IBOutlet NSTextField* mFirstCellOffsetY;
	
	IBOutlet NSView* mZombieGridView;
	
	IBOutlet NSBox* mCellInfoBox;
	IBOutlet NSBox* mEdgeInfoBox;
	
	IBOutlet NSComboBox* mCellTypeBox;
	IBOutlet NSSlider* mEdgeWeightSlider;
	
	IBOutlet NSTextField* mZombiesInitialText;
	IBOutlet NSTextField* mZombiesPerTurnText;
	IBOutlet NSTextField* mZombiesMaxPerPlayerText;
	IBOutlet NSTextField* mZombiesNumAPPointsText;
	
	IBOutlet NSTextField* mPlayerNumAPPointsText;
	IBOutlet NSTextField* mPlayerAPPointsCarryText;
	
	ZombieGridManager* mGridManager;
	
	CGPoint mSelectedCell;
	NSInteger mSelectedEdge;
}

-(void)OpenBackgroundFileFromPath:(NSString*) path;

-(IBAction)OpenBackgroundFileButton:(id) sender;

-(IBAction)CreateGrid:(id) sender;

-(IBAction)SelectCellType:(id) sender;

-(IBAction)SelectEdgeWeight:(id) sender;

-(IBAction)OpenLevel:(id) sender;

-(IBAction)SaveLevel:(id) sender;


@end
