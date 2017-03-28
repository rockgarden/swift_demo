//
//  ViewController.swift
//  WaterFlow
//

import UIKit

class ELWaterFlowLayoutVC: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource , ELWaterFlowLayoutDelegate{

    let heightArr : [CGFloat] = [30.0,20.0,10.0,9.0,70.0,50.0,66.0,45.0,78.0,90.0,100.0,30.0,20.0,10.0,9.0,70.0,50.0,66.0,45.0,78.0,90.0,100.0,30.0,20.0,10.0,9.0,70.0,50.0,66.0,45.0,78.0,90.0,100.0,30.0,20.0,10.0,9.0,70.0,50.0,66.0,45.0,78.0,90.0,100.0,30.0,20.0,10.0,9.0,70.0,50.0,66.0,45.0,78.0,90.0,100.0,30.0,20.0,10.0,9.0,70.0,50.0,66.0,45.0,78.0,90.0,100.0,30.0,20.0,10.0,9.0,70.0,50.0,66.0,45.0,78.0,90.0,100.0,30.0,20.0,10.0,9.0,70.0,50.0,66.0,45.0,78.0,90.0,100.0,30.0,20.0,10.0,9.0,70.0,50.0,66.0,45.0,78.0,90.0,100.0,30.0,20.0,10.0,9.0,70.0,50.0,66.0,45.0,78.0,90.0,100.0]

    lazy var flowLayout : ELWaterFlowLayout = ELWaterFlowLayout()

    var collectionView : UICollectionView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()

    }

    fileprivate func setupView() {
        collectionView = UICollectionView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 200)) , collectionViewLayout:self.flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        self.flowLayout.delegate = self
        collectionView.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(collectionView)
    }

    func el_flowLayout(_ flowLayout: ELWaterFlowLayout, heightForRowAt index: Int) -> CGFloat {
        return heightArr[index]
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heightArr.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TestCollectionViewCell
        //        cell.titleLabel.text = "\(indexPath.row)"
        return cell
    }

    @IBAction func lineCountChanged(_ sender: UISlider) {
        if self.flowLayout.lineCount != UInt(sender.value) {
            self.flowLayout.lineCount = UInt(sender.value)
        }
    }

    @IBAction func vSpaceChanged(_ sender: UISlider) {
        self.flowLayout.vItemSpace = CGFloat(sender.value)
    }

    @IBAction func hSpaceChanged(_ sender: UISlider) {
        self.flowLayout.hItemSpace = CGFloat(sender.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


fileprivate class TestCollectionViewCell: UICollectionViewCell {
    var titleLabel : UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel(frame: frame)
        titleLabel.textColor = UIColor.black
        //        titleLabel.text = "title"
        self.addSubview(titleLabel)


        let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
        let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let colorRun = UIColor.init(red:red, green:green, blue:blue , alpha: 1)

        self.backgroundColor = colorRun
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
}

