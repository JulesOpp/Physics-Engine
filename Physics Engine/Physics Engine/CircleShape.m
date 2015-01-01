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
	self = [super initWithpositionX:xx positionY:xy velocityX:vx velocityY:vy accelerationX:ax accelerationY:ay dragValueX:dx dragValueY:dy elasticity:e canMove:m andFramerate:fr];
    if (self) {
        radius = r;
    }
    [super setType:2];
    return self;
}

-(void) draw:(NSColor*)c {
    [c setFill];
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];    
    CGContextFillEllipseInRect(context, CGRectMake([super getPosX]-radius, [super getPosY]-radius, 2*radius, 2*radius));    
}


-(void) update {
    // OVER RIDDEN
    if (![super getMove]) return;

    double gravity = -2;
    //[super setAccX:([super getAccX]-[super getDragX]*[super getVelX])];
    //[super setAccY:([super getAccY]+gravity-[super getDragY]*[super getVelY])];
    double currentAccX = [super getAccX]-[super getDragX]*[super getVelX];
    double currentAccY = [super getAccY]+gravity-[super getDragY]*[super getVelY];
    
    [super setVelX:[super getVelX]+currentAccX*[super getFr]*10];
    [super setVelY:[super getVelY]+currentAccY*[super getFr]*10];
    
    // Keep at bottom
    ([super getPosY] <= radius) ? [super setPosY:radius] : [super setPosY:[super getPosY]+[super getVelY]*[super getFr]*10];

}

// Check for Circle v Rect collision
+(void) checkCollisionR:(CircleShape*)a:(RectangleShape *)b {
    // Circle vs Rectangle
    
    // COLLISION DETECT
    // Magic goes here
    
    // COLLISION SOLVE
    // posX = something else;
    // posY = something else;
}

// Check for Circle v Circle collision
+(void) checkCollisionC:(CircleShape*)a:(CircleShape *)b {
    // Circle vs Circle
    
    // COLLISION DETECT
    double r = [a getRadius] + [b getRadius];
    r *= r;
    if (r <= pow([a getPosX]-[b getPosX],2) + pow([a getPosY]-[b getPosY],2)) return;
    NSLog(@"Collision on Circle v Circle");
    
    // COLLISION SOLVE
    // posX = something else;
    // posY = something else;
}

// Check if clicked on circle
+(BOOL) checkCoord: (CircleShape*)a:(int)x:(int)y {
    double r = pow([a getRadius],2);
    return r > pow([a getPosX]-x,2) + pow([a getPosY]-y,2);
}

-(double) getRadius { return radius; }

@end
