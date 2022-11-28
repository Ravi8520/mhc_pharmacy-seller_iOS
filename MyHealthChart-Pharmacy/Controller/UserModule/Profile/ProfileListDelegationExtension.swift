//
//  ProfileListDelegationExtension.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 01/10/21.
//

import UIKit

extension ProfileVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewAdharCard {
            return profileData?.adharcard?.count ?? 0
        } else if collectionView == collectionViewDrugLicence {
            return profileData?.drugLicence?.count ?? 0
        } else if collectionView == collectionViewPartnerShipDeed {
            return profileData?.partnershipDeed?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionCell.idetifire(), for: indexPath) as! MediaCollectionCell
        
        cell.btnMediaCancel.isHidden = true
        
        if collectionView == collectionViewAdharCard {
            cell.mediaData = profileData?.adharcard?[indexPath.row]
        } else if collectionView == collectionViewDrugLicence {
            cell.mediaData = profileData?.drugLicence?[indexPath.row]
        } else if collectionView == collectionViewPartnerShipDeed {
            cell.mediaData = profileData?.partnershipDeed?[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewAdharCard {
            openMediaInFullScreen(
                media: profileData?.adharcard?[indexPath.row]
            )
        } else if collectionView == collectionViewDrugLicence {
            openMediaInFullScreen(media: profileData?.drugLicence?[indexPath.row])
        } else if collectionView == collectionViewPartnerShipDeed {
            openMediaInFullScreen(media: profileData?.partnershipDeed?[indexPath.row])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewHeight = collectionView.frame.height
        
        if collectionView == collectionViewAdharCard {
            return CGSize(width: collectionViewHeight + 50, height: collectionViewHeight)
        } else if collectionView == collectionViewDrugLicence {
            return CGSize(width: collectionViewHeight, height: collectionViewHeight)
        } else {
            return CGSize(width: collectionViewHeight, height: collectionViewHeight)
        }
        
    }
    
    
}

extension ProfileVC {
    
    func openMediaInFullScreen(media: MultiImageApiResponse?) {
        
        guard media != nil else { return }
        
        if media?.mimeTtype == MimeTypes.pdf.rawValue {
            let vc = PDFViewerVC.instantiate()
            vc.remoteUrl = media?.image ?? ""
            present(vc, animated: true, completion: nil)
        } else {
            let vc = FullScreenVC.instantiate()
            vc.remoteUrl = media!.image ?? ""
            present(vc, animated: true, completion: nil)
        }
    
    }
    
}
