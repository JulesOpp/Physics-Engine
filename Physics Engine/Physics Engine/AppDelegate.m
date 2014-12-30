//
//  AppDelegate.m
//  Physics Engine
//
//  Created by Jules on 12/26/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "AppView.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize numShape;

@synthesize xPosT;
@synthesize yPosT;
@synthesize xVelT;
@synthesize yVelT;

@synthesize color;

NSTimer *timer;
AppView *view;
double frameRate;
BOOL pausePlay;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    frameRate = 0.01;
    pausePlay = false;
    currentObject = 0;
    
    [self.window setFrame:CGRectMake(300, 200, 750, 500) display:YES];
    [self.window setStyleMask:[self.window styleMask] & ~NSResizableWindowMask];
    view = [[AppView alloc] initWithFr:_window.frame:frameRate];
    [view setFrameOrigin:NSMakePoint(0, 0)];
    [self.window.contentView addSubview:view];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:frameRate target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
    
    [numShape setStringValue:[NSString stringWithFormat:@"%i", view->numberShapes]];
    
    [xPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosX]]];
    [yPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosY]]];
    [xVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelX]]];
    [yVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelY]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xPosChange:) name:NSControlTextDidChangeNotification object:xPosT];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yPosChange:) name:NSControlTextDidChangeNotification object:yPosT];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xVelChange:) name:NSControlTextDidChangeNotification object:xVelT];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yVelChange:) name:NSControlTextDidChangeNotification object:yVelT];
    
    [color setColor:[NSColor blackColor]];
}

- (IBAction)refresh:(id)sender {
    [view setColor:[color color]];
    
    int temp = currentObject;
    currentObject = [view getCurrentObject];
    if ( temp != currentObject) {
        [xPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosX]]];
        [yPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosY]]];
        [xVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelX]]];
        [yVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelY]]];
   }   
    
    if (!pausePlay) [view setNeedsDisplay: true];
    
    //if (view->done == true) [self performSelectorOnMainThread:@selector(stopTimer) withObject:nil waitUntilDone:YES];
}

-(IBAction)pause:(id)sender { 
    pausePlay ^= 1; 
    view->pausePlay ^= 1; 
    [xPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosX]]];
    [yPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosY]]];
    [xVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelX]]];
    [yVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelY]]];
}

- (void)xPosChange:(NSNotification *)notification {
    [[view getObject:currentObject] setPosX:[xPosT.stringValue doubleValue]];
    [view setNeedsDisplay: true];
}
- (void)yPosChange:(NSNotification *)notification {
    [[view getObject:currentObject] setPosY:[yPosT.stringValue doubleValue]];
    [view setNeedsDisplay: true];
}
- (void)xVelChange:(NSNotification *)notification {
    [[view getObject:currentObject] setVelX:[xVelT.stringValue doubleValue]];
    [view setNeedsDisplay: true];
}
- (void)yVelChange:(NSNotification *)notification {
    [[view getObject:currentObject] setVelY:[yVelT.stringValue doubleValue]];
    [view setNeedsDisplay: true];
}

-(IBAction)applicationWillTerminate:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
