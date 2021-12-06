//
//  CreateListingFinalVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit
import CoreLocation
import BSImagePicker
import Photos
class CreateListingFinalVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var error: UILabel!
    @IBOutlet var photosImageView: UIImageView!
    @IBOutlet var addPhotosButton: UIButton!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var submitButton: UIButton!
    var dimmingView: UIView!
    
    var street: String?
    var city: String?
    var state: String?
    var zip: String?
    var location: CLLocation?
    
    var SelectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    var strPass = [String]()
    var numBed: Int?
    var numBath: Double?
    var numTenants: Int?
    
    var startDate: String?
    var endDate: String?
    var rentPerMonth: Int?
    var fees: Int?
    
    var titleField: String?
    var descriptionField: String?
    
    var goingBack: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
        
        self.submitButton.layer.cornerRadius = 8.0
        self.descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.descriptionTextView.layer.borderWidth = 0.3
        self.descriptionTextView.layer.cornerRadius = 8.0
        self.descriptionTextView.delegate = self
        
        self.navigationController?.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goingBack = true
        if titleField != nil {
            titleTextField.text = titleField
        }
        if descriptionField != nil && descriptionField != "Description..." {
            descriptionTextView.text = descriptionField
            descriptionTextView.textColor = UIColor.black
        } else {
            self.descriptionTextView.text = "Description..."
            self.descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let navC = navigationController else { return }
        if navC.viewControllers.firstIndex(of: self) != nil {
            return
        }
        guard let destination = navC.viewControllers.last as? CreateListingSubleaseVC else {
            return
        }
        if goingBack {
            if let titleVal = titleTextField.text {
                self.titleField = titleVal
            }
            if let descriptionVal = descriptionTextView.text {
                self.descriptionField = descriptionVal
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            destination.street = self.street
            destination.city = self.city
            destination.state = self.state
            destination.zip = self.zip
            destination.numBed = self.numBed
            destination.numBath = self.numBath
            destination.numTenants = self.numTenants
            destination.startDate = self.startDate
            destination.endDate = self.endDate
            destination.rentPerMonth = self.rentPerMonth
            destination.fees = self.fees
            destination.titleField = self.titleField
            destination.descriptionField = self.descriptionField
            destination.location = self.location
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func createListing(_ sender: UIButton) {
        goingBack = false
        if titleTextField.text == "" ||  descriptionTextView.text == ""{
            error.text = "Please fill out all fields"
        } else{
            let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
            self.view.addSubview(loaderView)
            loaderView.load()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            StudentListingObject.createListing(title: self.titleTextField.text!, street: self.street!, city: self.city!, state: self.state!, zip: self.zip!, location: self.location!, listingDescription: self.descriptionTextView.text!, numBed: self.numBed!, numBath: self.numBath!, startDate: self.startDate!, endDate: self.endDate!, rentPerMonth: self.rentPerMonth!, fees: self.fees!, numTenants: self.numTenants!, images: PhotoArray, failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }, success: {(listing) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                let alert = UIAlertController(title: "Success", message: "Your sublease has been listed!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
        }
    }
    
   @IBAction func addPhotos(_ sender: UIButton) {
        /*let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.mediaTypes = ["public.image"]
        present(picker, animated: true)*/
        // create an instance
        let vc = ImagePickerController()
        //display picture gallery
        self.presentImagePicker(vc, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
            
            }
            
            self.convertAssetToImages()
            
        }, completion: nil)
    }
    
    func convertAssetToImages() -> Void {
         
          if SelectedAssets.count != 0{
              
              
              for i in 0..<SelectedAssets.count{
                  
                  let manager = PHImageManager.default()
                  let option = PHImageRequestOptions()
                  var thumbnail = UIImage()
                  option.isSynchronous = true
                  
                 
                  manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
                      thumbnail = result!
                      
                  })
                  
                  let data = thumbnail.jpegData(compressionQuality: 0.7)
                  
                  
                  
                  
                  let newImage = UIImage(data: data!)
                  
                  let imageData:Data = newImage!.pngData()!
                  let imageStr = imageData.base64EncodedString()
                  self.strPass.append(imageStr)
                  
                
                  
                  self.PhotoArray.append(newImage! as UIImage)
                  
              }
             
              self.photosImageView.animationImages = self.PhotoArray
              self.photosImageView.animationDuration = 3.0
              self.photosImageView.startAnimating()
              
              
              
              
          }
          
         
          
          
          print("complete photo array \(self.PhotoArray)")
      }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.photosImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description..."
            textView.textColor = UIColor.lightGray
        }
    }

}
