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

class ThirdViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var myCollectionView : UICollectionView!
    var number:UInt32!
    
    var hennsuu = 10
    var count2 = 0
    var albumCorrect3:String!
    var photosCollectionView: [PHAsset] = []
    
    var imageCollectionView:[UIImage] = []
    var stringAry :[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ThirdViewController")
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        albumCorrect3 = appDelegate.albumCorrect //初期転換
        print("albumCorrect3 = \(albumCorrect3)")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 3.0
        layout.minimumLineSpacing = 5.0
        layout.itemSize = CGSizeMake(self.view.frame.width / 2 - 10, self.view.frame.height / 3 - 10)
        
        ////////////////////////////////////////////
        readColloctionView()
        imageCollectionViewAppear()
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
            
//            //predicateを外したら、全て取得する
//            let predicate = NSPredicate(format: "%K = %@", "album",albumCorrect3)
//            fetchRequest.predicate = predicate
            
//            for managedObject in fetchResults!{
//                print("fetchResult[i] as! PHAsset = \(managedObject)")
//                
////                let managedObject = fetchResults as! PHAsset
//                let managedObject = PHAsset.fetchAssetsWithOptions(nil)
//                
//                photosCollectionView.append(managedObject as! PHAsset)
//                print("fetchResult[i] as! PHAsset = \(managedObject)")
//
////                picture.album = rightSelectPicker
////                print("rightselectPickerString = \(rightSelectPicker)")
//                
//            }
            for managedObject in fetchResults!{
                
                let picture = managedObject as! Picture
                
                //画像を表示させる
                let filePath: String = picture.cameraroll!
                
                let fileUrl = NSURL(string:filePath)
                
                var imageData = PHAssetForFileURL(fileUrl!)
                photosCollectionView.append(imageData!) //Phassetを配列に入れる
                //            let fetchResult : PHFetchResult = PHAsset.fetchAssetsWithOptions(fetchResults!)
            }
            
            
//            photosCollectionView = [getAssets:fetchMax]
//            
//            photosCollectionView =
//            
//            let results = PHAsset.
//            (.Image, options: nil)
//            var assets: [PHAsset] = []
//            results.enumerateObjectsUsingBlock { (object, _, _) in
//                if let asset = object as? PHAsset {
//                    assets.append(asset)
//                }
//            }
//
//            //ソートできていない
//            for (var i = 0; i < 10; i++){ //検出した数の文だけ回す
//                
//                let fetchResult = PHAsset.fetchAssetsWithOptions(nil)
//                
//                photosCollectionView.append(fetchResult[i] as! PHAsset)
//                print("fetchResult[i] as! PHAsset = \(fetchResult[i] as! PHAsset)")
//            
//            }
            
//            for managedObject in fetchResults!{
//                
//                                    if count1 == 10 {
//                                         break
//                                    }
//                
//                                    count1++
//                
//                                    let picture = managedObject as! Picture
//                
//                
//                                    //画像を表示させる
//                                    let filePath: String = picture.cameraroll!
//                                    print(filePath)
//                                    let fileUrl = NSURL(string:filePath)
//                                    
//                                    //PHAssetUrl取得
//                                    PHAssetForFileURL(fileUrl!)
//                                
//                                    appDelegate.saveContext()
//            }

            
            
        }catch{
            print("could not catch")
        }
        
    }
    
    func PHAssetForFileURL(url: NSURL) -> PHAsset? {
        var imageRequestOptions = PHImageRequestOptions()
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
        
        var imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.version = .Current
        imageRequestOptions.deliveryMode = .HighQualityFormat
        imageRequestOptions.resizeMode = .Fast
        imageRequestOptions.synchronous = true

        
        for (var i = 0;i < photosCollectionView.count ; i++){
            
            
            let phimgr:PHImageManager = PHImageManager();
            phimgr.requestImageForAsset(photosCollectionView[i],
                targetSize: CGSize(width: 320, height: 320),
                contentMode: .AspectFill, options: imageRequestOptions) {
                    image, info in
                    //ここでUIImageを取得します。
                    self.imageCollectionView.append(image!)  //UIImageを配列に取得する
                    
            }
        }
    }

    
    
    /*
    Cellが選択された際に呼び出される
    */
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