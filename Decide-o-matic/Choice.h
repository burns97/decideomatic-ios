//
//  Choice.h
//  Decide-o-matic
//
//  Created by Matt Burns on 11/23/12.
//  Copyright (c) 2012 M@ Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Choice : NSManagedObject

@property (nonatomic, retain) NSString * choiceName;
@property (nonatomic, retain) NSManagedObject *partOf;

@end
