//
//  UserRemoteDataLoader.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "UserRemoteDataLoader.h"
#import "HTTPSessionManager.h"
#import "CoreDataStore.h"
#import "User+Additions.h"

@implementation UserRemoteDataLoader

-(NSString *)URLString
{
    return @"/mobile/users.json";
}

-(NSDictionary *)parameters
{
    NSString *filterParam = self.searchString ?: @"";
    return @{@"filter" : filterParam,
             @"offset" : @(self.offset),
             @"limit"  : @(self.limit)};
}

-(AFHTTPSessionManager *)sessionManager
{
    return [HTTPSessionManager sharedClient];
}

-(void)successulDataLoad {
    // change flags
    // [self fetchedData] contains the data coming from the server
    NSArray * itemsArray = [[self fetchedData] objectForKey:kXLRemoteDataLoaderDefaultKeyForNonDictionaryResponse];

    // This flag indicates if there is more data to load
    _hasMoreToLoad = !((itemsArray.count == 0) || (itemsArray.count < _limit && itemsArray.count != 0));
    [[CoreDataStore privateQueueContext] performBlock:^{
        for (NSDictionary *item in itemsArray) {
            // Creates or updates the User and the user who created it with the data that came from the server
            [User createOrUpdateWithServiceResult:item[@"user"] inContext:[CoreDataStore privateQueueContext]];
        }
        [self removeOutdatedData:itemsArray inContext:[CoreDataStore privateQueueContext]];
        [CoreDataStore savePrivateQueueContext];
    }];
    [super successulDataLoad];
}


#pragma mark - Auxiliary Functions

- (void)removeOutdatedData:(NSArray *)data inContext:(NSManagedObjectContext *)context
{
    // First, remove older data
    NSFetchRequest * fetchRequest = [User getFetchRequestBySearchInput:self.searchString];

    fetchRequest.fetchLimit = self.limit;
    fetchRequest.fetchOffset = self.offset;
    
    NSError *error;
    NSArray * oldObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSArray * arrayToIterate = [oldObjects copy];
    
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:error.localizedFailureReason ?: error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alertView show];
        });
        return;
    }
    
    for (User *user in arrayToIterate)
    {
        NSArray *filteredArray = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"user.id == %@" argumentArray:@[user.userId]]];
        if (filteredArray.count == 0) {
            // This User no longer exists
            [context deleteObject:user];
        }
    }
}

@end
