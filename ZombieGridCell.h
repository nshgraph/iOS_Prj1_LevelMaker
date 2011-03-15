//
//  ZombieGridCell.h
//  Zombies_Leveler
//
//  Created by Nathan Holmberg on 6/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@interface ZombieGridCell : NSObject {
	NSButton* mButton;
	CIFilter* mFilter;
	
	NSInteger mCellType;
}

@property(nonatomic,readwrite) NSInteger cellType;

-(id) initWithButton:(NSButton*) button;


@end
