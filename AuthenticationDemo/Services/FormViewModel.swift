//
//  FormViewModel.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 15.05.2023.
//

import Combine
import Foundation

enum FormType {
    case loginNJS, loginFirebase, register, forgot
}

class FormViewModel: ObservableObject {

    let formType: FormType

    var cancellables = Set<AnyCancellable>()

    @Published var username: String = ""
    @Published var isUsernameValid = false
    @Published var email: String = ""
    @Published var isEmailValid = false
    @Published var password: String = ""
    @Published var isPasswordValid = false

    @Published var isSubmitEnabled = false

    init(formType: FormType) {
        self.formType = formType
        addUsernameSubscriber()
        addEmailSubscriber()
        addPasswordSubscriber()
        addSubmitSubscriber()
    }

    func addUsernameSubscriber() {
        $username
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map { ValidationService.isValidUsername($0) }
            .sink { [weak self] in
                self?.isUsernameValid = $0
            }
            .store(in: &cancellables)
    }

    func addEmailSubscriber() {
        $email
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map { ValidationService.isValidEmail($0) }
            .sink { [weak self] in
                self?.isEmailValid = $0
            }
            .store(in: &cancellables)
    }

    func addPasswordSubscriber() {
        $password
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map { ValidationService.isValidPassword($0) }
            .sink { [weak self] in
                self?.isPasswordValid = $0
            }
            .store(in: &cancellables)
    }

    func addSubmitSubscriber() {
        switch formType {
        case .loginNJS:
            $isUsernameValid
                .combineLatest($isPasswordValid)
                .sink { [weak self] validTuple in
                    self?.isSubmitEnabled = validTuple.0 && validTuple.1
                }
                .store(in: &cancellables)
        case .loginFirebase:
            $isEmailValid
                .combineLatest($isPasswordValid)
                .sink { [weak self] validTuple in
                    self?.isSubmitEnabled = validTuple.0 && validTuple.1
                }
                .store(in: &cancellables)
        case .register:
            $isUsernameValid
                .combineLatest($isEmailValid, $isPasswordValid)
                .sink { [weak self] validTuple in
                    self?.isSubmitEnabled = validTuple.0 && validTuple.1 && validTuple.2
                }
                .store(in: &cancellables)
        case .forgot:
            $isEmailValid
                .sink { [weak self] in
                    self?.isSubmitEnabled = $0
                }
                .store(in: &cancellables)
        }

    }
}
