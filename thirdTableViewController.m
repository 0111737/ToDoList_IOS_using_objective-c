//
//  thirdTableViewController.m
//  toDoList Workshop
//
//  Created by JETS Mobile Lab on 30/08/2023.
//

#import "thirdTableViewController.h"
#import "todo.h"
#import "editViewController.h"

@interface thirdTableViewController ()
@property NSMutableArray <todo*> *todosArray;

@property NSMutableArray <todo*> *doneArray;
@property NSMutableArray <todo*> *inProgressArray;

@property NSUserDefaults* defaults;
@property todo* todo;


@end

@implementation thirdTableViewController

- (void)viewWillAppear:(BOOL)animated{
    

    
    
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _defaults = [NSUserDefaults standardUserDefaults];
    _todo = [todo new];
    NSError *error;
    
    // convert todosArray to NSData(binary data), so first object of array must conform <NSCoding,NSSecureCoding>
    NSData *donedata = [_defaults objectForKey:@"doneTasks" ];
    NSSet *doneset = [NSSet setWithArray:@[[NSArray class],[todo class]]];
    
    // unarchivedObjectOfClasses, No known class method for selector 'archivedObjectOfClasses:fromData:error:'
    _doneArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:doneset fromData:donedata error:&error];
    for(int i=0;i<_doneArray.count;i++){
        NSLog(@"%@----------------------", _doneArray[i].todoName);
    }
    
    [self.tableView reloadData];
 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)_doneArray.count);
    return _doneArray.count ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
    
    // Configure the cell...
    _todo =[_doneArray objectAtIndex:indexPath.row];

    cell.textLabel.text=_todo.todoName;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    _todo =[_doneArray objectAtIndex:indexPath.row];
    
    editViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
    edit.d=_todo.todoDescription;
    edit.n=_todo.todoName;
    edit.dt=_todo.todoDate;
    edit.p=_todo.todoPriority;
    edit.s=_todo.todoStatus;
    edit.todo = _todo;
    edit.index = indexPath.row;
    edit.tvc=3;
    
    [self.navigationController pushViewController:edit animated:YES];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
        return @"Done";
    }

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
