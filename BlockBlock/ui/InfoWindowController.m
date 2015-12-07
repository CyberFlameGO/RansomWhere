//
//  PrefsWindowController.m
//  KnockKnock
//
//  Created by Patrick Wardle on 2/6/15.
//  Copyright (c) 2015 Objective-See, LLC. All rights reserved.
//

#import "Consts.h"
#import "Logging.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "InfoWindowController.h"


@implementation InfoWindowController

@synthesize infoLabel;
@synthesize overlayView;
@synthesize firstButton;
@synthesize actionButton;
@synthesize infoLabelString;
@synthesize actionButtonTitle;
@synthesize progressIndicator;


//automatically called when nib is loaded
// ->center window
-(void)awakeFromNib
{
    //center
    [self.window center];
    
    return;
}

//automatically invoked when window is loaded
// ->set to white
-(void)windowDidLoad
{
    //super
    [super windowDidLoad];
    
    //make white
    [self.window setBackgroundColor: NSColor.whiteColor];
    
    //set main label
    [self.infoLabel setStringValue:self.infoLabelString];
    
    //set button text
    self.actionButton.title = self.actionButtonTitle;

    //hide first button when action is 'update'
    // ->don't need update check button ;)
    if(YES == [self.actionButton.title isEqualToString:@"update"])
    {
        //hide
        self.firstButton.hidden = YES;
    }
    
    //make it key window
    [self.window makeKeyAndOrderFront:self];
    
    //make window front
    [NSApp activateIgnoringOtherApps:YES];
    
    return;
}

//save the main label's & button title's text
// ->invoked before window is loaded (and thus buttons, etc are nil)
-(void)configure:(NSString*)label buttonTitle:(NSString*)buttonTitle
{
    //save label's string
    self.infoLabelString = label;
    
    //save button's title
    self.actionButtonTitle = buttonTitle;
    
    return;
}

//invoked when user clicks 'check for updates' button
// ->invoke method on app delegate that checks/displays result
-(IBAction)updateBtnHandler:(id)sender
{
    //version string
    NSMutableString* versionString = nil;
    
    //version flag
    __block NSInteger versionFlag = -1;
    
    //alloc string
    versionString = [NSMutableString string];
    
    //pre-req
    [self.overlayView setWantsLayer:YES];
    
    //set overlay's view color to black
    self.overlayView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    //make it semi-transparent
    self.overlayView.alphaValue = 0.75;
    
    //show it
    self.overlayView.hidden = NO;
    
    //disable 'update' check button
    ((NSButton*)sender).enabled = NO;
    
    //disable close button
    self.actionButton.enabled = NO;
    
    //remove detailed textz
    self.infoLabel.stringValue = @"";
    
    //show spinner
    self.progressIndicator.hidden = NO;
    
    //animate it
    [self.progressIndicator startAnimation:nil];
    
    //delay so UI shows spinner, etc
    // ->then process version logic
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        //get version flag
        versionFlag = isNewVersion(versionString);
        
        //run on main thread for UI updates, etc
        dispatch_sync(dispatch_get_main_queue(), ^{
            
        //hide spinner
        self.progressIndicator.hidden = YES;
        
        //hide overlay
        self.overlayView.hidden = YES;
        
        //take action based on version
        // ->show error, new version msg, etc
        switch(versionFlag)
        {
            //error
            // ->show err msg
            case -1:
                
                //red for error
                self.infoLabel.textColor = [NSColor redColor];
                
                //set label
                self.infoLabel.stringValue = @"error, update check failed :(";
                
                //set button title
                self.actionButton.title = @"close";
                
                break;
                
            //new version
            case YES:
                
                //set label
                self.infoLabel.stringValue = [NSString stringWithFormat:@"a new version (%@) is available!", versionString];
                
                //set button title
                self.actionButton.title = @"update";
                
                break;
                
            //no new version
            case NO:
                
                //set label
                // ->versions should be the same, but we'll use getAppVersion() (since beta's might be newer than what's live)
                self.infoLabel.stringValue = [NSString stringWithFormat:@"your version, (%@), is current", getAppVersion()];
                
                //set button title
                self.actionButton.title = @"close";
                
                break;
                
            default:
                
                break;
        }
            
        //always enable action button
        self.actionButton.enabled = YES;
        
        }); //dispatch on main thread
        
    }); //dispatch for delay
    
    return;
}

//invoked when user clicks button
// ->trigger action such as opening product website, updating, etc
-(IBAction)buttonHandler:(id)sender
{
    //handle 'update' / 'more info', etc
    // ->open BB's webpage
    if(YES != [((NSButton*)sender).title isEqualToString:@"close"])
    {
        //open URL
        // ->invokes user's default browser
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:PRODUCT_URL]];
    }
    
    //always close window
    [[self window] close];
        
    return;
}
@end
