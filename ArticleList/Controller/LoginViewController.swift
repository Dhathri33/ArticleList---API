//
//  LoginViewController.swift
//  ArticleList
//
//  Created by Dhathri Bathini on 9/30/25.
//
import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Properties
    
    var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Log in"
        titleLabel.textColor = .systemBlue
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    var subtitleLabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "We're glad to see you again. Log in to continue."
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .black
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleLabel
    }()
    
    var profileImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.tintColor = .systemGray
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        return profileImageView
    }()
    
    var usernameLabel = {
        let usernameLabel = UILabel()
        usernameLabel.text = "Username"
        usernameLabel.font = .systemFont(ofSize: 14)
        usernameLabel.textColor = .black
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        return usernameLabel
    }()
    
    var usernameTextField = {
        let usernameTextField = UITextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.backgroundColor = UIColor.white.withAlphaComponent(0.14)
        usernameTextField.layer.cornerRadius = 6
        usernameTextField.layer.masksToBounds = true
        usernameTextField.textColor = .black
        usernameTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your username",
            attributes: [
                .foregroundColor: UIColor.black.withAlphaComponent(0.7),
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        return usernameTextField
    }()
    
    var passwordLabel = {
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.font = .systemFont(ofSize: 14)
        passwordLabel.textColor = .black
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        return passwordLabel
    }()
    
    var passwordTextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = UIColor.white.withAlphaComponent(0.14)
        passwordTextField.layer.cornerRadius = 6
        passwordTextField.layer.masksToBounds = true
        passwordTextField.textColor = .black
        passwordTextField.isSecureTextEntry = true
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your password",
            attributes: [
                .foregroundColor: UIColor.black.withAlphaComponent(0.7),
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        return passwordTextField
    }()
    
    var loginButton = {
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Log in", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        loginButton.layer.cornerRadius = 6
        loginButton.contentHorizontalAlignment = .center
        loginButton.titleLabel?.textAlignment = .center
        return loginButton
    }()
    
    var userViewModel: UserViewModelProtocol!
    
    init(userViewModel: UserViewModelProtocol = UserViewModel()){
        self.userViewModel = userViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc private func loginAction() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        guard userViewModel.validateUser(username, password),
              userViewModel.checkLoginCredentials(username: username, password: password) else {
                print("Invalid Credentials")
                return
            }
        UserDefaultStorage.shared.set(username, forKey: UDKeys.username)
        navigateToNextScreen()
    }
}
    
//MARK: Helper functions

extension LoginViewController {
    
    func setupUI(){
        view.backgroundColor = .white
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, profileImageView, usernameLabel, usernameTextField, passwordLabel, passwordTextField,  loginButton, UIView()])
        vStack.axis = .vertical
        vStack.spacing = 20
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.setCustomSpacing(50, after: subtitleLabel)
        vStack.setCustomSpacing(4, after: passwordLabel)
        vStack.setCustomSpacing(4, after: usernameLabel)
        vStack.setCustomSpacing(50, after: subtitleLabel)
        vStack.setCustomSpacing(50, after: profileImageView)
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor
                .constraint(equalToConstant: 350),
            profileImageView.heightAnchor
                .constraint(equalToConstant: 128)
        ])
    }
    
    func navigateToNextScreen(){
        if let scene = view.window?.windowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate {
            sceneDelegate.showMainInterface()
        }
    }
}
