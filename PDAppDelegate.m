//
//  PDAppDelegate.m
//  PagesDemo
//
//  Created by Josh Abernathy on 12/6/10.
//  Copyright 2010 Maybe Apps, LLC. All rights reserved.
//

#import "PDAppDelegate.h"
#import "PDCoolWindowController.h"
#import "JAAnimatingContainer.h"


@implementation PDAppDelegate


#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [self.window makeKeyAndOrderFront:nil];
    
    PDCoolWindowController *windowController = [PDCoolWindowController defaultWindowController];
    NSView *view = [[windowController window] contentView];
    NSImage *image = [[NSImage alloc] initWithData:[view dataWithPDFInsideRect:[view bounds]]];
    self.imageView.image = image;
}


#pragma mark API

@synthesize window;
@synthesize imageView;

- (IBAction)createNewDocument:(id)sender {
    PDCoolWindowController *windowController = [PDCoolWindowController defaultWindowController];
    
    NSDisableScreenUpdates();
    [windowController.window makeKeyAndOrderFront:nil];
    JAAnimatingContainer *container = [JAAnimatingContainer containerFromWindow:windowController.window];
    [windowController.window orderOut:nil];
    NSEnableScreenUpdates();
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    container.animationLayer.contentsGravity = kCAGravityResizeAspect;
    container.animationLayer.bounds = CGRectMake(0.0f, 0.0f, self.imageView.bounds.size.width, self.imageView.bounds.size.height);
    NSPoint originalOrigin = [self.imageView.window convertBaseToScreen:[self.imageView convertPoint:self.imageView.bounds.origin toView:nil]];
    container.animationLayer.position = CGPointMake(originalOrigin.x + self.imageView.bounds.size.width/2, originalOrigin.y + self.imageView.bounds.size.height/2);
    [CATransaction commit];
    
    [container swapViewWithContainer];
    
    container.didFinishBlock = ^(JAAnimatingContainer *currentContainer, CAAnimation *animation) {
        PDCoolWindowController *windowController = [PDCoolWindowController defaultWindowController];
        
        [windowController.window setFrameOrigin:NSMakePoint(currentContainer.animationLayer.position.x - windowController.window.frame.size.width/2, currentContainer.animationLayer.position.y - windowController.window.frame.size.height/2)];
        
        NSDisableScreenUpdates();
        [currentContainer swapContainerWithView];
        [windowController.window makeKeyAndOrderFront:nil];
        [windowController.window display];
        NSEnableScreenUpdates();
    };
    
    const CFTimeInterval duration = ([self.window currentEvent].modifierFlags & NSShiftKeyMask) ? 10.0f : 0.33f;
    
    CABasicAnimation *zoomAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomAnimation.toValue = [NSValue valueWithPoint:NSMakePoint(windowController.window.frame.size.width / self.imageView.bounds.size.width, windowController.window.frame.size.height / self.imageView.bounds.size.height)];
    zoomAnimation.fillMode = kCAFillModeForwards;
    zoomAnimation.removedOnCompletion = NO;
    zoomAnimation.duration = duration;
    
    [container startAnimation:zoomAnimation];
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:duration];
    [[self.window animator] setAlphaValue:0.0f];
    [NSAnimationContext endGrouping];
}

@end
