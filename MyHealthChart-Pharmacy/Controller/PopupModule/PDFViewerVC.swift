//
//  PDFViewerVC.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 29/09/21.
//

import UIKit
import PDFKit

extension PDFViewerVC {
    static func instantiate() -> PDFViewerVC {
        StoryBoardConstants.popup.instantiateViewController(withIdentifier: String(describing: PDFViewerVC.self)) as! PDFViewerVC
    }
}

class PDFViewerVC: UIViewController {
    
    @IBOutlet weak var uiViewPDF: UIView!
    
    let pdfView = PDFView()
    
    var remoteUrl = ""
    var localData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpViews()
    }
    
    func setUpViews() {
        
        setUpConstraints()
        
        if let _ = localData {
            getLocalPdf()
        } else {
            getPdf()
            
        }
        
    }
    
    func setUpConstraints() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        uiViewPDF.addSubview(pdfView)
        pdfView.leadingAnchor.constraint(equalTo: uiViewPDF.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: uiViewPDF.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: uiViewPDF.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: uiViewPDF.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension PDFViewerVC {
    
    func getPdf() {
        
        let requestURL = URL(string: remoteUrl)!
        
        // remote pdf
        
        let urlRequest = URLRequest(url: requestURL)
        let session = URLSession.shared
        
        if requestURL.isFileURL == false {
            LoadingIndicator.showLoadingView(isUserInteractionAllow: false)
        }
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            DispatchQueue.main.async {
                LoadingIndicator.hideLoadingView()
            }
            
            if let actualError = error {
                
                Log.e("loading from \(requestURL.absoluteString) - some kind of error \(actualError.localizedDescription)")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                let statusCode = httpResponse.statusCode
                
                if (statusCode == StatusCode.success.rawValue) {
                    
                    Log.d("File downloaded")
                    
                    if let actualData = data {
                        
                        DispatchQueue.main.async {
                            self.pdfView.autoScales = true
                            self.pdfView.document = PDFDocument(data: actualData)
                        }
                    }
                    
                } else  {
                    Log.e("Failed")
                }
            }
            
            Log.m("all done")
        }
        task.resume()
        
    }
    
    func getLocalPdf() {
        
        if let actualData = localData {
            DispatchQueue.main.async {
                self.pdfView.autoScales = true
                self.pdfView.document = PDFDocument(data: actualData)
            }
        }
        
        
    }
    
}


