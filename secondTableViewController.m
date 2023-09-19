//
//  secondTableViewController.m
//  toDoList Workshop
//
// Created by JETS Mobile Lab on 30/08/2023.
//

#import "secondTableViewController.h"
#import "todo.h"
#import "editViewController.h"

@interface secondTableViewController ()

@property NSMutableArray <todo*> *todosArray;

@property NSMutableArray <todo*> *doneTodosArray;
@property NSMutableArray <todo*> *inProgressArray;

@property NSMutableArray <todo*> *lowArray;
@property NSMutableArray <todo*> *mediumArray;
@property NSMutableArray <todo*> *highArray;



@property NSUserDefaults* defaults; 
@property todo* todo;


@end

@implementation secondTableViewController

- (void)viewWillAppear:(BOOL)animated{
    
    _lowArray =[NSMutableArray new];
    _mediumArray=[NSMutableArray new];
    _highArray=[NSMutableArray new];
    
    
    _defaults = [NSUserDefaults standardUserDefaults];
    _todo = [todo new];
    NSError *error;
    
    // convert todosArray to NSData(binary data), so first object of array must conform <NSCoding,NSSecureCoding>
    NSData *Progressdata = [_defaults objectForKey:@"ProgressTasks" ];
    NSSet *Progressset = [NSSet setWithArray:@[[NSArray class],[todo class]]];
    
    // unarchivedObjectOfClasses, No known class method for selector 'archivedObjectOfClasses:fromData:error:'
    _inProgressArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:Progressset fromData:Progressdata error:&error];
    
    for(int i=0;i<_inProgressArray.count;i++){
        if([_inProgressArray[i].todoPriority isEqual:@"low"]){
            [_lowArray addObject:_inProgressArray[i]];
        }
        else  if([_inProgressArray[i].todoPriority isEqual:@"medium"]){
            [_mediumArray addObject:_inProgressArray[i]];
        }
        else  if([_inProgressArray[i].todoPriority isEqual:@"high"]){
            [_highArray addObject:_inProgressArray[i]];
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _numOfSec=3;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"sort" style:UIBarButtonItemStylePlain target:self action:@selector(performSort:)];
    
   
    
   
}

-(void)performSort:(id)sender{
    
    if (_numOfSec==1){
        _numOfSec=3;
    }
    else{
        _numOfSec=1;
    }
    [self.tableView reloadData];
    
}
    

// MARK: - Data Source and Delegate functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _numOfSec;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if(_numOfSec==3){
    switch (section) {
        case 0:
            return [_lowArray count];
            break;
        case 1:
            return  [_mediumArray count];
            break;
        case 2:
            return [_highArray count];
            break;
        default:
            return 0;
            break;
    }
    }else {
        return [_inProgressArray count];
    }
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    _todo =[_inProgressArray objectAtIndex:indexPath.row];
    
    if(_numOfSec==3){
    switch (indexPath.section) {
        case 0:
           cell.textLabel.text= _lowArray[indexPath.row].todoName;
            cell.imageView.image=[UIImage imageNamed:@"l"];
            break;
        case 1:
            cell.textLabel.text= _mediumArray[indexPath.row].todoName;
            cell.imageView.image=[UIImage imageNamed:@"m"];
            break;
        case 2:
            cell.textLabel.text= _highArray[indexPath.row].todoName;
            cell.imageView.image=[UIImage imageNamed:@"h"];
            break;
        default:
            break;
    }
    }else{
        cell.textLabel.text=_todo.todoName;
        if([_todo.todoPriority isEqual:@"low"]){
            cell.imageView.image=[UIImage imageNamed:@"l"];

            
        }
        else if([_todo.todoPriority isEqual:@"medium"]){
            cell.imageView.image=[UIImage imageNamed:@"m"];

            
        }
        else if([_todo.todoPriority isEqual:@"high"]){
            cell.imageView.image=[UIImage imageNamed:@"h"];

            
        }
    }
   
    return  cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _todo =[_inProgressArray objectAtIndex:indexPath.row];
    
    editViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
    edit.d=_todo.todoDescription;
    edit.n=_todo.todoName;
    edit.dt=_todo.todoDate;
    edit.p=_todo.todoPriority;
    edit.s=_todo.todoStatus;
    edit.todo = _todo;
    edit.index = indexPath.row;
    edit.tvc=2;
    
    // push to navigationController
    [self.navigationController pushViewController:edit animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(_numOfSec==3){
    switch (section) {
        case 0:
            return @"low";
            break;
        case 1:
            return @"medium";
            break;
        case 2:
            return @"high";
            break;
        default:
            return 0;
            break;
    }
    }else{
        return @"in progress";
    }
}


    - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        [self configureActionSheetWithTitle:@"Delete Todo" message:@"Confirm delete todo from progress!" editingStyle:editingStyle indexPath:indexPath];
        
    }
    
    


// MARK: - Configure action Sheet
// Configure action sheet alert controller
-(void) configureActionSheetWithTitle: (NSString*) _title message: (NSString* ) _message editingStyle: (UITableViewCellEditingStyle) _editingStyle indexPath: (NSIndexPath *) _indexPath{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* NoAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction* YesDeleteAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (_editingStyle == UITableViewCellEditingStyleDelete) {
            
            NSString *deletedtodoname = self->_inProgressArray[_indexPath.row].todoName;
            NSString *deletedTodoPriority =self->_inProgressArray[_indexPath.row].todoPriority;
            if ([deletedTodoPriority isEqual:@"low"]) {
                for (int i =0; i< self->_lowArray.count;i++){
                    if(self->_lowArray[i].todoName==deletedtodoname){
                        [self.lowArray removeObjectAtIndex:i];
                    }
                }
                
            }else if ([deletedTodoPriority isEqual:@"medium"]) {
                for (int i =0; i< self->_mediumArray.count;i++){
                    if(self->_mediumArray[i].todoName==deletedtodoname){
                        [self.mediumArray removeObjectAtIndex:i];
                    }
                }
                
            }
            
            else if ([deletedTodoPriority isEqual:@"high"]) {
                for (int i =0; i< self->_highArray.count;i++){
                    if(self->_highArray[i].todoName==deletedtodoname){
                        [self.highArray removeObjectAtIndex:i];
                    }
                }
                
            }
                [self.inProgressArray removeObjectAtIndex:_indexPath.row];
                NSError *error;
                NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self.inProgressArray requiringSecureCoding:YES error:&error];
                [self.defaults setObject:savedData forKey:@"ProgressTasks"];

            [self.tableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        [self.tableView reloadData];
    }];
    
    
    [alert addAction:NoAction];
    [alert addAction:YesDeleteAction];
    [ self presentViewController:alert animated:YES completion:nil];
}




// MARK: - Conform updateTodoTableView Protocol

@end


