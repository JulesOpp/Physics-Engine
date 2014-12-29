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
    //self = [super init:xx :xy :vx :vy :ax :ay :dx :dy :e :m :fr];
	self = [super initWithpositionX:xx positionY:xy velocityX:vx velocityY:vy accelerationX:ax accelerationY:ay dragValueX:dx dragValueY:dy elasticity:e canMove:m andFramerate:fr];
    if (self) {
        width = w;
        height = h;
    }
    [super setType:1];
    return self;
}

-(void) draw {
    NSRectFill(CGRectMake([super getPosX], [super getPosY], width, height));
}

// For a step by step calculation
// Xf = Xo + V
// Vf = Vo + A
// A = F/m    assuming m=1    Ay = g - dv  and   Ax = -dv

// THE INPUTTED ACCELERATION DOESNT DO ANYTHING RIGHT NOW

-(void) update {
    // OVER RIDDEN
    if (![super getMove]) return;
    
    double gravity = -2;
    [super setAccX:(-1*[super getDragX]*[super getVelX])];
    [super setAccY:(gravity-[super getDragY]*[super getVelY])];
    
    [super setVelX:[super getVelX]+[super getAccX]*[super getFr]*10];
    [super setVelY:[super getVelY]+[super getAccY]*[super getFr]*10];
    
    [super setPosX:[super getPosX]+[super getVelX]*[super getFr]*10];
    
    // THIS IS A TEMPORARY SOLUTION TO KEEP AT BOTTOM
    ([super getPosY] <= 0) ? [super setPosY:0] : [super setPosY:[super getPosY]+[super getVelY]*[super getFr]*10];
}

-(void) checkCollision: (CoreShape*) b {
    switch ([b getType]) {
        case 1:
            // Rectangle vs Rectangle
            
            // COLLISION DETECT
            //if (aRect.left > bRect.right || aRect.right < bRect.left) return false;
            //if (aRect.top < bRect.bottom || aRect.bottom > bRect.top) return false;
            //return true;
            
            // COLLISION SOLVE
            // posX = something else;
            // posY = something else;
            break;
        case 2:
            // Rectangle vs Circle
            
            // COLLISION DETECT
            // Magic goes here
            
            // COLLISION SOLVE
            // posX = something else;
            // posY = something else;
            break;
        default:
            NSLog(@"Something went horribly wrong");
            break;
    }
}

@end
