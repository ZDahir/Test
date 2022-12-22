//
//  OnBoardingVC.swift
//  The FreeStyle App
//
//  Created by Zaid Dahir on 07/05/2022.
//  Copyright © 2022 Zaid Dahir. All rights reserved.
//

import UIKit

class OnBoardingVC: UIViewController {
    
    @IBOutlet weak var collection_view: UICollectionView!
    @IBOutlet weak var next_btn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    var slides : [OnboardingSlide] = []
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage

            if currentPage == slides.count - 1{
                next_btn.setTitle("Get Started", for: .normal)
            } else {
                next_btn.setTitle("Next", for: .normal)

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        next_btn.layer.cornerRadius = 10
        
        slides = [
            OnboardingSlide(title: "EzRhymes", descr: "An app that helps you discover Rhymes when Writing.", image: UIImage(named: "Slid1")!),
            OnboardingSlide(title: "Easy to use Description", descr: "Simply start a session and start Rhyming.", image: UIImage(named: "Slide2")!),
            OnboardingSlide(title: "Save", descr: "Save your work and come back to it anytime. Try it now.", image: UIImage(named: "Slide3")!)
        ]
    }
    

    @IBAction func nextBtnClicked(){
        
        if currentPage == slides.count - 1{
            UserDefaults.standard.set(true, forKey: "Skipped")
                let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController")
                self.navigationController?.pushViewController(mainVC, animated: true)
            
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collection_view.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }

}


extension OnBoardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCell", for: indexPath) as! OnBoardingCell
        
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
    
}
