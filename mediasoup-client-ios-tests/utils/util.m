#import "util.h"

@implementation Util

+ (NSString *)dictionaryToJson:(NSDictionary *)dictionary {
    if (!dictionary) {
        return @"{}";
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (!jsonData) {
        return @"{}";
    }
    return [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
}

@end
