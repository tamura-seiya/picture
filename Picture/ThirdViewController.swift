//
//  ThirdViewController.swift
//  Picture
//
//  Created by tamura seiya on 2015/12/06.
//  Copyright © 2015年 Seiya Tamura. All rights reserved.
//

import UIKit
import Photos
import CoreData


class ThirdViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var myCollectionView : UICollectionView!
    var albumCorrect3:String!
    var photosCollectionView: [PHAsset] = []
    var imageCollectionView:[UIImage] = []
    var stringAry :[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ThirdViewController")
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        albumCorrect3 = appDelegate.albumCorrect //初期転換
        print("albumCorrect3 = \(albumCorrect3)")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 3.0
        layout.minimumLineSpacing = 5.0
        layout.itemSize = CGSizeMake(self.view.frame.width / 2 - 10, self.view.frame.height / 3 - 10)
        
        ////////////////////////////////////////////
        
        self.readColloctionView()
    
        self.imageCollectionViewAppear()
        
        ////////////////////////////////////////////
        
        // CollectionViewを生成.
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        // Cellに使われるクラスを登録.
        myCollectionView.registerClass(CustomCollectionTableViewCell.self, forCellWithReuseIdentifier: "MyCell")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        self.view.addSubview(myCollectionView)
        
    }
    
    func readColloctionView(){
        //Delegateを読み込む
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをAppdelegateから作成する
        let managedObjectContext = appDelegate.managedObjectContext
        
        //Entityを設定
        let entityDiscription = NSEntityDescription.entityForName("Picture", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Picture")
        fetchRequest.entity = entityDiscription
        
        //predicateでソートしたい、配列の並列の中身の確認
        let predicate = NSPredicate(format: "%K = %@", "album",albumCorrect3)
        fetchRequest.predicate = predicate

        //Predicate問題確定
        do{
            let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            print("fetchResults.count = \(fetchResults?.count)")
 
            for managedObject in fetchResults!{
                
                let picture = managedObject as! Picture
                
                //画像を表示させる
                let filePath: String = picture.cameraroll!
                
                let fileUrl = NSURL(string:filePath)
                
                var imageData = PHAssetForFileURL(fileUrl!)
                photosCollectionView.append(imageData!) //Phassetを配列に入れる
         }
            
        }catch{
            print("could not catch")
        }
    
        
    }
    
    func PHAssetForFileURL(url: NSURL) -> PHAsset? {
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.version = .Current
        imageRequestOptions.deliveryMode = .HighQualityFormat
        imageRequestOptions.resizeMode = .Fast
        imageRequestOptions.synchronous = true
        
        let fetchResult = PHAsset.fetchAssetsWithOptions(nil)
        for var index = 0; index < fetchResult.count; index++ {
            if let asset = fetchResult[index] as? PHAsset {
                var found = false
                PHImageManager.defaultManager().requestImageDataForAsset(asset,
                    options: imageRequestOptions) { (_, _, _, info) in
                        if let urlkey = info!["PHImageFileURLKey"] as? NSURL {
                            if urlkey.absoluteString == url.absoluteString {
                                found = true
                            }
                        }
                }
                if (found) {
                    return asset
                }
            }
        }
        
        return nil
    }
    
    func imageCollectionViewAppear() {
        //PHAssetをUIImageに変換して、画像の配列を作る
        
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.version = .Current
        imageRequestOptions.deliveryMode = .HighQualityFormat
        imageRequestOptions.resizeMode = .Fast
        imageRequestOptions.synchronous = true

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {

        for (var i = 0;i < self.photosCollectionView.count ; i++){
            
            let phimgr:PHImageManager = PHImageManager();
            phimgr.requestImageForAsset(self.photosCollectionView[i],
                targetSize: CGSize(width: 320, height: 320),
                contentMode: .AspectFill, options: imageRequestOptions) {
                    image, info in
                    //ここでUIImageを取得します。
                    self.imageCollectionView.append(image!)  //UIImageを配列に取得する
                    self.myCollectionView.reloadData() //読み込み直す
            }
            
            self.myCollectionView.reloadData() //読み込み直す
        }
    
        })
    }


    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("Num: \(indexPath.row)")
        print("Value:\(collectionView)")
        
    }
    
    /*
    Cellの総数を返す
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollectionView.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : CustomCollectionTableViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell",
            forIndexPath: indexPath) as! CustomCollectionTableViewCell

        // imabeviewを生成 (cgrectmakeで位置とサイズを指定するときにcellを親に考える)
    
        cell.imgView?.image = imageCollectionView[indexPath.row]
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    
}