//
//  DetailViewController.h
//  Decide-o-matic
//
//  Created by Matt Burns on 11/21/12.
//  Copyright (c) 2012 M@ Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UITextField *txtListName;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *txtNewChoice;
@property (weak, nonatomic) IBOutlet UITableView *choiceTable;

- (IBAction)btnAdd:(UIButton *)sender;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)textFileEditingDidEnd:(id)sender;
- (IBAction)btnDecide:(id)sender;

@end
