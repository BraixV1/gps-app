//
//  LoginView.swift
//  map-project
//
//  Created by Brajan Kukk on 26.12.2024.
//
import SwiftUI
import SwiftData

struct LoginView: View {
    @EnvironmentObject var loginRepository: LoginDataRepository
    @EnvironmentObject var user: LoginSave
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isLoading = false
    @State private var loginForm = LoginData(email: "", password: "")
    @State private var navigateToRegister = false
    private var loginService = LoginService(baseUrl: "/Account/Login")
    @State private var errors: [String] = []
    @State private var rememberMe = false

    var body: some View {
        NavigationStack{
            ZStack {
                themeManager.currentTheme.primaryGradient
                BackGround(image: "HikingDefault")
                    .environmentObject(themeManager)
                VStack {
                    Spacer().frame(height: 200)
                    VStack(spacing: 20) {
                        Text("Login")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.clear)
                            .overlay(
                                themeManager.currentTheme.buttonGradient
                                .mask(
                                    Text("Login")
                                        .font(.system(size: 40, weight: .bold, design: .rounded))
                                )
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ErrorsBox(Errors: errors)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.gray)
                            TextField("Email", text: $loginForm.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // Password field
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            SecureField("Password", text: $loginForm.password)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // Remember Me and Forgot Password
                        HStack {
                            Spacer()
                            Toggle("Remember Me", isOn: $rememberMe)
                                .toggleStyle(SwitchToggleStyle(tint: themeManager.currentTheme.primaryColor))
                        }
                        
                        // Login button
                        Button(action: {
                            Task {
                                await login()
                            }
                        }) {
                            Text("Login")
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
                        
                        // Register link
                        HStack {
                            Text("Need an account?")
                                .foregroundColor(themeManager.currentTheme.textColor)
                            Button(action: {
                                navigateToRegister = true
                            }) {
                                Text("Sign up")
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
            .frame(maxHeight: .infinity)
            .edgesIgnoringSafeArea(.top)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterView()
                    .environmentObject(loginRepository)
                    .environmentObject(user)
                    .environmentObject(themeManager)
            }
            .onTapGesture {
                dismissKeyboard()
            }
            .overlay(
                Group {
                        if isLoading {
                            SpinnerOverlay()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            
                        }
                    }
            )
        }


    }
    
    private func login() async -> Void {
            isLoading = true
            if !validateBeforeSend(login: loginForm) {
                isLoading = false
                return
            }
            
            let result = await loginService.create(data: loginForm)
            isLoading = false
            
            if let resultUser = result.data {
                user.firstName = resultUser.firstName
                user.lastName = resultUser.lastName
                user.status = resultUser.status
                user.token = resultUser.token
                if rememberMe {
                    loginRepository.save(login: user)
                }
            }
            
            if let errors = result.errors {
                self.errors = errors
            }
        }
    
    func validateBeforeSend(login: LoginData) -> Bool {
        var result = true
        errors = []
        if !validateEmail(enteredEmail: login.email) {
            result = false
            errors.append("Please enter a valid email")
        }
        if login.password.isEmpty {
            result = false
            errors.append("Please enter a password")
        }
        return result
    }
    
    func validateEmail(enteredEmail: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginDataRepository(container: try! ModelContainer(for: LoginSave.self)))
        .environmentObject(LoginSave(id: UUID(), token: "Token", status: "Logged in", firstName: "John", lastName: "Doe"))
        .environmentObject(ThemeManager())
}
