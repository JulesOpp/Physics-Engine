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

CoreShape *shapes[7];
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
        numberShapes = 7;
        // [posX,posY,velX,velY,accX,accY,dragX,dragY,elas,fr,(shape dependent)]
        // Drag should be on the order of 0 - 0.3
        
		shapes[0] = [[RectangleShape alloc] init:50:400:20:0:0:-0.1:0.2:0.1:0:true:framerate:15:20];
		shapes[1] = [[RectangleShape alloc] init:70:400:20:0:0:-0.1:0.2:0.2:0:true:framerate:2:10];
		shapes[2] = [[RectangleShape alloc] init:90:400:20:0:0:-0.1:0.2:0.05:0:true:framerate:10:20];
		
		shapes[3] = [[CircleShape alloc] init:50:400:20:0:0:-0.1:0:0:0:true:framerate:5];
		shapes[4] = [[CircleShape alloc] init:80:350:40:20:0:-0.1:0.1:0.1:0:true:framerate:10];
        
        shapes[5] = [[RectangleShape alloc] init:20:50:0:0:0:0:0:0:0:false:framerate:700:10];
        shapes[6] = [[CircleShape alloc] init:400:300:0:0:0:0:0:0:0:false:framerate:15];
        
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
        
        // IGNORE THE WARNING, I KNOW WHAT IM DOING
        for (int j=0; j<numberShapes; j++) {
            if (i == j) { }
            else if ([shapes[i] getType] == 1 && [shapes[j] getType] == 1)
                [RectangleShape checkCollisionR:shapes[i] :shapes[j]];
            else if ([shapes[i] getType] == 1 && [shapes[j] getType] == 2)
                [RectangleShape checkCollisionC:shapes[i] :shapes[j]];
            else if ([shapes[i] getType] == 2 && [shapes[j] getType] == 1)
                [CircleShape checkCollisionR:shapes[i] :shapes[j]];
            else if ([shapes[i] getType] == 2 && [shapes[j] getType] == 2)
                [CircleShape checkCollisionC:shapes[i] :shapes[j]];
        }
    }
}

// Debugging tool to log positions on the view
- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSLog(@"%f %f",point.x, point.y);
    [self display];
}

@end
