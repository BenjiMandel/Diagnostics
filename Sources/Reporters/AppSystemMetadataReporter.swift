//
//  AppSystemMetadataReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation
import CoreTelephony

/// Reports App and System specific metadata like OS and App version.
public struct AppSystemMetadataReporter: DiagnosticsReporting {
    
    public enum MetadataKey: String, CaseIterable {
        case appName = "App name"
        case appDisplayName = "App Display Name"
        case appVersion = "App version"
        case device = "Device"
        case system = "System"
        case freeSpace = "Free space"
        case deviceLanguage = "Device Language"
        case appLanguage = "App Language"
        case cellularAllowed = "Cellular Allowed"
    }
    
    static let hardwareName: [String: String] = [
        "iPhone7,1": "iPhone 6 Plus",
        "iPhone7,2": "iPhone 6",
        "iPhone8,1": "iPhone 6s",
        "iPhone8,2": "iPhone 6s Plus",
        "iPhone8,4": "iPhone SE",
        "iPhone9,1": "iPhone 7",
        "iPhone9,2": "iPhone 7 Plus",
        "iPhone9,3": "iPhone 7",
        "iPhone9,4": "iPhone 7 Plus",
        "iPhone10,1": "iPhone 8",
        "iPhone10,2": "iPhone 8 Plus",
        "iPhone10,3": "iPhone X",
        "iPhone10,4": "iPhone 8",
        "iPhone10,5": "iPhone 8 Plus",
        "iPhone10,6": "iPhone X",
        "iPhone11,2": "iPhone XS",
        "iPhone11,4": "iPhone XS Max",
        "iPhone11,6": "iPhone XS Max",
        "iPhone11,8": "iPhone XR",
        "iPhone12,1": "iPhone 11",
        "iPhone12,3": "iPhone 11 Pro",
        "iPhone12,5": "iPhone 11 Pro Max",
        "iPhone12,8" : "iPhone SE 2nd Gen",
        "iPhone13,1" : "iPhone 12 Mini",
        "iPhone13,2" : "iPhone 12",
        "iPhone13,3" : "iPhone 12 Pro",
        "iPhone13,4" : "iPhone 12 Pro Max",
        "iPhone14,2" : "iPhone 13 Pro",
        "iPhone14,3" : "iPhone 13 Pro Max",
        "iPhone14,4" : "iPhone 13 Mini",
        "iPhone14,5" : "iPhone 13",
        "iPhone14,6" : "iPhone SE 3rd Gen",
        "iPhone14,7" : "iPhone 14",
        "iPhone14,8" : "iPhone 14 Plus",
        "iPhone15,2" : "iPhone 14 Pro",
        "iPhone15,3" : "iPhone 14 Pro Max",
        
        //MARK: - iPod Touch
        "iPod9,1" : "7th Gen iPod",
        "iPod7,1" : "6th Gen iPod",
        
        //MARK: - iPad
        
        "iPad5,1"   : "iPad mini 4 (WiFi)",
        "iPad5,2"   : "4th Gen iPad mini (WiFi+Cellular)",
        "iPad5,3"   : "iPad Air 2 (WiFi)",
        "iPad5,4"   : "iPad Air 2 (Cellular)",
        "iPad6,3"   : "iPad Pro (9.7 inch, WiFi)",
        "iPad6,4"   : "iPad Pro (9.7 inch, WiFi+LTE)",
        "iPad6,7"   : "iPad Pro (12.9 inch, WiFi)",
        "iPad6,8"   : "iPad Pro (12.9 inch, WiFi+LTE)",
        "iPad6,11"  : "iPad (2017)",
        "iPad6,12"  : "iPad (2017)",
        "iPad7,1"   : "iPad Pro 2nd Gen (WiFi)",
        "iPad7,2"   : "iPad Pro 2nd Gen (WiFi+Cellular)",
        "iPad7,3"   : "iPad Pro 10.5-inch 2nd Gen",
        "iPad7,4"   : "iPad Pro 10.5-inch 2nd Gen",
        "iPad7,5"   : "iPad 6th Gen (WiFi)",
        "iPad7,6"   : "iPad 6th Gen (WiFi+Cellular)",
        "iPad7,11"  : "iPad 7th Gen 10.2-inch (WiFi)",
        "iPad7,12"  : "iPad 7th Gen 10.2-inch (WiFi+Cellular)",
        "iPad8,1"   : "iPad Pro 11 inch 3rd Gen (WiFi)",
        "iPad8,2"   : "iPad Pro 11 inch 3rd Gen (1TB, WiFi)",
        "iPad8,3"   : "iPad Pro 11 inch 3rd Gen (WiFi+Cellular)",
        "iPad8,4"   : "iPad Pro 11 inch 3rd Gen (1TB, WiFi+Cellular)",
        "iPad8,5"   : "iPad Pro 12.9 inch 3rd Gen (WiFi)",
        "iPad8,6"   : "iPad Pro 12.9 inch 3rd Gen (1TB, WiFi)",
        "iPad8,7"   : "iPad Pro 12.9 inch 3rd Gen (WiFi+Cellular)",
        "iPad8,8"   : "iPad Pro 12.9 inch 3rd Gen (1TB, WiFi+Cellular)",
        "iPad8,9"   : "iPad Pro 11 inch 4th Gen (WiFi)",
        "iPad8,10"  : "iPad Pro 11 inch 4th Gen (WiFi+Cellular)",
        "iPad8,11"  : "iPad Pro 12.9 inch 4th Gen (WiFi)",
        "iPad8,12"  : "iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)",
        "iPad11,1"  : "iPad mini 5th Gen (WiFi)",
        "iPad11,2"  : "iPad mini 5th Gen",
        "iPad11,3"  : "iPad Air 3rd Gen (WiFi)",
        "iPad11,4"  : "iPad Air 3rd Gen",
        "iPad11,6"  : "iPad 8th Gen (WiFi)",
        "iPad11,7"  : "iPad 8th Gen (WiFi+Cellular)",
        "iPad12,1"  : "iPad 9th Gen (WiFi)",
        "iPad12,2"  : "iPad 9th Gen (WiFi+Cellular)",
        "iPad14,1"  : "iPad mini 6th Gen (WiFi)",
        "iPad14,2"  : "iPad mini 6th Gen (WiFi+Cellular)",
        "iPad13,1"  : "iPad Air 4th Gen (WiFi)",
        "iPad13,2"  : "iPad Air 4th Gen (WiFi+Cellular)",
        "iPad13,4"  : "iPad Pro 11 inch 5th Gen",
        "iPad13,5"  : "iPad Pro 11 inch 5th Gen",
        "iPad13,6"  : "iPad Pro 11 inch 5th Gen",
        "iPad13,7"  : "iPad Pro 11 inch 5th Gen",
        "iPad13,8"  : "iPad Pro 12.9 inch 5th Gen",
        "iPad13,9"  : "iPad Pro 12.9 inch 5th Gen",
        "iPad13,10" : "iPad Pro 12.9 inch 5th Gen",
        "iPad13,11" : "iPad Pro 12.9 inch 5th Gen",
        "iPad13,16" : "iPad Air 5th Gen (WiFi)",
        "iPad13,17" : "iPad Air 5th Gen (WiFi+Cellular)",
        
        //MARK - Apple Watch
        
        "Watch3,1 " : "Apple Watch Series 3 38mm case (GPS+Cellular)",
        "Watch3,2 " : "Apple Watch Series 3 42mm case (GPS+Cellular)",
        "Watch3,3 " : "Apple Watch Series 3 38mm case (GPS)",
        "Watch3,4 " : "Apple Watch Series 3 42mm case (GPS)",
        "Watch4,1 " : "Apple Watch Series 4 40mm case (GPS)",
        "Watch4,2 " : "Apple Watch Series 4 44mm case (GPS)",
        "Watch4,3 " : "Apple Watch Series 4 40mm case (GPS+Cellular)",
        "Watch4,4 " : "Apple Watch Series 4 44mm case (GPS+Cellular)",
        "Watch5,1 " : "Apple Watch Series 5 40mm case (GPS)",
        "Watch5,2 " : "Apple Watch Series 5 44mm case (GPS)",
        "Watch5,3 " : "Apple Watch Series 5 40mm case (GPS+Cellular)",
        "Watch5,4 " : "Apple Watch Series 5 44mm case (GPS+Cellular)",
        "Watch5,9 " : "Apple Watch SE 40mm case (GPS)",
        "Watch5,10" : "Apple Watch SE 44mm case (GPS)",
        "Watch5,11" : "Apple Watch SE 40mm case (GPS+Cellular)",
        "Watch5,12" : "Apple Watch SE 44mm case (GPS+Cellular)",
        "Watch6,1 " : "Apple Watch Series 6 40mm case (GPS)",
        "Watch6,2 " : "Apple Watch Series 6 44mm case (GPS)",
        "Watch6,3 " : "Apple Watch Series 6 40mm case (GPS+Cellular)",
        "Watch6,4 " : "Apple Watch Series 6 44mm case (GPS+Cellular)",
        "Watch6,6 " : "Apple Watch Series 7 41mm case (GPS)",
        "Watch6,7 " : "Apple Watch Series 7 45mm case (GPS)",
        "Watch6,8 " : "Apple Watch Series 7 41mm case (GPS+Cellular)",
        "Watch6,9 " : "Apple Watch Series 7 45mm case (GPS+Cellular)",
        "Watch6,10" : "Apple Watch SE 40mm case (GPS)",
        "Watch6,11" : "Apple Watch SE 44mm case (GPS)",
        "Watch6,12" : "Apple Watch SE 40mm case (GPS+Cellular)",
        "Watch6,13" : "Apple Watch SE 44mm case (GPS+Cellular)",
        "Watch6,14" : "Apple Watch Series 8 40mm case (GPS)",
        "Watch6,15" : "Apple Watch Series 8 44mm case (GPS)",
        "Watch6,16" : "Apple Watch Series 8 40mm case (GPS+Cellular)",
        "Watch6,17" : "Apple Watch Series 8 44mm case (GPS+Cellular)",
        "Watch6,18" : "Apple Watch Ultra",
    ]
    
    let title: String = "App & System Details"
    var diagnostics: [String: String] {
        var systemInfo = utsname()
        uname(&systemInfo)
        var hardware = Mirror(reflecting: systemInfo.machine).children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        if let hardwareName = Self.hardwareName[hardware] {
            hardware += " (\(hardwareName))"
        }
        
        let system = "\(Device.systemName) \(Device.systemVersion)"
        
        var metadata: [String: String] = [
            MetadataKey.appName.rawValue: Bundle.appName,
            MetadataKey.appDisplayName.rawValue: Bundle.appDisplayName,
            MetadataKey.appVersion.rawValue: "\(Bundle.appVersion) (\(Bundle.appBuildNumber))",
            MetadataKey.device.rawValue: hardware,
            MetadataKey.system.rawValue: system,
            MetadataKey.freeSpace.rawValue: "\(Device.freeDiskSpace) of \(Device.totalDiskSpace)",
            MetadataKey.deviceLanguage.rawValue: Locale.current.languageCode ?? "Unknown",
            MetadataKey.appLanguage.rawValue: Locale.preferredLanguages[0]
        ]
#if os(iOS) && !targetEnvironment(macCatalyst)
        let cellularData = CTCellularData()
        metadata[MetadataKey.cellularAllowed.rawValue] = "\(cellularData.restrictedState)"
#endif
        return metadata
    }
    
    public func report() -> DiagnosticsChapter {
        return DiagnosticsChapter(title: title, diagnostics: diagnostics)
    }
}

#if os(iOS) && !targetEnvironment(macCatalyst)
extension CTCellularDataRestrictedState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .restricted:
            return "Restricted"
        case .notRestricted:
            return "Not restricted"
        default:
            return "Unknown"
        }
    }
}
#endif
