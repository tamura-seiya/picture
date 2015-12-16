//
//  CustomCollectionViewCell.swift
//  Picture
//
//  Created by tamura seiya on 2015/11/17.
//  Copyright © 2015年 Seiya Tamura. All rights reserved.
//

import UIKit

class CustomCollectionViewCell : UICollectionViewCell{
    
    var textLabel : UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
    
        
        
        super.init(frame: frame)
        
        // UILabelを生成
        textLabel = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
        textLabel?.textAlignment = NSTextAlignment.Center
        textLabel?.font = UIFont(name: "ChalkboardSE-Light", size: 24)
        textLabel?.textColor = UIColor.whiteColor()
        //ArialHebrew AvenirNext-UltraLightItalic ChalkboardSE-Bold ChalkboardSE-Light Cochin Cochin-Italic
        //Courier
        
        // Cellに追加.
        self.contentView.addSubview(textLabel!)
        
    }
    
        
    
    
    
}
