//
//  CircleShape.h
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreShape.h"

@class RectangleShape; // @class instead of import

@interface CircleShape : CoreShape
{
@private
    double radius;
}

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) dx: (double) dy: (double) e: (double) n: (BOOL) m: (double) r: (double) a: (double) rv: (double) ra;
-(void) draw:(NSColor*)c;
-(void) update;

+(void) checkCollisionC: (CircleShape*)a:(CircleShape *)b;

+(BOOL) checkCoord: (CircleShape*)a:(int)x:(int)y;

-(double) getRadius;

@end
