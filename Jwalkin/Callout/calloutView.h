//
//  calloutView.h
//  HuntersRoom
//
//  Created by Ashok Choudhary on 14/08/14.
//  Copyright (c) 2014 Ramprakash. All rights reserved.
//

#import <UIKit/UIKit.h>
 @interface calloutView : UIView


@property (nonatomic,strong)IBOutlet UILabel *lblHeader;
@property (nonatomic,strong)IBOutlet UIButton *btnA,*btnB,*btnC;
@property (strong, nonatomic) IBOutlet UILabel *lblAdd;


@property (strong, nonatomic) IBOutlet UIButton *btnBackClicked;



+ (calloutView*)ViewWithFrame:(CGRect)frame;
@end
