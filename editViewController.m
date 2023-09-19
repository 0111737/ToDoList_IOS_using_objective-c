//
//  editViewController.m
//  toDoList Workshop
//
//  Created by JETS Mobile Lab on 30/08/2023.
//

#import "editViewController.h"
#import "todo.h"

@interface editViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *descTextfield;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *state;
@property (weak, nonatomic) IBOutlet UIDatePicker *datee;

@end

@implementation editViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _todo=[todo new];
    
    _nameTextfield.text=_n;
    _todo.todoName=_n;
    
    _descTextfield.text=_d;
    _todo.todoDescription=_d;
    
    _datee.date=_dt;
    _todo.todoDate=_dt;
    
    if([_p  isEqual: @"low"]){
        _priority.selectedSegmentIndex = 0;
    }else if([_p isEqual: @"medium"]){
        _priority.selectedSegmentIndex = 1;
    }else if([_p isEqual: @"high"]){
        _priority.selectedSegmentIndex = 2;
    }
    _todo.todoPriority=_p;
    
    if([_s isEqual: @"todo"]){
        _state.selectedSegmentIndex = 0;
    }else if([_s isEqual: @"progress"]){
        _state.selectedSegmentIndex = 1;
    }else if([_s isEqual: @"done"]){
        _state.selectedSegmentIndex = 2;
    }
    _todo.todoStatus=_s;
    
    
    
    
   // _inProgressTodo =[todo new];
    //_doneTodo =[todo new];
    _defaults = [NSUserDefaults standardUserDefaults];
    NSError *error;
    
    NSData *tododata = [_defaults objectForKey:@"todoTasks" ];
    NSSet *todoset = [NSSet setWithArray:@[[NSArray class],[todo class]]];
    _todosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:todoset fromData:tododata error:&error];
    
    
    
    
    
    NSData *saveInProgressData = [_defaults objectForKey:@"ProgressTasks" ];
    NSSet *inProgressSet = [NSSet setWithArray:@[[NSArray class],[todo class]]];
    _inProgressArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:inProgressSet fromData:saveInProgressData error:&error];
    
    
    

    
    NSData *saveDoneData = [_defaults objectForKey:@"doneTasks" ];
    NSSet *doneSet = [NSSet setWithArray:@[[NSArray class],[todo class]]];
    _doneArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:doneSet fromData:saveDoneData error:&error];
    
    
    
    
    if(_todosArray == nil){
        _todosArray = [NSMutableArray new];
    }
    if(_inProgressArray == nil){
        _inProgressArray = [NSMutableArray new];
    }
    if(_doneArray == nil){
        _doneArray = [NSMutableArray new];
    }
    


}

- (IBAction)editButton:(id)sender {
    _todo.todoName=_nameTextfield.text;
    //NSLog(@"%@-----------------------------", _todo.todoName);
    _todo.todoDescription=_descTextfield.text;
    _todo.todoDate=_datee.date;
    
    if(_priority.selectedSegmentIndex==0){
        _todo.todoPriority = @"low";
    }
    else if(_priority.selectedSegmentIndex==1){
        _todo.todoPriority = @"medium";
    }
    else if(_priority.selectedSegmentIndex==2){
        _todo.todoPriority = @"high";
    }
    
    if(_state.selectedSegmentIndex==0){
        _todo.todoStatus = @"todo";
    }
    else if(_state.selectedSegmentIndex==1){
        _todo.todoStatus = @"progress";
    }
    else if(_state.selectedSegmentIndex==2){
        _todo.todoStatus = @"done";
        NSLog(@"%@", _todo.todoStatus);
    }
    if(_tvc==1){
        
        [self.todosArray removeObjectAtIndex:_index];
        
        NSError *error;
        NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self.todosArray requiringSecureCoding:YES error:&error];
        [self.defaults setObject:savedData forKey:@"todoTasks"];
        
        if([_todo.todoStatus isEqual:@"todo"]){
        
        [self.todosArray addObject:_todo];

        NSError *error;
        NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self.todosArray requiringSecureCoding:YES error:&error];
        [self.defaults setObject:savedData forKey:@"todoTasks"];
        
        
        }
        else  if([_todo.todoStatus isEqual:@"progress"]){
            
            [self.inProgressArray addObject:_todo];

            NSError *error;
            NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self.inProgressArray requiringSecureCoding:YES error:&error];
            [self.defaults setObject:savedData forKey:@"ProgressTasks"];
            
            
            }
        
        else  if([_todo.todoStatus isEqual:@"done"]){
            
            [self.doneArray addObject:_todo];

            NSError *error;
            NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self.doneTodo requiringSecureCoding:YES error:&error];
            [self.defaults setObject:savedData forKey:@"doneTasks"];
            
            
            }
     
        
    }
    else if(_tvc==2){
        if([_todo.todoStatus isEqual:@"todo"]){
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Wrong!" message:@"you can't return the inprogress task to todo list again !!" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction* oKAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:oKAction];
            [ self presentViewController:alert animated:YES completion:nil];
        }
        else if ([_todo.todoStatus isEqual:@"progress"]){
            
            [self.inProgressArray removeObjectAtIndex:_index];
            [self.inProgressArray addObject:_todo];

            NSError *error;
            NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self.inProgressArray requiringSecureCoding:YES error:&error];
            [self.defaults setObject:savedData forKey:@"ProgressTasks"];

        
        } else  if([_todo.todoStatus isEqual:@"done"]){
            
            [self.inProgressArray removeObjectAtIndex:_index];
            
            NSError *error;
            NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self.inProgressArray requiringSecureCoding:YES error:&error];
            [self.defaults setObject:savedData forKey:@"ProgressTasks"];
            
            [self.doneArray addObject:_todo];

            savedData = [NSKeyedArchiver archivedDataWithRootObject:self.doneTodo requiringSecureCoding:YES error:&error];
            [self.defaults setObject:savedData forKey:@"doneTasks"];
            
            
            }
            
    }else if(_tvc==3){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Wrong!" message:@"you can't edit the done tasks!!" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* oKAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        
        [alert addAction:oKAction];
        [ self presentViewController:alert animated:YES completion:nil];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
