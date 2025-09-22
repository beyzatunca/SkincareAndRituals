import SwiftUI
import AVFoundation
import PhotosUI

struct ContentView: View {
    @StateObject private var surveyViewModel = SurveyViewModel()
    
    var body: some View {
        if surveyViewModel.isNewUser {
            // New user flow: Show onboarding, survey, and face analysis
            if surveyViewModel.showFaceAnalysis {
                NavigationView {
                    FaceAnalysisView(surveyViewModel: surveyViewModel)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            } else if surveyViewModel.isOnboardingComplete {
                // This should only happen after face analysis is complete
                MainAppView()
            } else {
                NavigationView {
                    SurveyView(viewModel: surveyViewModel)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        } else {
            // Existing user flow: Go directly to main app
            MainAppView()
        }
    }
}

// MARK: - Main App View
struct MainAppView: View {
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
                print("🔴 Explore Products button tapped")
            }) {
                Text("Explore Products")
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
        .onAppear {
            print("🔴 MainAppView appeared successfully!")
        }
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
            .sheet(isPresented: $viewModel.showingPhotoPicker) {
                PhotoPicker(selectedImage: $viewModel.selectedImage) { image in
                    viewModel.setSelectedImage(image)
                }
            }
            .sheet(isPresented: $viewModel.showingConsentSheet) {
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
            self?.captureSession.stopRunning()
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
        stopCaptureSession()
    }
}

// MARK: - Face Analysis View Model Extensions
extension FaceAnalysisViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
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
