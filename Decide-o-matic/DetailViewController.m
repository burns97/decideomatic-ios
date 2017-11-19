//
//  DetailViewController.m
//  Decide-o-matic
//
//  Created by Matt Burns on 11/21/12.
//  Copyright (c) 2012 M@ Soft. All rights reserved.
//

#import "DetailViewController.h"
#import "ChoiceList.h"
#import "Choice.h"
#import "AppDelegate.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.txtListName.text = [[self.detailItem valueForKey:@"listName"] description];
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAdd:(UIButton *)sender {
    
    //Check to make sure there is something to add
    if (self.txtNewChoice.text.length <= 0)
    {
        //Display the name of the winner
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Nothing to add" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Choice *newChoice = [NSEntityDescription insertNewObjectForEntityForName:@"Choice" inManagedObjectContext: appDelegate.managedObjectContext];
    
    NSMutableString *newValue = [NSMutableString stringWithString:self.txtNewChoice.text];
    [newChoice setChoiceName:newValue];
    NSMutableSet *choiceValues = [self.detailItem mutableSetValueForKey:@"hasValues"];
    [choiceValues addObject:newChoice];
    
    [self.detailItem setHasValues:choiceValues];
    
    self.txtNewChoice.text = @"";
    
    [appDelegate saveContext];
    
    [self textFieldDoneEditing:self.txtNewChoice];
    
    [self.choiceTable reloadData];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)textFileEditingDidEnd:(id)sender {
    //Save change to ChoiceList listName field
    
    //Check to make sure there is a value to rename to
    if (self.txtListName.text.length > 0)
    {
        [self.detailItem setValue:self.txtListName.text forKey:@"listName"];
    
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate saveContext];
    }
    else
    {
        //Display the name of the winner
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"List name cannot be blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];

        self.txtListName.text = [[self.detailItem valueForKey:@"listName"] description];
    }
    
}

- (IBAction)btnDecide:(id)sender {
    NSString *msgText = [[NSString alloc] init];
    
    ChoiceList* selectedList = (ChoiceList *) self.detailItem;
    NSSet *currentValues = selectedList.hasValues;
    
    int optionCount = selectedList.hasValues.count;
    
    if (optionCount <= 0 )
    {
        msgText = @"No winner, nothing to choose";
    }
    else if (optionCount == 1)
    {
        //only one choice
        Choice* currentChoice = (Choice *) [[currentValues allObjects] objectAtIndex: 0];
        
        NSString *selectedValue = currentChoice.choiceName;
        
        msgText = [[NSString alloc] initWithFormat:@"By default, %@ is the winner!", selectedValue];
    }
    else
    {
        //Choose a random entry from the list
        int randomNumber = arc4random();
        int winningIndex = abs(randomNumber) % optionCount;
        
        NSLog(@"WinningIndex = %i", winningIndex);
        
        Choice* currentChoice = (Choice *) [[currentValues allObjects] objectAtIndex: winningIndex];
        
        NSString *selectedValue = currentChoice.choiceName;
        
        //NSString *selectedValue = [self.listData objectAtIndex:winningIndex];
        
        msgText = [[NSString alloc] initWithFormat:@"It was close race but %@ is the winner!", selectedValue];
    }
    
    //Display the name of the winner
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"And the results are..." message:msgText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    if(editing)
    {
        NSLog(@"editMode on");
        [self.choiceTable setEditing:YES animated:YES];
    }
    else
    {
        NSLog(@"Done leave editmode");
        [self.choiceTable setEditing:NO animated:YES];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ChoiceList* selectedList = (ChoiceList *) self.detailItem;
    return selectedList.hasValues.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceCell" forIndexPath:indexPath];
    ChoiceList* selectedList = (ChoiceList *) self.detailItem;
    NSSet *currentValues = selectedList.hasValues;
    
    Choice* currentChoice = (Choice *) [[currentValues allObjects] objectAtIndex: indexPath.row];
    
    cell.textLabel.text = currentChoice.choiceName;

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];  
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        
        ChoiceList* selectedList = (ChoiceList *) self.detailItem;
        NSSet *currentValues = selectedList.hasValues;
        Choice* currentChoice = (Choice *) [[currentValues allObjects] objectAtIndex: indexPath.row];
        
        NSLog(@"Deleting option %@", currentChoice.choiceName);
        [context deleteObject:currentChoice];
    
        NSLog(@"Number of choices remaining for ChoiceList %@ is %u", selectedList.listName, selectedList.hasValues.count);
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [self.choiceTable reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

@end
