//
//  AppDelegate.h
//  Physics Engine
//
//  Created by Jules on 12/26/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    @public
    AppView *view;
    
    int currentObject;
    
    @private
    BOOL pausePlay;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *numShape;

@property (assign) IBOutlet NSTextField *xPosT;
@property (assign) IBOutlet NSTextField *yPosT;
@property (assign) IBOutlet NSTextField *xVelT;
@property (assign) IBOutlet NSTextField *yVelT;

@property (assign) IBOutlet NSButton *pauseT;
@property (assign) IBOutlet NSColorWell *color;

- (IBAction)refresh:(id)sender;
-(IBAction)pause:(id)sender;

@end
