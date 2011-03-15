//
//  ZombieGridManagerDelegate.h
//  Zombies_Leveler
//
//  Created by Nathan Holmberg on 6/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol ZombieGridManagerDelegate

-(void) CellSelected:(CGPoint) cell;

-(void) EdgeSelected:(NSInteger) edge;

@end
