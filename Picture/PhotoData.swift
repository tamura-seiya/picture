//
//  Picture.swift
//  
//
//  Created by tamura seiya on 2015/11/05.
//
//

import Foundation
import CoreData

class Picture: NSManagedObject {

    @NSManaged var cameraRoll: NSData
    @NSManaged var tinderPic: NSData
    @NSManaged var album: NSData

}
