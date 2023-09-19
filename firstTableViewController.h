//
//  firstTableViewController.h
//  toDoList Workshop
//
//  Created by JETS Mobile Lab on 30/08/2023.
//

#import <UIKit/UIKit.h>
#import "todo.h"
NS_ASSUME_NONNULL_BEGIN

@interface firstTableViewController : UITableViewController < UISearchBarDelegate>{
    BOOL isFiltered;

}
@property (strong, nonatomic) NSArray <todo*> *filteredTodoObjects;
@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end




NS_ASSUME_NONNULL_END
