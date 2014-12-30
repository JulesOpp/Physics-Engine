//
//  RectangleShape.h
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreShape.h"
//#import "CircleShape.h"

@class CircleShape;

@interface RectangleShape : CoreShape
{
    @private
    double width;
    double height;
}

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) dx: (double) dy: (double) e: (BOOL) m: (double) fr: (double) w: (double) h;
-(void) draw:(NSColor*)c;
-(void) update;

+(void) checkCollisionR: (RectangleShape*)a:(RectangleShape*) b;
+(void) checkCollisionC: (RectangleShape*)a:(CircleShape *)b;

+(BOOL) checkCoord: (RectangleShape*)a:(int)x:(int)y;

-(double) getWidth;
-(double) getHeight;

@end
