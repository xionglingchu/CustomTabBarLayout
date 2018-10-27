//
//  Video.swift
//  CustomNavBar
//
//  Created by 刘敏 on 2018/10/26.
//  Copyright © 2018 刘敏. All rights reserved.
//

import UIKit

class Video: NSObject {
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    
    var channel: Channel?
}

class Channel: NSObject {
    var name: String?
    var profileImageName: String?
    
    
}
