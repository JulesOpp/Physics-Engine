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

NSTimer *timer;
AppView *view;
double frameRate;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    frameRate = 0.1;
    
    [self.window setFrame:CGRectMake(300, 200, 730, 420) display:YES];
    [self.window setStyleMask:[self.window styleMask] & ~NSResizableWindowMask];
    view = [[AppView alloc] initWithFrame:_window.frame];
    [view setFrameOrigin:NSMakePoint(0, 0)];
    [self.window.contentView addSubview:view];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:frameRate target:self selector:@selector(refresh:) userInfo:nil repeats:YES];
}

- (IBAction)refresh:(id)sender {
    NSLog(@"Hi");
    [view setNeedsDisplay: true];
    
    //if (view->done == true)
      //  [self performSelectorOnMainThread:@selector(stopTimer) withObject:nil waitUntilDone:YES];
}

@end
