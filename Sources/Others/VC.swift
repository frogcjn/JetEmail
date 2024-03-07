//
//  VC.swift
//  JetEmail
//
//  Created by Cao, Jiannan on 1/31/24.
//
/*
 
 
 
 struct MyViewRepresentable : NSViewControllerRepresentable {
     func makeNSViewController(context: Context) -> NSViewController {
         MyVC()
     }
     
     func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
         
     }
         
     
 }

class MyVC: NSViewController {
    
    let endPoint = OutlookGraphEndPoint()
    
    var callGraphButton: NSButton!
    var loggingText: NSTextView!
    var signOutButton: NSButton!

    var usernameLabel: NSTextField!

    /*func initUI() {

        usernameLabel = NSTextField()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.stringValue = ""
        usernameLabel.isEditable = false
        usernameLabel.isBezeled = false
        self.view.addSubview(usernameLabel)

        usernameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true

        // Add call Graph button
        callGraphButton  = NSButton()
        callGraphButton.translatesAutoresizingMaskIntoConstraints = false
        callGraphButton.title = "Call Microsoft Graph API"
        callGraphButton.target = self
        callGraphButton.action = #selector(callGraphAPI(_:))
        callGraphButton.bezelStyle = .rounded
        self.view.addSubview(callGraphButton)

        callGraphButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callGraphButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0).isActive = true
        callGraphButton.heightAnchor.constraint(equalToConstant: 34.0).isActive = true

        // Add sign out button
        signOutButton = NSButton()
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.title = "Sign Out"
        signOutButton.target = self
        signOutButton.action = #selector(signOut(_:))
        signOutButton.bezelStyle = .texturedRounded
        self.view.addSubview(signOutButton)

        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signOutButton.topAnchor.constraint(equalTo: callGraphButton.bottomAnchor, constant: 10.0).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        signOutButton.isEnabled = false

        // Add logging textfield
        loggingText = NSTextView()
        loggingText.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(loggingText)

        loggingText.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 10.0).isActive = true
        loggingText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10.0).isActive = true
        loggingText.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        loggingText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10.0).isActive = true
        loggingText.widthAnchor.constraint(equalToConstant: 500.0).isActive = true
        loggingText.heightAnchor.constraint(equalToConstant: 300.0).isActive = true
    }*/

    func platformViewDidLoadSetup() {}
    
    override func viewDidLoad() {

        super.viewDidLoad()

        //initUI()

        /*do {
            //try self.initMSAL()
        } catch let error {
            self.updateLogging(text: "Unable to create Application Context \(error)")
        }*/

        // self.loadCurrentAccount()
        // self.platformViewDidLoadSetup()
    }
    
    /*func initMSAL() throws {

        guard let authorityURL = URL(string: endPoint.kAuthority) else {
            self.updateLogging(text: "Unable to create authority URL")
            return
        }

        let authority = try MSALAADAuthority(url: authorityURL)

        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: endPoint.kClientID, redirectUri: nil, authority: authority)
        endPoint.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
        self.initWebViewParams()
    }
    
    func initWebViewParams() {
        endPoint.webViewParameters = MSALWebviewParameters()
        }*/

    /*@objc func callGraphAPI(_ sender: AnyObject) {

        self.loadCurrentAccount { (account) in

            guard let currentAccount = account else {

                // We check to see if we have a current logged in account.
                // If we don't, then we need to sign someone in.
                self.acquireTokenInteractively()
                return
            }

            self.acquireTokenSilently(currentAccount)
        }
    }*/

    typealias AccountCompletion = (MSGraph.Account?) -> Void

    /*func loadCurrentAccount(completion: AccountCompletion? = nil) {

        guard let applicationContext = endPoint.applicationContext else { return }

        let msalParameters = MSALParameters()
        msalParameters.completionBlockQueue = DispatchQueue.main

        applicationContext.getCurrentAccount(with: msalParameters, completionBlock: { [endPoint] (currentAccount, previousAccount, error) in

            if let error = error {
                self.updateLogging(text: "Couldn't query current account with error: \(error)")
                return
            }

            if let currentAccount = currentAccount {

                self.updateLogging(text: "Found a signed in account \(String(describing: currentAccount.username)). Updating data for that account...")

                endPoint.currentAccount = currentAccount

                if let completion = completion {
                    completion(endPoint.currentAccount)
                }

                return
            }

            self.updateLogging(text: "Account signed out. Updating UX")
            endPoint.accessToken = ""
            endPoint.currentAccount = nil

            if let completion = completion {
                completion(nil)
            }
        })
    }*/
    
    /*func acquireTokenInteractively() {

        guard let applicationContext = endPoint.applicationContext else { return }
        guard let webViewParameters = endPoint.webViewParameters else { return }

        // #1
        let parameters = MSALInteractiveTokenParameters(scopes: endPoint.kScopes, webviewParameters: webViewParameters)
        parameters.promptType = .selectAccount

        // #2
        applicationContext.acquireToken(with: parameters) { [endPoint] (result, error) in

            // #3
            if let error = error {

                self.updateLogging(text: "Could not acquire token: \(error)")
                return
            }

            guard let result = result else {

                self.updateLogging(text: "Could not acquire token: No result returned")
                return
            }

            // #4
            endPoint.accessToken = result.accessToken
            self.updateLogging(text: "Access token is \(endPoint.accessToken)")
            endPoint.currentAccount = result.account
            endPoint.getContentWithToken()
        }
    }
    
    
    func acquireTokenSilently(_ account : MSGraph.Account!) {

        guard let applicationContext = endPoint.applicationContext else { return }

        /**

         Acquire a token for an existing account silently

         - forScopes:           Permissions you want included in the access token received
         in the result in the completionBlock. Not all scopes are
         guaranteed to be included in the access token returned.
         - account:             An account object that we retrieved from the application object before that the
         authentication flow will be locked down to.
         - completionBlock:     The completion block that will be called when the authentication
         flow completes, or encounters an error.
         */

        let parameters = MSALSilentTokenParameters(scopes: endPoint.kScopes, account: account)

        applicationContext.acquireTokenSilent(with: parameters) { [endPoint] (result, error) in

            if let error = error {

                let nsError = error as NSError

                // interactionRequired means we need to ask the user to sign-in. This usually happens
                // when the user's Refresh Token is expired or if the user has changed their password
                // among other possible reasons.

                if (nsError.domain == MSALErrorDomain) {

                    if (nsError.code == MSALError.interactionRequired.rawValue) {

                        DispatchQueue.main.async {
                            self.acquireTokenInteractively()
                        }
                        return
                    }
                }

                self.updateLogging(text: "Could not acquire token silently: \(error)")
                return
            }

            guard let result = result else {

                self.updateLogging(text: "Could not acquire token: No result returned")
                return
            }

            endPoint.accessToken = result.accessToken
            self.updateLogging(text: "Refreshed Access token is \(endPoint.accessToken)")
            //? self.updateSignOutButton(enabled: true)
            endPoint.getContentWithToken()
        }
    }*/
    
    /*func getContentWithToken() {

        // Specify the Graph API endpoint
        let graphURI = endPoint.grapEndPointMe()
        let url = URL(string: graphURI + "mailFolders")
        
        var request = URLRequest(url: url!)

        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(endPoint.accessToken)", forHTTPHeaderField: "Authorization")
        print(endPoint.accessToken)

        URLSession..dataTask(with: request) { data, response, error in

            if let error = error {
                self.updateLogging(text: "Couldn't get graph result: \(error)")
                return
            }

            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {

                self.updateLogging(text: "Couldn't deserialize result JSON")
                return
            }

            self.updateLogging(text: "Result from Graph: \(result))")

            }.resume()
    }*/
    
    /*@objc func signOut(_ sender: AnyObject) {

            guard let applicationContext = endPoint.applicationContext else { return }

            guard let account = endPoint.currentAccount else { return }

            do {

                /**
                 Removes all tokens from the cache for this application for the provided account

                 - account:    The account to remove from the cache
                 */

                let signoutParameters = MSALSignoutParameters(webviewParameters: endPoint.webViewParameters!)
                signoutParameters.signoutFromBrowser = false // set this to true if you also want to signout from browser or webview

                applicationContext.signout(with: account, signoutParameters: signoutParameters, completionBlock: {[endPoint] (success, error) in

                    if let error = error {
                        self.updateLogging(text: "Couldn't sign out account with error: \(error)")
                        return
                    }

                    self.updateLogging(text: "Sign out completed successfully")
                    endPoint.accessToken = ""
                    endPoint.currentAccount = nil
                })

            }
        }*/
    
    func updateLogging(text : String) {

        if Thread.isMainThread {
            self.loggingText.string = text
        } else {
            DispatchQueue.main.async {
                self.loggingText.string = text
            }
        }
    }

    /*func updateSignOutButton(enabled : Bool) {
        if Thread.isMainThread {
            self.signOutButton.isEnabled = enabled
        } else {
            DispatchQueue.main.async {
                self.signOutButton.isEnabled = enabled
            }
        }
    }*/

     /*func updateAccountLabel() {

         guard let currentAccount = endPoint.currentAccount else {
            self.usernameLabel.stringValue = "Signed out"
            return
        }

        self.usernameLabel.stringValue = currentAccount.username ?? ""
        self.usernameLabel.sizeToFit()
     }*/

     /*func updateCurrentAccount(account: MSGraph.Account?) {
         endPoint.currentAccount = account
        self.updateAccountLabel()
        self.updateSignOutButton(enabled: account != nil)
    }*/
}
*/
