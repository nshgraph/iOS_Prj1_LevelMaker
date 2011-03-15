//
//  ZombieLevelUtils.h
//  Zombies_Leveler
//
//  Created by Nathan Holmberg on 7/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ZombieLevelUtils : NSObject {

}

+(NSString*) stringCoordinateForPoint: (CGPoint) point;

+(NSString*) stringCoordinateForSize: (CGSize) size;

+(CGPoint) parseSettingIntoCGPoint:(NSString*) setting;

@end
