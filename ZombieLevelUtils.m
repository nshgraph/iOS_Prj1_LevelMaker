//
//  ZombieLevelUtils.m
//  Zombies_Leveler
//
//  Created by Nathan Holmberg on 7/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZombieLevelUtils.h"


@implementation ZombieLevelUtils


+(NSString*) stringCoordinateForPoint: (CGPoint) point
{
	return [NSString stringWithFormat:@"(%i,%i)",(int)point.x,(int)point.y];
}
+(NSString*) stringCoordinateForSize: (CGSize) size
{
	return [NSString stringWithFormat:@"(%f,%f)",size.width,size.height];
}

+(CGPoint) parseSettingIntoCGPoint:(NSString*) setting
{
	float x, y;
	NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"(,)"];
	NSScanner* scanner = [NSScanner scannerWithString:setting];
	[scanner scanCharactersFromSet: charset intoString: NULL];
	[scanner scanFloat:&x];
	[scanner scanCharactersFromSet: charset intoString: NULL];
	[scanner scanFloat:&y];
	[scanner scanCharactersFromSet: charset intoString: NULL];
	
	return CGPointMake(x,y);
}

@end
