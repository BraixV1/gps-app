//
//  RegisterView.swift
//  map-project
//
//  Created by Brajan Kukk on 26.12.2024.
//
import SwiftData
import SwiftUI
import Foundation

struct RegisterView: View {
    @EnvironmentObject private var repository: LoginDataRepository
    @EnvironmentObject var themeManager: ThemeManager
    
    private var registerService = RegisterService(baseUrl: "/Account/Register")
    @State private var navigateToLogin = false
    @State private var errors: [String] = []
    @State private var registerForm = RegisterData(email: "", password: "", firstName: "", lastName: "")
    @State private var passwordMatch: String = ""
    @State private var rememberMe = false
    @State private var isLoading = false
    @EnvironmentObject var user: LoginSave

    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.currentTheme.primaryGradient
                .ignoresSafeArea()
                BackGround(image: "HikingDefault")
                    .environmentObject(themeManager)
                
                VStack {
                    Spacer().frame(height: 150)
                    
                    VStack(spacing: 20) {
                        // Title with gradient text
                        Text("Create Account")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.clear)
                            .overlay(
                                themeManager.currentTheme.buttonGradient
                                .mask(
                                    Text("Create Account")
                                        .font(.system(size: 40, weight: .bold, design: .rounded))
                                )
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Error messages
                        ErrorsBox(Errors: errors)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Input fields
                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                                TextField("First Name", text: $registerForm.firstName)
                                    .autocapitalization(.words)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                                TextField("Last Name", text: $registerForm.lastName)
                                    .autocapitalization(.words)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.gray)
                                TextField("Email", text: $registerForm.email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                SecureField("Password", text: $registerForm.password)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                SecureField("Confirm Password", text: $passwordMatch)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        
                        // Remember Me toggle
                        HStack {
                            Spacer()
                            Toggle("Remember Me", isOn: $rememberMe)
                                .toggleStyle(SwitchToggleStyle(tint: themeManager.currentTheme.primaryColor))
                        }
                        
                        // Register button
                        Button(action: {
                            Task {
                                await register()
                            }
                        }) {
                            Text("Register")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    themeManager.currentTheme.buttonGradient
                                )
                                .foregroundColor(themeManager.currentTheme.textColor)
                                .cornerRadius(10)
                        }
                        
                        // OR Divider
                        HStack {
                            Divider().frame(height: 1).background(Color.gray)
                            Text("OR")
                                .foregroundColor(.gray)
                            Divider().frame(height: 1).background(Color.gray)
                        }
                        
                        // Login link
                        HStack {
                            Text("Already have an account?")
                                .foregroundColor(themeManager.currentTheme.textColor)
                            Button(action: {
                                navigateToLogin = true
                            }) {
                                Text("Log in")
                                    .foregroundColor(.blue)
                                    .bold()
                            }
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
                    .environmentObject(repository)
                    .environmentObject(user)
                    .environmentObject(themeManager)
            }
            .frame(maxHeight: .infinity)
            .onTapGesture {
                dismissKeyboard()
            }
            .overlay(
                Group {
                        if isLoading {
                            SpinnerOverlay()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .environmentObject(themeManager)
                        } else {
                            
                        }
                    }
            )
        }
    }
    
    private func register() async {
        isLoading = true
        dismissKeyboard()
        if !validateBeforeSend(registerForm: registerForm) {
            isLoading = false
            return
        }
        let result = await registerService.create(data: registerForm)
        isLoading = false
        
        if let resultUser = result.data {
            user.firstName = resultUser.firstName
            user.lastName = resultUser.lastName
            user.status = resultUser.status
            user.token = resultUser.token
            if rememberMe {
                repository.save(login: user)
            }
        }
        if let resultErrors = result.errors {
            self.errors = resultErrors
        }
    }
    
    private func validateBeforeSend(registerForm: RegisterData) -> Bool {
        var result = true
        errors = []
        if !validateEmail(enteredEmail: registerForm.email) {
            result = false
            errors.append("Please enter a valid email")
        }
        if registerForm.password.isEmpty {
            result = false
            errors.append("Please enter a password")
        }
        if registerForm.firstName.isEmpty {
            result = false
            errors.append("Please enter your first name")
        }
        if registerForm.lastName.isEmpty {
            result = false
            errors.append("Please enter your last name")
        }
        if registerForm.password != passwordMatch {
            result = false
            errors.append("Passwords do not match")
        }
        return result
    }
    
    private func validateEmail(enteredEmail: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    RegisterView()
        .environmentObject(LoginDataRepository(container: try! ModelContainer(for: LoginSave.self)))
        .environmentObject(LoginSave(id: UUID(), token: "Token", status: "Logged in", firstName: "John", lastName: "Doe"))
        .environmentObject(ThemeManager())
}
