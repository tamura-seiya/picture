//
//  SecondViewController.swift
//  Picture
//
//  Created by tamura seiya on 2015/12/04.
//  Copyright © 2015年 Seiya Tamura. All rights reserved.
//

import UIKit
import iAd
import CoreData

class SecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var myCollectionView : UICollectionView!
    var myValues2:[String] = []
    var albumCorrect2:String! //画像をソートするときに飛び出される数
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        read()
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        self.myValues2 = appDelegate.myValues //CollectionViewに表示する文字の配列
        
        print("myValues = \(appDelegate.myValues)")
                
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .Vertical
            layout.minimumInteritemSpacing = 3.0
            layout.minimumLineSpacing = 5.0
            layout.itemSize = CGSizeMake(self.view.frame.width / 2 - 10, self.view.frame.height / 3 - 10)
            layout.sectionInset = UIEdgeInsetsMake(20, 5, 10, 5)
        
        
                // CollectionViewを生成.
            myCollectionView = UICollectionView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height), collectionViewLayout: layout)
        
                // Cellに使われるクラスを登録.
            myCollectionView.registerClass(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        
            myCollectionView.delegate = self
            myCollectionView.dataSource = self
            myCollectionView.backgroundColor = UIColor.clearColor()
                print("myCollectionView")
                
            self.view.addSubview(myCollectionView)
        
            self.canDisplayBannerAds = true //iAdを出力

    }
    
    @IBAction func tapBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("Num: \(indexPath.row)")
        print("Value:\(collectionView)")
        
        
        albumCorrect2 = myValues2[indexPath.row]
        print("選択されたときのalbumCorrect = \(albumCorrect2)")
        //画像のPredicateのパスに入れる
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        appDelegate.albumCorrect = albumCorrect2
    
        
        let thirdViewController = ThirdViewController()
        
        // SecondViewに移動する.
        self.navigationController?.pushViewController(thirdViewController, animated: true)

    }
    
    /*
    Cellの総数を返す
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return myValues2.count
    }
    
    
    
    /*
    Cellに値を設定する
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : CustomCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("myCell",
            forIndexPath: indexPath) as! CustomCollectionViewCell
        
        //myValuesの画像のテキストを貼りつける
        cell.textLabel?.text = myValues2[indexPath.row]
        
        cell.backgroundColor = UIColor.blueColor()
        return cell
    }
    
    func read(){
        //Delegateを読み込む
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをAppdelegateから作成する
        let managedObjectContext = appDelegate.managedObjectContext
        
        //Entityを設定
        let entityDiscription = NSEntityDescription.entityForName("Picture", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Picture")
        fetchRequest.entity = entityDiscription
        
        //errorが発生した際にキャッチするための変数
        var error : NSError? = nil
        
        //フェッチリクエスト(データの検索と取得処理の実行)
        do {
            //Pictureの中の画像の数を抽出
            //resultsという配列に格納
            let predicate = NSPredicate(format: "%K = %@", "album","1回目") //PhotoKeysのパスが相違
            fetchRequest.predicate = predicate //場所を変える
            
            
            let results : NSArray = try managedObjectContext.executeFetchRequest(fetchRequest)
            print("Album内のデータの数 = \(results.count)")
            
            //////////////////predicate取得//////////////////////////////////////////////////
            
            for managedObject in results{
                
            let picture = managedObject as! Picture
            print("picture.albumのソートの数 = \(picture.cameraroll)")
                
            }
            
        } catch let error1 as NSError {
            error = error1
        }catch{
            print("Unknown Error")
        }
        
    }
    

    
}