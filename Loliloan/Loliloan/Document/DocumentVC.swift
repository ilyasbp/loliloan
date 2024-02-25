//
//  DocumentVC.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 25/02/24.
//

import UIKit
import RxSwift
import RxCocoa
 
// MARK: - INITIAL
class DocumentVC: UIViewController {
    // SUB: Reactive
    let disposeBag = DisposeBag()
    let vm = DocumentVM()
    // SUB: UI
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var b_close: UIButton!
    @IBOutlet weak var lb_docname: UILabel!
    @IBOutlet weak var iv_document: UIImageView!
    // SUB: Variable
    
    static func create(document: Document) -> DocumentVC {
        let vc = DocumentVC(nibName: String(describing: self), bundle: nil)
        vc.vm.document.accept(document)
        return vc
    }
}
 
 
// MARK: - LIFECYCLE
extension DocumentVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
 
// MARK: - UI & BINDING
extension DocumentVC{
    func setupUI(){
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
    }
    
    func setupBinding(){
        vm.document.bind { [weak self] document in
            guard let strself = self else { return }
            strself.lb_docname.text = document.type?.rawValue
            strself.iv_document.setImage(from: document.url ?? "")
        }.disposed(by: disposeBag)
        
        b_close.rx.tap.bind { [weak self] in
            guard let strself = self else { return }
            strself.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
    }
}

// MARK: - ZOOM
extension DocumentVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return iv_document
    }
}
