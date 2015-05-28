//
//  User+Additions.m
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


#import "CoreDataStore.h"
#import "User+Additions.h"

#define USER_ID                        @"id"
#define USER_IMAGE_URL                 @"imageURL"
#define USER_NAME                      @"name"


@implementation User (Additions)

+ (User *)createOrUpdateWithServiceResult:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;
{
    User *user = [User findFirstByAttribute:@"userId" withValue:data[USER_ID] inContext:context];
    if (!user)
    {
        user = [User insert:context];
    }
    user.userId = data[USER_ID];
    user.userImageURL = data[USER_IMAGE_URL] ;
    user.userName = data[USER_NAME];
    return user;
}

+ (UIImage *)defaultProfileImage
{
    return [UIImage imageNamed:@"default-avatar"];
}

+ (NSPredicate *)getPredicateBySearchInput:(NSString *)search {

    if (search && ![search isEqualToString:@""]) {
        return [NSPredicate predicateWithFormat:@"userName CONTAINS[cd] %@" , search];
    }
    return nil;
}

+ (NSFetchRequest *)getFetchRequest {
    return [User getFetchRequestBySearchInput:nil];
}

+ (NSFetchRequest *)getFetchRequestBySearchInput:(NSString *)search {
    NSFetchRequest * fetchRequest = [User fetchRequest];
    fetchRequest.predicate = [User getPredicateBySearchInput:search];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"userName" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    return fetchRequest;
}

#pragma mark - XLFormOptionObject

-(NSString *)formDisplayText
{
    return self.userName;
}

-(id)formValue
{
    return self.userId;
}


@end
