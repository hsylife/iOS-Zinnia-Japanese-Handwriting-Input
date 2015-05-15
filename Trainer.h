//
//  Trainer.h
//  ZinniaCocoaTouch
//
//  Created by Morten Bertz on 5/15/15.
//  Copyright (c) 2015 Morten Bertz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trainer : NSObject

-(void)trainWithSEXPModels:(NSArray *)paths completion:(void (^)(BOOL success, NSURL * outputpath))completion;

@end
