//
//  LoanDetailVM.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 25/02/24.
//

import RxSwift
import RxRelay

// MARK: - INIT
class LoanDetailVM {
    let loan = BehaviorRelay<Loan>(value: Loan())
    let installments = BehaviorRelay<[Installment]>(value: [])
    let documents = BehaviorRelay<[Document]>(value: [])
}
