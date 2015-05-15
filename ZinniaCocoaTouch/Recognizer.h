//
//  Zinnia.h
//  ZinniaSample
//
//  Created by Watanabe Toshinori on 10/12/27.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TargetConditionals.h"

#if TARGET_OS_IPHONE
@import UIKit;

#define valueWithPoint valueWithCGPoint
#define pointValue CGPointValue

#define VIEW UIView

#else

#define VIEW NSView

#import <AppKit/AppKit.h>
#endif







@interface Recognizer : NSObject

@property NSUInteger count;
@property (nonatomic) CGSize canvasSize;



- (instancetype)initWithCanvas:(VIEW*)canvas;

- (NSArray *)classify:(NSArray *)points;
- (void)clear;



@end
