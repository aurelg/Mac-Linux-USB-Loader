//
//  SBEnterpriseConfigurationWriter.m
//  Mac Linux USB Loader
//
//  Created by SevenBits on 10/24/14.
//  Copyright (c) 2014 SevenBits. All rights reserved.
//

#import "SBEnterpriseConfigurationWriter.h"
#import "SBAppDelegate.h"

@implementation SBEnterpriseConfigurationWriter

+ (void)writeConfigurationFileAtUSB:(SBUSBDevice *)device distributionFamily:(SBLinuxDistribution)family isMacUbuntu:(BOOL)isMacUbuntu containsLegacyUbuntuVersion:(BOOL)containsLegacyUbuntu {
	NSString *path = [device.path stringByAppendingPathComponent:@"/efi/boot/.MLUL-Live-USB"];
	NSMutableString *string = [NSMutableString stringWithCapacity:30];
	[string appendString:@"#This file is machine generated. Do not modify it unless you know what you are doing.\n\n"];
	[string appendFormat:@"entry %@\n", [SBAppDelegate distributionStringForEquivalentEnum:family]];
	[string appendFormat:@"family %@\n", [SBAppDelegate distributionStringForEquivalentEnum:family]];

	if (family == SBDistributionUbuntu && (isMacUbuntu || containsLegacyUbuntu)) {
		NSMutableString *kernelString = [NSMutableString stringWithString:@"kernel "];

		if (isMacUbuntu) {
			[kernelString appendString:@"/casper/vmlinuz "];
		} else if (containsLegacyUbuntu) {
			[kernelString appendString:@"file=/cdrom/preseed/ubuntu.seed "];
		}

		[kernelString appendString:@"\n"];
		[string appendString:kernelString];
	}

	[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	[string writeToFile:path atomically:NO encoding:NSASCIIStringEncoding error:nil];
}

@end