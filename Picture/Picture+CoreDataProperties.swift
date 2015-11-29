//
//  Picture+CoreDataProperties.swift
//  Picture
//
//  Created by tamura seiya on 2015/11/25.
//  Copyright © 2015年 Seiya Tamura. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Picture {

    @NSManaged var album: String?
    @NSManaged var cameraroll: String?

}
