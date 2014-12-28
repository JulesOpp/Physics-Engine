//
//  CircleShape.m
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CircleShape.h"

@implementation CircleShape

// The posX and posY define the center of the circle
// All else needed is the radius

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) d: (double) e: (double) fr: (double) r {
    self = [super init:xx :xy :vx :vy :ax :ay :d :e :fr];
    if (self) {
        radius = r;
    }
    return self;
}

-(void) draw {
    // OVER RIDDEN
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];    
    CGContextFillEllipseInRect(context, CGRectMake([super getPosX]-radius, [super getPosY]-radius, 2*radius, 2*radius));    
}

@end
