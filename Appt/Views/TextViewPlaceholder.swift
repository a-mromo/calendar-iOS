//
//  TextViewPlaceholder.swift
//  Appt
//


import UIKit

extension UITextView: UITextViewDelegate {
  
  override open var bounds: CGRect {
    didSet {
      self.resizePlaceholder()
    }
  }
  
  public var placeholder: String? {
    get {
      var placeholderText: String?
      
      if let placeholderLabel = self.viewWithTag(100) as? UILabel {
        placeholderText = placeholderLabel.text
      }
      
      return placeholderText
    }
    set {
      if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
        placeholderLabel.text = newValue
        placeholderLabel.sizeToFit()
      } else {
        self.addPlaceholder(newValue!)
      }
    }
  }
  
  public func textViewDidChange(_ textView: UITextView) {
    if let placeholderLabel = self.viewWithTag(100) as? UILabel {
      placeholderLabel.isHidden = self.text.characters.count > 0
    }
  }
  
  private func resizePlaceholder() {
    if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
      let labelX = self.textContainer.lineFragmentPadding
      let labelY = self.textContainerInset.top - 2
      let labelWidth = self.frame.width - (labelX * 2)
      let labelHeight = placeholderLabel.frame.height
      
      placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
    }
  }
  
  private func addPlaceholder(_ placeholderText: String) {
    let placeholderLabel = UILabel()
    
    placeholderLabel.text = placeholderText
    placeholderLabel.sizeToFit()
    
    placeholderLabel.font = self.font
    placeholderLabel.textColor = UIColor.lightGray
    placeholderLabel.tag = 100
    
    placeholderLabel.isHidden = self.text.characters.count > 0
    
    self.addSubview(placeholderLabel)
    self.resizePlaceholder()
    self.delegate = self
  }
  
}
