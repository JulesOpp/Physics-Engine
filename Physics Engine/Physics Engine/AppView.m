//
//  AppView.m
//  Physics Engine
//
//  Created by Jules on 12/26/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "AppView.h"
#import "CoreShape.h"
#import "RectangleShape.h"
#import "CircleShape.h"

@implementation AppView

struct circle {
double x;
double y;
double r;
};

CoreShape *shapes[6];
int numberShapes;
double framerate;
int windowWidth;
int windowHeight;


// Initiate all parameters
- (id)initWithFr:(CGRect)frame:(double)fr
{
    self = [super initWithFrame:frame];
    if (self) {
        framerate = fr;
        numberShapes = 6;
        // [posX,posY,velX,velY,accX,accY,dragX,dragY,elas,fr,(shape dependent)]
        // Drag should be on the order of 0 - 0.3
        
		shapes[0] = [[RectangleShape alloc] init:50:400:20:0:0:-0.1:0.2:0.1:0:true:framerate:10:20];
		shapes[1] = [[RectangleShape alloc] init:70:400:20:0:0:-0.1:0.2:0.2:0:true:framerate:10:20];
		shapes[2] = [[RectangleShape alloc] init:90:400:20:0:0:-0.1:0.2:0.05:0:true:framerate:10:20];
		
		shapes[3] = [[CircleShape alloc] init:50:400:20:0:0:-0.1:0:0:0:true:framerate:5];
		shapes[4] = [[CircleShape alloc] init:110:350:40:20:0:-0.1:0.1:0.1:0:true:framerate:10];
        
        shapes[5] = [[RectangleShape alloc] init:20:50:0:0:0:0:0:0:0:false:framerate:700:10];
        
        windowWidth = frame.size.width;
        windowHeight = frame.size.height;
    }
    return self;
}

// Main drawing functions - calls other drawers
-(void)drawRect:(NSRect)dirtyRect {
    for (int i=0; i<numberShapes; i++) {
        [shapes[i] draw];
        [shapes[i] update];
        
        // TO BE IMPLEMENTED
        for (int j=0; j<numberShapes; j++) {
            // [shapes[i] checkCollision: shapes[j]];
        }
    }
}

// Check if two rectangles collide
-(BOOL)collideRect: (Rect)aRect: (Rect)bRect {
    if (aRect.left > bRect.right || aRect.right < bRect.left) return false;
    if (aRect.top < bRect.bottom || aRect.bottom > bRect.top) return false;
    return true;
}

// Check if two circles collide
-(BOOL)collideCircle: (struct circle)a: (struct circle)b {
    double r = a.r + b.r;
    r *= r;
    return r > pow(a.x - b.x,2) + pow(a.y - b.y,2);
}

// Debugging tool to log positions on the view
- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSLog(@"%f %f",point.x, point.y);
    [self display];
}

@end
