//
//  ViewController.swift
//  Picture
//
//  Created by tamura seiya on 2015/11/02.
//  Copyright (c) 2015年 Seiya Tamura. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    var myLabel:UILabel!
    var view1:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        view1 = UIView(frame: self.view.frame)
        view1.backgroundColor = UIColor.orangeColor()
        view1.layer.position = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        self.view.addSubview(view1)
        
         //scrollViewを定義
         self.scrollView?.contentSize = CGSizeMake(self.scrollView.frame.width * 3, self.scrollView.frame.size.height)
        
        // １ページ単位でスクロールさせる
        scrollView.pagingEnabled = true
        
        //scroll画面の初期位置
        scrollView.contentOffset = CGPointMake(0, 0);

        
        view1 = UIView(frame: self.view.frame)
        view1.backgroundColor = UIColor.orangeColor()
        view1.layer.position = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        self.view.addSubview(view1)
        
        
        //labelを生成
        myLabel = UILabel(frame: CGRectMake(0,0,200,50))
        myLabel.backgroundColor = UIColor.orangeColor()
        myLabel.layer.masksToBounds = true
        myLabel.layer.cornerRadius = 20.0
        myLabel.text = "Hello Swift!!"
        myLabel.textColor = UIColor.whiteColor()
        myLabel.shadowColor = UIColor.grayColor()
        myLabel.textAlignment = NSTextAlignment.Center
        
        // 座標設定
        myLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 200)
        
        // Viewの背景色を青にする.
        self.view.backgroundColor = UIColor.cyanColor()

        self.view.addSubview(myLabel)
        
        
        //上へのスワイプを定義
        var upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        upSwipe.direction = .Up
        
        //下へのスワイプを定義
        var downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        downSwipe.direction = .Down
        
        //leftSwipeで足す
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //ここでswipeGestureを定義
    func handleSwipes(sender: UISwipeGestureRecognizer){
        if (sender.direction == .Up){
            myLabel.text = "aa"
        }else if (sender.direction == .Down){
            myLabel.text = "bb"
        }else{
            myLabel.text = "cc"
        }
    }
}

