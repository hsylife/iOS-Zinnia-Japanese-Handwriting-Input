//
//  Trainer.m
//  ZinniaCocoaTouch
//
//  Created by Morten Bertz on 5/15/15.
//  Copyright (c) 2015 Morten Bertz. All rights reserved.
//

#import "Trainer.h"
#import "zinnia.h"

#import "TargetConditionals.h"

#if TARGET_OS_IPHONE

#define valueWithPoint valueWithCGPoint
#define pointValue CGPointValue
@import UIKit;

#else


#endif


@interface CharacterStroke :NSObject

@property NSString *character;
@property CGSize size;
@property NSArray *strokes;

@end


@implementation CharacterStroke



@end



@implementation Trainer{
    zinnia_character_t *character;
    zinnia_trainer_t *trainer;
}

-(void)trainWithSEXPModels:(NSArray *)paths completion:(void (^)(BOOL, NSURL *))completion{
    
    NSMutableArray *characters=[NSMutableArray array];
    for (NSURL *path in paths) {
        NSArray *pathArray =[self strokesFromSEXP:path];
        [characters addObjectsFromArray:pathArray];
    }
  
    trainer=zinnia_trainer_new();
    character=zinnia_character_new();
    for (CharacterStroke *stroke in characters) {
        NSString *kanji=stroke.character;
        zinnia_character_set_value(character, [kanji cStringUsingEncoding:NSUTF8StringEncoding]);
        zinnia_character_set_width(character, stroke.size.width);
        zinnia_character_set_height(character, stroke.size.height);
        
        for (NSUInteger i=0; i<stroke.strokes.count; i++) {
            NSArray *singleStrokeArray=stroke.strokes[i];
            for (NSValue *strokeValue in singleStrokeArray) {
                CGPoint point=[strokeValue pointValue];
                zinnia_character_add(character, i, point.x, point.y);
            }
            
        }
        
        zinnia_trainer_add(trainer, character);
        zinnia_character_clear(character);
    }
    NSString *outputName=[[[paths.firstObject lastPathComponent]stringByDeletingPathExtension]stringByAppendingString:@"_model"];
    NSString *output=[[[paths.firstObject path]stringByDeletingLastPathComponent]stringByAppendingPathComponent:outputName];
    
    int returnvalue =zinnia_trainer_train(trainer, [output cStringUsingEncoding:NSUTF8StringEncoding]);
    
    if (returnvalue==1) {
        completion(YES,[NSURL fileURLWithPath:output]);
    }
    else{
        completion(NO,nil);
    }
    
   
}

-(void)dealloc{
    zinnia_character_destroy(character);
    zinnia_trainer_destroy(trainer);
}


-(NSArray*)strokesFromSEXP:(NSURL*)path{
    
   
    NSError *charactersError;
    NSString *characters=[NSString stringWithContentsOfFile:path.path encoding:NSUTF8StringEncoding error:&charactersError];
    NSScanner *reusableLineScanner=[[NSScanner alloc]initWithString:characters];
    NSMutableArray *array=[NSMutableArray array];
    while (!reusableLineScanner.isAtEnd) {
        NSString *line;
        NSMutableArray *strokes=[NSMutableArray array];
        if ([reusableLineScanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&line]) {
            NSString *value;
            NSScanner *detail=[[NSScanner alloc]initWithString:line];
            [detail scanUpToString:@"value" intoString:NULL];
            [detail scanString:@"value" intoString:NULL];
            [detail scanUpToString:@")" intoString:&value];
            NSInteger height;
            NSInteger width;
            [detail scanUpToString:@"width" intoString:NULL];
            [detail scanString:@"width" intoString:NULL];
            [detail scanInteger:&width];
            [detail scanUpToString:@"height" intoString:NULL];
            [detail scanString:@"height" intoString:NULL];
            [detail scanInteger:&height];
            [detail scanUpToString:@"strokes" intoString:NULL];
            NSString *stroke;
            [detail scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&stroke];
            NSScanner *strokeScanner=[[NSScanner alloc]initWithString:stroke];
            
            while (!strokeScanner.isAtEnd) {
                NSMutableArray *singleStrokeArray=[NSMutableArray array];
                NSString *singleStroke;
                [strokeScanner scanUpToString:@"((" intoString:NULL];
                if ( [strokeScanner scanUpToString:@"))" intoString:&singleStroke]) {
                    NSScanner *pointScanner=[[NSScanner alloc]initWithString:singleStroke];
                    NSCharacterSet *brackets=[NSCharacterSet characterSetWithCharactersInString:@"()"];
                    NSMutableCharacterSet *skip=[[NSCharacterSet whitespaceCharacterSet]mutableCopy];
                    [skip formUnionWithCharacterSet:brackets];
                    pointScanner.charactersToBeSkipped=skip;
                    while (!pointScanner.isAtEnd) {
                        double p1;
                        double p2;
                        [pointScanner scanDouble:&p1];
                        [pointScanner scanDouble:&p2];
                        CGPoint point=CGPointMake(p1, p2);
                        [singleStrokeArray addObject:[NSValue valueWithPoint:point]];
                    }
                    [strokes addObject:singleStrokeArray.copy];
                }
                
            }
            CharacterStroke *newCharacter=[CharacterStroke new];
            newCharacter.character=value;
            newCharacter.size=CGSizeMake(width, height);
            newCharacter.strokes=strokes;
            [array addObject:newCharacter];

        }
    }
    return array.copy;
}


@end
