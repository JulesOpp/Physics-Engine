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

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) dx: (double) dy: (double) e: (BOOL) m: (double) fr: (double) r {
    //self = [super init:xx :xy :vx :vy :ax :ay :dx :dy :e :m :fr];
	self = [super initWithpositionX:xx positionY:xy velocityX:vx velocityY:vy accelerationX:ax accelerationY:ay dragValueX:dx dragValueY:dy elasticity:e canMove:m andFramerate:fr];
    if (self) {
        radius = r;
    }
    return self;
}

-(void) draw {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];    
    CGContextFillEllipseInRect(context, CGRectMake([super getPosX]-radius, [super getPosY]-radius, 2*radius, 2*radius));    
}


-(void) update {
    // OVER RIDDEN
    if (![super getMove]) return;

    double gravity = -2;
    [super setAccX:(-1*[super getDragX]*[super getVelX])];
    [super setAccY:(gravity-[super getDragY]*[super getVelY])];
    
    [super setVelX:[super getVelX]+[super getAccX]*[super getFr]*10];
    [super setVelY:[super getVelY]+[super getAccY]*[super getFr]*10];
    
    // TEMPORARY
    ([super getPosX] >= 740) ? [super setPosX:740] : [super setPosX:[super getPosX]+[super getVelX]*[super getFr]*10];
    
    // THIS IS A TEMPORARY SOLUTION TO KEEP AT BOTTOM
    ([super getPosY] <= radius) ? [super setPosY:radius] : [super setPosY:[super getPosY]+[super getVelY]*[super getFr]*10];

}

@end
