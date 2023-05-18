//
//  HomeController.swift
//  AuthenticationDemo
//
//  Created by Денис Трясунов on 13.05.2023.
//

import UIKit

class HomeController: UIViewController {

    private let userInfoStack = UIStackView()
    private let infoLine1 = AuthInfoLabel()
    private let infoLine2 = AuthInfoLabel()
    private let infoLine3 = AuthInfoLabel()
    private let homeImageView = UIImageView()
    private let addPhotoButton = AuthButton(title: "Set Photo")

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configure() {
        view.backgroundColor = .systemTeal

        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem = signOutButton

        configureUserInfoStack()
        configureImageView()

        addPhotoButton.addTarget(self, action: #selector(addPhotoFromLibrary), for: .touchUpInside)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false

        setupUI()
    }

    private func configureUserInfoStack() {

        userInfoStack.axis = .vertical
        userInfoStack.spacing = 10
        userInfoStack.addArrangedSubview(infoLine1)
        userInfoStack.addArrangedSubview(infoLine2)
        userInfoStack.addArrangedSubview(infoLine3)
        infoLine1.translatesAutoresizingMaskIntoConstraints = false
        infoLine2.translatesAutoresizingMaskIntoConstraints = false
        infoLine3.translatesAutoresizingMaskIntoConstraints = false
        userInfoStack.translatesAutoresizingMaskIntoConstraints = false

        Task {
            do {
                let user = try await AuthService.shared.fetchUser()

                infoLine1.text = user.username
                infoLine2.text = user.email
                infoLine3.text = user.uid
            } catch let error {
                showUserFetchAlert(with: error)
            }
        }
    }

    private func configureImageView() {
        var image = UIImage(systemName: "sun.dust")
        if
            let documentsPath = FileManager.default.documentsDirectory,
            let storedImage = UIImage(from: documentsPath.appendingPathComponent("home_photo"))
        {
            image = storedImage
        }
        homeImageView.image = image
        homeImageView.contentMode = .scaleAspectFit
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        homeImageView.tintColor = .systemOrange
        homeImageView.layer.cornerRadius = 15
        homeImageView.layer.borderColor = UIColor.systemIndigo.cgColor
        homeImageView.layer.borderWidth = 4
        homeImageView.clipsToBounds = true

        homeImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupUI() {
        view.addSubviews(userInfoStack, homeImageView, addPhotoButton)

        NSLayoutConstraint.activate([
            userInfoStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            userInfoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userInfoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userInfoStack.heightAnchor.constraint(equalToConstant: 90),

            homeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            homeImageView.widthAnchor.constraint(equalToConstant: 250),
            homeImageView.heightAnchor.constraint(equalToConstant: 250),

            addPhotoButton.topAnchor.constraint(equalTo: homeImageView.bottomAnchor, constant: 40),
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 200),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    @objc private func signOut() {
        do {
            try AuthService.shared.logout()
            configureSceneAuthStatus()
        } catch let error {
            showLogoutAlert(with: error)
        }
    }

    @objc private func addPhotoFromLibrary() {
        addPhotoButton.setProcessing(true)
        let photoPicker = UIImagePickerController()
        photoPicker.allowsEditing = true
        photoPicker.delegate = self
        present(photoPicker, animated: true)
        addPhotoButton.setProcessing(false)
    }
}

extension HomeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard
            let image = info[.editedImage] as? UIImage,
            let documentsPath = FileManager.default.documentsDirectory
        else { return }

        homeImageView.image = image

        image.writeToDocuments(documentsPath, name: "home_photo")

        dismiss(animated: true)
    }
}
