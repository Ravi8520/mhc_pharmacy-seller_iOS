//
//  CreateAccountListExtension.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 29/09/21.
//

import UIKit

extension CreateAccountVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewPartnershipDeed {
            return partnershipDeedDataSource.count
        } else if collectionView == collectionViewDrugLicence {
            return drugLicenceDataSource.count
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionCell.idetifire(), for: indexPath) as! MediaCollectionCell
        
        if collectionView == collectionViewPartnershipDeed {
            cell.data = partnershipDeedDataSource[indexPath.row]
        } else if collectionView == collectionViewDrugLicence {
            cell.data = drugLicenceDataSource[indexPath.row]
        }
        
        cell.mediaCancelHandler = { [self] in
            
            if collectionView == collectionViewPartnershipDeed {
                partnershipDeedDataSource.remove(at: indexPath.row)
                uiViewUploadPartnerShipDeedBorder.isHidden = false
                collectionViewPartnershipDeed.reloadData()
            } else if collectionView == collectionViewDrugLicence {
                drugLicenceDataSource.remove(at: indexPath.row)
                uiViewUploadDrugLicenceBorder.isHidden = false
                collectionViewDrugLicence.reloadData()
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewPartnershipDeed {
            openMediaInFullScreen(media: partnershipDeedDataSource[indexPath.row])
        } else if collectionView == collectionViewDrugLicence {
            openMediaInFullScreen(media: drugLicenceDataSource[indexPath.row])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewHeight = collectionView.frame.height
        
        if collectionView == collectionViewPartnershipDeed {
            return CGSize(width: collectionViewHeight, height: collectionViewHeight)
        } else if collectionView == collectionViewDrugLicence {
            return CGSize(width: collectionViewHeight + 50, height: collectionViewHeight)
        } else {
            return CGSize(width: collectionViewHeight, height: collectionViewHeight)
        }
        
    }
    
}

