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

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) d: (double) e: (double) fr: (double) w: (double) h {
    //self = [super init:xx :xy :vx :vy :ax :ay :d :e: fr];
	self = [super initWithpositionX:xx positionY:xy velocityX:vx velocityY:vy accelerationX:ax accelerationY:ay dragValue:d elasticity:e andFramerate:fr];
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

// ∆X = V
// ∆V = A
// F = ma = g - dv
// ∆A = g - dv
//

-(void) update {
    // OVER RIDDEN
    // Time = 1/Framerate
    double gravity = -1;
    double time = 1/[super getFr]/200;
    [super setAccX:(-1*[super getDrag]*[super getVelX])/2];
    [super setAccY:(gravity-[super getDrag]*[super getVelY])];
    [super setPosX:[super getPosX]+[super getVelX]];//*[super getFr]+[super getAccX]/2*time*time];
    [super setPosY:[super getPosY]+[super getVelY]];//*[super getFr]+[super getAccY]/2*time*time];
    [super setVelX:[super getVelX]+[super getAccX]];
    [super setVelY:[super getVelY]+[super getAccY]];
}

@end
