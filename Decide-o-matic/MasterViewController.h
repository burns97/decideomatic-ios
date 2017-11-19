//
//  MasterViewController.h
//  Decide-o-matic
//
//  Created by Matt Burns on 11/21/12.
//  Copyright (c) 2012 M@ Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, ADBannerViewDelegate>
{
    ADBannerView *adView;
    BOOL bannerIsVisible;
    BOOL adLoaded;
}

@property (nonatomic,assign) BOOL bannerIsVisible;
@property (nonatomic,assign) BOOL adLoaded;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
