//
//  ViewController.m
//  TestingApp
//
//  Created by Saul Rivera on 06/06/20.
//  Copyright © 2020 Saul Rivera. All rights reserved.
//

#import "ViewController.h"
#import "Repo.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray<Repo *> *repos;

@end

@implementation ViewController

NSString *cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Repositories";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellId];
    
    [self setupRepos];
    [self fetchCoursesUsingJSON];
}

- (void)setupRepos {
    self.repos = NSMutableArray.new;
    Repo *repo = Repo.new;
    repo.name = @"Instagram Firebase";
    repo.repoDescription = @"An instagram app";
    [self.repos addObject:repo];
}

- (void)fetchCoursesUsingJSON {
    NSLog(@"Fetching courses");
    NSString *urlString = @"https://api.github.com/users/saulrivera/repos";
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Finished fetching courses...");
        
        NSError *err;
        NSArray *repoJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (err) {
            NSLog(@"Failed to seriealize into JSON: %@", err);
            return;
        }
        
        NSMutableArray<Repo *> *repos = NSMutableArray.new;
        for (NSDictionary *repoDict in repoJSON) {
            NSString *name = repoDict[@"name"];
            NSString *description = repoDict[@"description"];
            
            Repo *repo = Repo.new;
            repo.name = name;
            repo.repoDescription = description;
            
            [repos addObject:repo];
        }
        
        self.repos = repos;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }] resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
   
    Repo *repo = self.repos[indexPath.row];
    
    cell.textLabel.text = repo.name;
    return cell;
}

@end
