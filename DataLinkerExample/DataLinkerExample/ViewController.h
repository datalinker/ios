//
//  ViewController.h
//  DataLinkerExample
//
//  Created by Julius Petraška on 11/4/16.
//  Copyright © 2016 SailRacer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DataLinker/DataLinker.h>

@interface ViewController : UIViewController <DataLinkerDelegate> {
    IBOutlet UITextView *receivedDataView;
    
    DataLinker *dataLinker;
}


@end

