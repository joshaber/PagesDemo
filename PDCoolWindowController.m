//
//  PDCoolWindowController.m
//  PagesDemo
//
//  Created by Josh Abernathy on 12/6/10.
//  Copyright 2010 Maybe Apps, LLC. All rights reserved.
//

#import "PDCoolWindowController.h"


@implementation PDCoolWindowController


#pragma mark API

+ (PDCoolWindowController *)defaultWindowController {
    return [[[self alloc] initWithWindowNibName:NSStringFromClass(self)] autorelease];
}

@end
