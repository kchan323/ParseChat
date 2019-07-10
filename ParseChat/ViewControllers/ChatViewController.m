//
//  ChatViewController.m
//  ParseChat
//
//  Created by kchan23 on 7/10/19.
//  Copyright © 2019 kchan23. All rights reserved.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "ChatCell.h"
#import "AppDelegate.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *chatField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *chatsArray;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self onTimer];
}

- (IBAction)didTapSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2019"];
    chatMessage[@"text"] = self.chatField.text;
    chatMessage[@"user"] = PFUser.currentUser;
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.chatField.text = @"";
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    
}

- (void)fetchChats {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2019"];
    //[query whereKey:@"likesCount" greaterThan:@100];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *chats, NSError *error) {
        if (chats != nil) {
            NSLog(@"😎😎😎 Successfully loaded");
            self.chatsArray = chats;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error loading: %@", error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    PFObject *chat = self.chatsArray[indexPath.row];
    cell.chatLabel.text = chat[@"text"];
    
    PFUser *user = chat[@"user"];
    if (user != nil) {
        // User found! update username label with username
        cell.usernameLabel.text = user.username;
    } else {
        // No user found, set default username
        cell.usernameLabel.text = @"🤖";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatsArray.count;
}

- (void)onTimer {
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    [self fetchChats];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
    appDelegateTemp.window.rootViewController = navigation;
}

@end
