//
//  ViewController.swift
//  ScrollTableView
//


import UIKit

/// 用BringSubview来切换Touch的响应View, 没有实用价值
class BringSubviewVC: UIViewController,UIScrollViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var flowOut: UICollectionViewFlowLayout!
    @IBOutlet weak var myScrollView: UIScrollView!
    var myView:DetailView!
    var photoGallery = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        configurePhotoGallery()
        configureCollectionView()
        configureScrollView()
    }

    func configurePhotoGallery(){
        let image1 = UIImage(named: "img1")
        let image2 = UIImage(named: "img2")
        let image3 = UIImage(named: "img3")
        photoGallery.append(image1!)
        photoGallery.append(image2!)
        photoGallery.append(image3!)
    }
    
    func configureScrollView(){
        myView = Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)?[0] as! DetailView
        myView.frame = CGRect(x: 0, y: myCollectionView.frame.height, width: view.bounds.width, height: view.bounds.height + 500)
        myScrollView!.addSubview(myView)
        myScrollView?.delegate = self
        myScrollView?.showsVerticalScrollIndicator = true
        myScrollView!.contentSize = myView!.frame.size
        view.bringSubview(toFront: myCollectionView)
    }
    
    func configureCollectionView(){
        myCollectionView.dataSource = self
        myCollectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        flowOut.itemSize = CGSize(width: view.frame.width, height: CGFloat(200))
    }

    /// 当 scrollView did scroll myScrollView 覆盖 myCollectionView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.bringSubview(toFront: myScrollView)
        /// contentOffset 为0 myCollectionView 才可响应 touch
        if myScrollView.contentOffset.y == 0 {
            self.view.bringSubview(toFront: myCollectionView)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let image = photoGallery[indexPath.row]
        cell.photo.image = image
        return cell
    }

}


internal class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


internal class DetailView: UIView {
    @IBOutlet weak var myLabel: UILabel!
}
