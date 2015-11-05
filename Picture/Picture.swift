//
//  Picture.swift
//  Picture
//
//  Created by tamura seiya on 2015/11/05.
//  Copyright (c) 2015年 Seiya Tamura. All rights reserved.
//

import Foundation
import CoreData

class Picture: NSManagedObject {

    @NSManaged var cameraRoll: NSData
    @NSManaged var tinderPic: NSData
    @NSManaged var album: NSData

}
