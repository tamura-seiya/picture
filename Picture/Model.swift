//
//  Picture.swift
//  CameracameraSample
//
//  Created by tamura seiya on 2015/11/11.
//  Copyright (c) 2015年 Seiya Tamura. All rights reserved.
//

import Foundation
import CoreData

class Picture: NSManagedObject {
    
    @NSManaged var cameraroll: String
    @NSManaged var cameraclass: String
    
}
