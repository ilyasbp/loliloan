//
//  DocumentVM.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 25/02/24.
//

import RxSwift
import RxRelay

// MARK: - INIT
class DocumentVM {
    let document = BehaviorRelay<Document>(value: Document())
}
