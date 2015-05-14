//
//  Zinnia.h
//  ZinniaSample
//
//  Created by Watanabe Toshinori on 10/12/27.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface Recognizer : NSObject

@property NSUInteger count;
@property (nonatomic) CGSize canvasSize;


@property (nonatomic) CGSize canvasSize;


- (instancetype)initWithCanvas:(UIView *)canvas;
- (NSArray *)classify:(NSArray *)points;
- (void)clear;



@end
