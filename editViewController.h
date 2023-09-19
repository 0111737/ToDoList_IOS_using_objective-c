//
//  editViewController.h
//  toDoList Workshop
//
//  Created by JETS Mobile Lab on 30/08/2023.
//

#import <UIKit/UIKit.h>
#import "todo.h"

NS_ASSUME_NONNULL_BEGIN

@interface editViewController : UIViewController
@property NSString *n;
@property NSString *d;
@property NSString *p;
@property NSString *s;
@property NSDate *dt;
@property todo *todo;
@property NSInteger index;

@property NSInteger tvc;



@property NSUserDefaults* defaults;
@property NSMutableArray <todo*> *todosArray;


@property todo* inProgressTodo;
@property todo* doneTodo;

//@property NSMutableArray <TodoModel*> *todosArray;
@property NSMutableArray <todo*> *doneArray;
@property NSMutableArray <todo*> *inProgressArray;


@end

NS_ASSUME_NONNULL_END
