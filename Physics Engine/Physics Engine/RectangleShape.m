//
//  RectangleShape.m
//  Physics Engine
//
//  Created by Jules on 12/27/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "RectangleShape.h"
#import "AppView.h"
#import "CircleShape.h"
#import "AppDelegate.h"

@implementation RectangleShape

// The posX and posY define the bottom left corner of the rectangle
// All else needed is the width and height

-(id) init: (double) xx: (double) xy: (double) vx: (double) vy: (double) ax: (double) ay: (double) dx: (double) dy: (double) e: (double) n: (BOOL) m: (double) fr: (double) w: (double) h {
	self = [super initWithpositionX:xx positionY:xy velocityX:vx velocityY:vy accelerationX:ax accelerationY:ay dragValueX:dx dragValueY:dy elasticity:e mass:n canMove:m andFramerate:fr];
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
    double fr = [AppDelegate getFrameRate]; 
    
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
    
    [super setVelX:[super getVelX]+currentAccX*fr*10];
    [super setVelY:[super getVelY]+currentAccY*fr*10];
    
    [super setPosX:[super getPosX]+[super getVelX]*fr*10];
    [super setPosY:[super getPosY]+[super getVelY]*fr*10];
    
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
    if ([super getPosY] <= 0) {
        [super setPosY:0];
        [super setVelY:0];
        [super setIgnoreNextUpdate:true];
    }
}

// Check for Rect v Rect collision
+(void) checkCollisionR:(RectangleShape*)a:(RectangleShape *) b {
    // Rectangle vs Rectangle
    
    // COLLISION DETECT
    if ([a getPosX]>[b getPosX]+[b getWidth] || [a getPosX]+[a getWidth]<[b getPosX]) return;
    if ([a getPosY]+[a getHeight]<[b getPosY] || [a getPosY]>[b getPosY]+[b getHeight]) return;
    
    //NSLog(@"Collision on Rect v Rect");
    
    /*double Vrx = [a getVelX] - [b getVelX];
    double Vry = [a getVelY] - [b getVelY];
    double Nx = [a getPosX] - [b getPosX];
    double Ny = [a getPosY] - [b getPosY];
    double NVr = Nx * Vrx + Ny * Vry;
    
    double sumMass = [a getMass] + [b getMass];
    [a setVelX:[a getVelX] - Nx * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [b getMass]/sumMass];
    [a setVelY:[a getVelY] - Ny * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [b getMass]/sumMass];
    
    [b setVelX:[b getVelX] + Nx * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [a getMass]/sumMass];
    [b setVelY:[b getVelY] + Ny * NVr / (pow(Nx,2)+pow(Ny,2)) * 2 * [a getMass]/sumMass];
    */

    
    
    
    // COLLISION SOLVE
    if (![a getMove]) {
        double dx = ([a getPosX] + [a getWidth]/2 - [b getPosX] - [b getWidth]/2)/[a getWidth];
        double dy = ([a getPosY] + [a getHeight]/2 - [b getPosY] - [b getHeight]/2)/[a getHeight];
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Side
        if (adx > ady) {
            [b setVelX:[b getVelX]*[b getElas]*-1];
            [b setPosX:[b getPosX]+adx];
        }
        // Top or bottom
        else {
            [b setVelY:[b getVelY]*[b getElas]*-1];
            [b setPosY:[b getPosY]+ady];
        }
        
        // No gravity sink
        [b setIgnoreNextUpdate:true];
    }
    if (![b getMove]) {
        double dx = ([a getPosX] + [a getWidth]/2 - [b getPosX] - [b getWidth]/2)/[b getWidth];
        double dy = ([a getPosY] + [a getHeight]/2 - [b getPosY] - [b getHeight]/2)/[b getHeight];
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Side
        if (adx > ady) {
            [a setVelX:[a getVelX]*[a getElas]*-1];
            [a setPosX:[a getPosX]+adx];
        }
        // Top or bottom
        else {
            [a setVelY:[a getVelY]*[a getElas]*-1];
            [a setPosY:[a getPosY]+ady];
        }
        
        // No gravity sink
        [a setIgnoreNextUpdate:true];
    }
    if ([a getMove] && [b getMove]) {
        // Get distance from midpoints
        double dx = [a getPosX] + [a getWidth]/2 - [b getPosX] - [b getWidth]/2;
        double dy = [a getPosY] + [a getHeight]/2 - [b getPosY] - [b getHeight]/2;
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Approaching from corner
        //if (fabs(adx - ady) < 0.1) {
            // TO BE IMPLEMENTED LATER
        //}
        // Approaching from sides
        if (adx > ady) {
            // a on the left
            /*if (dx < 0) {
                [a setVelX:fabs([a getVelX]*[a getElas])*-1];
                [b setVelX:fabs([b getVelX]*[b getElas])*1];
            }
            // a on the right
            else {
                [a setVelX:fabs([a getVelX]*[a getElas])*1];    
                [b setVelX:fabs([b getVelX]*[b getElas])*-1];
            }*/
            // Inelastic collision equation
            double Va = [a getVelX];
            double Vb = [b getVelX];
            
            // Va = E*Mb*(Vb-Va)+Ma*Va+Mb*Vb / Ma+Mb
            [a setVelX:([a getElas]*[b getMass]*(Vb-Va)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setVelX:([b getElas]*[a getMass]*(Va-Vb)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [a setPosX:[a getPosX]+adx/[b getWidth]];

        }
        // Approaching from top or bottom
        else {
            //[a setVelY:[a getVelY]*[a getElas]*-1];
            //[b setVelY:[b getVelY]*[b getElas]*-1];
            
            double Va = [a getVelY];
            double Vb = [b getVelY];
            
            [a setVelY:([a getElas]*[b getMass]*(Vb-Va)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setVelY:([b getElas]*[a getMass]*(Va-Vb)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [a setPosY:[a getPosY]+ady/[b getHeight]];

        }
    }
    
    if (fabs([a getVelX]) < 0.04) [a setVelX:0];
    if (fabs([a getVelY]) < 0.04) [a setVelY:0];
    if (fabs([b getVelX]) < 0.04) [b setVelX:0];
    if (fabs([b getVelY]) < 0.04) [b setVelY:0];
}

// Check for Rect v Circle collision
+(void) checkCollisionC:(RectangleShape*)a:(CircleShape *)b {
    // Rectangle vs Circle
    
    // COLLISION DETECT
    if ([a getPosX]>[b getPosX]+[b getRadius] || [a getPosX]+[a getWidth]<[b getPosX]-[b getRadius]) return;
    if ([a getPosY]+[a getHeight]<[b getPosY]-[b getRadius] || [a getPosY]>[b getPosY]+[b getRadius]) return;
    
    //double r = pow([b getRadius],2);
    
    
    // TO IMPLEMENT, CORNER DETECTION - Right now, circles are interpretted as rects
    //if (r > pow([b getPosX]-[a getPosX],2)+pow([b getPosY]-[a getPosY],2)) return;
    //if (r < pow([b getPosX]-[a getPosX]-[a getWidth],2)+pow([b getPosY]-[a getPosY],2)) return;
    //if (r < pow([b getPosX]-[a getPosX],2)+pow([b getPosY]-[a getPosY]-[a getHeight],2)) return;
    //if (r < pow([b getPosX]-[a getPosX]-[a getWidth],2)+pow([b getPosY]-[a getPosY]-[a getHeight],2)) return;

    
    //NSLog(@"Collision on Rect v Circle");
    
    
    // COLLISION SOLVE
    if (![a getMove]) {
        double dx = ([a getPosX] + [a getWidth]/2 - [b getPosX])/[a getWidth];
        double dy = ([a getPosY] + [a getHeight]/2 - [b getPosY])/[a getHeight];
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Side
        if (adx > ady)
            [b setVelX:[b getVelX]*[b getElas]*-1];
        // Top or bottom
        else
            [b setVelY:[b getVelY]*[b getElas]*-1];
        
        // No gravity sink
        [b setIgnoreNextUpdate:true];
    }
    if (![b getMove]) {
        double dx = ([a getPosX] + [a getWidth]/2 - [b getPosX])/[b getRadius]/2;
        double dy = ([a getPosY] + [a getHeight]/2 - [b getPosY])/[b getRadius]/2;
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Side
        if (adx > ady)
            [a setVelX:[a getVelX]*[a getElas]*-1];
        // Top or bottom
        else
            [a setVelY:[a getVelY]*[a getElas]*-1];
        
        // No gravity sink
        [a setIgnoreNextUpdate:true];
    }
    if ([a getMove] && [b getMove]) {
        // Get distance from midpoints
        double dx = [a getPosX] + [a getWidth]/2 - [b getPosX];
        double dy = [a getPosY] + [a getHeight]/2 - [b getPosY];
        double adx = fabs(dx);
        double ady = fabs(dy);
        
        // Approaching from corner
        //if (fabs(adx - ady) < 0.1) {
        // TO BE IMPLEMENTED LATER
        //}
        // Approaching from sides
        if (adx > ady) {
            // Inelastic collision equation
            double Va = [a getVelX];
            double Vb = [b getVelX];
            
            // Va = E*Mb*(Vb-Va)+Ma*Va+Mb*Vb / Ma+Mb
            [a setVelX:([a getElas]*[b getMass]*(Vb-Va)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setVelX:([b getElas]*[a getMass]*(Va-Vb)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setPosX:[b getPosX]+adx/[a getWidth]];
        }
        // Approaching from top or bottom
        else {
            double Va = [a getVelY];
            double Vb = [b getVelY];
            
            [a setVelY:([a getElas]*[b getMass]*(Vb-Va)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setVelY:([b getElas]*[a getMass]*(Va-Vb)+[a getMass]*Va+[b getMass]*Vb)/([a getMass]+[b getMass])];
            [b setPosY:[b getPosY]+ady/[a getHeight]];

        }
    }
    
    if (fabs([a getVelX]) < 0.04) [a setVelX:0];
    if (fabs([a getVelY]) < 0.04) [a setVelY:0];
    if (fabs([b getVelX]) < 0.04) [b setVelX:0];
    if (fabs([b getVelY]) < 0.04) [b setVelY:0];
    
    /*double Vrx = [a getVelX] - [b getVelX];
    double Vry = [a getVelY] - [b getVelY];
    double Nx = [a getPosX] - [b getPosX];
    double Ny = [a getPosY] - [b getPosY];
    double NVr = Nx * Vrx + Ny * Vry;
    
    [a setVelX:[a getVelX] - Nx * NVr / (pow(Nx,2)+pow(Ny,2))];
    [a setVelY:[a getVelY] - Ny * NVr / (pow(Nx,2)+pow(Ny,2))];
    
    [b setVelX:[b getVelX] + Nx * NVr / (pow(Nx,2)+pow(Ny,2))];
    [b setVelY:[b getVelY] + Ny * NVr / (pow(Nx,2)+pow(Ny,2))];*/
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
