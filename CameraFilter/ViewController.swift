//
//  ViewController.swift
//  CameraFilter
//
//  Created by SeonHo Cha on 2022/10/26.
//

import UIKit
import RxSwift

//최종적으로 사진을 구독할 놈은 이 뷰컨트롤러이기 때문에 여기서 구독하자
class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    //세그웨이 준비
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
            fatalError("Segue destination is not found")
        }
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in    // 클로저 내부에서 self를 쓸 때 메모리 누수를 위해? [weak self] 넣어준다.
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        
            //구독해서 받은 이미지(photo)를 iboutlet연결한 imageView에 할당..
            
        }).disposed(by: disposeBag) // 여기서 구독했으니 여기서 dispose
        
    
    }
    
    @IBAction func applyFilterButtonPressed() { //dafdfadfasdf
        
        guard let sourceImage = self.photoImageView.image else {
            return
        }//filterservice를 구독
        FiltersService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
        
    }
    //MARK: - update UI
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
        self.applyFilterButton.isHidden = false
    }

}

