//
//  ViewController.swift
//  Cities
//
//  Created by Daniel Bonates on 8/5/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var coverView: UIImageView!
    
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var b1: UIImageView!
    @IBOutlet weak var b2: UIImageView!
    @IBOutlet weak var b3: UIImageView!
    @IBOutlet weak var b4: UIImageView!
    
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    let places = ["Angra dos Reis", "Búzios", "Rio de Janeiro", "Petrópolis", "Paraty"]
    let upperView = UIImageView(frame: CGRectZero)
    let lowerView = UIImageView(frame: CGRectZero)
    
    let lineWidth:CGFloat = 1.0
    let lineView = UIView(frame: CGRectZero)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(upperView)
        view.addSubview(lowerView)
        
        let lineY:CGFloat = view.bounds.size.height/2
        //view.bounds.size.width
        
        lineView.frame = CGRectMake(0, lineY, view.bounds.size.width, lineWidth)
        lineView.transform = CGAffineTransformMakeScale(0, 0)
        lineView.layer.opacity = 0
        lineView.hidden = true
        lineView.backgroundColor = UIColor.whiteColor()
        view.addSubview(lineView)
        
        setupRevealFramesViews()
        
        self.animateTapInfo()
       
    }
    
    func animateTapInfo() {
        
        let animGroup = CAAnimationGroup()
        animGroup.duration = 3
        animGroup.repeatCount = HUGE
        
        let force = 0.6
        let duration = 0.5
        let delay = 1
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.rotation"
        animation.values = [0, 0.3*force, -0.3*force, 0.3*force, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.duration = CFTimeInterval(duration)
        animation.additive = true
//        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        
        animGroup.animations = [animation]
        
        tapLabel.layer.addAnimation(animGroup, forKey: "wobble")
    }
    
    // MARK: - Setup upper and lower frames
    func setupRevealFramesViews() {
        
        picker.delegate = self
        picker.selectRow(2, inComponent: 0, animated: false)
        
        
        let upperFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2)
        let lowerFrame = CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width, self.view.bounds.size.height/2)
        
        upperView.frame = upperFrame
        lowerView.frame = lowerFrame
        
        upperView.layer.opacity = 0
        lowerView.layer.opacity = 0
        
        let originalImg = coverView.image
        
        // blur fx for the whoole img
        let visualEffectViewFullImage = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        visualEffectViewFullImage.frame = coverView.bounds
        
        // creating a full uiimageview with blured original
        let fullBluredImageView = UIImageView(image: originalImg)
        fullBluredImageView.addSubview(visualEffectViewFullImage) // the view to hold uiimageview

        // extract the image into a full blur image
        UIGraphicsBeginImageContextWithOptions(fullBluredImageView.bounds.size, false, 0);
        fullBluredImageView.drawViewHierarchyInRect(fullBluredImageView.bounds, afterScreenUpdates: true)
        let fullBluredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        visualEffectViewFullImage.removeFromSuperview()
        
        
        // now with the blur source we can split it into up and down
        
        
        // first the upper one
        
        var imgRef = CGImageCreateWithImageInRect(fullBluredImage?.CGImage, upperView.frame)
        upperView.image = UIImage(CGImage: imgRef)
        
        
        // now the lower
        
        imgRef = CGImageCreateWithImageInRect(fullBluredImage?.CGImage, lowerView.frame)
        lowerView.image = UIImage(CGImage: imgRef)
        

        
    }
    
    
    @IBAction func viewTapped(sender: AnyObject) {
        
        if !picker.hidden { return }
        
        
        self.upperView.hidden = false
        self.lowerView.hidden = false
        
        picker.hidden = false
        okBtn.hidden = false
        cancelBtn.hidden = false
        
        
        UIView.animateWithDuration(0.5, delay: 00, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.lowerView.layer.opacity = 1
            self.upperView.layer.opacity = 1
            
            
        }, completion: { success in
            
            self.coverView.hidden = true
            
            self.showCutLine()
            
        })
        
        
    }
    
    func showCutLine() {
        
        self.lineView.hidden = false
        
         UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.lineView.transform = CGAffineTransformMakeScale(1, 1)
            self.lineView.layer.opacity = 0.5
            
            
            }, completion: { success in
                self.showPicker()
         })
    }
    
    func showPicker() {
        
        let upperGoesUp = CGAffineTransformMakeTranslation(0, -80)
        let lowerGoesDown = CGAffineTransformMakeTranslation(0, 80)

        picker.hidden = false
        okBtn.hidden = false
        cancelBtn.hidden = false
        
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.upperView.layer.shadowOffset = CGSizeMake(0, 15)
            self.upperView.layer.shadowOpacity = 0.35
            self.upperView.layer.shadowRadius = 20
            
            self.lowerView.layer.shadowOffset = CGSizeMake(0, -15)
            self.lowerView.layer.shadowOpacity = 0.35
            self.lowerView.layer.shadowRadius = 20
            
            self.upperView.transform = upperGoesUp
            self.lowerView.transform = lowerGoesDown
            
            self.lineView.transform = upperGoesUp
            self.lineView.layer.opacity = 0
            
            
            }, completion: nil)
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
//        println("cancelPressed")
        closePicker(false)
        
    }
    
    
    
    @IBAction func okGoPressed(sender: AnyObject) {
//        println("okGoPressed")
        closePicker(true)
    }
    
    func closePicker(endDemo:Bool) {
        
        let upperGoesUp = CGAffineTransformMakeTranslation(0, 0)
        
        let lowerGoesDown = CGAffineTransformMakeTranslation(0, 0)
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.upperView.transform = upperGoesUp
            self.lowerView.transform = lowerGoesDown
            
            self.lowerView.layer.shadowOffset = CGSizeMake(0, 1)
            self.lowerView.layer.shadowOpacity = 0.1
            self.lowerView.layer.shadowRadius = 1
            
            self.upperView.layer.shadowOffset = CGSizeMake(0, 1)
            self.upperView.layer.shadowOpacity = 0.1
            self.upperView.layer.shadowRadius = 1

            }, completion: { success in
                self.picker.hidden = true
                self.cancelBtn.hidden = true
                self.okBtn.hidden = true
                self.coverView.hidden = false
                
                self.lineView.transform = CGAffineTransformConcat(upperGoesUp, CGAffineTransformMakeScale(0, 0))
                self.lineView.layer.opacity = 0
                self.lineView.hidden = true
                
                self.hideCoverViews()
                
                if endDemo { self.fadeOutDemo() }
        })
        

    }
    
    func hideCoverViews() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.lowerView.layer.opacity = 0
            self.upperView.layer.opacity = 0
            }, completion: { success in
                self.upperView.hidden = true
                self.lowerView.hidden = true
                
                self.animateTapInfo()
            })
    }
    
    func fadeOutDemo() {
        let fadeView = UIView(frame: view.bounds)
        fadeView.backgroundColor = UIColor.blackColor()
        fadeView.layer.opacity = 0
        view.addSubview(fadeView)
        
        UIView.animateWithDuration(3, animations: { () -> Void in
            fadeView.layer.opacity = 1
        })
    }
    
    // MARK: - UIPickerView stuff
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return places.count;
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: "\(places[row])", attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

