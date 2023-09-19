//
//  todo.h
//  toDoList Workshop
//
//  Created by JETS Mobile Lab on 30/08/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface todo : NSObject<NSCoding,NSSecureCoding>
@property NSString* todoName;
@property NSString* todoDescription;
@property NSString* todoPriority;
@property NSString* todoStatus;
@property NSDate* todoDate;


@end

NS_ASSUME_NONNULL_END
