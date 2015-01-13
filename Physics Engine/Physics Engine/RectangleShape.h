//
//  RectangleShape.h
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreShape.h"

@class CircleShape; // It does @class instead of import

@interface RectangleShape : CoreShape
{
    @private
    double width;
    double height;
    double angle;
    double rotation;
}

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) dx: (double) dy: (double) e: (double) n: (BOOL) m: (double) w: (double) h;
-(void) draw:(NSColor*)c;
-(void) update;

+(BOOL) checkCollisionR2:(RectangleShape*)a:(RectangleShape *) b;

+(void) checkCollisionR: (RectangleShape*)a:(RectangleShape*) b;
+(void) checkCollisionC: (RectangleShape*)a:(CircleShape *)b;

+(BOOL) checkCoord: (RectangleShape*)a:(int)x:(int)y;

-(double) getWidth;
-(double) getHeight;
-(double) getAngle;
-(void) setAngle: (double) a;
-(void) setRotation: (double) r;

@end
