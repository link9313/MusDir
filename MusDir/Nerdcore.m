//
//  Nerdcore.m
//  MusDir
//
//  Created by Nick on 11/24/15.
//  Copyright © 2015 Nick Lauber. All rights reserved.
//

#import "Nerdcore.h"
#import <spotify/Spotify.h>

@interface Nerdcore ()

@end

@implementation Nerdcore

SPTListPage *searchNerdcoreResults;
NSArray *nerdcoreResults;
NSArray *nerdcoreURIs;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Search for nerdcore tracks
    [SPTSearch performSearchWithQuery:@"nerdcore" queryType:SPTQueryTypeTrack accessToken:nil
                             callback:^(NSError *searchError, SPTListPage *searchNerdcoreResults)
    {
        // If an error, print and exit
        if (searchError != nil) {
            NSLog(@"*** Getting results got error: %@", searchError);
            return;
        }
         
        // Mutable array of track titles
        NSMutableArray *arrayOfTracks = [[NSMutableArray alloc] init];
        NSMutableArray *arrayofURIs = [[NSMutableArray alloc] init];
         
        // Loop through the list of items
        for (int x = 0; x < searchNerdcoreResults.items.count; x++) {
            // Grab the track in each position of the items NSArray
            SPTPartialTrack *track = [searchNerdcoreResults.items objectAtIndex:x];
             
            // Put the name and uri in the current string
            NSString *name = track.name;
            NSURL *uri = track.playableUri;
             
            // Add the track to the array of track names
            [arrayOfTracks addObject:name];
            [arrayofURIs addObject:uri];
        }
         
        // set a non-mutable version of the array for later use
        nerdcoreResults = [NSArray arrayWithArray:arrayOfTracks];
        nerdcoreURIs = [NSArray arrayWithArray:arrayofURIs];
        
        // free the memeory of the mutable array
        [arrayOfTracks removeAllObjects];
        [arrayofURIs removeAllObjects];
        
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return nerdcoreResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [nerdcoreResults objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Click a table row

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *message = [nerdcoreResults objectAtIndex:indexPath.row];
    NSString *URI = [NSString stringWithFormat:@"%@", [nerdcoreURIs objectAtIndex:indexPath.row]];
    
    // Create the alert with message
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the open in spotify action
    UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Open in Spotify"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URI]];
                                                       }];
    
    // Create the clipboard copy action
    UIAlertAction *copyAction = [UIAlertAction actionWithTitle:@"Copy to Clipboard"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           UIPasteboard *pb = [UIPasteboard generalPasteboard];
                                                           [pb setString:message];
                                                       }];
    
    // Create the cancel action
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction *action) {}];
    
    // Add actions and display the alert
    [alert addAction:openAction];
    [alert addAction:copyAction];
    [alert addAction:closeAction];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
