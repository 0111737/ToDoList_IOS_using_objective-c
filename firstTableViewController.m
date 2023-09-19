//
//  firstTableViewController.m
//  toDoList Workshop
//
//  Created by JETS Mobile Lab on 30/08/2023.
//

#import "firstTableViewController.h"
#import "ViewController.h"
#import "todo.h"
#import "editViewController.h"

@interface firstTableViewController ()
@property NSUserDefaults* defaults;
@property NSMutableArray <todo*> *todosArray;
@property todo* todo;
@property NSMutableArray <todo*> *searchResultsArray;
@end

@implementation firstTableViewController

- (void)viewWillAppear:(BOOL)animated{
    
    _defaults = [NSUserDefaults standardUserDefaults];
    _todo = [todo new];
    NSError *error;
    
    NSData *data = [_defaults objectForKey:@"todoTasks" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[todo class]]];
    
    _todosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];

    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(performAdd:)];
 
  
    isFiltered = false;

     self.searchBar.delegate = self;
  
}

-(void)performAdd:(id)sender{
   // [self.navigationController popViewControllerAnimated:YES];
    
    ViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"vc"];
    
       [self.navigationController pushViewController:vc animated:YES];
}
    

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([searchText isEqualToString:@""]) {
        isFiltered = false;
    }
    else {
        isFiltered = true;
    }
    [self filterContentForSearchText];
}

- (void) filterContentForSearchText {
    
    _searchResultsArray = [NSMutableArray<todo*> new];
    
    if (![_searchBar.text isEqualToString:@""]) {
        isFiltered = true;
        NSString *searchString = _searchBar.text.lowercaseString;
        
        for (int i = 0; i < _todosArray.count; ++i) {
            NSString *taskName = _todosArray[i].todoName.lowercaseString;
            
            if (searchString.length <= taskName.length) {
                if ([searchString isEqualToString:[taskName substringToIndex:searchString.length]]) {
                    [_searchResultsArray addObject:_todosArray[i]];
                }
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isFiltered) {
        return _searchResultsArray.count;
    } else {
        return _todosArray.count;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    if (isFiltered) {
        _todo =[_searchResultsArray objectAtIndex:indexPath.row];
    } else {
        _todo =[_todosArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = _todo.todoName;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    todo *c =_todosArray[indexPath.row];
        
          

   editViewController *edit= [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
    edit.d=c.todoDescription;
    edit.n=c.todoName;
    edit.dt=c.todoDate;
    edit.p=c.todoPriority;
    edit.s=c.todoStatus;
    edit.index = indexPath.row;
    edit.tvc=1;
    
    [self.navigationController pushViewController:edit animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureActionSheetWithTitle:@"Delete Todo" message:@"Are you sure you want to delete this todo!" editingStyle:editingStyle indexPath:indexPath];
    
}

-(void) configureActionSheetWithTitle: (NSString*) _title message: (NSString* ) _message editingStyle: (UITableViewCellEditingStyle) _editingStyle indexPath: (NSIndexPath *) _indexPath{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction* yesDeleteAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (_editingStyle == UITableViewCellEditingStyleDelete) {
            
                [self.todosArray removeObjectAtIndex:_indexPath.row];
                NSError *error;
                NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self.todosArray requiringSecureCoding:YES error:&error];
                [self.defaults setObject:savedData forKey:@"todoTasks"];

            [self.tableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        [self.tableView reloadData];
    }];
    
    
    [alert addAction:noAction];
    [alert addAction:yesDeleteAction];
    [ self presentViewController:alert animated:YES completion:nil];
}
/*
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    _filteredData = [_todosArray filteredArrayUsingPredicate:resultPredicate];
    [self.tableView reloadData];

}
 
 */
/*
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
            scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                objectAtIndex:[self.searchDisplayController.searchBar
                selectedScopeButtonIndex]]];
    
    [self.tableView reloadData];

    
    return YES;
} */



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
