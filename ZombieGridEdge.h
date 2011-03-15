//
//  ZombieGridEdge.h
//  Zombies_Leveler
//
//  Created by Nathan Holmberg on 6/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@interface ZombieGridEdge : NSObject {
	NSButton* mButton;
	CIFilter* mFilter;
	
	float mEdgeWeight;
}
@property(nonatomic,readwrite) float edgeWeight;

-(id) initWithButton:(NSButton*) button;

@end
