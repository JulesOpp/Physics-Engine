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

CoreShape *shapes[10];   // Storage of all the shapes
int numberShapes;       // The number of shapes
double framerate;       // The number of seconds/frame
int windowWidth;        // Width of main window - not utilized
int windowHeight;       // Height of main window - not utilized
BOOL pausePlay;         // Whether paused or play
int currentObject;      // Currently selected object

BOOL isDrawingArrow;    // State of arrow
NSBezierPath * path;    // Arrow
double arrowXi;
double arrowYi;
double arrowXf;
double arrowYf;

// Initiate all parameters
- (id)initWithFr:(CGRect)frame:(double)fr {
    self = [super initWithFrame:frame];
    if (self) {
        framerate = fr;
        numberShapes = 10;
        currentObject = 0;
        isDrawingArrow = false;
        
        // [posX,posY,velX,velY,accX,accY,dragX,dragY,elas,mass,canMove,fr,(shape dependent)]
        // Drag should be on the order of 0 - 0.3
        // Coefficient of Restitution - elasticity - must be 0-1
        
		shapes[0] = [[RectangleShape alloc] init:374:320:0:0:0:0:0.2:0.1:1:1:true:15:20];
		shapes[1] = [[RectangleShape alloc] init:70:400:20:0:0:0:0.2:0.2:1:1:true:10:10];
		shapes[2] = [[RectangleShape alloc] init:200:400:20:0:0:0:0.2:0.05:1:1:true:10:20];
		
		shapes[3] = [[CircleShape alloc] init:80:400:20:0:0:0:0:0:1:1:true:5];
		shapes[4] = [[CircleShape alloc] init:400:400:210:0:0:0:0.1:0:1:1:true:10];
        
        shapes[5] = [[RectangleShape alloc] init:20:50:0:0:0:0:0:0:1:100:false:700:10];
        //shapes[6] = [[RectangleShape alloc] init:370:50:0:0:0:0:0:0:1:100:false:350:10];
        shapes[6] = [[CircleShape alloc] init:400:300:0:0:0:0:0:0:1:100:false:15];
        
        shapes[7] = [[CircleShape alloc] init:470:450:-20:0:0:0:0:0:1:1:true:10];
        
        shapes[8] = [[RectangleShape alloc] init:370:400:-20:0:0:0:0.2:0.05:1:1:true:10:20];
        
        shapes[9] = [[RectangleShape alloc] init:150:80:0:0:0:0:0:0:1:1:true:20:20];
        
        [(RectangleShape*)shapes[0] setAngle: 45];
        [(RectangleShape*)shapes[0] setRotation:1];
        
        windowWidth = frame.size.width;
        windowHeight = frame.size.height;
        pausePlay = false;
    }
    return self;
}


// Main drawing functions - calls other drawers
-(void)drawRect:(NSRect)dirtyRect {
    // Don't update if paused
    
    if (pausePlay)
        for (int i=0; i<numberShapes; i++)
            (i!=currentObject)?[shapes[i] draw: drawColor]:[shapes[i] draw:[NSColor blueColor]];
    else
        for (int i=0; i<numberShapes; i++) {
            // Update, draw, collision manage
            [shapes[i] update];
            
            (i!=currentObject)?[shapes[i] draw: drawColor]:[shapes[i] draw:[NSColor blueColor]];
            
            for (int j=i; j<numberShapes; j++)
                if (i == j) { }
                else if ([shapes[i] getType] == 1 && [shapes[j] getType] == 1)
                    [RectangleShape checkCollisionR:(RectangleShape*)shapes[i] :(RectangleShape*)shapes[j]];
                else if ([shapes[i] getType] == 1 && [shapes[j] getType] == 2)
                    [RectangleShape checkCollisionC:(RectangleShape*)shapes[i] :(CircleShape*)shapes[j]];
                else if ([shapes[i] getType] == 2 && [shapes[j] getType] == 1)
                    [RectangleShape checkCollisionC:(RectangleShape*)shapes[j] :(CircleShape*)shapes[i]];
                else if ([shapes[i] getType] == 2 && [shapes[j] getType] == 2)
                    [CircleShape checkCollisionC:(CircleShape*)shapes[i] :(CircleShape*)shapes[j]];            
        }
    if (isDrawingArrow) {
        NSLog(@"Draw");
        
        path = [NSBezierPath bezierPath];
        [path moveToPoint:CGPointMake(arrowXi, arrowYi)];
        [path lineToPoint:CGPointMake(arrowXf, arrowYf)];
        [path setLineWidth: 4];
        
        [[NSColor whiteColor] set];
        [path fill];
        
        [[NSColor grayColor] set]; 
        [path stroke];
    }
}

// Debugging tool to log positions on the view and select current object
- (void)mouseDown:(NSEvent *)theEvent {
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSLog(@"%f %f",point.x, point.y);
    
    isDrawingArrow = true;
    NSLog(@"Down");
    arrowXi = point.x;
    arrowYi = point.y;
    arrowXf = point.x;
    arrowYf = point.y;
    
    if (!pausePlay) return;
    
    // If playing change current objects
    for (int i=0; i<numberShapes; i++)
        if ([shapes[i] getType] == 1 && [RectangleShape checkCoord:(RectangleShape*)shapes[i]:point.x:point.y]) {
            NSLog(@"Object Rect %d",i);
            currentObject = i;
        }
        else if ([shapes[i] getType] == 2 && [CircleShape checkCoord:(CircleShape*)shapes[i] :point.x :point.y]) {
            NSLog(@"Object circle %d",i);
            currentObject = i;
        }
}

-(void)mouseDragged:(NSEvent *)theEvent {
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    arrowXf = point.x;
    arrowYf = point.y;
}

-(void)mouseUp:(NSEvent *)theEvent {
    isDrawingArrow = false;
    NSLog(@"Up");
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    arrowXf = point.x;
    arrowYf = point.y;
    
    // UPDATE VELOCITY VECTOR
    [shapes[currentObject] setVelX:arrowXf-arrowXi];
    [shapes[currentObject] setVelY:arrowYf-arrowYi];
}

// Current object management
-(CoreShape*) getObject: (int) i { return shapes[i]; }
-(int) getCurrentObject { return currentObject; }

// Color management
-(void)setColor:(NSColor *)c { drawColor = c; }

+(int) getWidth { return windowWidth; }
+(int) getHeight { return windowHeight; }

@end
