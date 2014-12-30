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

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) dx: (double) dy: (double) e: (BOOL) m: (double) fr: (double) w: (double) h {
	self = [super initWithpositionX:xx positionY:xy velocityX:vx velocityY:vy accelerationX:ax accelerationY:ay dragValueX:dx dragValueY:dy elasticity:e canMove:m andFramerate:fr];
    if (self) {
        width = w;
        height = h;
    }
    [super setType:1];
    return self;
}

-(void) draw:(NSColor*)c {
    [c setFill];
    NSRectFill(CGRectMake([super getPosX], [super getPosY], width, height));
}

// For a step by step calculation
// Xf = Xo + V
// Vf = Vo + A
// A = F/m    assuming m=1    Ay = g - dv  and   Ax = -dv

// THE INPUTTED ACCELERATION DOESNT DO ANYTHING RIGHT NOW

-(void) update {
    if (![super getMove]) return;
    
    double gravity = -2;
    [super setAccX:(-1*[super getDragX]*[super getVelX])];
    [super setAccY:(gravity-[super getDragY]*[super getVelY])];
    
    [super setVelX:[super getVelX]+[super getAccX]*[super getFr]*10];
    [super setVelY:[super getVelY]+[super getAccY]*[super getFr]*10];
    
    [super setPosX:[super getPosX]+[super getVelX]*[super getFr]*10];
    
    // Keep at bottom
    ([super getPosY] <= 0) ? [super setPosY:0] : [super setPosY:[super getPosY]+[super getVelY]*[super getFr]*10];
}

// Check for Rect v Rect collision
+(void) checkCollisionR:(RectangleShape*)a:(RectangleShape *) b {
    // Rectangle vs Rectangle
    
    // COLLISION DETECT
    if ([a getPosX]>[b getPosX]+[b getWidth] || [a getPosX]+[a getWidth]<[b getPosX]) return;
    if ([a getPosY]+[a getHeight]<[b getPosY] || [a getPosY]>[b getPosY]+[b getHeight]) return;
    
    NSLog(@"Collision on Rect v Rect");
    
    // COLLISION SOLVE
    // posX = something else;
    // posY = something else;
}

// Check for Rect v Circle collision
+(void) checkCollisionC:(RectangleShape*)a:(CircleShape *)b {
    // Rectangle vs Circle
    
    // COLLISION DETECT
    // Magic goes here
    
    // COLLISION SOLVE
    // posX = something else;
    // posY = something else;
}

// Check if click on rect
+(BOOL) checkCoord: (RectangleShape*)a:(int)x:(int)y {
    if (x < [a getPosX] || x > [a getPosX] + [a getWidth]) return false;
    if (y < [a getPosY] || y > [a getPosY] + [a getHeight]) return false;
    return true;
}

-(double) getWidth { return width; }
-(double) getHeight { return height; }


@end
