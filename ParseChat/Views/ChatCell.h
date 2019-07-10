//
//  ChatCell.h
//  ParseChat
//
//  Created by kchan23 on 7/10/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatLabel;

@end

NS_ASSUME_NONNULL_END
