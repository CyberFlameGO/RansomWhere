//
//  ErrorWindowController.h
//  BlockBlock
//
//  Created by Patrick Wardle on 1/26/15.
//  Copyright (c) 2015 Synack. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ErrorWindowController : NSWindowController <NSWindowDelegate>
{
    
}

//main msg in window
@property (weak) IBOutlet NSTextField *errMsg;

//sub msg in window
@property (weak) IBOutlet NSTextField *errSubMsg;

//info/help/fix button
@property (weak) IBOutlet NSButton *infoButton;

//close button
@property (weak) IBOutlet NSButton *closeButton;

//(optional) url for 'Info' button
@property(nonatomic, retain)NSURL* errorURL;

//flag indicating close button should exit app
@property BOOL shouldExit;

/* METHODS */

//configure the object/window
-(void)configure:(NSDictionary*)errorInfo;

//display (show) window
-(void)display;

@end
