//
//  ViewController.m
//  NTMonthYearPickerDemo
//
//  Created by Arun Nair on 11/4/13.
//  Copyright (c) 2013 Arun Nair. All rights reserved.
//

#import "ViewController.h"
#import "NTMonthYearPicker.h"

@implementation ViewController

NTMonthYearPicker *picker;
UIPopoverController *popupCtrl;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Initialize the picker
    picker = [[NTMonthYearPicker alloc] init];
    [picker addTarget:self action:@selector(onDatePicked:) forControlEvents:UIControlEventValueChanged];

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];

    // Set mode to month + year
    // This is optional; default is month + year
    picker.datePickerMode = NTMonthYearPickerModeMonthAndYear;

    // Set minimum date to January 2000
    // This is optional; default is no min date
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:2000];
    picker.minimumDate = [cal dateFromComponents:comps];

    // Set maximum date to next month
    // This is optional; default is no max date
    [comps setDay:0];
    [comps setMonth:1];
    [comps setYear:0];
    picker.maximumDate = [cal dateByAddingComponents:comps toDate:[NSDate date] options:0];

    // Set initial date to last month
    // This is optional; default is current month/year
    [comps setDay:0];
    [comps setMonth:-1];
    [comps setYear:0];
    picker.date = [cal dateByAddingComponents:comps toDate:[NSDate date] options:0];

    // Initialize UI label and mode selector
    [self updateModeSelector];
    [self updateLabel];
}

// Add picker to view once it has appeared.
// We do not do this in viewDidLoad because at that time the view may not yet be part of a window, and UIPopoverController requires it to be.
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
        // iPhone: show picker at the bottom of the screen
        if( ![picker isDescendantOfView:self.view] ) {
            picker.frame = CGRectMake( 0, [[UIScreen mainScreen] bounds].size.height - pickerSize.height, pickerSize.width, pickerSize.height );
            [self.view addSubview:picker];
        }
    } else {
        // iPad: show picker in a popover
        if( !popupCtrl.isPopoverVisible ) {
            UIView *container = [[UIView alloc] init];
            [container addSubview:picker];

            UIViewController* popupVC = [[UIViewController alloc] init];
            popupVC.view = container;

            popupCtrl = [[UIPopoverController alloc] initWithContentViewController:popupVC];
            [popupCtrl setPopoverContentSize:picker.frame.size animated:NO];

            [popupCtrl presentPopoverFromRect:[pickerModeSelector bounds]
                                       inView:pickerModeSelector
                     permittedArrowDirections:UIPopoverArrowDirectionAny
                                     animated:YES];
        }
    }

    [self viewDidAppear:TRUE];
}

- (IBAction)pickerModeChanged {
    picker.datePickerMode = (pickerModeSelector.selectedSegmentIndex == 0) ? NTMonthYearPickerModeMonthAndYear : NTMonthYearPickerModeYear;
    [self updateLabel];
}

- (void)onDatePicked:(UITapGestureRecognizer *)gestureRecognizer {
    [self updateLabel];
}

- (void)updateModeSelector {
    pickerModeSelector.selectedSegmentIndex = (picker.datePickerMode == NTMonthYearPickerModeMonthAndYear ? 0 : 1);
}

- (void)updateLabel {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    if( picker.datePickerMode == NTMonthYearPickerModeMonthAndYear ) {
        [df setDateFormat:@"MMMM yyyy"];
    } else {
        [df setDateFormat:@"yyyy"];
    }

    NSString *dateStr = [df stringFromDate:picker.date];
    selectedDate.text = [NSString stringWithFormat:@"Selected: %@", dateStr];
}

@end
