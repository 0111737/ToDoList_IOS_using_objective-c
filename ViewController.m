//
//  ViewController.m
//  toDoList Workshop
//
//  Created by JETS Mobile Lab on 30/08/2023.
//

#import "ViewController.h"
#import "todo.h"
#import "firstTableViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *descTextfield;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePick;



@property NSUserDefaults* defaults; 
@property NSMutableArray <todo*> *todosArray;
@property todo* todo;

@end

@implementation ViewController


// MARK: - ViewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Add Todo"];
    
    // init todo
    _todo = [todo new];
    _defaults = [NSUserDefaults standardUserDefaults];

    NSError* error;
    NSData* data = [_defaults objectForKey:@"todoTasks"];
    NSSet* set = [NSSet setWithArray:@[[NSArray class],[todo class]]];
    
    _todosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
    
    
    [_defaults setObject:data forKey:@"todoTasks"];
    
    if(_todosArray == nil){
        _todosArray = [NSMutableArray new];
    }

    
}

- (IBAction)saveTodoButtonTapped:(id)sender {
    NSString* name = self.nameTextfield.text;
  
    // trimming white spaces
    NSString* todoNameTrimmmed = [name stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([todoNameTrimmmed  isEqual: @""]) {
        [self configureAlertWithTitle:@"Todo Field is Empty" message:@"Please insert empty field/s"];
    } else {
        _todo.todoName = _nameTextfield.text;
        _todo.todoDescription = _descTextfield.text;
        _todo.todoDate = _datePick.date;
        switch (_prioritySegment.selectedSegmentIndex) {
            case 0:
                _todo.todoPriority = @"low";
                break;
            case 1:
                _todo.todoPriority = @"medium";
                break;
            case 2:
                _todo.todoPriority = @"high";
                break;
        }
        _todo.todoStatus = @"todo"; 
        //_todo.todoStatus= @"high";
        [_todosArray addObject:_todo];
        
        NSError *error;
        NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:_todosArray requiringSecureCoding:YES error:&error];
        [_defaults setObject:savedData forKey:@"todoTasks"];
        //TodosTVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TodosTVC"];
        // run delegate here, reload tableView in TodosTVC. before back.
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    // Delegate
    //[_ref updateTodoTableView];
  
    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(void) configureAlertWithTitle: (NSString*) _title message: (NSString* ) _message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    [ self presentViewController:alert animated:YES completion:nil];
}



@end
