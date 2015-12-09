//
//  CustomCollectionTableViewCell.swift
//  Picture
//
//  Created by tamura seiya on 2015/12/07.
//  Copyright © 2015年 Seiya Tamura. All rights reserved.
//

import UIKit

class CustomCollectionTableViewCell: UICollectionViewCell {
    
    var imgView : UIImageView?

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        
        super.init(frame: frame)
        // ... and then the rest of the code
        
        self.contentView.addSubview(imgView!)
        
                
    }

}
