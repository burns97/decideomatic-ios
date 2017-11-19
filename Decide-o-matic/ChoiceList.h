//
//  ChoiceList.h
//  Decide-o-matic
//
//  Created by Matt Burns on 11/23/12.
//  Copyright (c) 2012 M@ Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Choice;

@interface ChoiceList : NSManagedObject

@property (nonatomic, retain) NSString * listName;
@property (nonatomic, retain) NSSet *hasValues;
@end

@interface ChoiceList (CoreDataGeneratedAccessors)

- (void)addHasValuesObject:(Choice *)value;
- (void)removeHasValuesObject:(Choice *)value;
- (void)addHasValues:(NSSet *)values;
- (void)removeHasValues:(NSSet *)values;

@end
