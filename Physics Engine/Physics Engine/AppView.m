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

CoreShape *shapes[8];
int numberShapes;
double framerate;
int windowWidth;
int windowHeight;
BOOL pausePlay;
int currentObject;

// Initiate all parameters
- (id)initWithFr:(CGRect)frame:(double)fr
{
    self = [super initWithFrame:frame];
    if (self) {
        framerate = fr;
        numberShapes = 8;
        currentObject = 0;
        // [posX,posY,velX,velY,accX,accY,dragX,dragY,elas,fr,(shape dependent)]
        // Drag should be on the order of 0 - 0.3
        
		shapes[0] = [[RectangleShape alloc] init:50:400:20:0:0:-0.1:0.2:0.1:0:true:framerate:15:20];
		shapes[1] = [[RectangleShape alloc] init:70:400:20:0:0:-0.1:0.2:0.2:0:true:framerate:2:10];
		shapes[2] = [[RectangleShape alloc] init:90:400:20:0:0:-0.1:0.2:0.05:0:true:framerate:10:20];
		
		shapes[3] = [[CircleShape alloc] init:50:400:20:0:0:-0.1:0:0:0:true:framerate:5];
		shapes[4] = [[CircleShape alloc] init:80:350:40:20:0:-0.1:0.1:0.1:0:true:framerate:10];
        
        shapes[5] = [[RectangleShape alloc] init:20:50:0:0:0:0:0:0:0:false:framerate:700:10];
        shapes[6] = [[CircleShape alloc] init:400:300:0:0:0:0:0:0:0:false:framerate:15];
        
        shapes[7] = [[CircleShape alloc] init:600:300:-25:0:0:0:0:0:0:true:framerate:10];
        
        windowWidth = frame.size.width;
        windowHeight = frame.size.height;
        pausePlay = false;
    }
    return self;
}

// Main drawing functions - calls other drawers
-(void)drawRect:(NSRect)dirtyRect {
    if (pausePlay) {
        for (int i=0; i<numberShapes; i++)
            (i!=currentObject)?[shapes[i] draw: drawColor]:[shapes[i] draw:[NSColor blueColor]];
        return;
    }
    
    for (int i=0; i<numberShapes; i++) {
        (i!=currentObject)?[shapes[i] draw: drawColor]:[shapes[i] draw:[NSColor blueColor]];
        [shapes[i] update];
        
        for (int j=0; j<numberShapes; j++) {
            if (i == j) { }
            else if ([shapes[i] getType] == 1 && [shapes[j] getType] == 1)
                [RectangleShape checkCollisionR:(RectangleShape*)shapes[i] :(RectangleShape*)shapes[j]];
            else if ([shapes[i] getType] == 1 && [shapes[j] getType] == 2)
                [RectangleShape checkCollisionC:(RectangleShape*)shapes[i] :(CircleShape*)shapes[j]];
            else if ([shapes[i] getType] == 2 && [shapes[j] getType] == 1)
                [CircleShape checkCollisionR:(CircleShape*)shapes[i] :(RectangleShape*)shapes[j]];
            else if ([shapes[i] getType] == 2 && [shapes[j] getType] == 2)
                [CircleShape checkCollisionC:(CircleShape*)shapes[i] :(CircleShape*)shapes[j]];
        }
    }
}

// Debugging tool to log positions on the view
- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSLog(@"%f %f",point.x, point.y);
    
    if (!pausePlay) return;
    
    for (int i=0; i<numberShapes; i++) {
        if ([shapes[i] getType] == 1 && [RectangleShape checkCoord:(RectangleShape*)shapes[i]:point.x:point.y]) {
            NSLog(@"Object Rect");
            currentObject = i;
        }
        else if ([shapes[i] getType] == 2 && [CircleShape checkCoord:(CircleShape*)shapes[i] :point.x :point.y]) {
            NSLog(@"Object circle");
            currentObject = i;
        }
    }
}

-(CoreShape*) getObject: (int) i { return shapes[i]; }
-(int) getCurrentObject { return currentObject; }

-(void)setColor:(NSColor *)c {
    drawColor = c;
}

@end
