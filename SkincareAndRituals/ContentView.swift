import SwiftUI
import AVFoundation
import Photos
import PhotosUI

struct ContentView: View {
    @StateObject private var surveyViewModel = SurveyViewModel()
    
    var body: some View {
        Group {
        if surveyViewModel.isNewUser {
            // New user flow: Show onboarding, survey, and face analysis
            if surveyViewModel.showFaceAnalysis {
                NavigationView {
                    FaceAnalysisView(surveyViewModel: surveyViewModel)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            } else if surveyViewModel.isOnboardingComplete {
                // This should only happen after face analysis is complete
                MainAppView(surveyViewModel: surveyViewModel)
            } else {
                NavigationView {
                    SurveyView(viewModel: surveyViewModel)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        } else {
            // Existing user flow: Go directly to main app
            MainAppView(surveyViewModel: surveyViewModel)
            }
        }
    }
}

// MARK: - Main App View
struct MainAppView: View {
    @ObservedObject var surveyViewModel: SurveyViewModel
    
    var body: some View {
        SkincareRitualsHomeView(surveyViewModel: surveyViewModel)
    }
}

// MARK: - New User Home View
struct NewUserHomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Skincare & Rituals")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Welcome to Your Skincare Journey!")
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                print("🔴 Add Routine button tapped")
            }) {
                Text("Add Routine")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            
            Button(action: {
                print("🔴 View My Routines button tapped")
            }) {
                Text("View My Routines")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
        }
        .padding()
    }
}

// MARK: - Existing User Home View
struct ExistingUserHomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Skincare & Rituals")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Your Daily Routine")
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Routine panel with radio, spotify, news buttons
            VStack(spacing: 15) {
                Button(action: {
                    print("🔴 Radio button tapped")
                }) {
                    HStack {
                        Image(systemName: "radio")
                            .font(.title2)
                        Text("Radio")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    print("🔴 Spotify button tapped")
                }) {
                    HStack {
                        Image(systemName: "music.note")
                            .font(.title2)
                        Text("Spotify")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    print("🔴 News button tapped")
                }) {
                    HStack {
                        Image(systemName: "newspaper")
                            .font(.title2)
                        Text("News")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding()
    }
}

// MARK: - Face Analysis View
struct FaceAnalysisView: View {
    @StateObject private var viewModel = FaceAnalysisViewModel()
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var surveyViewModel: SurveyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Modern Background - Survey akışındaki renk paleti
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Modern Header
                    modernHeaderView(geometry: geometry)
                    
                    Spacer(minLength: 20)
                    
                    // Modern Camera Preview Card
                    modernCameraPreviewView(geometry: geometry)
                    
                    Spacer(minLength: 30)
                    
                    // Modern Bottom Controls
                    modernBottomControlsView(geometry: geometry)
                    
                    Spacer(minLength: 40)
                    
                    // Analysis Completion View
                    if viewModel.analysisCompleted {
                        modernAnalysisCompletionView(geometry: geometry)
                    }
                }
            }
        }
        .navigationBarHidden(true)
            .onAppear {
                print("🔴 FaceAnalysisView appeared")
                // Delay permission check to avoid immediate crash
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.checkPermissions()
                }
            }
            .sheet(isPresented: $viewModel.showingPhotoPicker, onDismiss: {
                // Reset photo picker state when dismissed
                viewModel.showingPhotoPicker = false
            }) {
                PhotoPicker(selectedImage: $viewModel.selectedImage) { image in
                    viewModel.setSelectedImage(image)
                }
            }
            .sheet(isPresented: $viewModel.showingConsentSheet, onDismiss: {
                // Reset consent sheet state when dismissed
                viewModel.showingConsentSheet = false
            }) {
                ConsentSheet(
                    image: viewModel.capturedImage,
                    onConfirm: {
                        viewModel.startAnalysis()
                    }
                )
            }
            .sheet(isPresented: $viewModel.showingSkinReport) {
                SkinReportView(
                    image: viewModel.capturedImage,
                    onContinue: {
                        viewModel.showingSkinReport = false
                        surveyViewModel.completeFaceAnalysis()
                    },
                    faceAnalysisViewModel: viewModel
                )
            }
            .sheet(isPresented: $viewModel.showingResultAdjustment) {
                ResultAdjustmentView(viewModel: viewModel)
            }
        .alert("Camera Permission Required", isPresented: $viewModel.showingPermissionAlert) {
            Button("Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please enable camera access in Settings to analyze your skin.")
        }
    }
    
    // MARK: - Modern Header View
    private func modernHeaderView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            // Top Navigation
            HStack {
                Button(action: {
                    // Go back to survey's last question
                    print("🔴 FaceAnalysisView: Back button tapped")
                    surveyViewModel.goBackToSurvey()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppTheme.darkCharcoal)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(AppTheme.creamWhite)
                                .shadow(color: AppTheme.darkCharcoal.opacity(0.1), radius: 4, x: 0, y: 2)
                        )
                }
                .accessibilityLabel("Back")
                
                Spacer()
                
                // Close button placeholder
                Spacer()
                    .frame(width: 32, height: 32)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Title and Subtitle
            VStack(spacing: 8) {
                Text("Analyze Your Skin with AI")
                    .font(AppTheme.Typography.surveyTitle)
                    .foregroundColor(AppTheme.darkCharcoal)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text("Get personalized skincare recommendations in seconds.")
                    .font(AppTheme.Typography.surveySubtitle)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 10)
    }
    
        // MARK: - Modern Camera Preview View
        private func modernCameraPreviewView(geometry: GeometryProxy) -> some View {
            VStack(spacing: 24) {
                // Modern Camera Preview Card - Survey akışındaki ModernQuestionCard stilinde
                VStack(spacing: 24) {
                    if let capturedImage = viewModel.capturedImage {
                        // Show captured/selected image
                        VStack(spacing: 16) {
                            Image(uiImage: capturedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 300)
                                .cornerRadius(16)
                                .shadow(color: AppTheme.darkCharcoal.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Photo Ready")
                                .font(AppTheme.Typography.title2)
                                .foregroundColor(AppTheme.darkCharcoal)
                                .multilineTextAlignment(.center)
                            
                            Text("Your photo is ready for analysis.")
                                .font(AppTheme.Typography.surveyOption)
                                .foregroundColor(AppTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                        }
                    } else if viewModel.cameraPermissionGranted {
                        // Show camera preview when permission granted
                        VStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(0.1))
                                    .frame(height: 300)
                                
                                CameraPreviewView(session: viewModel.captureSession)
                                    .frame(height: 300)
                                    .cornerRadius(16)
                                    .clipped()
                            }
                        }
                        
                        // Camera Ready Text
                        VStack(spacing: 8) {
                            Text("Camera Ready")
                                .font(AppTheme.Typography.title2)
                                .foregroundColor(AppTheme.darkCharcoal)
                                .multilineTextAlignment(.center)
                            
                            Text("Take a photo or select from gallery.")
                                .font(AppTheme.Typography.surveyOption)
                                .foregroundColor(AppTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                        }
                    } else {
                        // Show camera icon when no permission
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.darkCharcoal.opacity(0.15))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(AppTheme.darkCharcoal.opacity(0.8))
                            }
                        }
                        
                        // Camera Access Text
                        VStack(spacing: 8) {
                            Text("Enable Camera Access")
                                .font(AppTheme.Typography.title2)
                                .foregroundColor(AppTheme.darkCharcoal)
                                .multilineTextAlignment(.center)
                            
                            Text("Allow camera access to take photos or select from gallery.")
                                .font(AppTheme.Typography.surveyOption)
                                .foregroundColor(AppTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppTheme.cardGradient)
                        .shadow(color: AppTheme.darkCharcoal.opacity(0.08), radius: 20, x: 0, y: 8)
                )
                .padding(.horizontal, 20)
            
            // Tips Card - Survey akışındaki stil
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppTheme.warmBeige)
                    
                    Text("Tips for best results")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.darkCharcoal)
                }
                
                VStack(spacing: 8) {
                    Text("• Good lighting, remove glasses")
                        .font(AppTheme.Typography.surveyOption)
                        .foregroundColor(AppTheme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("• Keep hair away from face")
                        .font(AppTheme.Typography.surveyOption)
                        .foregroundColor(AppTheme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("• Hold still for 2–3 seconds")
                        .font(AppTheme.Typography.surveyOption)
                        .foregroundColor(AppTheme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.creamWhite)
                    .shadow(color: AppTheme.darkCharcoal.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Modern Bottom Controls View
    private func modernBottomControlsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 20) {
                // Modern Control Buttons - Survey akışındaki stil
                HStack(spacing: 40) {
                    // Left button (Refresh/Retake)
                    Button(action: {
                        if viewModel.capturedImage != nil {
                            viewModel.retakePhoto()
                        } else {
                            viewModel.showPhotoPicker()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.creamWhite)
                                .frame(width: 60, height: 60)
                                .shadow(color: AppTheme.darkCharcoal.opacity(0.1), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(AppTheme.darkCharcoal.opacity(0.8))
                        }
                    }
                    .accessibilityLabel("Refresh")
                    
                    // Center capture button - Camera capture (fotoğraf çekme)
                    Button(action: {
                        if viewModel.cameraPermissionGranted {
                            viewModel.capturePhoto()
                        } else {
                            viewModel.showPhotoPicker()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.softPink)
                                .frame(width: 80, height: 80)
                                .shadow(color: AppTheme.softPink.opacity(0.3), radius: 12, x: 0, y: 6)
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .accessibilityLabel("Take Photo")
                    
                    // Right button (Gallery/Photo selection)
                    Button(action: {
                        viewModel.showPhotoPicker()
                    }) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.creamWhite)
                                .frame(width: 60, height: 60)
                                .shadow(color: AppTheme.darkCharcoal.opacity(0.1), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "photo.fill")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(AppTheme.darkCharcoal.opacity(0.8))
                        }
                    }
                    .accessibilityLabel("Select from Gallery")
                }
            .padding(.horizontal, 20)
            
            // Analyze Button - Survey akışındaki ModernBottomButton stilinde
            if viewModel.capturedImage != nil {
                Button(action: {
                    viewModel.startAnalysis()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text("Analyze My Skin")
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppTheme.softPink)
                    )
                }
                .padding(.horizontal, 20)
                .transition(.opacity.combined(with: .scale))
                .animation(.easeInOut(duration: 0.3), value: viewModel.capturedImage != nil)
            }
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Modern Analysis Completion View
    private func modernAnalysisCompletionView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 24) {
            // Success message - Survey akışındaki ModernQuestionCard stilinde
            VStack(spacing: 24) {
                // Success Icon - Survey akışındaki icon stilinde
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.darkCharcoal.opacity(0.15))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
                
                // Success Text
                VStack(spacing: 8) {
                    Text("Analysis Complete!")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.darkCharcoal)
                        .multilineTextAlignment(.center)
                    
                    Text("Your skin analysis has been completed successfully.")
                        .font(AppTheme.Typography.surveyOption)
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppTheme.cardGradient)
                    .shadow(color: AppTheme.darkCharcoal.opacity(0.08), radius: 20, x: 0, y: 8)
            )
            .padding(.horizontal, 20)
            
            // Continue to app button - Survey akışındaki ModernBottomButton stilinde
            Button(action: {
                surveyViewModel.completeFaceAnalysis()
            }) {
                HStack(spacing: 8) {
                    Text("Continue to App")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppTheme.softPink)
                )
            }
            .padding(.horizontal, 20)
        }
        .transition(.opacity.combined(with: .scale))
        .animation(.easeInOut(duration: 0.5), value: viewModel.analysisCompleted)
    }
}

    // MARK: - Face Analysis View Model
    @MainActor
    class FaceAnalysisViewModel: NSObject, ObservableObject {
        @Published var cameraPermissionGranted = false
        @Published var capturedImage: UIImage?
        @Published var selectedImage: UIImage?
        @Published var showingPhotoPicker = false
        @Published var showingConsentSheet = false
        @Published var isAnalyzing = false
        @Published var analysisCompleted = false
        @Published var showingSkinReport = false
        @Published var showingPermissionAlert = false
        @Published var showingResultAdjustment = false // New state for result adjustment
        
        // Analysis results that can be adjusted
        @Published var skinType = "Combination"
        @Published var skinSensitivity = "Low"
        @Published var acne = "Mild"
        @Published var tZoneOilness = "Moderate"
        @Published var dryness = "Low"
        @Published var wrinkles = "Minimal"
        @Published var blackheads = "Few"
        
        // Dropdown states
        @Published var showingSkinTypeOptions = false
        @Published var showingSkinSensitivityOptions = false
        @Published var showingAcneOptions = false
        @Published var showingTZoneOilnessOptions = false
        @Published var showingDrynessOptions = false
        @Published var showingWrinklesOptions = false
        @Published var showingBlackheadsOptions = false
        
        let captureSession = AVCaptureSession()
        private var photoOutput = AVCapturePhotoOutput()
    
    override init() {
        super.init()
        setupCaptureSession()
    }
    
    func checkPermissions() {
        print("🔴 Checking camera permissions...")
        
        // Check if Info.plist contains camera usage description
        guard let infoPlistPath = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let infoPlist = NSDictionary(contentsOfFile: infoPlistPath),
              let cameraUsageDescription = infoPlist["NSCameraUsageDescription"] as? String,
              !cameraUsageDescription.isEmpty else {
            print("🔴 Info.plist missing NSCameraUsageDescription - disabling camera")
            cameraPermissionGranted = false
            return
        }
        
        print("🔴 Info.plist contains camera usage description: \(cameraUsageDescription)")
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("🔴 Camera permission already granted")
            cameraPermissionGranted = true
            startCaptureSession()
        case .notDetermined:
            print("🔴 Requesting camera permission...")
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    print("🔴 Camera permission result: \(granted)")
                    self?.cameraPermissionGranted = granted
                    if granted {
                        self?.startCaptureSession()
                    }
                }
            }
        case .denied, .restricted:
            print("🔴 Camera permission denied or restricted")
            showingPermissionAlert = true
        @unknown default:
            print("🔴 Unknown camera permission status")
            break
        }
    }
    
    private func setupCaptureSession() {
        print("🔴 Setting up capture session...")
        
        // Only setup if camera permission is granted
        guard cameraPermissionGranted else {
            print("🔴 Camera permission not granted - skipping setup")
            return
        }
        
        captureSession.beginConfiguration()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("🔴 Failed to get video device")
            captureSession.commitConfiguration()
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
                print("🔴 Video input added successfully")
            } else {
                print("🔴 Cannot add video input")
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
                print("🔴 Photo output added successfully")
            } else {
                print("🔴 Cannot add photo output")
            }
            
            captureSession.commitConfiguration()
            print("🔴 Capture session setup completed")
        } catch {
            print("🔴 Error setting up capture session: \(error)")
            captureSession.commitConfiguration()
        }
    }
    
    private func startCaptureSession() {
        print("🔴 Starting capture session...")
        
        // Only start if camera permission is granted
        guard cameraPermissionGranted else {
            print("🔴 Camera permission not granted - skipping start")
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
                print("🔴 Capture session started")
            } else {
                print("🔴 Capture session already running")
            }
        }
    }
    
    private func stopCaptureSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.captureSession.stopRunning()
            print("🔴 Capture session stopped")
        }
    }
    
    func capturePhoto() {
        // Only capture if camera permission is granted
        guard cameraPermissionGranted else {
            print("🔴 Camera permission not granted - opening photo picker instead")
            showPhotoPicker()
            return
        }
        
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func retakePhoto() {
        capturedImage = nil
    }
    
    func confirmPhoto() {
        showingConsentSheet = true
    }
    
    func showPhotoPicker() {
        showingPhotoPicker = true
    }
    
    func setSelectedImage(_ image: UIImage?) {
        selectedImage = image
        if let image = image {
            capturedImage = image
        }
    }
    
        func startAnalysis() {
            guard let image = capturedImage else { return }
            
            isAnalyzing = true
            
            // Simulate analysis
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isAnalyzing = false
                self.analysisCompleted = true
                self.showingSkinReport = true
            }
        }
    
    deinit {
        // Stop capture session synchronously to avoid concurrency issues
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

// MARK: - Skincare & Rituals Home View
struct SkincareRitualsHomeView: View {
    @State private var selectedTab = 0
    @ObservedObject var surveyViewModel: SurveyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                // Content based on selected tab
                Group {
                    switch selectedTab {
                    case 0: // Home
                        homeContent(geometry: geometry)
                    case 1: // Products
                        ProductsView(selectedTab: $selectedTab)
                    case 2: // Scan
                        scanContent(geometry: geometry)
                    case 3: // Sparkles
                        sparklesContent(geometry: geometry)
                    case 4: // Profile
                        profileContent(geometry: geometry)
                    default:
                        homeContent(geometry: geometry)
                    }
                }
                
                // Bottom Navigation
                VStack {
                    Spacer()
                    BottomNavigationView(selectedTab: $selectedTab)
                        .background(
                            Rectangle()
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                        )
                }
            }
        }
    }
    
    // MARK: - Home Content
    private func homeContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: AppTheme.Spacing.lg) {
                // Dynamic Greeting with Animation
                GreetingView()
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.top, geometry.size.height * 0.05)
                
                Text("Skincare & Rituals")
                    .font(AppTheme.Typography.largeTitle)
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(.bottom, AppTheme.Spacing.md)
            }
            
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    
                    // Conditional content based on isNewUser
                    if surveyViewModel.isNewUser {
                        // New user: Show Add Routine + Environmental Factors
                        AddRoutineCard()
                        
                        // Environmental Factors
                        HStack(spacing: AppTheme.Spacing.md) {
                            UVIndexCard()
                            HumidityCard()
                        }
                        
                        // Weather Conditions
                        HStack(spacing: AppTheme.Spacing.md) {
                            TemperatureCard()
                            WindCard()
                        }
                        
                        // Pollution Level Panel
                        PollutionLevelCard()
                    } else {
                        // Existing user: Show Today's Routine + Skin Journal + Environmental Factors
                        MorningRoutineCard()
                        
                        EveningRoutineCard()
                        
                        SkinJournalCard()
                        
                        // Environmental Factors
                        HStack(spacing: AppTheme.Spacing.md) {
                            UVIndexCard()
                            HumidityCard()
                        }
                        
                        // Weather Conditions
                        HStack(spacing: AppTheme.Spacing.md) {
                            TemperatureCard()
                            WindCard()
                        }
                        
                        // Pollution Level Panel
                        PollutionLevelCard()
                        
                        // Did you know? Section
                        DidYouKnowCard()
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.bottom, 100) // Space for bottom navigation
            }
        }
    }
    
    // MARK: - Scan Content
    private func scanContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Text("Scan Products")
                .font(AppTheme.Typography.largeTitle)
                .foregroundColor(AppTheme.textPrimary)
                .padding(.top, geometry.size.height * 0.1)
            
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.lg) {
                Image(systemName: "viewfinder")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.primaryColor)
                
                Text("Point your camera at a skincare product to analyze its ingredients")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.lg)
            }
            
            Spacer()
        }
    }
    
    // MARK: - Sparkles Content
    private func sparklesContent(geometry: GeometryProxy) -> some View {
        ExploreRoutinesView()
    }
    
    // MARK: - Profile Content
    private func profileContent(geometry: GeometryProxy) -> some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Text("Profile")
                .font(AppTheme.Typography.largeTitle)
                .foregroundColor(AppTheme.textPrimary)
                .padding(.top, geometry.size.height * 0.1)
            
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.lg) {
                Image(systemName: "person.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.primaryColor)
                
                Text("Manage your skincare profile and preferences")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.lg)
            }
            
            Spacer()
        }
    }
}

// MARK: - Add Routine Card
struct AddRoutineCard: View {
    var body: some View {
        HStack(spacing: AppTheme.Spacing.lg) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("AI skin analysis results & your concerns will be used to prepare a personalized skincare routine just for you.")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Button(action: {
                    // Add routine action
                }) {
                    Text("Add Routine")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .fill(AppTheme.primaryColor)
                        )
                }
            }
            
            Spacer()
            
            // Decorative icon
            VStack(spacing: 4) {
                Image(systemName: "drop.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.primaryColor)
                
                Image(systemName: "square.fill")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.softPink)
                
                Image(systemName: "triangle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.warmBeige)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(AppTheme.softPink.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(AppTheme.softPink.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Morning Routine Card
struct MorningRoutineCard: View {
    @State private var isCompleted = false
    @State private var showingStartOptions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Header
            HStack {
                Text("Morning Routine")
                    .font(AppTheme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Button(action: {
                    showingStartOptions = true
                }) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(isCompleted ? .green : AppTheme.textSecondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Description
            Text("Start your day with a guided skincare routine")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(AppTheme.Spacing.md)
                        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(AppTheme.surfaceColor)
                .appShadow(AppTheme.Shadows.small)
        )
        .sheet(isPresented: $showingStartOptions) {
            RoutineStartOptionsView(isCompleted: $isCompleted)
        }
    }
}

// MARK: - Evening Routine Card
struct EveningRoutineCard: View {
    @State private var isCompleted = false
    @State private var showingStartOptions = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Header
            HStack {
                Text("Evening Routine")
                    .font(AppTheme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Button(action: {
                    showingStartOptions = true
                }) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(isCompleted ? .green : AppTheme.textSecondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Description
            Text("End your day with a guided skincare routine")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(AppTheme.Spacing.md)
                        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(AppTheme.surfaceColor)
                .appShadow(AppTheme.Shadows.small)
        )
        .sheet(isPresented: $showingStartOptions) {
            EveningRoutineStartOptionsView(isCompleted: $isCompleted)
        }
    }
}

// MARK: - Routine Start Options View
struct RoutineStartOptionsView: View {
    @Binding var isCompleted: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var showingRoutineGuide = false
    @State private var selectedOption: RoutineStartOption?
    
    private let startOptions: [RoutineStartOption] = [
        RoutineStartOption(title: "Do routine with Spotify", icon: "music.note", color: .purple),
        RoutineStartOption(title: "Do routine with Radio", icon: "radio", color: .purple),
        RoutineStartOption(title: "Do routine with Daily News", icon: "newspaper", color: .purple),
        RoutineStartOption(title: "Do routine with Mindfulness", icon: "leaf", color: .green),
        RoutineStartOption(title: "Do routine with Silent", icon: "moon", color: .gray)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Header
                VStack(spacing: AppTheme.Spacing.md) {
                    Text("How do you want to start?")
                        .font(AppTheme.Typography.title1)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Choose your preferred way to begin your morning skincare routine")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppTheme.Spacing.xl)
                
                // Options List
                VStack(spacing: AppTheme.Spacing.md) {
                    ForEach(startOptions, id: \.title) { option in
                        RoutineStartOptionButton(
                            option: option,
                            isSelected: selectedOption?.title == option.title
                        ) {
                            selectedOption = option
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                
                Spacer()
                
                // Start Button
                Button(action: {
                    if selectedOption != nil {
                        showingRoutineGuide = true
                    }
                }) {
                    Text("Start Routine")
                        .font(AppTheme.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .fill(selectedOption != nil ? AppTheme.primaryColor : AppTheme.textSecondary)
                        )
                }
                .disabled(selectedOption == nil)
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
            .navigationTitle("Morning Routine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primaryColor)
                }
            }
        }
        .sheet(isPresented: $showingRoutineGuide) {
            RoutineGuideView(isCompleted: $isCompleted, startOption: selectedOption)
        }
    }
}

// MARK: - Evening Routine Start Options View
struct EveningRoutineStartOptionsView: View {
    @Binding var isCompleted: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var showingRoutineGuide = false
    @State private var selectedOption: RoutineStartOption?
    
    private let startOptions: [RoutineStartOption] = [
        RoutineStartOption(title: "Do routine with Spotify", icon: "music.note", color: .purple),
        RoutineStartOption(title: "Do routine with Radio", icon: "radio", color: .purple),
        RoutineStartOption(title: "Do routine with Daily News", icon: "newspaper", color: .purple),
        RoutineStartOption(title: "Do routine with Mindfulness", icon: "leaf", color: .green),
        RoutineStartOption(title: "Do routine with Silent", icon: "moon", color: .gray)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Header
                VStack(spacing: AppTheme.Spacing.md) {
                    Text("How do you want to start?")
                        .font(AppTheme.Typography.title1)
                        .fontWeight(.bold)
                            .foregroundColor(AppTheme.textPrimary)
                        .multilineTextAlignment(.center)
                        
                    Text("Choose your preferred way to begin your evening skincare routine")
                            .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, AppTheme.Spacing.xl)
                
                // Options List
                VStack(spacing: AppTheme.Spacing.md) {
                    ForEach(startOptions, id: \.title) { option in
                        RoutineStartOptionButton(
                            option: option,
                            isSelected: selectedOption?.title == option.title
                        ) {
                            selectedOption = option
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                        
                        Spacer()
                        
                // Start Button
                        Button(action: {
                    if selectedOption != nil {
                        showingRoutineGuide = true
                    }
                }) {
                    Text("Start Routine")
                        .font(AppTheme.Typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .fill(selectedOption != nil ? AppTheme.primaryColor : AppTheme.textSecondary)
                        )
                }
                .disabled(selectedOption == nil)
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
            .navigationTitle("Evening Routine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primaryColor)
                }
            }
        }
        .sheet(isPresented: $showingRoutineGuide) {
            EveningRoutineGuideView(isCompleted: $isCompleted, startOption: selectedOption)
        }
    }
}

// MARK: - Routine Start Option Model
struct RoutineStartOption {
    let title: String
    let icon: String
    let color: Color
}

// MARK: - Routine Start Option Button
struct RoutineStartOptionButton: View {
    let option: RoutineStartOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: option.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(option.color)
                    .frame(width: 24)
                
                Text(option.title)
                    .font(AppTheme.Typography.body)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                        .foregroundColor(AppTheme.primaryColor)
                }
            }
            .padding(AppTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(isSelected ? AppTheme.primaryColor.opacity(0.1) : AppTheme.surfaceColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .stroke(isSelected ? AppTheme.primaryColor : Color.clear, lineWidth: 2)
                    )
            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
}

// MARK: - Routine Guide View
struct RoutineGuideView: View {
    @Binding var isCompleted: Bool
    let startOption: RoutineStartOption?
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var timeRemaining = 0
    @State private var timer: Timer?
    @State private var showingCompletion = false
    @State private var isMirrorOn = true
    
    private let routineSteps = [
        ("Cleanser", "soap.fill", "Apply gently in circular motions", 30),
        ("Serum", "drop.fill", "Pat gently until absorbed", 45),
        ("Moisturizer", "pump.fill", "Massage in upward motions", 60),
        ("SPF", "sun.max.fill", "Apply evenly to face and neck", 30)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Camera Background (only when mirror is on)
                if isMirrorOn {
                    RoutineCameraPreview()
                        .ignoresSafeArea()
                } else {
                    Color.black
                        .ignoresSafeArea()
                }
                
                // Overlay Content
                VStack {
                    // Header
            HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Step \(currentStep + 1)/\(routineSteps.count)")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        // Mirror Toggle
                        HStack(spacing: 4) {
                            Image(systemName: "mirror")
                                .font(.system(size: 16))
                            Toggle("", isOn: $isMirrorOn)
                                .toggleStyle(SwitchToggleStyle(tint: .green))
                                .scaleEffect(0.8)
                        }
                        .foregroundColor(.white)
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Product Info Card
                    VStack(spacing: AppTheme.Spacing.md) {
                        // Selected Option Indicator
                        if let option = startOption {
                            HStack {
                                Image(systemName: option.icon)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(option.color)
                                
                                Text(option.title)
                        .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                                    .fill(option.color.opacity(0.1))
                            )
                        }
                        
                        // Product Icon and Name
                        HStack {
                            Image(systemName: routineSteps[currentStep].1)
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(AppTheme.primaryColor)
                            
                            Text(routineSteps[currentStep].0)
                                .font(AppTheme.Typography.title2)
                                .fontWeight(.bold)
                        .foregroundColor(AppTheme.textPrimary)
                        }
                        
                        // Instructions
                        Text(routineSteps[currentStep].2)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        // Timer
                        Text("\(timeRemaining)s")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(AppTheme.primaryColor)
                    }
                    .padding(AppTheme.Spacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .fill(Color.white)
                            .appShadow(AppTheme.Shadows.medium)
                    )
                    .padding(.horizontal, AppTheme.Spacing.md)
                    
                    // Skip Button
                    Button("Skip") {
                        nextStep()
                    }
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.vertical, AppTheme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(Color.gray.opacity(0.7))
                    )
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.bottom, AppTheme.Spacing.lg)
                }
            }
        }
        .onAppear {
            timeRemaining = routineSteps[currentStep].3
            startTimer()
        }
        .onChange(of: timeRemaining) { newValue in
            if newValue == 0 && currentStep < routineSteps.count - 1 {
                nextStep()
            } else if newValue == 0 && currentStep == routineSteps.count - 1 {
                showingCompletion = true
            }
        }
        .alert("Congratulations! 🎉", isPresented: $showingCompletion) {
            Button("Done") {
                isCompleted = true
                dismiss()
            }
        } message: {
            Text("You've completed your morning skincare routine!")
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
    
    private func nextStep() {
        timer?.invalidate()
        if currentStep < routineSteps.count - 1 {
            currentStep += 1
            timeRemaining = routineSteps[currentStep].3
        } else {
            showingCompletion = true
        }
    }
}

// MARK: - Evening Routine Guide View
struct EveningRoutineGuideView: View {
    @Binding var isCompleted: Bool
    let startOption: RoutineStartOption?
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var timeRemaining = 0
    @State private var timer: Timer?
    @State private var showingCompletion = false
    @State private var isMirrorOn = true
    
    private let routineSteps = [
        ("Cleanser", "soap.fill", "Remove makeup and cleanse thoroughly", 45),
        ("Toner", "drop.fill", "Apply with cotton pad in gentle strokes", 30),
        ("Serum", "drop.fill", "Pat gently until absorbed", 45),
        ("Moisturizer", "pump.fill", "Massage in upward motions", 60),
        ("Night Cream", "jar.fill", "Apply generously for overnight care", 30)
    ]
    
    var body: some View {
        NavigationView {
                ZStack {
                // Camera Background (only when mirror is on)
                if isMirrorOn {
                    RoutineCameraPreview()
                        .ignoresSafeArea()
                } else {
                    Color.black
                        .ignoresSafeArea()
                }
                
                // Overlay Content
                VStack {
                    // Header
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Step \(currentStep + 1)/\(routineSteps.count)")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        // Mirror Toggle
                        HStack(spacing: 4) {
                            Image(systemName: "mirror")
                                .font(.system(size: 16))
                            Toggle("", isOn: $isMirrorOn)
                                .toggleStyle(SwitchToggleStyle(tint: .green))
                                .scaleEffect(0.8)
                        }
                        .foregroundColor(.white)
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Product Info Card
                    VStack(spacing: AppTheme.Spacing.md) {
                        // Selected Option Indicator
                        if let option = startOption {
                            HStack {
                                Image(systemName: option.icon)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(option.color)
                                
                                Text(option.title)
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                                
                                Spacer()
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                                    .fill(option.color.opacity(0.1))
                            )
                        }
                        
                        // Product Icon and Name
                        HStack {
                            Image(systemName: routineSteps[currentStep].1)
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(AppTheme.primaryColor)
                            
                            Text(routineSteps[currentStep].0)
                                .font(AppTheme.Typography.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.textPrimary)
                        }
                        
                        // Instructions
                        Text(routineSteps[currentStep].2)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        // Timer
                        Text("\(timeRemaining)s")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(AppTheme.primaryColor)
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(Color.white)
                            .appShadow(AppTheme.Shadows.medium)
                    )
                    .padding(.horizontal, AppTheme.Spacing.md)
                    
                    // Skip Button
                    Button("Skip") {
                        nextStep()
                    }
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.vertical, AppTheme.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                            .fill(Color.gray.opacity(0.7))
                    )
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.bottom, AppTheme.Spacing.lg)
                }
            }
        }
        .onAppear {
            timeRemaining = routineSteps[currentStep].3
            startTimer()
        }
        .onChange(of: timeRemaining) { newValue in
            if newValue == 0 && currentStep < routineSteps.count - 1 {
                nextStep()
            } else if newValue == 0 && currentStep == routineSteps.count - 1 {
                showingCompletion = true
            }
        }
        .alert("Congratulations! 🎉", isPresented: $showingCompletion) {
            Button("Done") {
                isCompleted = true
                dismiss()
            }
        } message: {
            Text("You've completed your evening skincare routine!")
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
    
    private func nextStep() {
        timer?.invalidate()
        if currentStep < routineSteps.count - 1 {
            currentStep += 1
            timeRemaining = routineSteps[currentStep].3
        } else {
            showingCompletion = true
        }
    }
}

// MARK: - Routine Camera Preview View
struct RoutineCameraPreview: View {
    var body: some View {
        Rectangle()
            .fill(Color.black)
            .overlay(
                Text("Camera Preview")
                    .foregroundColor(.white)
                    .font(.title)
            )
    }
}

// MARK: - Action Button
struct ActionButton: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                
                Text(text)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(color)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Skin Journal Card
struct SkinJournalCard: View {
    @State private var selectedMood = 0
    @State private var selectedConditions = Set<String>()
    @State private var isExpanded = false
    @State private var sparkleRotation = 0.0
    @State private var isAnimating = false
    
    private let moods = ["😊", "😌", "😐", "😕", "😢"]
    private let conditions = ["Redness", "Dryness", "Breakout", "Glowy"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            // Header with animation
            HStack {
                HStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.yellow)
                        .rotationEffect(.degrees(sparkleRotation))
                        .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: sparkleRotation)
                    
                Text("Skin Journal")
                    .font(AppTheme.Typography.headline)
                    .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: { 
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isExpanded)
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    // Fun prompt with emoji
                    HStack {
                        Text("✨")
                            .font(.system(size: 20))
            Text("How does your skin feel today?")
                .font(AppTheme.Typography.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    
                    // Enhanced Mood Selection
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Mood Check")
                            .font(AppTheme.Typography.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.8))
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
            HStack(spacing: AppTheme.Spacing.md) {
                ForEach(0..<moods.count, id: \.self) { index in
                                Button(action: { 
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        selectedMood = index
                                    }
                                }) {
                        Text(moods[index])
                                        .font(.system(size: 28))
                                        .frame(width: 50, height: 50)
                            .background(
                                Circle()
                                                .fill(selectedMood == index ? Color.white.opacity(0.3) : Color.clear)
                                                .overlay(
                                                    Circle()
                                                        .stroke(selectedMood == index ? Color.white.opacity(0.5) : Color.clear, lineWidth: 2)
                            )
                                        )
                                        .scaleEffect(selectedMood == index ? 1.1 : 1.0)
                                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedMood)
                    }
                    .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    
                    // Enhanced Skin Condition Tags
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Skin Conditions")
                            .font(AppTheme.Typography.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.8))
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppTheme.Spacing.sm) {
                ForEach(conditions, id: \.self) { condition in
                    Button(action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        if selectedConditions.contains(condition) {
                            selectedConditions.remove(condition)
                        } else {
                            selectedConditions.insert(condition)
                                        }
                        }
                    }) {
                        Text(condition)
                            .font(AppTheme.Typography.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(selectedConditions.contains(condition) ? .white : .white.opacity(0.9))
                            .padding(.horizontal, AppTheme.Spacing.sm)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                            .background(
                                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                                                .fill(selectedConditions.contains(condition) ? Color.white.opacity(0.3) : Color.white.opacity(0.1))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                                                        .stroke(selectedConditions.contains(condition) ? Color.white.opacity(0.5) : Color.white.opacity(0.2), lineWidth: 1)
                                                )
                                        )
                                        .scaleEffect(selectedConditions.contains(condition) ? 1.02 : 1.0)
                                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selectedConditions)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
                    }
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity.combined(with: .move(edge: .top))
                ))
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.8),
                        Color.purple.opacity(0.7),
                        Color.pink.opacity(0.6)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Animated background pattern
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 150
                        )
                    )
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .animation(
                        Animation.easeInOut(duration: 3.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
        .appShadow(AppTheme.Shadows.medium)
        .scaleEffect(isAnimating ? 1.01 : 1.0)
        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.8)) {
            isAnimating = true
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            sparkleRotation = 360
        }
    }
}

// MARK: - UV Index Card
struct UVIndexCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.orange)
                
                Text("UV Index")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Text("6")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.orange)
            
            Text("Wear hat/shade, SPF50+, avoid midday sun.")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.orange.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Humidity Card
struct HumidityCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: "drop.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                
                Text("Humidity")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Text("45%")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.blue)
            
            Text("Good balance — continue normal routine.")
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.blue.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Pollution Level Card
struct PollutionLevelCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack {
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.green)
                    
                    Text("Pollution Level")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                HStack(alignment: .bottom, spacing: AppTheme.Spacing.sm) {
                    Text("13")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("Good")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.green)
                        )
                }
                
                Text("Normal levels; antioxidants are a good idea.")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(Color.green.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Bottom Navigation
struct BottomNavigationView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabIcon(for: index))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(selectedTab == index ? AppTheme.primaryColor : AppTheme.textSecondary)
                        
                        if selectedTab == index {
                            Circle()
                                .fill(AppTheme.primaryColor)
                                .frame(width: 6, height: 6)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.md)
                }
            }
        }
        .background(Color.white)
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "drop.fill"
        case 2: return "viewfinder"
        case 3: return "sparkles"
        case 4: return "person.fill"
        default: return "circle"
        }
    }
}

// MARK: - Face Analysis View Model Extensions
extension FaceAnalysisViewModel: @preconcurrency AVCapturePhotoCaptureDelegate {
    nonisolated func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = image
        }
    }
}

    // MARK: - Camera Preview View
    struct CameraPreviewView: UIViewRepresentable {
        let session: AVCaptureSession
        
        func makeUIView(context: Context) -> UIView {
            let view = UIView(frame: UIScreen.main.bounds)
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = view.frame
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
                previewLayer.frame = uiView.bounds
            }
        }
    }

    // MARK: - Photo Picker
    struct PhotoPicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        let onImageSelected: (UIImage?) -> Void
        @Environment(\.dismiss) private var dismiss
        
        func makeUIViewController(context: Context) -> PHPickerViewController {
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, PHPickerViewControllerDelegate {
            let parent: PhotoPicker
            
            init(_ parent: PhotoPicker) {
                self.parent = parent
            }
            
            func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                picker.dismiss(animated: true)
                
                guard let provider = results.first?.itemProvider,
                      provider.canLoadObject(ofClass: UIImage.self) else { return }
                
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    DispatchQueue.main.async {
                        let selectedImage = image as? UIImage
                        self?.parent.selectedImage = selectedImage
                        self?.parent.onImageSelected(selectedImage)
                    }
                }
            }
        }
    }

// MARK: - Consent Sheet
struct ConsentSheet: View {
    let image: UIImage?
    let onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Confirm Photo")
                .font(.title2)
                .fontWeight(.bold)
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
            }
            
            Text("Is this photo good for analysis?")
                .font(.body)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Button("Retake") {
                    dismiss()
                }
                .foregroundColor(.secondary)
                
                Button("Confirm") {
                    onConfirm()
                    dismiss()
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

    // MARK: - Skin Report View
    struct SkinReportView: View {
        let image: UIImage?
        let onContinue: () -> Void
        @Environment(\.dismiss) private var dismiss
        @State private var showingAboutResult = false
        @ObservedObject var faceAnalysisViewModel: FaceAnalysisViewModel
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    // Modern Background - Survey akışındaki renk paleti
                    AppTheme.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Modern Header
                        modernHeaderView(geometry: geometry)
                        
                        Spacer(minLength: 20)
                        
                        // Skin Analysis Results
                        modernSkinResultsView(geometry: geometry)
                        
                        Spacer(minLength: 30)
                        
                        // Continue Button
                        modernContinueButton(geometry: geometry)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAboutResult) {
                AboutResultsView(
                    onContinue: {
                        showingAboutResult = false
                        onContinue()
                    },
                    onCancel: {
                        showingAboutResult = false
                        // Show result adjustment view
                        faceAnalysisViewModel.showingResultAdjustment = true
                    }
                )
            }
            .sheet(isPresented: $faceAnalysisViewModel.showingResultAdjustment) {
                ResultAdjustmentView(viewModel: faceAnalysisViewModel)
            }
        }
        
        // MARK: - Modern Header View
        private func modernHeaderView(geometry: GeometryProxy) -> some View {
            VStack(spacing: 20) {
                // Top Navigation
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppTheme.darkCharcoal)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(AppTheme.creamWhite)
                                    .shadow(color: AppTheme.darkCharcoal.opacity(0.1), radius: 4, x: 0, y: 2)
                            )
                    }
                    .accessibilityLabel("Back")
                    
                    Spacer()
                    
                    // Close button placeholder
                    Spacer()
                        .frame(width: 32, height: 32)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Title and Subtitle
                VStack(spacing: 8) {
                    Text("Your Skin Report")
                        .font(AppTheme.Typography.surveyTitle)
                        .foregroundColor(AppTheme.darkCharcoal)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text("AI-powered analysis of your skin condition.")
                        .font(AppTheme.Typography.surveySubtitle)
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 10)
        }
        
        // MARK: - Modern Skin Results View
        private func modernSkinResultsView(geometry: GeometryProxy) -> some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Photo Preview
                    if let image = image {
                        VStack(spacing: 16) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200)
                                .cornerRadius(16)
                                .shadow(color: AppTheme.darkCharcoal.opacity(0.1), radius: 8, x: 0, y: 4)
                        }
                    }
                    
                    // Analysis Results Card
                    VStack(spacing: 20) {
                        // Success Icon
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.darkCharcoal.opacity(0.15))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(.green)
                            }
                        }
                        
                        // Results Text
                        VStack(spacing: 12) {
                            Text("Analysis Complete!")
                                .font(AppTheme.Typography.title2)
                                .foregroundColor(AppTheme.darkCharcoal)
                                .multilineTextAlignment(.center)
                            
                            Text("Your skin has been analyzed successfully. Here are your personalized recommendations:")
                                .font(AppTheme.Typography.surveyOption)
                                .foregroundColor(AppTheme.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(4)
                        }
                        
                        // Skin Analysis Results
                        VStack(spacing: 12) {
                            if faceAnalysisViewModel.skinType != "None" {
                                RecommendationCard(
                                    title: "Skin Type",
                                    value: faceAnalysisViewModel.skinType,
                                    description: "Your skin shows both oily and dry areas.",
                                    icon: "face.smiling",
                                    color: .yellow
                                )
                            }
                            
                            if faceAnalysisViewModel.skinSensitivity != "None" {
                                RecommendationCard(
                                    title: "Skin Sensitivity",
                                    value: faceAnalysisViewModel.skinSensitivity,
                                    description: "Your skin is generally not reactive to products.",
                                    icon: "exclamationmark.triangle.fill",
                                    color: .orange
                                )
                            }
                            
                            if faceAnalysisViewModel.acne != "None" {
                                RecommendationCard(
                                    title: "Acne",
                                    value: faceAnalysisViewModel.acne,
                                    description: "Breakouts are minimal and easily manageable.",
                                    icon: "circle.fill",
                                    color: .red
                                )
                            }
                            
                            if faceAnalysisViewModel.tZoneOilness != "None" {
                                RecommendationCard(
                                    title: "T-Zone Oilness",
                                    value: faceAnalysisViewModel.tZoneOilness,
                                    description: "Your T-zone shows some oiliness during the day.",
                                    icon: "drop.fill",
                                    color: .blue
                                )
                            }
                            
                            if faceAnalysisViewModel.dryness != "None" {
                                RecommendationCard(
                                    title: "Dryness",
                                    value: faceAnalysisViewModel.dryness,
                                    description: "Your skin maintains good hydration levels.",
                                    icon: "sun.max.fill",
                                    color: .orange
                                )
                            }
                            
                            if faceAnalysisViewModel.wrinkles != "None" {
                                RecommendationCard(
                                    title: "Wrinkles & Fine Lines",
                                    value: faceAnalysisViewModel.wrinkles,
                                    description: "Very few signs of aging are present.",
                                    icon: "line.3.horizontal",
                                    color: .gray
                                )
                            }
                            
                            if faceAnalysisViewModel.blackheads != "None" {
                                RecommendationCard(
                                    title: "Blackheads",
                                    value: faceAnalysisViewModel.blackheads,
                                    description: "Minimal blackheads detected in your pores.",
                                    icon: "circle.dotted",
                                    color: .brown
                                )
                            }
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.cardGradient)
                            .shadow(color: AppTheme.darkCharcoal.opacity(0.08), radius: 20, x: 0, y: 8)
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 100) // Extra padding for scroll
            }
        }
        
        // MARK: - Modern Continue Button
        private func modernContinueButton(geometry: GeometryProxy) -> some View {
            Button(action: {
                showingAboutResult = true
            }) {
                HStack(spacing: 8) {
                    Text("Are you satisfied with the results?")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppTheme.softPink)
                )
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Recommendation Card
    struct RecommendationCard: View {
        let title: String
        let value: String
        let description: String
        let icon: String
        let color: Color
        
        var body: some View {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(color)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppTheme.Typography.surveyOption)
                        .foregroundColor(AppTheme.textSecondary)
                    
                    Text(value)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.darkCharcoal)
                    
                    Text(description)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(AppTheme.textSecondary)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.creamWhite)
                    .shadow(color: AppTheme.darkCharcoal.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
    }

    // MARK: - About Results View
    struct AboutResultsView: View {
        let onContinue: () -> Void
        let onCancel: () -> Void
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    // Modern Background
                    AppTheme.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Header
                        modernHeaderView(geometry: geometry)
                        
                        Spacer(minLength: 20)
                        
                        // Content
                        modernContentView(geometry: geometry)
                        
                        Spacer(minLength: 30)
                        
                        // Buttons
                        modernButtonsView(geometry: geometry)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        
        // MARK: - Modern Header View
        private func modernHeaderView(geometry: GeometryProxy) -> some View {
            VStack(spacing: 20) {
                // Top Navigation
                HStack {
                    Button(action: onCancel) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppTheme.darkCharcoal)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(AppTheme.creamWhite)
                                    .shadow(color: AppTheme.darkCharcoal.opacity(0.1), radius: 4, x: 0, y: 2)
                            )
                    }
                    .accessibilityLabel("Close")
                    
                    Spacer()
                    
                    // Title
                    Text("About Results")
                        .font(AppTheme.Typography.surveyTitle)
                        .foregroundColor(AppTheme.darkCharcoal)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Spacer()
                        .frame(width: 32, height: 32)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .padding(.bottom, 10)
        }
        
        // MARK: - Modern Content View
        private func modernContentView(geometry: GeometryProxy) -> some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Main Content Card
                    VStack(spacing: 20) {
                        // Icon
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.darkCharcoal.opacity(0.15))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(AppTheme.softPink)
                            }
                        }
                        
                        // Content Text
                        VStack(spacing: 16) {
                            Text("Understanding Your Skin Analysis")
                                .font(AppTheme.Typography.title2)
                                .foregroundColor(AppTheme.darkCharcoal)
                                .multilineTextAlignment(.center)
                            
                            VStack(spacing: 12) {
                                Text("Sometimes it's not possible to determine the analysis completely accurately from just one photo :) If you're not satisfied, would you like to make adjustments to the analysis results and complete your profile?")
                                    .font(AppTheme.Typography.surveyOption)
                                    .foregroundColor(AppTheme.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.cardGradient)
                            .shadow(color: AppTheme.darkCharcoal.opacity(0.08), radius: 20, x: 0, y: 8)
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
        }
        
        // MARK: - Modern Buttons View
        private func modernButtonsView(geometry: GeometryProxy) -> some View {
            VStack(spacing: 16) {
                // Continue Button
                Button(action: onContinue) {
                    HStack(spacing: 8) {
                        Text("Continue to App")
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppTheme.softPink)
                    )
                }
                .padding(.horizontal, 20)
                
                // Adjust Button
                Button(action: onCancel) {
                    Text("Adjust your results")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.darkCharcoal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppTheme.creamWhite)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(AppTheme.darkCharcoal.opacity(0.2), lineWidth: 1)
                                )
                        )
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Info Row
    struct InfoRow: View {
        let title: String
        let description: String
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                // Bullet point
                Circle()
                    .fill(AppTheme.softPink)
                    .frame(width: 6, height: 6)
                    .padding(.top, 6)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.darkCharcoal)
                    
                    Text(description)
                        .font(AppTheme.Typography.surveyOption)
                        .foregroundColor(AppTheme.textSecondary)
                        .lineLimit(nil)
                }
                
                Spacer()
            }
        }
    }

    // MARK: - Result Adjustment View
    struct ResultAdjustmentView: View {
        @ObservedObject var viewModel: FaceAnalysisViewModel
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    // Modern Background
                    AppTheme.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Header
                        modernHeaderView(geometry: geometry)
                        
                        Spacer(minLength: 20)
                        
                        // Content
                        modernContentView(geometry: geometry)
                        
                        Spacer(minLength: 30)
                        
                        // Buttons
                        modernButtonsView(geometry: geometry)
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        
        // MARK: - Modern Header View
        private func modernHeaderView(geometry: GeometryProxy) -> some View {
            VStack(spacing: 20) {
                // Top Navigation
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppTheme.darkCharcoal)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(AppTheme.creamWhite)
                                    .shadow(color: AppTheme.darkCharcoal.opacity(0.1), radius: 4, x: 0, y: 2)
                            )
                    }
                    .accessibilityLabel("Close")
                    
                    Spacer()
                    
                    // Title
                    Text("Adjust Your Results")
                        .font(AppTheme.Typography.surveyTitle)
                        .foregroundColor(AppTheme.darkCharcoal)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Spacer()
                        .frame(width: 32, height: 32)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .padding(.bottom, 10)
        }
        
        // MARK: - Modern Content View
        private func modernContentView(geometry: GeometryProxy) -> some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Main Content Card
                    VStack(spacing: 20) {
                        // Icon
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.darkCharcoal.opacity(0.15))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundColor(AppTheme.softPink)
                            }
                        }
                        
                        // Content Text
                        VStack(spacing: 16) {
                            Text("Customize Your Analysis")
                                .font(AppTheme.Typography.title2)
                                .foregroundColor(AppTheme.darkCharcoal)
                                .multilineTextAlignment(.center)
                            
                            Text("Adjust the analysis results to better match your skin condition. You can modify or remove any category.")
                                .font(AppTheme.Typography.surveyOption)
                                .foregroundColor(AppTheme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Adjustment Options
                        VStack(spacing: 16) {
                            // Skin Type (No delete button - cannot be removed)
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Skin Type")
                                        .font(AppTheme.Typography.headline)
                                        .foregroundColor(AppTheme.darkCharcoal)
                                    
                                    Spacer()
                                    
                                    // No remove button for Skin Type
                                }
                                
                                Button(action: {
                                    // Toggle dropdown for Skin Type
                                    viewModel.showingSkinTypeOptions.toggle()
                                }) {
                                    HStack {
                                        Text(viewModel.skinType)
                                            .font(AppTheme.Typography.surveyOption)
                                            .foregroundColor(AppTheme.darkCharcoal)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(AppTheme.darkCharcoal)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(AppTheme.creamWhite)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(AppTheme.darkCharcoal.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                                
                                // Skin Type Options
                                if viewModel.showingSkinTypeOptions {
                                    VStack(spacing: 8) {
                                        ForEach(["Normal", "Oily", "Dry", "Combination", "Sensitive"], id: \.self) { option in
                                            Button(action: {
                                                viewModel.skinType = option
                                                viewModel.showingSkinTypeOptions = false
                                            }) {
                                                HStack {
                                                    Text(option)
                                                        .font(AppTheme.Typography.surveyOption)
                                                        .foregroundColor(option == viewModel.skinType ? AppTheme.softPink : AppTheme.darkCharcoal)
                                                    
                                                    Spacer()
                                                    
                                                    if option == viewModel.skinType {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 14, weight: .medium))
                                                            .foregroundColor(AppTheme.softPink)
                                                    }
                                                }
                                                .padding(12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(option == viewModel.skinType ? AppTheme.softPink.opacity(0.1) : AppTheme.creamWhite)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Skin Sensitivity
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Skin Sensitivity")
                                        .font(AppTheme.Typography.headline)
                                        .foregroundColor(AppTheme.darkCharcoal)
                                    
                                    Spacer()
                                    
                                    // Remove button
                                    Button(action: {
                                        viewModel.skinSensitivity = "None"
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.red)
                                            .frame(width: 24, height: 24)
                                            .background(
                                                Circle()
                                                    .fill(Color.red.opacity(0.1))
                                            )
                                    }
                                }
                                
                                Button(action: {
                                    // Toggle dropdown for Skin Sensitivity
                                    viewModel.showingSkinSensitivityOptions.toggle()
                                }) {
                                    HStack {
                                        Text(viewModel.skinSensitivity == "None" ? "Removed" : viewModel.skinSensitivity)
                                            .font(AppTheme.Typography.surveyOption)
                                            .foregroundColor(viewModel.skinSensitivity == "None" ? .red : AppTheme.darkCharcoal)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(AppTheme.darkCharcoal)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.skinSensitivity == "None" ? Color.red.opacity(0.05) : AppTheme.creamWhite)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(viewModel.skinSensitivity == "None" ? Color.red.opacity(0.3) : AppTheme.darkCharcoal.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                                
                                // Skin Sensitivity Options
                                if viewModel.showingSkinSensitivityOptions {
                                    VStack(spacing: 8) {
                                        ForEach(["Low", "Moderate", "High"], id: \.self) { option in
                                            Button(action: {
                                                viewModel.skinSensitivity = option
                                                viewModel.showingSkinSensitivityOptions = false
                                            }) {
                                                HStack {
                                                    Text(option)
                                                        .font(AppTheme.Typography.surveyOption)
                                                        .foregroundColor(option == viewModel.skinSensitivity ? AppTheme.softPink : AppTheme.darkCharcoal)
                                                    
                                                    Spacer()
                                                    
                                                    if option == viewModel.skinSensitivity {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 14, weight: .medium))
                                                            .foregroundColor(AppTheme.softPink)
                                                    }
                                                }
                                                .padding(12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(option == viewModel.skinSensitivity ? AppTheme.softPink.opacity(0.1) : AppTheme.creamWhite)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Acne
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Acne")
                                        .font(AppTheme.Typography.headline)
                                        .foregroundColor(AppTheme.darkCharcoal)
                                    
                                    Spacer()
                                    
                                    // Remove button
                                    Button(action: {
                                        viewModel.acne = "None"
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.red)
                                            .frame(width: 24, height: 24)
                                            .background(
                                                Circle()
                                                    .fill(Color.red.opacity(0.1))
                                            )
                                    }
                                }
                                
                                Button(action: {
                                    // Toggle dropdown for Acne
                                    viewModel.showingAcneOptions.toggle()
                                }) {
                                    HStack {
                                        Text(viewModel.acne == "None" ? "Removed" : viewModel.acne)
                                            .font(AppTheme.Typography.surveyOption)
                                            .foregroundColor(viewModel.acne == "None" ? .red : AppTheme.darkCharcoal)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(AppTheme.darkCharcoal)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.acne == "None" ? Color.red.opacity(0.05) : AppTheme.creamWhite)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(viewModel.acne == "None" ? Color.red.opacity(0.3) : AppTheme.darkCharcoal.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                                
                                // Acne Options
                                if viewModel.showingAcneOptions {
                                    VStack(spacing: 8) {
                                        ForEach(["None", "Mild", "Moderate", "Severe"], id: \.self) { option in
                                            Button(action: {
                                                viewModel.acne = option
                                                viewModel.showingAcneOptions = false
                                            }) {
                                                HStack {
                                                    Text(option)
                                                        .font(AppTheme.Typography.surveyOption)
                                                        .foregroundColor(option == viewModel.acne ? AppTheme.softPink : AppTheme.darkCharcoal)
                                                    
                                                    Spacer()
                                                    
                                                    if option == viewModel.acne {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 14, weight: .medium))
                                                            .foregroundColor(AppTheme.softPink)
                                                    }
                                                }
                                                .padding(12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(option == viewModel.acne ? AppTheme.softPink.opacity(0.1) : AppTheme.creamWhite)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // T-Zone Oilness
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("T-Zone Oilness")
                                        .font(AppTheme.Typography.headline)
                                        .foregroundColor(AppTheme.darkCharcoal)
                                    
                                    Spacer()
                                    
                                    // Remove button
                                    Button(action: {
                                        viewModel.tZoneOilness = "None"
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.red)
                                            .frame(width: 24, height: 24)
                                            .background(
                                                Circle()
                                                    .fill(Color.red.opacity(0.1))
                                            )
                                    }
                                }
                                
                                Button(action: {
                                    // Toggle dropdown for T-Zone Oilness
                                    viewModel.showingTZoneOilnessOptions.toggle()
                                }) {
                                    HStack {
                                        Text(viewModel.tZoneOilness == "None" ? "Removed" : viewModel.tZoneOilness)
                                            .font(AppTheme.Typography.surveyOption)
                                            .foregroundColor(viewModel.tZoneOilness == "None" ? .red : AppTheme.darkCharcoal)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(AppTheme.darkCharcoal)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.tZoneOilness == "None" ? Color.red.opacity(0.05) : AppTheme.creamWhite)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(viewModel.tZoneOilness == "None" ? Color.red.opacity(0.3) : AppTheme.darkCharcoal.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                                
                                // T-Zone Oilness Options
                                if viewModel.showingTZoneOilnessOptions {
                                    VStack(spacing: 8) {
                                        ForEach(["None", "Low", "Moderate", "High"], id: \.self) { option in
                                            Button(action: {
                                                viewModel.tZoneOilness = option
                                                viewModel.showingTZoneOilnessOptions = false
                                            }) {
                                                HStack {
                                                    Text(option)
                                                        .font(AppTheme.Typography.surveyOption)
                                                        .foregroundColor(option == viewModel.tZoneOilness ? AppTheme.softPink : AppTheme.darkCharcoal)
                                                    
                                                    Spacer()
                                                    
                                                    if option == viewModel.tZoneOilness {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 14, weight: .medium))
                                                            .foregroundColor(AppTheme.softPink)
                                                    }
                                                }
                                                .padding(12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(option == viewModel.tZoneOilness ? AppTheme.softPink.opacity(0.1) : AppTheme.creamWhite)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Dryness
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Dryness")
                                        .font(AppTheme.Typography.headline)
                                        .foregroundColor(AppTheme.darkCharcoal)
                                    
                                    Spacer()
                                    
                                    // Remove button
                                    Button(action: {
                                        viewModel.dryness = "None"
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.red)
                                            .frame(width: 24, height: 24)
                                            .background(
                                                Circle()
                                                    .fill(Color.red.opacity(0.1))
                                            )
                                    }
                                }
                                
                                Button(action: {
                                    // Toggle dropdown for Dryness
                                    viewModel.showingDrynessOptions.toggle()
                                }) {
                                    HStack {
                                        Text(viewModel.dryness == "None" ? "Removed" : viewModel.dryness)
                                            .font(AppTheme.Typography.surveyOption)
                                            .foregroundColor(viewModel.dryness == "None" ? .red : AppTheme.darkCharcoal)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(AppTheme.darkCharcoal)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.dryness == "None" ? Color.red.opacity(0.05) : AppTheme.creamWhite)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(viewModel.dryness == "None" ? Color.red.opacity(0.3) : AppTheme.darkCharcoal.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                                
                                // Dryness Options
                                if viewModel.showingDrynessOptions {
                                    VStack(spacing: 8) {
                                        ForEach(["None", "Low", "Moderate", "High"], id: \.self) { option in
                                            Button(action: {
                                                viewModel.dryness = option
                                                viewModel.showingDrynessOptions = false
                                            }) {
                                                HStack {
                                                    Text(option)
                                                        .font(AppTheme.Typography.surveyOption)
                                                        .foregroundColor(option == viewModel.dryness ? AppTheme.softPink : AppTheme.darkCharcoal)
                                                    
                                                    Spacer()
                                                    
                                                    if option == viewModel.dryness {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 14, weight: .medium))
                                                            .foregroundColor(AppTheme.softPink)
                                                    }
                                                }
                                                .padding(12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(option == viewModel.dryness ? AppTheme.softPink.opacity(0.1) : AppTheme.creamWhite)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Wrinkles & Fine Lines
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Wrinkles & Fine Lines")
                                        .font(AppTheme.Typography.headline)
                                        .foregroundColor(AppTheme.darkCharcoal)
                                    
                                    Spacer()
                                    
                                    // Remove button
                                    Button(action: {
                                        viewModel.wrinkles = "None"
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.red)
                                            .frame(width: 24, height: 24)
                                            .background(
                                                Circle()
                                                    .fill(Color.red.opacity(0.1))
                                            )
                                    }
                                }
                                
                                Button(action: {
                                    // Toggle dropdown for Wrinkles
                                    viewModel.showingWrinklesOptions.toggle()
                                }) {
                                    HStack {
                                        Text(viewModel.wrinkles == "None" ? "Removed" : viewModel.wrinkles)
                                            .font(AppTheme.Typography.surveyOption)
                                            .foregroundColor(viewModel.wrinkles == "None" ? .red : AppTheme.darkCharcoal)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(AppTheme.darkCharcoal)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.wrinkles == "None" ? Color.red.opacity(0.05) : AppTheme.creamWhite)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(viewModel.wrinkles == "None" ? Color.red.opacity(0.3) : AppTheme.darkCharcoal.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                                
                                // Wrinkles Options
                                if viewModel.showingWrinklesOptions {
                                    VStack(spacing: 8) {
                                        ForEach(["None", "Minimal", "Moderate", "Severe"], id: \.self) { option in
                                            Button(action: {
                                                viewModel.wrinkles = option
                                                viewModel.showingWrinklesOptions = false
                                            }) {
                                                HStack {
                                                    Text(option)
                                                        .font(AppTheme.Typography.surveyOption)
                                                        .foregroundColor(option == viewModel.wrinkles ? AppTheme.softPink : AppTheme.darkCharcoal)
                                                    
                                                    Spacer()
                                                    
                                                    if option == viewModel.wrinkles {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 14, weight: .medium))
                                                            .foregroundColor(AppTheme.softPink)
                                                    }
                                                }
                                                .padding(12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(option == viewModel.wrinkles ? AppTheme.softPink.opacity(0.1) : AppTheme.creamWhite)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Blackheads
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Blackheads")
                                        .font(AppTheme.Typography.headline)
                                        .foregroundColor(AppTheme.darkCharcoal)
                                    
                                    Spacer()
                                    
                                    // Remove button
                                    Button(action: {
                                        viewModel.blackheads = "None"
                                    }) {
                                        Image(systemName: "trash")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.red)
                                            .frame(width: 24, height: 24)
                                            .background(
                                                Circle()
                                                    .fill(Color.red.opacity(0.1))
                                            )
                                    }
                                }
                                
                                Button(action: {
                                    // Toggle dropdown for Blackheads
                                    viewModel.showingBlackheadsOptions.toggle()
                                }) {
                                    HStack {
                                        Text(viewModel.blackheads == "None" ? "Removed" : viewModel.blackheads)
                                            .font(AppTheme.Typography.surveyOption)
                                            .foregroundColor(viewModel.blackheads == "None" ? .red : AppTheme.darkCharcoal)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(AppTheme.darkCharcoal)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(viewModel.blackheads == "None" ? Color.red.opacity(0.05) : AppTheme.creamWhite)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(viewModel.blackheads == "None" ? Color.red.opacity(0.3) : AppTheme.darkCharcoal.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                                
                                // Blackheads Options
                                if viewModel.showingBlackheadsOptions {
                                    VStack(spacing: 8) {
                                        ForEach(["None", "Few", "Moderate", "Many"], id: \.self) { option in
                                            Button(action: {
                                                viewModel.blackheads = option
                                                viewModel.showingBlackheadsOptions = false
                                            }) {
                                                HStack {
                                                    Text(option)
                                                        .font(AppTheme.Typography.surveyOption)
                                                        .foregroundColor(option == viewModel.blackheads ? AppTheme.softPink : AppTheme.darkCharcoal)
                                                    
                                                    Spacer()
                                                    
                                                    if option == viewModel.blackheads {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 14, weight: .medium))
                                                            .foregroundColor(AppTheme.softPink)
                                                    }
                                                }
                                                .padding(12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(option == viewModel.blackheads ? AppTheme.softPink.opacity(0.1) : AppTheme.creamWhite)
                                                )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.cardGradient)
                            .shadow(color: AppTheme.darkCharcoal.opacity(0.08), radius: 20, x: 0, y: 8)
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
        }
        
        // MARK: - Modern Buttons View
        private func modernButtonsView(geometry: GeometryProxy) -> some View {
            VStack(spacing: 16) {
                // Save Button
                Button(action: {
                    viewModel.showingResultAdjustment = false
                    // Don't show skin report again, just close this view
                }) {
                    HStack(spacing: 8) {
                        Text("Save Changes")
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(.white)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppTheme.softPink)
                    )
                }
                .padding(.horizontal, 20)
                
                // Cancel Button
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.darkCharcoal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppTheme.creamWhite)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(AppTheme.darkCharcoal.opacity(0.2), lineWidth: 1)
                                )
                        )
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Adjustment Row
    struct AdjustmentRow: View {
        let title: String
        @Binding var value: String
        let options: [String]
        @State private var showingOptions = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(AppTheme.Typography.headline)
                        .foregroundColor(AppTheme.darkCharcoal)
                    
                    Spacer()
                    
                    // Remove button
                    Button(action: {
                        value = "None"
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                            .frame(width: 24, height: 24)
                            .background(
                                Circle()
                                    .fill(Color.red.opacity(0.1))
                            )
                    }
                }
                
                Button(action: {
                    showingOptions.toggle()
                }) {
                    HStack {
                        Text(value == "None" ? "Removed" : value)
                            .font(AppTheme.Typography.surveyOption)
                            .foregroundColor(value == "None" ? .red : AppTheme.darkCharcoal)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppTheme.darkCharcoal)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(value == "None" ? Color.red.opacity(0.05) : AppTheme.creamWhite)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(value == "None" ? Color.red.opacity(0.3) : AppTheme.darkCharcoal.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
                
                if showingOptions {
                    VStack(spacing: 8) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                value = option
                                showingOptions = false
                            }) {
                                HStack {
                                    Text(option)
                                        .font(AppTheme.Typography.surveyOption)
                                        .foregroundColor(option == value ? AppTheme.softPink : AppTheme.darkCharcoal)
                                    
                                    Spacer()
                                    
                                    if option == value {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(AppTheme.softPink)
                                    }
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(option == value ? AppTheme.softPink.opacity(0.1) : AppTheme.creamWhite)
                                )
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
    }

    #Preview {
        ContentView()
    }


// MARK: - Product Detail View
struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    // Product Header
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text(product.brand)
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.primaryColor)
                        
                        Text(product.name)
                            .font(AppTheme.Typography.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        Text(product.description)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.textSecondary)
                        
                        // Fit Score Section
                        HStack {
                            Spacer()
                            
                            Text("97% fit for you")
                                .font(AppTheme.Typography.title2)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primaryColor)
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    // Product Image Placeholder
                    VStack(spacing: AppTheme.Spacing.md) {
                        Image(systemName: product.category.icon)
                            .font(.system(size: 80))
                            .foregroundColor(AppTheme.primaryColor)
                        
                        Text(product.category.rawValue)
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .fill(AppTheme.softPink.opacity(0.1))
                    )
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    // Product Info
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        // Price Section
                        HStack {
                            Text("Price")
                                .font(AppTheme.Typography.headline)
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Spacer()
                            
                            Text("$\(String(format: "%.2f", product.price))")
                                .font(AppTheme.Typography.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.primaryColor)
                        }
                        
                        // Rating Section
                        if product.rating > 0 {
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                HStack {
                                    Text("Rating")
                                        .font(AppTheme.Typography.headline)
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    Spacer()
                                }
                                
                                HStack(spacing: AppTheme.Spacing.sm) {
                                    HStack(spacing: 4) {
                                        ForEach(0..<5) { index in
                                            Image(systemName: index < Int(product.rating) ? "star.fill" : 
                                                  (index == Int(product.rating) && product.rating.truncatingRemainder(dividingBy: 1) > 0) ? "star.leadinghalf.filled" : "star")
                                                .font(.system(size: 16))
                                                .foregroundColor(.yellow)
                                        }
                                    }
                                    
                                    Text(String(format: "%.1f", product.rating))
                                        .font(AppTheme.Typography.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    Text("(\(Int.random(in: 100...2000)) reviews)")
                                        .font(AppTheme.Typography.body)
                                        .foregroundColor(AppTheme.textSecondary)
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                        // Product Attributes
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("Product Attributes")
                                .font(AppTheme.Typography.headline)
                                .foregroundColor(AppTheme.textPrimary)
                            
                            HStack(spacing: AppTheme.Spacing.sm) {
                                // Cruelty Free
                                HStack(spacing: 4) {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                    
                                    Text("Cruelty Free")
                                        .font(AppTheme.Typography.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, AppTheme.Spacing.sm)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(AppTheme.primaryColor)
                                )
                                
                                // Vegan
                                if Bool.random() {
                                    HStack(spacing: 4) {
                                        Image(systemName: "leaf.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white)
                                        
                                        Text("Vegan")
                                            .font(AppTheme.Typography.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, AppTheme.Spacing.sm)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(Color.green)
                                    )
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    // Benefits Section
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Benefits")
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            ForEach(["Hydrates skin", "Reduces fine lines", "Improves texture"], id: \.self) { benefit in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                    
                                    Text(benefit)
                                        .font(AppTheme.Typography.body)
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    // How to Use Section
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("How to Use")
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        Text("Apply a small amount to clean skin morning and evening. Gently massage in circular motions until absorbed.")
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    // Ingredients Section
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Key Ingredients")
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            ForEach(["Hyaluronic Acid", "Niacinamide", "Vitamin C"], id: \.self) { ingredient in
                                HStack {
                                    Text("•")
                                        .foregroundColor(AppTheme.primaryColor)
                                        .font(.caption)
                                    
                                    Text(ingredient)
                                        .font(AppTheme.Typography.body)
                                        .foregroundColor(AppTheme.textPrimary)
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                        // All Ingredients Section
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("All Ingredients")
                                .font(AppTheme.Typography.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(AppTheme.textPrimary)
                            
                            Text("Aqua, Glycerin, Hyaluronic Acid, Niacinamide, Vitamin C, Sodium Hyaluronate, Ceramides, Peptides, Retinol, Salicylic Acid, Alpha Hydroxy Acids, Beta Hydroxy Acids, Antioxidants, Preservatives, Fragrance")
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(AppTheme.textSecondary)
                                .lineLimit(nil)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    
                    // Buy Online Button
                    VStack(spacing: AppTheme.Spacing.md) {
                        Button(action: {
                            // Open Amazon link
                            if let url = URL(string: "https://amazon.com") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "cart.fill")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text("Buy Online from Amazon")
                                    .font(AppTheme.Typography.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.Spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                    .fill(Color.orange)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.bottom, 100) // Space for navigation
                }
            }
            .navigationTitle("Product Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

    // MARK: - Products View
    struct ProductsView: View {
        @StateObject private var viewModel = ProductsViewModel()
        @Binding var selectedTab: Int
        @State private var showingProductDetail: Product?
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    // Background gradient
                    AppTheme.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Header
                        VStack(spacing: AppTheme.Spacing.md) {
                            Text("Products")
                                .font(AppTheme.Typography.largeTitle)
                                .foregroundColor(AppTheme.textPrimary)
                                .padding(.top, geometry.size.height * 0.05)
                        }
                        
                        // Category Selection Bar
                        categorySelectionBar()
                        
                        // Search Bar
                        searchBar()
                        
                        // Products Grid
                        productsGrid()
                    }
                    
                    // Bottom Navigation
                    VStack {
                        Spacer()
                        BottomNavigationView(selectedTab: $selectedTab)
                            .background(
                                Rectangle()
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                            )
                    }
                }
            }
            .sheet(item: $showingProductDetail, onDismiss: {
                // Reset product detail state when dismissed
                showingProductDetail = nil
            }) { product in
                ProductDetailView(product: product)
            }
            .onAppear {
                print("✅ ProductsView appeared, items=\(viewModel.filteredProducts.count)")
            }
        }
    
    // MARK: - Category Selection Bar
    private func categorySelectionBar() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach([ProductCategory.all, .cleanser, .moisturizer, .serum, .sunscreen], id: \.self) { category in
                    Button(action: {
                        viewModel.selectCategory(category)
                    }) {
                        Text(category.rawValue)
                            .font(AppTheme.Typography.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(viewModel.selectedCategory == category ? .white : AppTheme.textPrimary)
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(
                                viewModel.selectedCategory == category ?
                                    AppTheme.primaryColor : AppTheme.creamWhite
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
        }
    }
    
    // MARK: - Search Bar
    private func searchBar() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.textSecondary)
                .font(AppTheme.Typography.subheadline)
            
            TextField("Search products…", text: $viewModel.query)
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.textPrimary)
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: viewModel.query) {
                    viewModel.filterProducts()
                }
            
            if !viewModel.query.isEmpty {
                Button(action: {
                    viewModel.clearSearch()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.textSecondary)
                        .font(AppTheme.Typography.subheadline)
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(AppTheme.creamWhite)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.bottom, AppTheme.Spacing.md)
    }
    
    // MARK: - Products Grid
    private func productsGrid() -> some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if viewModel.filteredProducts.isEmpty {
                emptyStateView()
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 160), spacing: AppTheme.Spacing.md)
                    ],
                    spacing: AppTheme.Spacing.md
                ) {
                    ForEach(viewModel.filteredProducts) { product in
                        Button(action: {
                            showingProductDetail = product
                        }) {
                            ProductCardView(product: product, viewModel: viewModel)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.bottom, 100) // Space for bottom navigation
            }
        }
        .refreshable {
            viewModel.loadProducts()
        }
    }
    
    // MARK: - Empty State
    private func emptyStateView() -> some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.textSecondary.opacity(0.5))
            
            Text("No products found")
                .font(AppTheme.Typography.title2)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.textPrimary)
            
            Text("Try adjusting your search or category filter")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Product Card View
struct ProductCardView: View {
    let product: Product
    @ObservedObject var viewModel: ProductsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Product Image/Icon - Much Larger
            ZStack(alignment: .topTrailing) {
                VStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: product.category.icon)
                        .font(.system(size: 80))
                        .foregroundColor(AppTheme.primaryColor)
                    
                    Text(product.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(AppTheme.softPink.opacity(0.1))
                )
                
                // Favorite Button
                Button(action: {
                    viewModel.toggleFavorite(for: product)
                }) {
                    Image(systemName: viewModel.isFavorite(product) ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(viewModel.isFavorite(product) ? .red : AppTheme.textSecondary)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 8)
                .padding(.trailing, 8)
            }
            
                // Product Info - Much Smaller Text
                VStack(alignment: .leading, spacing: 4) {
                    // Brand - Very Small
                    Text(product.brand)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)
                    
                    // Product Name - Smaller
                    Text(product.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                        .lineLimit(2)
                    
                    // Category - Very Small
                    Text(product.category.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(AppTheme.primaryColor)
                        .lineLimit(1)
                }
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.bottom, AppTheme.Spacing.sm)
        }
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
    }
    }

// MARK: - Weather Cards
struct TemperatureCard: View {
    @State private var temperature: Double = 22.0 // Simulated temperature
    @State private var location: String = "Istanbul"
    
    private var temperatureLevel: TemperatureLevel {
        switch temperature {
        case ..<0:
            return .veryCold
        case 0..<10:
            return .cold
        case 10..<20:
            return .mild
        case 20..<30:
            return .warm
        case 30..<40:
            return .hot
        default:
            return .veryHot
        }
    }
    
    private var cardColor: Color {
        switch temperatureLevel {
        case .veryCold:
            return Color.blue.opacity(0.1)
        case .cold:
            return Color.blue.opacity(0.2)
        case .mild:
            return Color.green.opacity(0.1)
        case .warm:
            return Color.orange.opacity(0.1)
        case .hot:
            return Color.orange.opacity(0.2)
        case .veryHot:
            return Color.red.opacity(0.2)
        }
    }
    
    private var borderColor: Color {
        switch temperatureLevel {
        case .veryCold:
            return Color.blue
        case .cold:
            return Color.blue.opacity(0.7)
        case .mild:
            return Color.green
        case .warm:
            return Color.orange
        case .hot:
            return Color.orange.opacity(0.8)
        case .veryHot:
            return Color.red
        }
    }
    
    private var skinImpact: String {
        switch temperatureLevel {
        case .veryCold:
            return "Extreme cold can cause skin dryness and irritation"
        case .cold:
            return "Cold weather may lead to dry, tight skin"
        case .mild:
            return "Mild temperatures are gentle on your skin"
        case .warm:
            return "Warm weather may increase oil production"
        case .hot:
            return "Hot weather can cause dehydration and sun sensitivity"
        case .veryHot:
            return "Extreme heat requires extra hydration and sun protection"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: "thermometer")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(borderColor)
                
                Text("Temperature")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(temperature))°C")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(borderColor)
                
                Text(location)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Text(skinImpact)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(cardColor)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(borderColor, lineWidth: 1)
                )
        )
    }
}

struct WindCard: View {
    @State private var windSpeed: Double = 15.0 // Simulated wind speed in km/h
    @State private var windDirection: String = "NW"
    
    private var windLevel: WindLevel {
        switch windSpeed {
        case ..<5:
            return .calm
        case 5..<15:
            return .light
        case 15..<30:
            return .moderate
        case 30..<50:
            return .strong
        case 50..<70:
            return .veryStrong
        default:
            return .extreme
        }
    }
    
    private var cardColor: Color {
        switch windLevel {
        case .calm:
            return Color.green.opacity(0.1)
        case .light:
            return Color.blue.opacity(0.1)
        case .moderate:
            return Color.orange.opacity(0.1)
        case .strong:
            return Color.orange.opacity(0.2)
        case .veryStrong:
            return Color.red.opacity(0.1)
        case .extreme:
            return Color.red.opacity(0.2)
        }
    }
    
    private var borderColor: Color {
        switch windLevel {
        case .calm:
            return Color.green
        case .light:
            return Color.blue
        case .moderate:
            return Color.orange
        case .strong:
            return Color.orange.opacity(0.8)
        case .veryStrong:
            return Color.red
        case .extreme:
            return Color.red
        }
    }
    
    private var skinImpact: String {
        switch windLevel {
        case .calm:
            return "Gentle conditions are ideal for skin health"
        case .light:
            return "Light breeze may help cool your skin naturally"
        case .moderate:
            return "Moderate wind can cause mild skin dryness"
        case .strong:
            return "Strong wind may lead to skin irritation and dryness"
        case .veryStrong:
            return "Very strong wind can cause significant skin dehydration"
        case .extreme:
            return "Extreme wind conditions require extra skin protection"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: "wind")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(borderColor)
                
                Text("Wind")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(windSpeed)) km/h")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(borderColor)
                
                Text("\(windDirection)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Text(skinImpact)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(cardColor)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(borderColor, lineWidth: 1)
                )
        )
    }
}

// MARK: - Weather Enums
enum TemperatureLevel {
    case veryCold, cold, mild, warm, hot, veryHot
}

enum WindLevel {
    case calm, light, moderate, strong, veryStrong, extreme
}

// MARK: - Greeting System
struct GreetingView: View {
    @State private var currentTime = Date()
    @State private var animationOffset: CGFloat = 0
    @State private var animationOpacity: Double = 0
    
    private let userName = "Beyza" // This could be dynamic from user profile
    
    private var timeOfDay: TimeOfDay {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour {
        case 5..<12:
            return .morning
        case 12..<17:
            return .afternoon
        case 17..<21:
            return .evening
        default:
            return .night
        }
    }
    
    private var greetingText: String {
        switch timeOfDay {
        case .morning:
            return "Good Morning, \(userName)"
        case .afternoon:
            return "Good Afternoon, \(userName)"
        case .evening:
            return "Good Evening, \(userName)"
        case .night:
            return "Good Night, \(userName)"
        }
    }
    
    private var greetingIcon: String {
        switch timeOfDay {
        case .morning:
            return "sun.max.fill"
        case .afternoon:
            return "sun.max"
        case .evening:
            return "sunset.fill"
        case .night:
            return "moon.stars.fill"
        }
    }
    
    private var greetingColor: Color {
        switch timeOfDay {
        case .morning:
            return Color.orange.opacity(0.8)
        case .afternoon:
            return Color.orange.opacity(0.7)
        case .evening:
            return Color.purple.opacity(0.8)
        case .night:
            return Color.blue.opacity(0.8)
        }
    }
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Greeting Text
            Text(greetingText)
                .font(AppTheme.Typography.title2)
                .fontWeight(.medium)
                .foregroundColor(AppTheme.textPrimary)
                .opacity(animationOpacity)
                .animation(
                    Animation.easeInOut(duration: 1.5),
                    value: animationOpacity
                )
            
            Spacer()
            
            // Animated Icon - Modern Design
            ZStack {
                // Background circle for modern look
                Circle()
                    .fill(greetingColor.opacity(0.15))
                    .frame(width: 50, height: 50)
                    .scaleEffect(animationOpacity)
                    .animation(
                        Animation.easeInOut(duration: 1.0),
                        value: animationOpacity
                    )
                
                // Icon
                Image(systemName: greetingIcon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(greetingColor)
                    .offset(y: animationOffset)
                    .opacity(animationOpacity)
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: animationOffset
                    )
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .onAppear {
            startAnimations()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            currentTime = Date()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.0)) {
            animationOpacity = 1.0
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            animationOffset = -5
        }
    }
}

enum TimeOfDay {
    case morning, afternoon, evening, night
}

// MARK: - Did You Know Card
struct DidYouKnowCard: View {
    @State private var currentTip: DailyTip?
    @State private var tipIndex: Int = 0
    @State private var isAnimating = false
    @State private var sparkleRotation = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Header with animated sparkles
            HStack {
                Text("Did you know?")
                    .font(AppTheme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: "sparkles")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.yellow)
                            .rotationEffect(.degrees(sparkleRotation + Double(index * 120)))
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
            }
            
            // Tip Content with fun styling
            if let tip = currentTip {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text(tip.text)
                        .font(AppTheme.Typography.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .opacity(isAnimating ? 1.0 : 0.7)
                        .animation(.easeInOut(duration: 0.8), value: isAnimating)
                }
            } else {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                    
                    Text("Loading fun tip...")
                        .font(AppTheme.Typography.body)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.8),
                        Color.pink.opacity(0.6),
                        Color.orange.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Animated background pattern
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 100
                        )
                    )
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
                    .animation(
                        Animation.easeInOut(duration: 3.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large))
        .appShadow(AppTheme.Shadows.medium)
        .scaleEffect(isAnimating ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
        .onAppear {
            loadDailyTip()
            startAnimations()
        }
    }
    
    private func loadDailyTip() {
        // Get current day of year (1-365)
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        
        // Use day of year to get the tip (with bounds checking)
        let tipIndex = (dayOfYear - 1) % SKINCARE_TIPS_365.count
        currentTip = SKINCARE_TIPS_365[tipIndex]
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.8)) {
            isAnimating = true
        }
        
        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
            sparkleRotation = 360
        }
    }
}

// MARK: - Routine Model
struct Routine: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let gradient: LinearGradient
    let difficulty: Difficulty
    
    enum Difficulty: String, CaseIterable {
        case beginner = "Başlangıç"
        case intermediate = "Orta"
        case advanced = "İleri"
        case expert = "Uzman"
        
        var color: Color {
            switch self {
            case .beginner:
                return .green
            case .intermediate:
                return .orange
            case .advanced:
                return .red
            case .expert:
                return .purple
            }
        }
    }
}

// MARK: - Skincare Guide Model
struct SkincareGuide: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let gradient: LinearGradient
    let category: GuideCategory
    
    enum GuideCategory: String, CaseIterable {
        case cleansing = "Temizlik"
        case treatment = "Tedavi"
        case moisturizing = "Nemlendirme"
        case protection = "Koruma"
        
        var color: Color {
            switch self {
            case .cleansing:
                return .blue
            case .treatment:
                return .purple
            case .moisturizing:
                return .green
            case .protection:
                return .orange
            }
        }
    }
}

// MARK: - DIY Skincare Model
struct DIYRecipe: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let gradient: LinearGradient
    let category: RecipeCategory
    
    enum RecipeCategory: String, CaseIterable {
        case hydration = "Hydration"
        case brightening = "Brightening"
        case nourishing = "Nourishing"
        case exfoliation = "Exfoliation"
        
        var color: Color {
            switch self {
            case .hydration:
                return .blue
            case .brightening:
                return .yellow
            case .nourishing:
                return .green
            case .exfoliation:
                return .orange
            }
        }
    }
}

// MARK: - DIY Recipe Sample Data
extension DIYRecipe {
    static let sampleRecipes: [DIYRecipe] = [
        DIYRecipe(
            title: "Hydration",
            icon: "drop.fill",
            gradient: LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .hydration
        ),
        DIYRecipe(
            title: "Brightening",
            icon: "sun.max.fill",
            gradient: LinearGradient(
                colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .brightening
        ),
        DIYRecipe(
            title: "Nourishing",
            icon: "leaf.fill",
            gradient: LinearGradient(
                colors: [Color.green.opacity(0.8), Color.mint.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .nourishing
        ),
        DIYRecipe(
            title: "Exfoliation",
            icon: "sparkles",
            gradient: LinearGradient(
                colors: [Color.purple.opacity(0.8), Color.pink.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .exfoliation
        )
    ]
}

// MARK: - Recipe Model
struct Recipe: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let ingredients: [String]
    let steps: [String]
    let skinConcern: SkinConcern
    let timeNeeded: Int // minutes
    let difficulty: RecipeDifficulty
    let category: RecipeCategory
    
    enum SkinConcern: String, CaseIterable {
        case dryness = "Dryness"
        case dullness = "Dullness"
        case acne = "Acne"
        case aging = "Aging"
        case sensitivity = "Sensitivity"
        case oiliness = "Oiliness"
        
        var color: Color {
            switch self {
            case .dryness:
                return .blue
            case .dullness:
                return .orange
            case .acne:
                return .red
            case .aging:
                return .purple
            case .sensitivity:
                return .pink
            case .oiliness:
                return .green
            }
        }
    }
    
    enum RecipeDifficulty: String, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        
        var stars: String {
            switch self {
            case .easy:
                return "⭐"
            case .medium:
                return "⭐⭐"
            case .hard:
                return "⭐⭐⭐"
            }
        }
        
        var color: Color {
            switch self {
            case .easy:
                return .green
            case .medium:
                return .orange
            case .hard:
                return .red
            }
        }
    }
    
    enum RecipeCategory: String, CaseIterable {
        case hydration = "Hydration"
        case brightening = "Brightening"
        case nourishing = "Nourishing"
        case exfoliation = "Exfoliation"
        
        var color: Color {
            switch self {
            case .hydration:
                return .blue
            case .brightening:
                return .yellow
            case .nourishing:
                return .green
            case .exfoliation:
                return .purple
            }
        }
    }
}

// MARK: - Recipe Sample Data
extension Recipe {
    static let sampleRecipes: [Recipe] = [
        // Hydration Recipes
        Recipe(
            title: "Honey & Yogurt Hydrating Mask",
            imageName: "honey_yogurt_mask",
            ingredients: [
                "2 yemek kaşığı yoğurt",
                "1 çay kaşığı bal",
                "1 çay kaşığı zeytinyağı"
            ],
            steps: [
                "Tüm malzemeleri karıştırın",
                "Temiz cilde uygulayın",
                "15 dakika bekleyip ılık suyla yıkayın"
            ],
            skinConcern: .dryness,
            timeNeeded: 15,
            difficulty: .easy,
            category: .hydration
        ),
        Recipe(
            title: "Avocado Hydrating Treatment",
            imageName: "avocado_mask",
            ingredients: [
                "1/2 olgun avokado",
                "1 çay kaşığı bal",
                "2 damla lavanta yağı"
            ],
            steps: [
                "Avokadoyu ezin",
                "Bal ve yağı ekleyin",
                "10 dakika uygulayın"
            ],
            skinConcern: .dryness,
            timeNeeded: 10,
            difficulty: .easy,
            category: .hydration
        ),
        
        // Brightening Recipes
        Recipe(
            title: "Turmeric Brightening Mask",
            imageName: "turmeric_mask",
            ingredients: [
                "1 çay kaşığı zerdeçal",
                "1 çay kaşığı yoğurt",
                "1 çay kaşığı bal"
            ],
            steps: [
                "Malzemeleri karıştırın",
                "Cilde uygulayın",
                "10 dakika bekleyip yıkayın"
            ],
            skinConcern: .dullness,
            timeNeeded: 10,
            difficulty: .easy,
            category: .brightening
        ),
        Recipe(
            title: "Lemon & Honey Glow",
            imageName: "lemon_honey",
            ingredients: [
                "1 çay kaşığı limon suyu",
                "1 çay kaşığı bal",
                "1 çay kaşığı yulaf"
            ],
            steps: [
                "Yulafları öğütün",
                "Limon ve balı ekleyin",
                "5 dakika uygulayın"
            ],
            skinConcern: .dullness,
            timeNeeded: 5,
            difficulty: .easy,
            category: .brightening
        ),
        
        // Nourishing Recipes
        Recipe(
            title: "Oatmeal Nourishing Mask",
            imageName: "oatmeal_mask",
            ingredients: [
                "2 çay kaşığı yulaf",
                "1 çay kaşığı bal",
                "1 çay kaşığı süt"
            ],
            steps: [
                "Yulafları öğütün",
                "Süt ve balı ekleyin",
                "15 dakika uygulayın"
            ],
            skinConcern: .dryness,
            timeNeeded: 15,
            difficulty: .easy,
            category: .nourishing
        ),
        Recipe(
            title: "Banana & Honey Nourisher",
            imageName: "banana_mask",
            ingredients: [
                "1/2 olgun muz",
                "1 çay kaşığı bal",
                "1 çay kaşığı badem yağı"
            ],
            steps: [
                "Muzu ezin",
                "Diğer malzemeleri ekleyin",
                "20 dakika uygulayın"
            ],
            skinConcern: .dryness,
            timeNeeded: 20,
            difficulty: .medium,
            category: .nourishing
        ),
        
        // Exfoliation Recipes
        Recipe(
            title: "Sugar & Coffee Scrub",
            imageName: "sugar_coffee_scrub",
            ingredients: [
                "1 çay kaşığı kahve telvesi",
                "1 çay kaşığı şeker",
                "1 çay kaşığı hindistan cevizi yağı"
            ],
            steps: [
                "Malzemeleri karıştırın",
                "Nazikçe ovalayarak uygulayın",
                "Ilık suyla yıkayın"
            ],
            skinConcern: .dullness,
            timeNeeded: 5,
            difficulty: .easy,
            category: .exfoliation
        ),
        Recipe(
            title: "Papaya Enzyme Peel",
            imageName: "papaya_peel",
            ingredients: [
                "2 çorba kaşığı papaya püresi",
                "1 çay kaşığı bal",
                "1 çay kaşığı limon suyu"
            ],
            steps: [
                "Papayayı püre haline getirin",
                "Bal ve limonu ekleyin",
                "10 dakika uygulayın"
            ],
            skinConcern: .dullness,
            timeNeeded: 10,
            difficulty: .medium,
            category: .exfoliation
        )
    ]
    
    static func recipes(for category: Recipe.RecipeCategory) -> [Recipe] {
        return sampleRecipes.filter { $0.category == category }
    }
}

// MARK: - Skincare Guide Sample Data
extension SkincareGuide {
    static let sampleGuides: [SkincareGuide] = [
        SkincareGuide(
            title: "Micellar Water",
            icon: "drop.fill",
            gradient: LinearGradient(
                colors: [AppTheme.softPink, AppTheme.warmBeige],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .cleansing
        ),
        SkincareGuide(
            title: "Eye Remover",
            icon: "eye.fill",
            gradient: LinearGradient(
                colors: [AppTheme.warmBeige, AppTheme.softPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .cleansing
        ),
        SkincareGuide(
            title: "Cleansing Balm",
            icon: "circle.fill",
            gradient: LinearGradient(
                colors: [AppTheme.darkSoftPink, AppTheme.softPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .cleansing
        ),
        SkincareGuide(
            title: "Cleansing Oil",
            icon: "drop.circle.fill",
            gradient: LinearGradient(
                colors: [AppTheme.primaryColor.opacity(0.8), AppTheme.darkSoftPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .cleansing
        ),
        SkincareGuide(
            title: "Cleansing Milk",
            icon: "drop.triangle.fill",
            gradient: LinearGradient(
                colors: [AppTheme.successColor.opacity(0.7), AppTheme.warmBeige],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .cleansing
        ),
        SkincareGuide(
            title: "Cleansing Foam",
            icon: "cloud.fill",
            gradient: LinearGradient(
                colors: [AppTheme.warningColor.opacity(0.7), AppTheme.softPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .cleansing
        ),
        SkincareGuide(
            title: "Enzyme Power",
            icon: "bolt.circle.fill",
            gradient: LinearGradient(
                colors: [AppTheme.errorColor.opacity(0.7), AppTheme.warmBeige],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .treatment
        ),
        SkincareGuide(
            title: "Chemical Peeling",
            icon: "hexagon.fill",
            gradient: LinearGradient(
                colors: [AppTheme.primaryColor.opacity(0.6), AppTheme.darkSoftPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .treatment
        ),
        SkincareGuide(
            title: "Exfoliating Toner",
            icon: "circle.dotted",
            gradient: LinearGradient(
                colors: [AppTheme.softPink, AppTheme.primaryColor.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .treatment
        ),
        SkincareGuide(
            title: "Toner",
            icon: "drop.circle",
            gradient: LinearGradient(
                colors: [AppTheme.warmBeige, AppTheme.softPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .treatment
        ),
        SkincareGuide(
            title: "Face Cream",
            icon: "circle.circle.fill",
            gradient: LinearGradient(
                colors: [AppTheme.successColor.opacity(0.8), AppTheme.warmBeige],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .moisturizing
        ),
        SkincareGuide(
            title: "Sheet Mask",
            icon: "rectangle.fill",
            gradient: LinearGradient(
                colors: [AppTheme.softPink, AppTheme.darkSoftPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .moisturizing
        ),
        SkincareGuide(
            title: "Creamy Mask",
            icon: "oval.fill",
            gradient: LinearGradient(
                colors: [AppTheme.warmBeige, AppTheme.primaryColor.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .moisturizing
        ),
        SkincareGuide(
            title: "Peel Off Mask",
            icon: "oval.portrait.fill",
            gradient: LinearGradient(
                colors: [AppTheme.darkSoftPink, AppTheme.softPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .moisturizing
        ),
        SkincareGuide(
            title: "Face Serum",
            icon: "syringe.fill",
            gradient: LinearGradient(
                colors: [AppTheme.primaryColor.opacity(0.7), AppTheme.successColor.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .treatment
        ),
        SkincareGuide(
            title: "Face Oil",
            icon: "drop.triangle",
            gradient: LinearGradient(
                colors: [AppTheme.warningColor.opacity(0.8), AppTheme.softPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .moisturizing
        ),
        SkincareGuide(
            title: "Eye Treatment",
            icon: "eye.circle.fill",
            gradient: LinearGradient(
                colors: [AppTheme.softPink, AppTheme.primaryColor.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .treatment
        ),
        SkincareGuide(
            title: "SPF",
            icon: "sun.max.fill",
            gradient: LinearGradient(
                colors: [AppTheme.warningColor, AppTheme.errorColor.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            category: .protection
        )
    ]
}

// MARK: - Sample Data
extension Routine {
    static let sampleRoutines: [Routine] = [
        Routine(
            title: "Essential Routine",
            description: "Günlük cilt bakımının temel adımları",
            icon: "sparkles",
            gradient: LinearGradient(
                colors: [AppTheme.softPink, AppTheme.warmBeige],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            difficulty: .beginner
        ),
        Routine(
            title: "Complete Routine",
            description: "Kapsamlı ve detaylı cilt bakım rutini",
            icon: "checkmark.circle.fill",
            gradient: LinearGradient(
                colors: [AppTheme.warmBeige, AppTheme.softPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            difficulty: .intermediate
        ),
        Routine(
            title: "Power Routine",
            description: "Güçlü ve etkili aktif içeriklerle rutin",
            icon: "bolt.fill",
            gradient: LinearGradient(
                colors: [AppTheme.darkSoftPink, AppTheme.softPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            difficulty: .advanced
        ),
        Routine(
            title: "High-Performance Routine",
            description: "Profesyonel seviye yüksek performans rutini",
            icon: "star.fill",
            gradient: LinearGradient(
                colors: [AppTheme.primaryColor.opacity(0.8), AppTheme.darkSoftPink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            difficulty: .expert
        ),
        Routine(
            title: "SOS Skincare Routine",
            description: "Acil durumlar için hızlı çözüm rutini",
            icon: "cross.case.fill",
            gradient: LinearGradient(
                colors: [AppTheme.errorColor.opacity(0.7), AppTheme.warningColor.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            difficulty: .beginner
        ),
        Routine(
            title: "Skin Cycling Routine",
            description: "Modern cilt döngü sistemi rutini",
            icon: "arrow.clockwise",
            gradient: LinearGradient(
                colors: [AppTheme.successColor.opacity(0.7), AppTheme.warmBeige],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            difficulty: .intermediate
        )
    ]
}

// MARK: - Recipe Card View
struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Image placeholder with category color
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            recipe.category.color.opacity(0.3),
                            recipe.category.color.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 180)
                .overlay(
                    VStack {
                        Image(systemName: getImageIcon(for: recipe.title))
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(recipe.category.color)
                        Text("Recipe Photo")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(recipe.category.color.opacity(0.7))
                    }
                )
            
            VStack(alignment: .leading, spacing: 12) {
                // Title
                Text(recipe.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .multilineTextAlignment(.leading)
                
                // Badges Row
                HStack(spacing: 8) {
                    // Skin Concern Badge
                    Text(recipe.skinConcern.rawValue)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(recipe.skinConcern.color)
                        )
                    
                    Spacer()
                    
                    // Time Needed
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 10))
                        Text("\(recipe.timeNeeded) dk")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(AppTheme.textSecondary)
                    
                    // Difficulty Level
                    HStack(spacing: 2) {
                        Text(recipe.difficulty.stars)
                            .font(.system(size: 10))
                        Text(recipe.difficulty.rawValue)
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(recipe.difficulty.color)
                }
                
                // Ingredients
                VStack(alignment: .leading, spacing: 4) {
                    Text("Malzemeler:")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .font(.system(size: 12))
                                .foregroundColor(recipe.category.color)
                            Text(ingredient)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            Spacer()
                        }
                    }
                }
                
                // Steps
                VStack(alignment: .leading, spacing: 4) {
                    Text("Adımlar:")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(index + 1).")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(recipe.category.color)
                                .frame(width: 16, alignment: .leading)
                            Text(step)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [Color.black.opacity(0.1), Color.black.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private func getImageIcon(for title: String) -> String {
        if title.contains("Honey") && title.contains("Yogurt") {
            return "drop.fill"
        } else if title.contains("Avocado") {
            return "leaf.fill"
        } else if title.contains("Turmeric") {
            return "sun.max.fill"
        } else if title.contains("Lemon") {
            return "sun.max"
        } else if title.contains("Oatmeal") {
            return "grain"
        } else if title.contains("Banana") {
            return "leaf"
        } else if title.contains("Sugar") && title.contains("Coffee") {
            return "circle.grid.cross.fill"
        } else if title.contains("Papaya") {
            return "sparkles"
        }
        return "photo.fill"
    }
}

// MARK: - DIY Recipe Card View
struct DIYRecipeCardView: View {
    let recipe: DIYRecipe
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon and Title
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(recipe.gradient)
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: recipe.icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                }
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                
                VStack(spacing: 6) {
                    Text(recipe.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
            
            // Try Recipes Button
            NavigationLink(destination: RecipeDetailView(category: convertToRecipeCategory(recipe.category))) {
                HStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 14, weight: .medium))
                    Text("Try Recipes")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppTheme.primaryColor)
                )
            }
        }
        .padding(20)
        .frame(height: 320)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.black.opacity(0.1), Color.black.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.1),
                            Color.black.opacity(0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
    
    private func convertToRecipeCategory(_ diyCategory: DIYRecipe.RecipeCategory) -> Recipe.RecipeCategory {
        switch diyCategory {
        case .hydration:
            return .hydration
        case .brightening:
            return .brightening
        case .nourishing:
            return .nourishing
        case .exfoliation:
            return .exfoliation
        }
    }
}

// MARK: - Recipe Detail View
struct RecipeDetailView: View {
    let category: Recipe.RecipeCategory
    @Environment(\.presentationMode) var presentationMode
    
    private var recipes: [Recipe] {
        Recipe.recipes(for: category)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        HStack {
                            Text(category.rawValue)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                            Spacer()
                        }
                        
                        HStack {
                            Text("\(recipes.count) tarif bulundu")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Recipes List
                    LazyVStack(spacing: 16) {
                        ForEach(recipes) { recipe in
                            RecipeCardView(recipe: recipe)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .background(AppTheme.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(AppTheme.backgroundColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Geri")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(AppTheme.primaryColor)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(category.rawValue)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

// MARK: - Explore Routines View
struct ExploreRoutinesView: View {
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var guideCurrentIndex: Int = 0
    @State private var guideDragOffset: CGFloat = 0
    @State private var recipeCurrentIndex: Int = 0
    @State private var recipeDragOffset: CGFloat = 0
    private let routines = Routine.sampleRoutines
    private let guides = SkincareGuide.sampleGuides
    private let recipes = DIYRecipe.sampleRecipes
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Explore Routines Section
                    VStack(spacing: 4) {
                        HStack {
                            Text("Explore Routines")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Cilt bakım rutinlerini keşfedin")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                    // Routine Cards Section
                    ZStack {
                        // Routine Cards
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(routines.enumerated()), id: \.element.id) { index, routine in
                                        RoutineCardView(routine: routine)
                                            .frame(width: UIScreen.main.bounds.width - 80)
                                            .id(index)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .offset(x: dragOffset)
                            }
                            .scrollDisabled(true)
                            .onAppear {
                                scrollToIndex(proxy, index: currentIndex)
                            }
                            .onChange(of: currentIndex) { newIndex in
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    scrollToIndex(proxy, index: newIndex)
                                }
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation.width
                                    }
                                    .onEnded { value in
                                        let threshold: CGFloat = 50
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            if value.translation.width > threshold && currentIndex > 0 {
                                                currentIndex -= 1
                                            } else if value.translation.width < -threshold && currentIndex < routines.count - 1 {
                                                currentIndex += 1
                                            }
                                            dragOffset = 0
                                        }
                                    }
                            )
                        }
                        
                        // Navigation Buttons
                        HStack {
                            // Left Button
                            Button(action: {
                                if currentIndex > 0 {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        currentIndex -= 1
                                    }
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(currentIndex > 0 ? AppTheme.textPrimary : AppTheme.textSecondary.opacity(0.3))
                                    .frame(width: 36, height: 36)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.surfaceColor)
                                            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                                    )
                            }
                            .disabled(currentIndex <= 0)
                            
                            Spacer()
                            
                            // Right Button
                            Button(action: {
                                if currentIndex < routines.count - 1 {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        currentIndex += 1
                                    }
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(currentIndex < routines.count - 1 ? AppTheme.textPrimary : AppTheme.textSecondary.opacity(0.3))
                                    .frame(width: 36, height: 36)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.surfaceColor)
                                            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                                    )
                            }
                            .disabled(currentIndex >= routines.count - 1)
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 320)
                    
                    // Page Indicator for Routines
                    HStack(spacing: 6) {
                        ForEach(0..<routines.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? AppTheme.primaryColor : AppTheme.textSecondary.opacity(0.3))
                                .frame(width: 6, height: 6)
                                .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 12)
                    
                    // Skincare Guides Section
                    VStack(spacing: 4) {
                        HStack {
                            Text("Skincare Application & Face Gym Guides")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Cilt bakım ürünlerinin doğru kullanımı")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // Guide Cards Section
                    ZStack {
                        // Guide Cards
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(guides.enumerated()), id: \.element.id) { index, guide in
                                        SkincareGuideCardView(guide: guide)
                                            .frame(width: UIScreen.main.bounds.width - 80)
                                            .id(index)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .offset(x: guideDragOffset)
                            }
                            .scrollDisabled(true)
                            .onAppear {
                                scrollToGuideIndex(proxy, index: guideCurrentIndex)
                            }
                            .onChange(of: guideCurrentIndex) { newIndex in
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    scrollToGuideIndex(proxy, index: newIndex)
                                }
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        guideDragOffset = value.translation.width
                                    }
                                    .onEnded { value in
                                        let threshold: CGFloat = 50
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            if value.translation.width > threshold && guideCurrentIndex > 0 {
                                                guideCurrentIndex -= 1
                                            } else if value.translation.width < -threshold && guideCurrentIndex < guides.count - 1 {
                                                guideCurrentIndex += 1
                                            }
                                            guideDragOffset = 0
                                        }
                                    }
                            )
                        }
                        
                        // Navigation Buttons for Guides
                        HStack {
                            // Left Button
                            Button(action: {
                                if guideCurrentIndex > 0 {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        guideCurrentIndex -= 1
                                    }
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(guideCurrentIndex > 0 ? AppTheme.textPrimary : AppTheme.textSecondary.opacity(0.3))
                                    .frame(width: 36, height: 36)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.surfaceColor)
                                            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                                    )
                            }
                            .disabled(guideCurrentIndex <= 0)
                            
                            Spacer()
                            
                            // Right Button
                            Button(action: {
                                if guideCurrentIndex < guides.count - 1 {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        guideCurrentIndex += 1
                                    }
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(guideCurrentIndex < guides.count - 1 ? AppTheme.textPrimary : AppTheme.textSecondary.opacity(0.3))
                                    .frame(width: 36, height: 36)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.surfaceColor)
                                            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                                    )
                            }
                            .disabled(guideCurrentIndex >= guides.count - 1)
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 320)
                    
                    // Page Indicator for Guides
                    HStack(spacing: 6) {
                        ForEach(0..<guides.count, id: \.self) { index in
                            Circle()
                                .fill(index == guideCurrentIndex ? AppTheme.primaryColor : AppTheme.textSecondary.opacity(0.3))
                                .frame(width: 6, height: 6)
                                .animation(.easeInOut(duration: 0.3), value: guideCurrentIndex)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 20)
                    
                    // DIY Skincare Section
                    VStack(spacing: 4) {
                        HStack {
                            Text("DIY Skincare")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Evde yapabileceğin doğal cilt bakım tarifleri")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    
                    // DIY Recipe Cards Section
                    ZStack {
                        // Recipe Cards
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(Array(recipes.enumerated()), id: \.element.id) { index, recipe in
                                        DIYRecipeCardView(recipe: recipe)
                                            .frame(width: UIScreen.main.bounds.width - 80)
                                            .id(index)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .offset(x: recipeDragOffset)
                            }
                            .scrollDisabled(true)
                            .onAppear {
                                scrollToRecipeIndex(proxy, index: recipeCurrentIndex)
                            }
                            .onChange(of: recipeCurrentIndex) { newIndex in
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    scrollToRecipeIndex(proxy, index: newIndex)
                                }
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        recipeDragOffset = value.translation.width
                                    }
                                    .onEnded { value in
                                        let threshold: CGFloat = 50
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            if value.translation.width > threshold && recipeCurrentIndex > 0 {
                                                recipeCurrentIndex -= 1
                                            } else if value.translation.width < -threshold && recipeCurrentIndex < recipes.count - 1 {
                                                recipeCurrentIndex += 1
                                            }
                                            recipeDragOffset = 0
                                        }
                                    }
                            )
                        }
                        
                        // Navigation Buttons
                        HStack {
                            // Left Button
                            Button(action: {
                                if recipeCurrentIndex > 0 {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        recipeCurrentIndex -= 1
                                    }
                                }
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(recipeCurrentIndex > 0 ? AppTheme.textPrimary : AppTheme.textSecondary.opacity(0.3))
                                    .frame(width: 36, height: 36)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.surfaceColor)
                                            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                                    )
                            }
                            .disabled(recipeCurrentIndex <= 0)
                            
                            Spacer()
                            
                            // Right Button
                            Button(action: {
                                if recipeCurrentIndex < recipes.count - 1 {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        recipeCurrentIndex += 1
                                    }
                                }
                            }) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(recipeCurrentIndex < recipes.count - 1 ? AppTheme.textPrimary : AppTheme.textSecondary.opacity(0.3))
                                    .frame(width: 36, height: 36)
                                    .background(
                                        Circle()
                                            .fill(AppTheme.surfaceColor)
                                            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                                    )
                            }
                            .disabled(recipeCurrentIndex >= recipes.count - 1)
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 320)
                    
                    // Page Indicator for Recipes
                    HStack(spacing: 6) {
                        ForEach(0..<recipes.count, id: \.self) { index in
                            Circle()
                                .fill(index == recipeCurrentIndex ? AppTheme.primaryColor : AppTheme.textSecondary.opacity(0.3))
                                .frame(width: 6, height: 6)
                                .animation(.easeInOut(duration: 0.3), value: recipeCurrentIndex)
                        }
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 40)
                }
                .padding(.bottom, 100) // Extra padding for safe scrolling
                .navigationTitle("Explore")
                .navigationBarTitleDisplayMode(.inline)
                .appBackground()
                .ignoresSafeArea(.all, edges: .top)
                .toolbarBackground(AppTheme.backgroundColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
    
    private func scrollToIndex(_ proxy: ScrollViewProxy, index: Int) {
        proxy.scrollTo(index, anchor: .center)
    }
    
    private func scrollToGuideIndex(_ proxy: ScrollViewProxy, index: Int) {
        proxy.scrollTo(index, anchor: .center)
    }
    
    private func scrollToRecipeIndex(_ proxy: ScrollViewProxy, index: Int) {
        proxy.scrollTo(index, anchor: .center)
    }
}

// MARK: - Skincare Guide Card View
struct SkincareGuideCardView: View {
    let guide: SkincareGuide
    
    var body: some View {
        VStack(spacing: 16) {
            // Header with Watch & Learn Button
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(guide.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(guide.category.rawValue)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(guide.category.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(guide.category.color.opacity(0.1))
                        )
                }
                
                Spacer()
                
                // Watch & Learn Button
                Button(action: {
                    // TODO: Implement video playback
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 12, weight: .medium))
                        Text("Watch")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(guide.category.color)
                    )
                }
            }
            
            // Icon
            ZStack {
                Circle()
                    .fill(guide.gradient)
                    .frame(width: 80, height: 80)
                
                Image(systemName: guide.icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
            }
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            
            Spacer()
        }
        .padding(20)
        .frame(height: 320)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.black.opacity(0.1), Color.black.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [
                            guide.category.color.opacity(0.15),
                            Color.clear,
                            guide.category.color.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

// MARK: - Routine Card View
struct RoutineCardView: View {
    let routine: Routine
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon and Title
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(routine.gradient)
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: routine.icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 6) {
                    Text(routine.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    // Difficulty Badge
                    Text(routine.difficulty.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(routine.difficulty.color)
                        )
                }
            }
            
            // Description
            Text(routine.description)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 12)
            
            Spacer()
            
            // Action Button
            Button(action: {
                // TODO: Navigate to routine detail
            }) {
                HStack(spacing: 6) {
                    Text("Rutini İncele")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppTheme.primaryColor)
                )
            }
        }
        .padding(20)
        .frame(height: 320)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.black.opacity(0.1), Color.black.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
        )
    }
}

