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
                        TodaysRoutineCard()
                        
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
        VStack(spacing: AppTheme.Spacing.lg) {
            Text("Recommendations")
                .font(AppTheme.Typography.largeTitle)
                .foregroundColor(AppTheme.textPrimary)
                .padding(.top, geometry.size.height * 0.1)
            
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.lg) {
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundColor(AppTheme.primaryColor)
                
                Text("AI-powered skincare recommendations based on your skin analysis")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.lg)
            }
            
            Spacer()
        }
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

// MARK: - Today's Routine Card
struct TodaysRoutineCard: View {
    @State private var selectedTime = "Morning"
    @State private var completedSteps = Set<String>()
    
    private let routineSteps = [
        ("Cleanser", "soap.fill"),
        ("Serum", "drop.fill"),
        ("Moisturizer", "pump.fill"),
        ("SPF", "sun.max.fill")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Header
            HStack {
                Text("Today's Routine")
                    .font(AppTheme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    ForEach(0..<3) { _ in
                        Circle()
                            .fill(AppTheme.textSecondary.opacity(0.3))
                            .frame(width: 4, height: 4)
                    }
                }
            }
            
            // Time Selection
            HStack(spacing: AppTheme.Spacing.sm) {
                Button(action: { selectedTime = "Morning" }) {
                    Text("Morning")
                        .font(AppTheme.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(selectedTime == "Morning" ? .white : AppTheme.textSecondary)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(
                            Capsule()
                                .fill(selectedTime == "Morning" ? AppTheme.primaryColor : Color.clear)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: { selectedTime = "Evening" }) {
                    Text("Evening")
                        .font(AppTheme.Typography.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(selectedTime == "Evening" ? .white : AppTheme.textSecondary)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(
                            Capsule()
                                .fill(selectedTime == "Evening" ? AppTheme.primaryColor : Color.clear)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
            
            // Routine Steps
            VStack(spacing: AppTheme.Spacing.sm) {
                ForEach(routineSteps, id: \.0) { step in
                    HStack {
                        Image(systemName: step.1)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppTheme.primaryColor)
                            .frame(width: 28, height: 28)
                        
                        Text(step.0)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.textPrimary)
                        
                        Spacer()
                        
                        Button(action: {
                            if completedSteps.contains(step.0) {
                                completedSteps.remove(step.0)
                            } else {
                                completedSteps.insert(step.0)
                            }
                        }) {
                            Image(systemName: completedSteps.contains(step.0) ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 20))
                                .foregroundColor(completedSteps.contains(step.0) ? AppTheme.primaryColor : AppTheme.textSecondary)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, 4)
                }
            }
            
            // Progress and Additional Info
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("\(completedSteps.count)/\(routineSteps.count) steps")
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.textPrimary)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                // Progress Circle
                ZStack {
                    Circle()
                        .stroke(AppTheme.primaryColor.opacity(0.2), lineWidth: 3)
                        .frame(width: 50, height: 50)
                    
                    Circle()
                        .trim(from: 0, to: Double(completedSteps.count) / Double(routineSteps.count))
                        .stroke(AppTheme.primaryColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(completedSteps.count)/\(routineSteps.count)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                }
            }
            
            // Action Buttons
            HStack(spacing: AppTheme.Spacing.sm) {
                ActionButton(icon: "music.note", text: "Spotify", color: .purple)
                ActionButton(icon: "radio", text: "Radio", color: .purple)
                ActionButton(icon: "newspaper", text: "Daily news", color: .purple)
                ActionButton(icon: "leaf", text: "Mintot.", color: .pink)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
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
    @State private var noteText = ""
    
    private let moods = ["😊", "😌", "😐", "😕", "😢"]
    private let conditions = ["Redness", "Dryness", "Breakout", "Glowy"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            // Header
            HStack {
                Text("Skin Journal")
                    .font(AppTheme.Typography.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.primaryColor)
            }
            
            // Prompt
            Text("How does your skin feel today?")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.textPrimary)
            
            // Mood Selection
            HStack(spacing: AppTheme.Spacing.md) {
                ForEach(0..<moods.count, id: \.self) { index in
                    Button(action: { selectedMood = index }) {
                        Text(moods[index])
                            .font(.system(size: 24))
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(selectedMood == index ? AppTheme.primaryColor.opacity(0.1) : Color.clear)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            // Skin Condition Tags
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach(conditions, id: \.self) { condition in
                    Button(action: {
                        if selectedConditions.contains(condition) {
                            selectedConditions.remove(condition)
                        } else {
                            selectedConditions.insert(condition)
                        }
                    }) {
                        Text(condition)
                            .font(AppTheme.Typography.caption)
                            .fontWeight(.medium)
                            .foregroundColor(selectedConditions.contains(condition) ? .white : AppTheme.textPrimary)
                            .padding(.horizontal, AppTheme.Spacing.sm)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(selectedConditions.contains(condition) ? AppTheme.primaryColor : AppTheme.primaryColor.opacity(0.1))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            // Note Input
            TextField("Add a note...", text: $noteText)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.textPrimary)
                .padding(AppTheme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(AppTheme.backgroundColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                                .stroke(AppTheme.textSecondary.opacity(0.2), lineWidth: 1)
                        )
                )
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
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

