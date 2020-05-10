//
//  PDMVector3TableViewCell.h
//  Sensors
//
//  Created by Alexey Sobolevsky on 10.05.2020.
//  Copyright © 2020 Alexey Sobolevsky. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PDMVector3TableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *propertyLabel;
@property (nonatomic, weak) IBOutlet UILabel *xValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *yValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *zValueLabel;

@end

