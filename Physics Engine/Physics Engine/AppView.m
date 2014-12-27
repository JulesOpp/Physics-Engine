//
//  AppView.m
//  Physics Engine
//
//  Created by Jules on 12/26/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "AppView.h"
#import "CoreShape.h"

@implementation AppView

struct circle {
double x;
double y;
double r;
};

CoreShape *shapes[2];
int numberShapes;


// Initiate all parameters
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        numberShapes = 0;
        for (int i=0; i<2; i++) {
            shapes[i] = [[CoreShape alloc] init];
            numberShapes++;
        }
        
    }
    return self;
}

// Main drawing functions - calls other drawers
-(void)drawRect:(NSRect)dirtyRect {
    for (int i=0; i<2; i++) {
        // Draw shapes
    }
    
    
    /*struct circle circle1 = {50,60,10};
    struct circle circle2 = {62,70,5};
    [self drawCircle:dirtyRect :circle1];
    [self drawCircle:dirtyRect :circle2];
    if ([self collideCircle:circle1 :circle2]) NSLog(@"Collide");
    
    Rect rect1 = {40,10,10,30};
    Rect rect2 = {60,10,50,30};
    if ([self collideRect:rect1 :rect2]) NSLog(@"Collide");
    [self drawRectangle:dirtyRect :rect1];
    [self drawRectangle:dirtyRect :rect2];*/
}

// Draws rectangle
-(void)drawRectangle:(NSRect)aRect:(Rect)bRect {
    NSRectFill(CGRectMake(bRect.left, bRect.bottom, bRect.right-bRect.left, bRect.top-bRect.bottom));
}

// Draws circle
-(void)drawCircle:(NSRect)aRect:(struct circle)bRect {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];    
    CGContextFillEllipseInRect(context, CGRectMake(bRect.x-bRect.r, bRect.y-bRect.r, 2*bRect.r, 2*bRect.r));
    
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
