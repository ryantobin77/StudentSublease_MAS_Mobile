//
//  CreateListingFinalVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit

class CreateListingFinalVC: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var photosImageView: UIImageView!
    @IBOutlet var addPhotosButton: UIButton!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var submitButton: UIButton!
    var dimmingView: UIView!
    var numBed: Int!
    var numBath: Double!
    var numTenants: Int!
    var startDate: String!
    var endDate: String!
    var rentPerMonth: Int!
    var fees: Int!
    var street: String!
    var city: String!
    var state: String!
    var zip: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
        
        self.submitButton.layer.cornerRadius = 8.0
        self.descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.descriptionTextView.layer.borderWidth = 0.3
        self.descriptionTextView.textColor = UIColor.lightGray
        self.descriptionTextView.layer.cornerRadius = 8.0
        self.descriptionTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func createListing(_ sender: UIButton) {
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        StudentListingObject.createListing(title: self.titleTextField.text!, street: self.street, city: self.city, state: self.state, zip: self.zip, listingDescription: self.descriptionTextView.text!, numBed: self.numBed, numBath: self.numBath, startDate: self.startDate, endDate: self.endDate, rentPerMonth: self.rentPerMonth, fees: self.fees, numTenants: self.numTenants, failure: {
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
    
    @IBAction func addPhotos(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.mediaTypes = ["public.image"]
        present(picker, animated: true)
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
