//
//  OnBoardingCell.swift
//  The FreeStyle App
//
//  Created by Zaid Dahir on 07/05/2022.
//  Copyright © 2022 Zaid Dahir. All rights reserved.
//

import UIKit

class OnBoardingCell: UICollectionViewCell {
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideDescriptionLabel: UILabel!

    
    func setup(_ slide: OnboardingSlide){
        slideImageView.image = slide.image
        slideTitleLabel.text = slide.title
        slideDescriptionLabel.text = slide.descr

    }
}
