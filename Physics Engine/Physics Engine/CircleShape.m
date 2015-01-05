//
//  CircleShape.m
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "CircleShape.h"
#import "AppView.h"

@implementation CircleShape

// The posX and posY define the center of the circle
// All else needed is the radius

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) dx: (double) dy: (double) e: (double) n: (BOOL) m: (double) fr: (double) r {
	self = [super initWithpositionX:xx positionY:xy velocityX:vx velocityY:vy accelerationX:ax accelerationY:ay dragValueX:dx dragValueY:dy elasticity:e mass:n canMove:m andFramerate:fr];
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
    
    // Ax = (ma - dv)/m      Ay = (ma - mg - dv)/m
    double currentAccX = ([super getMass]*[super getAccX]-[super getDragX]*[super getVelX])/[super getMass];
    double currentAccY = ([super getMass]*[super getAccY]+[super getMass]*gravity-[super getDragY]*[super getVelY])/[super getMass];
    
    if ([super getIgnoreNextUpdate]) {
        currentAccX = 0;
        currentAccY = 0;
        [super setIgnoreNextUpdate:false];
    }
    
    [super setVelX:[super getVelX]+currentAccX*[super getFr]*10];
    [super setVelY:[super getVelY]+currentAccY*[super getFr]*10];
    
    [super setPosX:[super getPosX]+[super getVelX]*[super getFr]*10];
    [super setPosY:[super getPosY]+[super getVelY]*[super getFr]*10];

    // Bounce
    if ([super getPosY] < 0 && [super getVelY] < 0)
        [super setVelY:-1*[super getVelY]];
    if ([super getPosX] < 0 && [super getVelX] < 0)
        [super setVelX:-1*[super getVelX]];
    if ([super getPosY] > [AppView getHeight] && [super getVelY] > 0)
        [super setVelY:-1*[super getVelY]];
    if ([super getPosX] > [AppView getWidth] && [super getVelX] > 0)
        [super setVelX:-1*[super getVelX]];
    
    // Keep at bottom
    if ([super getPosY] <= radius) {
        [super setPosY:radius];
        [super setVelY:0];
        [super setIgnoreNextUpdate:true];
    }

}

// Check for Circle v Circle collision
+(void) checkCollisionC:(CircleShape*)a:(CircleShape *)b {
    // Circle vs Circle
    
    // COLLISION DETECT
    double r = [a getRadius] + [b getRadius]; // Needed distance
    r *= r;
    if (r <= pow([a getPosX]-[b getPosX],2) + pow([a getPosY]-[b getPosY],2)) return;
    NSLog(@"Collision on Circle v Circle");
    
    // COLLISION SOLVE - http://en.wikipedia.org/wiki/Elastic_collision
    // Angle-free collisions
    // Normal = (vx,vy) -> (-vy,vx)
    // Va -= I
    // Vb += I
    // I = (1 + elas) * N * (Vr cross N)
    // Vr = Va - Vb = (vxa-vxb, vya-vba)
    // Vr cross N = Vrx*Nx + Vry*Ny
    
    double Vrx = [a getVelX] - [b getVelX];
    double Vry = [a getVelY] - [b getVelY];
    double Nx = [a getPosX] - [b getPosX];
    double Ny = [a getPosY] - [b getPosY];
    double NVr = Nx * Vrx + Ny * Vry;
    
    [a setVelX:[a getVelX] - Nx * NVr / (pow(Nx,2)+pow(Ny,2))];
    [a setVelY:[a getVelY] - Ny * NVr / (pow(Nx,2)+pow(Ny,2))];
    
    [b setVelX:[b getVelX] + Nx * NVr / (pow(Nx,2)+pow(Ny,2))];
    [b setVelY:[b getVelY] + Ny * NVr / (pow(Nx,2)+pow(Ny,2))];
    
    // Actual distance
    double d = sqrt(pow([a getPosX]-[b getPosX],2) + pow([a getPosY]-[b getPosY],2));
    double pen;
    
    // Circles not on top of each other
    if (d != 0) {
        pen = r - d;
    }
    // Circles on top of each other
    else {
        pen = [a getRadius];
    }
    
    //[a setPosX:[a getPosX] + pen];
}

// Check if clicked on circle
+(BOOL) checkCoord: (CircleShape*)a:(int)x:(int)y {
    double r = pow([a getRadius],2);
    return r > pow([a getPosX]-x,2) + pow([a getPosY]-y,2);
}

-(double) getRadius { return radius; }

@end
