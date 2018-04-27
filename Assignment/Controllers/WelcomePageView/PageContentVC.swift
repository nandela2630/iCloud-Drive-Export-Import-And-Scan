//
//  PageContentVC.swift
//  Assignment
//
//  Created by JMRIMAC-1 on 4/26/18.
//  Copyright © 2018 JMRIMAC-1. All rights reserved.
//

import UIKit

class PageContentVC: UIViewController {

    @IBOutlet weak var pageControl1: UIPageControl!
    @IBOutlet weak var nextBtn1: UIButton!
    @IBOutlet weak var containerView1: UIView!
    
    var customPageViewController: PageViewController? {
        didSet {
            customPageViewController?.customDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.pageControl1.subviews[0].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let customPageViewController = segue.destination as? PageViewController {
            self.customPageViewController = customPageViewController
        }
    }
    
    @IBAction func didTapNextButton1(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Next"  {
        
        customPageViewController?.scrollToNextViewController(btnTitle: (nextBtn1.titleLabel?.text)!)
            
        }else if sender.titleLabel?.text == "Continue"{
            
            pushToMainView()
        }
        
        
    }
    
    @IBAction func didTapSkipButton1(_ sender: UIButton) {
        
        //SKIP
        GlobalClass.pushToView(from: self, withIdentifier: "ViewController")
    }
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    @IBAction func valueChanged(_ sender: UIPageControl) {
        customPageViewController?.scrollToViewController(index: pageControl1.currentPage)
    }
    
    func pushToMainView(){
        
       GlobalClass.pushToView(from: self, withIdentifier: "ViewController")
        
    }
    

}

extension PageContentVC: PageViewControllerDelegate {
    
    func customPageViewController(_ customPageViewController: PageViewController,
                                    didUpdatePageCount count: Int) {
        pageControl1.numberOfPages = count
    }
    
    func customPageViewController(_ customPageViewController: PageViewController,
                                    didUpdatePageIndex index: Int) {
        
        pageControl1.currentPage = index
        
        for i in 0 ..< pageControl1.subviews.count {
            if(i == index){
                
                pageControl1.subviews[i].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                
            }
            else{
                pageControl1.subviews[i].transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        
        if index == 1 {
            
            nextBtn1.setTitle("Continue", for: .normal)
            
        }else{
            
            nextBtn1.setTitle("Next", for: .normal)
        }
    }
    
}
