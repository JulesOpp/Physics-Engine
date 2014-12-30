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

@synthesize window = _window; // The main window
@synthesize numShape; // The number of objects currently

// The physics of the selected object
@synthesize xPosT;
@synthesize yPosT;
@synthesize xVelT;
@synthesize yVelT;

@synthesize pauseT; // The text of the pause button
@synthesize color; // Reference to the color well

NSTimer *timer; // Timer running telling the engine to update
AppView *view; // Reference to the AppView
double frameRate; // The frameRate is what the timer is based upon
BOOL pausePlay; // Boolean determining whether paused or not


// Run when application opens
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    frameRate = 0.01;
    pausePlay = false;
    currentObject = 0;
    
    // Create the main window
    [self.window setFrame:CGRectMake(300, 200, 750, 500) display:YES];
    [self.window setStyleMask:[self.window styleMask] & ~NSResizableWindowMask];
    view = [[AppView alloc] initWithFr:_window.frame:frameRate];
    [view setFrameOrigin:NSMakePoint(0, 0)];
    [self.window.contentView addSubview:view];
    
    // Set the timer
    timer = [NSTimer scheduledTimerWithTimeInterval:frameRate target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
    
    // Get the number of shapes - will be changed when becomes dynamic
    [numShape setStringValue:[NSString stringWithFormat:@"%i", view->numberShapes]];
    
    // Set the initial physics in the child window
    [xPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosX]]];
    [yPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosY]]];
    [xVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelX]]];
    [yVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelY]]];
    
    // Observers to determine when the text boxes changed, so the physics can change
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xPosChange:) name:NSControlTextDidChangeNotification object:xPosT];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yPosChange:) name:NSControlTextDidChangeNotification object:yPosT];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xVelChange:) name:NSControlTextDidChangeNotification object:xVelT];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yVelChange:) name:NSControlTextDidChangeNotification object:yVelT];
    
    // Initial color black
    [color setColor:[NSColor blackColor]];
}


// All the actions when the timer is called
- (IBAction)refresh:(id)sender {
    // Check color
    [view setColor:[color color]];
    
    // If the current object changed or in play mode, update text boxes
    int temp = currentObject;
    currentObject = [view getCurrentObject];
    if ( temp != currentObject || !pausePlay) {
        [xPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosX]]];
        [yPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosY]]];
        [xVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelX]]];
        [yVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelY]]];
   }   
    
    // Call drawRect in the view
    [view setNeedsDisplay: true];
    
    // To be done later maybe - if done, stop timer
    //if (view->done == true) [self performSelectorOnMainThread:@selector(stopTimer) withObject:nil waitUntilDone:YES];
}


// Method controlling the pause button
-(IBAction)pause:(id)sender {
    // There is a pausePlay for the AppDelegate and the AppView, maybe redundant w/e
    pausePlay ^= 1; 
    view->pausePlay ^= 1; 
    
    // Update the text
    ([pauseT.title isEqualToString:@"Pause"])?[pauseT setTitle:@"Play"]:[pauseT setTitle:@"Pause"];
    
    // This updates the physics boxes, but isn't necessary any more
    /*[xPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosX]]];
    [yPosT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getPosY]]];
    [xVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelX]]];
    [yVelT setStringValue:[NSString stringWithFormat:@"%f", [[view getObject:currentObject] getVelY]]];*/
}

// If any of the text boxes are written in, change the physics
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

// Remove memory leaks on the text box observers - I don't know if this works
-(IBAction)applicationWillTerminate:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
