//
//  MultiImageGridVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 29/09/21.
//

import UIKit

extension MultiImageGridVC {
    static func instantiate() -> MultiImageGridVC {
        StoryBoardConstants.popup.instantiateViewController(withIdentifier: String(describing: MultiImageGridVC.self)) as! MultiImageGridVC
    }
}

class MultiImageGridVC: UIViewController {
    
    @IBOutlet weak var uiViewToolBar: ToolBar!
    
    @IBOutlet weak var collectionViewImage: UICollectionView!
    
    private let cellHeight:Double = 135
    
    //var dataSource: [UpcomingOrderResponsePrescriptionImage] = []
    var mediaDataSource: [MediaData] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    func setUpViews() {
        uiViewToolBar.delegate = self
        uiViewToolBar.btnClearAll.isHidden = true
        uiViewToolBar.btnSearch.isHidden = true
        uiViewToolBar.labelTitle.isHidden = true
        registerNib()
        setFlowLayout()
    }
    
    func setFlowLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        self.collectionViewImage.collectionViewLayout = layout
    }
    
    func registerNib() {
        collectionViewImage.register(
            UINib.init(
                nibName: "PrescriptionGridCell",
                bundle: nil
            ),
            forCellWithReuseIdentifier: "PrescriptionGridCell"
        )
    }
}

extension MultiImageGridVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if !mediaDataSource.isEmpty {
            return mediaDataSource.count
        } else {
            return 0//dataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrescriptionGridCell", for: indexPath) as! PrescriptionGridCell
        
        cell.currentIndex = indexPath.row
        
        if !mediaDataSource.isEmpty {
            cell.mediaData = mediaDataSource[indexPath.row]
        } else {
            //cell.imageData = dataSource[indexPath.row]
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell:PrescriptionGridCell = collectionView.cellForItem(at: indexPath) as! PrescriptionGridCell
        
        if !mediaDataSource.isEmpty {
            
            if let media = cell.mediaData {
                
                if media.fileType == .pdf {
                    
                    if let pdfData = media.pdfData {
                        let vc = PDFViewerVC.instantiate()
                        vc.localData = pdfData
                        present(vc, animated: true, completion: nil)
                    }
                    
                } else {
                    
                    if let image = media.image {
                        let vc = FullScreenVC.instantiate()
                        vc.image = image
                        present(vc, animated: true, completion: nil)
                    }
                    
                }
                
            }
            
        } else {
            if let img = cell.imageViewPrescription.image {
                let vc = FullScreenVC.instantiate()
                vc.image = img
                present(vc, animated: true, completion: nil)
            }
        }
    
    }
    
}

extension MultiImageGridVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Here, I need 3 equal cells occupying whole screen width so i divided it by 3.0. You can use as per your need.
        let width = ((UIScreen.main.bounds.size.width/3.0) - 16)
        let height = (width + 16.0) // 150
        
        return CGSize(width: width, height: height)
    }
    
}

extension MultiImageGridVC: ToolBarDelegate {
    
    func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

