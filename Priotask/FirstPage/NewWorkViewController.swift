//
//  NewWorkViewController.swift
//  Priotask
//
//  Created by Nikita Felicia on 26/04/22.
//

import UIKit

class NewWorkViewController: UIViewController {

    
    @IBOutlet weak var workNameTextField: UITextField!
    @IBOutlet weak var workDescriptionTextField: UITextField!
    
    @IBOutlet weak var nameDescriptionContainerView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var newWorkTopConstraint: NSLayoutConstraint!
    
    private var workViewModel: WorkViewModel!
    private var keyboardOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.workViewModel = WorkViewModel()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: WorkTypeCollectionViewCell.description(), bundle: .main), forCellWithReuseIdentifier: WorkTypeCollectionViewCell.description())
        
        self.startButton.layer.cornerRadius = 12
        self.nameDescriptionContainerView.layer.cornerRadius = 12
        
        self.workNameTextField.attributedPlaceholder = NSAttributedString(string: "Work Name", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.55)])
        self.workNameTextField.addTarget(self, action: #selector(Self.textFieldInputChanged(_ :)), for: .editingChanged)
                                         
        self.workDescriptionTextField.attributedPlaceholder = NSAttributedString(string: "Short Description", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.55)])
        self.workDescriptionTextField.addTarget(self, action: #selector(Self.textFieldInputChanged(_ :)), for: .editingChanged)
    
        self.disableButton()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Self.viewTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
    }
    
    
    @objc func textFieldInputChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if (textField == workNameTextField){
            self.workViewModel.setWorkName(to: text)
            
        } else if (textField == workDescriptionTextField) {
            self.workViewModel.setWorkDescription(to: text)
        }
    
            checkButtonStatus()
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !Constants.hasTopNotch, !keyboardOpened{
            self.keyboardOpened.toggle()
            self.newWorkTopConstraint.constant -= self.view.frame.height * 0.2
            self.view.layoutIfNeeded()
            
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.newWorkTopConstraint.constant = 20
        self.keyboardOpened = false
        self.view.layoutIfNeeded()
    }
    
    
    override class func description() -> String {
        return "NewWorkViewController"
    }
    
    func enableButton() {
        if(self.startButton.isUserInteractionEnabled == false) {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.startButton.layer.opacity = 1
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    
    func disableButton() {
        if(self.startButton.isUserInteractionEnabled) {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.startButton.layer.opacity = 0.25
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    func checkButtonStatus() {
        if workViewModel.isWorkValid() {
            enableButton()
        } else {
            disableButton()
            }
    }
}

extension NewWorkViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workViewModel.getWorkTypes().count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3.75
        let width: CGFloat = collectionView.frame.width
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let adjustedWidth = width - (flowLayout.minimumLineSpacing * (columns - 1))
        
        return CGSize(width: adjustedWidth / columns, height: self.collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkTypeCollectionViewCell.description(), for: indexPath) as! WorkTypeCollectionViewCell
        
        cell.setupCell(workType: self.workViewModel.getWorkTypes()[indexPath.item], isSelected: workViewModel.getSelectedIndex() == indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.workViewModel.setSelectedIndex(to: indexPath.item)
        self.collectionView.reloadSections(IndexSet(0..<1))
        checkButtonStatus()
    }
}
