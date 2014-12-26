//
//  AppView.m
//  Physics Engine
//
//  Created by Jules on 12/26/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

// I use the struct Rect - instead of {top,left,bottom,right}, I use {height,x,y,width}

#import "AppView.h"

@implementation AppView

struct circle {
double x;
double y;
double r;
};

// Initiate all parameters
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Main drawing functions - calls other drawers
-(void)drawRect:(NSRect)dirtyRect {
    struct circle circle1 = {50,60,10};
    [self drawCircle:dirtyRect :circle1];
    
    Rect rect1 = {30,10,10,20};
    [self drawRectangle:dirtyRect :rect1];
}

// Draws rectangle
-(void)drawRectangle:(NSRect)aRect:(Rect)bRect {
    NSRectFill(CGRectMake(bRect.left, bRect.bottom, bRect.right, bRect.top));
}

// Draws circle
-(void)drawCircle:(NSRect)aRect:(struct circle)bRect {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];    
    CGContextFillEllipseInRect(context, CGRectMake(bRect.x-bRect.r, bRect.y-bRect.r, 2*bRect.r, 2*bRect.r));
    
}

// Debugging tool to log positions on the view
- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSLog(@"%f %f",point.x, point.y);
    [self display];
}

@end
