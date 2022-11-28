//
//  OrderDetailDataSetupExtension.swift
//  My Health Chart-Pharmacy
//
//  Created by Freebird App Studio LLP on 17/12/21.
//

import UIKit

extension OrderDetailVC {
    
    func setupData() {
        
        guard let _ = orderDetailData else { return }
        
        setPrescriptionDetails()
        setOrderDetails()
        setTimeLine()
        setUserData()
        setupBottomButtons()
        SetPaymentDetails()
        uiViewContent.isHidden = false
    }
    
    private func SetPaymentDetails() {
        
        if uiViewPaymentDetail.isHidden == false{
            lblDateTime.text = orderDetailData?.payment_details?.date
            lblRefNo.text = orderDetailData?.payment_details?.reference_no
            lblTotalAmount.text = orderDetailData?.payment_details?.amount
        }
    }
    
    private func setPrescriptionDetails() {
        
        if orderDetailData!.order_note!.isEmpty {
            stackViewOrderNote.isHidden = true
        } else {
            stackViewOrderNote.isHidden = false
            labelOrderNote.text = orderDetailData?.order_note
        }
        
        /*if orderDetailData!.order_type == OrderTypes.manualOrder.serverString {
            setManualOrderData()
        } else {
            setPrescriptionOrderData()
        }*/
        
        if orderDetailData!.manual_order!.count > 0 {
            setManualOrderData()
        }
        else {
            uiViewManualOrderContainer.isHidden = true
            manualOrderTblHeight.constant = 0
        }
        if orderDetailData!.prescription_image!.count > 0 {
            setPrescriptionOrderData()
        }
        else {
            uiViewPrescriptionContainer.isHidden = true
        }
    }
    
    private func setOrderDetails() {
        
        setOrderNumber()
        setDeliveryType()
        setOrderType()
        setLeaveWithNeighbour()
        
        if !orderDetailData!.rating!.isEmpty {
            uiViewRating.isHidden = false
            uiViewRating.rating = Double(orderDetailData?.rating ?? "0") ?? 0
        }
        
        func setOrderNumber() {
            uiViewToolBar.labelTitle.text = orderDetailData?.order_number
        }
        func setDeliveryType() {
            
            switch orderDetailData!.delivery_type {
                    
                case DeliveryType.internald.serverString:
                    labelDeliveryType.text = DeliveryType.internald.displayString
                case DeliveryType.external.serverString:
                    labelDeliveryType.text = DeliveryType.external.displayString
                default:
                    break
            }
        }
        func setOrderType() {
            
            switch orderDetailData!.order_type {
                    
                case OrderTypes.manualOrder.serverString:
                    
                    labelOrderType.text = OrderTypes.manualOrder.detailDisplayString
                    labelPrescriptionOrderType.isHidden = true
                    
                case OrderTypes.asPerPrescription.serverString:
                    
                    labelOrderType.text = OrderTypes.asPerPrescription.detailDisplayString
                    labelPrescriptionOrderType.isHidden = true
                    labelPrescriptionOrderType.text = OrderTypes.asPerPrescription.appDisplayString
                    
                case OrderTypes.selectedItem.serverString:
                    
                    labelOrderType.text = OrderTypes.asPerPrescription.detailDisplayString
                    labelPrescriptionOrderType.isHidden = true
                    labelPrescriptionOrderType.text = OrderTypes.selectedItem.appDisplayString
                    
                case OrderTypes.fullOrder(orderDetailData?.total_days ?? "").serverString:
                    
                    labelOrderType.text = OrderTypes.asPerPrescription.detailDisplayString
                    labelPrescriptionOrderType.isHidden = true
                    labelPrescriptionOrderType.text = OrderTypes.fullOrder(orderDetailData?.total_days ?? "").appDisplayString
                    
                default:
                    break
            }
            
        }
        func setLeaveWithNeighbour() {
            labelLeaveWithNeighbour.text = orderDetailData?.leaveWithNeighbour?.capitalized
        }
    }
    
    private func setPrescriptionOrderData() {
        
        //uiViewManualOrderContainer.isHidden = true
        
        guard orderDetailData?.prescription_image != nil else { return }
        
        guard !orderDetailData!.prescription_image!.isEmpty else { return }
        
        uiViewPrescriptionContainer.isHidden = false
        imageViewPrescription.image = #imageLiteral(resourceName: "ic_prescription_placeHolder")
        
        if orderDetailData!.prescription_image!.count > 1 {
            uiViewPrecriptionOverlay.isHidden = false
            labelPrescriptionCount.text = "+\(orderDetailData!.prescription_image!.count-1)"
        } else {
            uiViewPrecriptionOverlay.isHidden = true
        }
        
        labelPrescriptionName.text = orderDetailData!.prescription_name
        
        // Pdf prescription setup is remains
        
        if orderDetailData!.prescription_image!.first!.mimetype != MimeTypes.pdf.rawValue {
            
            let url = orderDetailData!.prescription_image!.first!.image!
            
            imageViewPrescription.loadImageFromUrl(
                urlString: url,
                placeHolder: UIImage(named: "ic_prescription_placeHolder")
            )
            
        } else {
            uiViewPrescriptionHolder.isHidden = true
        }
    }
    
    private func setManualOrderData() {
        
        //uiViewPrescriptionHolder.isHidden = true
        
        guard orderDetailData?.manual_order != nil &&
                !orderDetailData!.manual_order!.isEmpty else { return }
        
        uiViewManualOrderContainer.isHidden = false
        
        manualOrderTblHeight.constant = CGFloat((orderDetailData!.manual_order!.count * 60))
        
        tableViewManualOrder.reloadData()
        
    }
    
    private func setTimeLine() {
        
        guard let data = orderDetailData else { return }
        
        switch data.order_status {
                
            case OrderStatus.upcoming.serverString:
                
                labelOrderReceivedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.received_date)
                
                hideAcceptedStatus()
                hideAssignToStatus()
                hidePickupStatus()
                hideDropStatus()
                
            case OrderStatus.accepted.serverString:
                
                labelOrderReceivedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.received_date)
                labelOrderAcceptedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.accept_date)
                
                hideAssignToStatus()
                hidePickupStatus()
                hideDropStatus()
                
            case OrderStatus.readyforpickup.serverString:
                
                let assignDate = DateHelper.shared.getOrderFormateDate(serverDate: data.assign_date)
                let deliveryBoy = data.order_assign_to // Set external delivery text if delivery type is external
                
                labelAssignToDate.text = "\(assignDate), \(deliveryBoy ?? "")"
                labelOrderAmount.text = "₹ \(data.order_amount ?? "")"
                
                labelOrderReceivedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.received_date)
                labelOrderAcceptedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.accept_date)
                
                setInvoiceImages()
                
                hidePickupStatus()
                hideDropStatus()
                
            case OrderStatus.outfordelivery.serverString:
                
                let assignDate = DateHelper.shared.getOrderFormateDate(serverDate: data.assign_date)
                let deliveryBoy = data.order_assign_to
                
                labelAssignToDate.text = "\(assignDate), \(deliveryBoy ?? "")"
                labelOrderAmount.text = "₹ \(data.order_amount ?? "")"
                
                labelOrderReceivedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.received_date)
                labelOrderAcceptedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.accept_date)
                labelOrderPickupDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.pickup_date)
                
                setInvoiceImages()
                setPickupImages()
                
                hideDropStatus()
                
            case OrderStatus.completed.serverString:
                
                let assignDate = DateHelper.shared.getOrderFormateDate(serverDate: data.assign_date)
                let deliveryBoy = data.order_assign_to
                
                labelAssignToDate.text = "\(assignDate), \(deliveryBoy ?? "")"
                labelOrderAmount.text = "₹ \(data.order_amount ?? "")"
                
                labelOrderReceivedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.received_date)
                labelOrderAcceptedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.accept_date)
                labelOrderPickupDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.pickup_date)
                labelOrderDropDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.drop_date)
                
                setInvoiceImages()
                setPickupImages()
                setDropImages()
                
            case OrderStatus.rejected.serverString:
                
                stackViewRejectedAt.isHidden = false
                stackViewOrderAcceptAt.isHidden = true
                stackViewOrderAssignAt.isHidden = true
                stackViewOrderPickup.isHidden = true
                stackViewOrderDrop.isHidden = true
                
                labelOrderReceivedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.received_date)
                labelRejectedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.reject_date)
                labelRejectedAtReason.text = data.reject_reason
                
            case OrderStatus.cancelled.serverString:
                
                stackViewCancelledAt.isHidden = false
                stackViewOrderAcceptAt.isHidden = true
                stackViewOrderAssignAt.isHidden = true
                stackViewOrderPickup.isHidden = true
                stackViewOrderDrop.isHidden = true
                
                labelOrderReceivedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.received_date)
                labelCancelledAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.cancel_date)
                labelCancelledAtReason.text = data.cancel_reason
                
            case OrderStatus.returned.serverString:
                
                stackViewOrderDrop.isHidden = true
                stackViewDeliveryAttempted.isHidden = false
                
                if let date = orderDetailData?.return_confirm_date {
                    if date.isEmpty {
                        stackViewReturnAtMedical.isHidden = true
                        imageViewDeliveryAttemptedBlueLine2.isHidden = true
                    } else {
                        stackViewReturnAtMedical.isHidden = false
                        imageViewDeliveryAttemptedBlueLine2.isHidden = false
                        
                        let formattedDate = DateHelper.shared.getOrderFormateDate(serverDate: date)
                        
                        labelReturnAtMedicalDate.text = "\(formattedDate), \(data.return_confirm_name ?? "")"
                    }
                } else {
                    stackViewReturnAtMedical.isHidden = true
                }
                
                let assignDate = DateHelper.shared.getOrderFormateDate(serverDate: data.assign_date)
                let deliveryBoy = data.order_assign_to
                
                labelAssignToDate.text = "\(assignDate), \(deliveryBoy ?? "")"
                labelOrderAmount.text = "₹ \(data.order_amount ?? "")"
                
                labelOrderReceivedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.received_date)
                labelOrderAcceptedAtDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.accept_date)
                labelOrderPickupDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.pickup_date)
                labelDeliveryAttemptedDate.text = DateHelper.shared.getOrderFormateDate(serverDate: data.return_date)
                labelDeliveryAttemptedDate.text! += ", \(deliveryBoy ?? "")"
                
                setInvoiceImages()
                setPickupImages()
                
                hideDropStatus()
                
            default:
                break
        }
        
    }
    
    private func setInvoiceImages() {
        
        if let images = orderDetailData?.invoice {
            
            if !images.isEmpty {
                
                let url = images.first!.image
                
                imageViewInvoice.loadImageFromUrl(
                    urlString: url ?? "",
                    placeHolder: UIImage(named: "ic_prescription_placeHolder")
                )
                
                if images.count > 1 {
                    uiViewInvoiceOverlay.isHidden = false
                    labelInvoiceCount.text = "+ \(images.count - 1)"
                } else {
                    uiViewInvoiceOverlay.isHidden = true
                }
                
            } else {
                stackViewOrderAssignToHolder.isHidden = true
            }
            
        } else {
            stackViewOrderAssignToHolder.isHidden = true
        }
        
    }
    
    private func setPickupImages() {
        
        if let images = orderDetailData?.pickup_images {
            
            if !images.isEmpty {
                
                let url = images.first!.image
                
                imageViewOrderPickupImage.loadImageFromUrl(
                    urlString: url ?? "",
                    placeHolder: UIImage(named: "ic_prescription_placeHolder")
                )
                
                if images.count > 1 {
                    uiViewOrderPickupOverlay.isHidden = false
                    labelOrderPickupImageCount.text = "+ \(images.count - 1)"
                } else {
                    uiViewOrderPickupOverlay.isHidden = true
                }
                
            } else {
                uiViewOrderPickupImageContainer.isHidden = true
            }
            
        } else {
            uiViewOrderPickupImageContainer.isHidden = true
        }
        
    }
    
    private func setDropImages() {
        
        if let images = orderDetailData?.drop_images {
            
            if !images.isEmpty {
                
                let url = images.first!.image
                
                imageViewOrderDropImage.loadImageFromUrl(
                    urlString: url ?? "",
                    placeHolder: UIImage(named: "ic_prescription_placeHolder")
                )
                
                if images.count > 1 {
                    uiViewOrderDropImageOverlay.isHidden = false
                    labelOrderDropImageCount.text = "+ \(images.count - 1)"
                } else {
                    uiViewOrderDropImageOverlay.isHidden = true
                }
                
            } else {
                uiViewDropOrderImageContainer.isHidden = true
            }
            
        } else {
            uiViewDropOrderImageContainer.isHidden = true
        }
        
    }
    
    private func hideAcceptedStatus() {
        imageViewOrderAcceptedAtBlueLine1.isHidden = true
        imageViewOrderAcceptedAtBlueLine2.isHidden = true
        imageViewOrderAcceptedAtBlueDot.isHidden = true
        labelOrderAcceptedAtDate.text = nil
    }
    
    private func hideAssignToStatus() {
        imageViewOrderAssignToBlueLine1.isHidden = true
        imageViewOrderAssignToBlueLine2.isHidden = true
        imageViewOrderAssignToBlueDot.isHidden = true
        labelAssignToDate.text = nil
        stackViewOrderAssignToHolder.isHidden = true
    }
    
    private func hidePickupStatus() {
        imageViewOrderPickupBlueLine1.isHidden = true
        imageViewOrderPickupBlueLine2.isHidden = true
        imageViewOrderPickupBlueDot.isHidden = true
        labelOrderPickupDate.text = nil
        uiViewOrderPickupImageContainer.isHidden = true
    }
    
    private func hideDropStatus() {
        imageViewOrderDropBlueLine1.isHidden = true
        imageViewOrderDropBlueDot.isHidden = true
        labelOrderDropDate.text = nil
        uiViewDropOrderImageContainer.isHidden = true
    }
    
    private func setUserData() {
        
        labelCustomerName.text = orderDetailData?.customer_name
        
        labelMobileNo.text = orderDetailData?.mobile_number
        
        labelCustomerLocation.text = ""
        
        if let blcno = orderDetailData?.location?.blockno {
            labelCustomerLocation.text?.append("\(blcno),")
        }
        if let strtName = orderDetailData?.location?.streetname {
            labelCustomerLocation.text?.append("\(strtName),")
        }
        if let lndMark = orderDetailData?.location?.landmark {
            labelCustomerLocation.text?.append("\(lndMark),")
        }
        if let cty = orderDetailData?.location?.city {
            labelCustomerLocation.text?.append("\(cty),")
        }
        if let pCode = orderDetailData?.location?.pincode {
            labelCustomerLocation.text?.append("\(pCode)")
        }
        
    }
    
    private func setupBottomButtons() {
        
        switch orderDetailData!.order_status {
                
            case OrderStatus.upcoming.serverString:
                
                uiViewAcceptRejectButtons.isHidden = false
                btnAssign.isHidden = true
                btnReassign.isHidden = true
                
            case OrderStatus.accepted.serverString:
                
                uiViewAcceptRejectButtons.isHidden = true
                btnAssign.isHidden = false
                btnReassign.isHidden = true
                
            case OrderStatus.readyforpickup.serverString:
                
                uiViewAcceptRejectButtons.isHidden = true
                btnAssign.isHidden = true
                
                if orderDetailData!.delivery_type == DeliveryType.internald.serverString || orderDetailData!.delivery_type == DeliveryType.both.serverString {
                    btnReassign.isHidden = false
                } else {
                    btnReassign.isHidden = true
                }
            
            case OrderStatus.returned.serverString:
                
                uiViewAcceptRejectButtons.isHidden = true
                btnAssign.isHidden = true
                btnReassign.isHidden = true
                
                if orderDetailData!.return_confirm_date!.isEmpty {
                    btnConfirmReturn.isHidden = false
                } else {
                    btnConfirmReturn.isHidden = true
                }
            
            self.labelReturnReason.isHidden = false
            self.labelReturnReason.text = orderDetailData!.return_reason
            
            default:
                uiViewAcceptRejectButtons.isHidden = true
                btnAssign.isHidden = true
                btnReassign.isHidden = true
        }
        
    }
    
}
