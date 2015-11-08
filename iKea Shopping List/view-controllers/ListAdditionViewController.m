//
//  ListAdditionViewController.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-07.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "ListAdditionViewController.h"

@interface ListAdditionViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *listInfoForm;

@end

@implementation ListAdditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /* Set current view controller as the delegate for the navigation bar
     * so that the top position of the bar can be controlled.*/
    self.navigationBar.delegate = self ;
    
    /* Set current view controller as data source of the new list info form. */
    self.listInfoForm.dataSource = self;
    
    /* Make the tablView style of new list information form Grouped.
     * If it is Plain style then make sure to hide remove separators between 
     * empty cells as indicated below. */
    /*self.listInfoForm.tableFooterView = [UIView new];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma navbar - position

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    if(bar == self.navigationBar)
        /* let the navbar background to show through the status bar.
         * Note that, in storyboard the navbar must be placed 20points from the 
         * top of the screen.
         */
        return UIBarPositionTopAttached;
    else
        return UIBarPositionTop; //Return default value.
}

#pragma tableview - data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell =
        [tableView dequeueReusableCellWithIdentifier:@"new-list-info-cell"];

    return cell;
}


#pragma mark - Navigation

- (IBAction)onTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onTapDone:(id)sender {
    /* As recommended in Official View Controller iOS Programming Guide here in
     * this link: http://goo.gl/Phwrp6, Dismissing a Presented View Controller
     * section mentioned exciplictly that If the presented view controller must 
     * return data to the presenting view controller, use the delegation design 
     * pattern to facilitate the transfer.
     */
    [self.listInfoCreationDelegate listInfoDidCreatedWithTitle:@"Wael"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
