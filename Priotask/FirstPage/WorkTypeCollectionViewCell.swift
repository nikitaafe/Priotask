//
//  WorkTypeCollectionViewCell.swift
//  Priotask
//
//  Created by Nikita Felicia on 26/04/22.
//

import UIKit

class WorkTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageContainerView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var typeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.imageContainerView.layer.cornerRadius = self.imageContainerView.bounds.width / 2
        }
    }
    
    override class func description() -> String{
        return "WorkTypeCollectionViewCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
        self.imageView.image = nil
    }
    
    func setupCell(workType: WorkType, isSelected: Bool) {
        self.typeName.text = workType.typeName
        
        if (isSelected) {
            self.imageContainerView.backgroundColor = UIColor(named : "purpleUnselected")?.withAlphaComponent(0.5)
            self.typeName.textColor = UIColor(named : "purpleAccent")
            self.imageView.tintColor = UIColor(named : "purpleAccent")
            self.imageView.image = UIImage(systemName: workType.symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
        }else {
          
            self.imageView.image = UIImage(systemName: workType.symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
            reset()
        }
    }

func reset() {
    self.imageContainerView.backgroundColor = UIColor.clear
    self.typeName.textColor = UIColor(named : "purpleUnselected")
    self.imageView.tintColor = UIColor(named : "purpleUnselected")
    }
    
}



