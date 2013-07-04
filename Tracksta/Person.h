//
//  Person.h
//  Tracksta
//
//  Created by RAGHAV  on 04/07/13.
//  Copyright (c) 2013 RAGHAV . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *homeEmail;
@property (nonatomic, strong) NSString *workEmail;
@end
