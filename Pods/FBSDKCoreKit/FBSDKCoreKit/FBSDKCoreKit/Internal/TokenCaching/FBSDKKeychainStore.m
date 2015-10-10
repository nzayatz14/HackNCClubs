/**
 * Contains code from UICKeyChainStore
 *
 * Copyright (c) 2011 kishikawa katsumi
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "FBSDKKeychainStore.h"

#import "FBSDKDynamicFrameworkLoader.h"
#import "FBSDKMacros.h"

@implementation FBSDKKeychainStore

- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup
{
    if ((self = [super init])) {
      _service = service ? [service copy] : [[NSBundle mainBundle] bundleIdentifier];
        _accessGroup = [accessGroup copy];
        NSAssert(_service, @"Keychain must be initialized with service");
    }

    return self;
}

- (instancetype)init
{
  FBSDK_NOT_DESIGNATED_INITIALIZER(initWithService:accessGroup:);
  return [self initWithService:nil accessGroup:nil];
}

- (BOOL)setDictionary:(NSDictionary *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    NSData *data = value == nil ? nil : [NSKeyedArchiver archivedDataWithRootObject:value];
    return [self setData:data forKey:key accessibility:accessibility];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
    NSData *data = [self dataForKey:key];
    if (!data) {
        return nil;
    }

    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    return dict;
}

- (BOOL)setString:(NSString *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    return [self setData:data forKey:key accessibility:accessibility];
}

- (NSString *)stringForKey:(NSString *)key
{
    NSData *data = [self dataForKey:key];
    if (!data) {
        return nil;
    }

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (BOOL)setData:(NSData *)value forKey:(NSString *)key accessibility:(CFTypeRef)accessibility
{
    if (!key) {
        return NO;
    }

    NSMutableDictionary *query = [self queryForKey:key];

    OSStatus status;
    if (value) {
        NSMutableDictionary *attributesToUpdate = [NSMutableDictionary dictionary];
        [attributesToUpdate setObject:value forKey:[FBSDKDynamicFrameworkLoader loadkSecValueData]];

        status = fbsdkdfl_SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
        if (status == errSecItemNotFound) {
#if TARGET_OS_IPHONE || (defined(MAC_OS_X_VERSION_10_9) && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_9)
            if (accessibility) {
                [query setObject:(__bridge id)(accessibility) forKey:[FBSDKDynamicFrameworkLoader loadkSecAttrAccessible]];
            }
#endif
            [query setObject:value forKey:[FBSDKDynamicFrameworkLoader loadkSecValueData]];

            status = fbsdkdfl_SecItemAdd((__bridge CFDictionaryRef)query, NULL);
        }
    } else {
        status = fbsdkdfl_SecItemDelete((__bridge CFDictionaryRef)query);
        if (status == errSecItemNotFound) {
            status = errSecSuccess;
        }
    }

    return (status == errSecSuccess);
}

- (NSData *)dataForKey:(NSString *)key
{
    if (!key) {
        return nil;
    }

    NSMutableDictionary *query = [self queryForKey:key];
    [query setObject:(id)kCFBooleanTrue forKey:[FBSDKDynamicFrameworkLoader loadkSecReturnData]];
    [query setObject:[FBSDKDynamicFrameworkLoader loadkSecMatchLimitOne] forKey:[FBSDKDynamicFrameworkLoader loadkSecMatchLimit]];

    CFTypeRef data = nil;
    OSStatus status = fbsdkdfl_SecItemCopyMatching((__bridge CFDictionaryRef)query, &data);
    if (status != errSecSuccess) {
        return nil;
    }

    if (!data || CFGetTypeID(data) != CFDataGetTypeID()) {
        return nil;
    }

    NSData *ret = [NSData dataWithData:(__bridge NSData *)(data)];
    CFRelease(data);

    return ret;
}

- (NSMutableDictionary *)queryForKey:(NSString *)key
{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    [query setObject:[FBSDKDynamicFrameworkLoader loadkSecClassGenericPassword] forKey:[FBSDKDynamicFrameworkLoader loadkSecClass]];
    [query setObject:_service forKey:[FBSDKDynamicFrameworkLoader loadkSecAttrService]];
    [query setObject:key forKey:[FBSDKDynamicFrameworkLoader loadkSecAttrAccount]];
#if !TARGET_IPHONE_SIMULATOR
    if (_accessGroup) {
        [query setObject:_accessGroup forKey:[FBSDKDynamicFrameworkLoader loadkSecAttrAccessGroup]];
    }
#endif

    return query;
}

@end
