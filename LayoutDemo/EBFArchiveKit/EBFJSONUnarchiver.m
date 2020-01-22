//
//  EBFJSONUnarchiver.m
//  LayoutDemo
//
//  Created by Vitaly Dyachkov on 08/06/16.
//  Copyright © 2016 Vitaly Dyachkov. All rights reserved.
//

#import "EBFJSONUnarchiver.h"

NS_ASSUME_NONNULL_BEGIN

@interface EBFJSONUnarchiver ()

@property (nonatomic) NSDictionary *dictionary;
@property (nonatomic) NSMutableDictionary *classTranslationMapping;

@end

@implementation EBFJSONUnarchiver

- (instancetype)initForReadingWithData:(NSData *)data {
    self = [super init];
    if (self) {
        // TODO: Check for parsing error
        _dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _classTranslationMapping = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setClass:(nullable Class)class forClassName:(NSString *)className {
    self.classTranslationMapping[className] = class;
}

- (nullable Class)classForClassName:(NSString *)className {
    return self.classTranslationMapping[className];
}

- (nullable id)unarchiveRootObjectWithParentObject:(nullable id)parentObject {
    NSString *className = [self.dictionary objectForKey:@"class"];
    Class class = self.classTranslationMapping[className];
    if (!class) {
        class = NSClassFromString(className);
    }
    
    if (![class instancesRespondToSelector:@selector(initWithCoder:parentObject:)]) {
        return nil;
    }
    
    id <EBFTreeCoding> decodedObject = [[class alloc] initWithCoder:self parentObject:parentObject];
    
    if ([decodedObject respondsToSelector:@selector(awakeAfterUsingCoder:parentObject:)]) {
        [decodedObject awakeAfterUsingCoder:self parentObject:parentObject];
    }
    
    return decodedObject;
}

- (nullable id)unarchiveRootObject {
    return [self unarchiveRootObjectWithParentObject:nil];
}

- (nullable id)decodeObjectForKey:(NSString *)key parentObject:(nonnull id)parentObject {
    NSDictionary *subdictionary = self.dictionary[key];
    if (subdictionary && [subdictionary isKindOfClass:[NSDictionary class]]) {
        id object = nil;
        
        NSDictionary *dictionary = self.dictionary;
        self.dictionary = subdictionary;
        object = [self unarchiveRootObjectWithParentObject:parentObject];
        self.dictionary = dictionary;
        
        return object;
    }
    
    return nil;
}

- (nullable NSArray *)decodeObjectsForKey:(NSString *)key parentObject:(nonnull id)parentObject{
    NSArray *subdictionaries = self.dictionary[key];
    if (subdictionaries && [subdictionaries isKindOfClass:[NSArray class]]) {
        NSMutableArray *objects = [[NSMutableArray alloc] init];
        
        NSDictionary *dictionary = self.dictionary;
        for (NSDictionary *subdictionary in self.dictionary[key]) {
            self.dictionary = subdictionary;
            id object = [self unarchiveRootObjectWithParentObject:parentObject];
            [objects addObject:object];
        }
        self.dictionary = dictionary;
        
        return [objects copy];
    }
    
    return nil;
}

- (NSString *)decodeStringForKey:(NSString *)key {
    id object = self.dictionary[key];
    if ([object isKindOfClass:[NSString class]]) {
        return (NSString *)object;
    }
    return nil;
}

- (NSNumber *)decodeNumberForKey:(NSString *)key {
    id object = self.dictionary[key];
    if ([object isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)object;
    }
    return nil;
}

- (NSInteger)decodeIntegerForKey:(NSString *)key {
    NSNumber *number = [self decodeNumberForKey:key];
    if (number) {
        return [number integerValue];
    }
    
    return NSNotFound;
}

@end

NS_ASSUME_NONNULL_END
