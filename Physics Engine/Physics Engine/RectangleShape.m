//
//  RectangleShape.m
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "RectangleShape.h"

@implementation RectangleShape

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) d: (double) e: (double) t: (double) l: (double) b: (double) r {
    self = [super init];
    if (self) {
        top = t;
        left = l;
        bottom = b;
        right = r;
    }
    return self;
}

-(void) draw {
    // OVER RIDDEN
}

@end
