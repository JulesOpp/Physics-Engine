//
//  RectangleShape.m
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "RectangleShape.h"

@implementation RectangleShape

// The posX and posY define the bottom left corner of the rectangle
// All else needed is the width and height

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) d: (double) e: (double) w: (double) h {
    self = [super init:xx :xy :vx :vy :ax :ay :d :e];
    if (self) {
        width = w;
        height = h;
    }
    return self;
}

-(void) draw {
    // OVER RIDDEN
    NSRectFill(CGRectMake([super getPosX], [super getPosY], width, height));

}

@end
