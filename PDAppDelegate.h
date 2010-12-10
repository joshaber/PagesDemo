//
//  PDAppDelegate.h
//  PagesDemo
//
//  Created by Josh Abernathy on 12/6/10.
//  Copyright 2010 Maybe Apps, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PDAppDelegate : NSObject <NSApplicationDelegate> {
    CGImageRef currentImage;
}

- (IBAction)createNewDocument:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSImageView *imageView;

@end
