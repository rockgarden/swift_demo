//
//  PhotoKitVC.swift
//  PhotoKit
//
// 参考：http://www.jianshu.com/p/42e5d2f75452 https://objccn.io/issue-21-4/
/// !使用 Photos 前要判断用户是否启用 icloud

import UIKit
import Photos

class PhotoKitVC: UIViewController {
    var albums : PHFetchResult<PHAssetCollection>!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    /// List Moments
    @IBAction func doButton(_ sender: Any) {
        checkForPhotoLibraryAccess{
            let opts = PHFetchOptions()
            let desc = NSSortDescriptor(key: "startDate", ascending: true)
            opts.sortDescriptors = [desc]
            let result = PHCollectionList.fetchCollectionLists(with:
                .momentList, subtype: .momentListYear, options: opts)
            for ix in 0..<result.count {
                let list = result[ix]
                let f = DateFormatter()
                f.dateFormat = "yyyy"
                print(f.string(from:list.startDate!))
                // return;
                if list.collectionListType == .momentList {
                    let result = PHAssetCollection.fetchMoments(inMomentList:list, options: nil)
                    for ix in 0 ..< result.count {
                        let coll = result[ix]
                        if ix == 0 {
                            print("======= \(result.count) clusters")
                        }
                        f.dateFormat = ("yyyy-MM-dd")
                        print("starting \(f.string(from:coll.startDate!)): " + "\(coll.estimatedAssetCount)")
                    }
                }
                print("\n")
            }
        }
    }

    /// List Albums
    // in iOS 10: .album - nothing, so use .smartAlbum or .moment
    @IBAction func doButton2(_ sender: Any) {
        checkForPhotoLibraryAccess {
            var result = PHAssetCollection.fetchAssetCollections(with:
                // let's examine albums synced onto the device from iPhoto
                .album, subtype: .albumSyncedAlbum, options: nil)
            if result.count == 0 {
                // 若没有 启用 icloud 则 获取 .albumRegular
                result = PHAssetCollection.fetchAssetCollections(with:
                    .album, subtype: .albumRegular, options: nil)
            }
            for ix in 0 ..< result.count {
                let album = result[ix]
                print("\(String(describing: album.localizedTitle)): " +
                    "approximately \(album.estimatedAssetCount) photos")
            }
        }
    }

    /// List Photos in One Album
    // 是否使用 albumSyncedAlbum 与 是否启用 icloud 相关
    @IBAction func doButton3(_ sender: Any) {
        checkForPhotoLibraryAccess {
            let alert = UIAlertController(title: "Pick an album:", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            var result = PHAssetCollection.fetchAssetCollections(with:
                .album, subtype: .albumSyncedAlbum, options: nil)
            if result.count == 0 {
                result = PHAssetCollection.fetchAssetCollections(with:
                    .album, subtype: .albumRegular, options: nil)
            }
            for ix in 0 ..< result.count {
                let album = result[ix]
                var title = "title"
                if album.localizedTitle != nil { title = album.localizedTitle! }
                alert.addAction(UIAlertAction(title: title, style: .default) {
                    (_:UIAlertAction!) in
                    let result = PHAsset.fetchAssets(in:album, options: nil)
                    for ix in 0 ..< result.count {
                        let asset = result[ix]
                        print(asset.localIdentifier)
                    }
                })
            }
            self.present(alert, animated: true)
            if let pop = alert.popoverPresentationController {
                if let v = sender as? UIView {
                    pop.sourceView = v
                    pop.sourceRect = v.bounds
                }
            }
        }
    }

    /// Create Album
    var newAlbumId : String?
    @IBAction func doButton4(_ sender: Any) {
        checkForPhotoLibraryAccess {

            // modification of the library
            // all modifications operate through their own "changeRequest" class
            // so, for example, to create or delete a PHAssetCollection,
            // or to alter what assets it contains,
            // we need a PHAssetCollectionChangeRequest
            // we can use this only inside a PHPhotoLibrary `performChanges` block

            var which : Int {return 2}
            switch which {
            case 1:
                PHPhotoLibrary.shared().performChanges({
                    let t = "TestAlbum"
                    typealias Req = PHAssetCollectionChangeRequest
                    Req.creationRequestForAssetCollection(withTitle:t)
                })
            case 2:
                var ph : PHObjectPlaceholder?
                PHPhotoLibrary.shared().performChanges({
                    let t = "TestAlbum"
                    typealias Req = PHAssetCollectionChangeRequest
                    let cr = Req.creationRequestForAssetCollection(withTitle:t)
                    ph = cr.placeholderForCreatedAssetCollection
                }) { ok, err in
                    // completion may take some considerable time (asynchronous)
                    print("created TestAlbum: \(ok)")
                    if ok, let ph = ph {
                        print("and its id is \(ph.localIdentifier)")
                        self.newAlbumId = ph.localIdentifier
                    }
                }
            default: break
            }
        }
    }

    /// Add Photo to Created Album
    @IBAction func doButton5(_ sender: Any) {

        checkForPhotoLibraryAccess {
            PHPhotoLibrary.shared().register(self as PHPhotoLibraryChangeObserver) // *

            let opts = PHFetchOptions()
            opts.wantsIncrementalChangeDetails = false
            // use this opts to prevent extra PHChange messages

            // imagine first that we are displaying a list of all regular albums...
            // ... so have performed a fetch request and are hanging on to the result
            let alb = PHAssetCollection.fetchAssetCollections(with:
                .album, subtype: .albumRegular, options: nil)
            self.albums = alb

            // find Recently Added smart album
            let result = PHAssetCollection.fetchAssetCollections(with:
                .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: opts)
            guard let rec = result.firstObject else {
                print("no recently added album")
                return
            }
            // find its first asset
            let result2 = PHAsset.fetchAssets(in:rec, options: opts)
            guard let asset1 = result2.firstObject else {
                print("no first item in recently added album")
                return
            }
            // find our newly created album by its local id
            debugPrint(self.newAlbumId as Any)
            guard self.newAlbumId != nil else {return}
            let result3 = PHAssetCollection.fetchAssetCollections(
                withLocalIdentifiers: [self.newAlbumId!], options: opts)
            guard let alb2 = result3.firstObject else {
                print("no target album")
                return
            }

            PHPhotoLibrary.shared().performChanges({
                typealias Req = PHAssetCollectionChangeRequest
                let cr = Req(for: alb2)
                cr?.addAssets([asset1] as NSArray)
            }) {
                // completion may take some considerable time (asynchronous)
                (ok:Bool, err:Error?) in
                print("added it: \(ok)")
            }
        }
    }
}

extension PhotoKitVC : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInfo: PHChange) {
        if self.albums !== nil {
            let details = changeInfo.changeDetails(for:self.albums)
            print(details as Any)
            if details !== nil {
                self.albums = details!.fetchResultAfterChanges
                // ... and adjust interface if needed ...
            }
        }
    }
}

