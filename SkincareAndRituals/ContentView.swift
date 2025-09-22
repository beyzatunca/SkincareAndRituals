import SwiftUI
import AVFoundation
import PhotosUI

struct ContentView: View {
    @StateObject private var surveyViewModel = SurveyViewModel()
    
    var body: some View {
        NavigationView {
            if surveyViewModel.isNewUser {
                // New user flow: Show onboarding, survey, and face analysis
                if surveyViewModel.showFaceAnalysis {
                    FaceAnalysisView(surveyViewModel: surveyViewModel)
                } else if surveyViewModel.isOnboardingComplete {
                    MainAppView()
                } else {
                    SurveyView(viewModel: surveyViewModel)
                }
            } else {
                // Existing user flow: Go directly to main app
                MainAppView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            print("🔴 ContentView appeared - isNewUser: \(surveyViewModel.isNewUser), showFaceAnalysis: \(surveyViewModel.showFaceAnalysis), isOnboardingComplete: \(surveyViewModel.isOnboardingComplete)")
        }
        .onChange(of: surveyViewModel.showFaceAnalysis) { newValue in
            print("🔴 showFaceAnalysis changed to: \(newValue)")
        }
        .onChange(of: surveyViewModel.isOnboardingComplete) { newValue in
            print("🔴 isOnboardingComplete changed to: \(newValue)")
        }
    }
}

// MARK: - Main App View (Placeholder)
struct MainAppView: View {
    var body: some View {
        VStack {
            Text("Main App")
                .font(.largeTitle)
                .foregroundColor(.primary)
            
            Text("Welcome to the main app!")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
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
            viewModel.checkPermissions()
        }
        .sheet(isPresented: $viewModel.showingPhotoPicker) {
            PhotoPicker(selectedImage: $viewModel.selectedImage)
        }
        .sheet(isPresented: $viewModel.showingConsentSheet) {
            ConsentSheet(
                image: viewModel.capturedImage,
                onConfirm: {
                    viewModel.startAnalysis()
                }
            )
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
                // Camera Icon - Survey akışındaki icon stilinde
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
                    
                    Text("Camera access is required to analyze your skin.")
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
                
                // Center capture button - Survey akışındaki ModernBottomButton stilinde
                Button(action: {
                    if viewModel.capturedImage != nil {
                        viewModel.confirmPhoto()
                    } else {
                        viewModel.capturePhoto()
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
                .disabled(!viewModel.cameraPermissionGranted && viewModel.capturedImage == nil)
                .accessibilityLabel("Take Photo")
                
                // Right button (Gallery/Upload)
                Button(action: {
                    viewModel.showPhotoPicker()
                }) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.creamWhite)
                            .frame(width: 60, height: 60)
                            .shadow(color: AppTheme.darkCharcoal.opacity(0.1), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(AppTheme.darkCharcoal.opacity(0.8))
                    }
                }
                .accessibilityLabel("Upload from Gallery")
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
    @Published var showingPermissionAlert = false
    
    private let captureSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    
    override init() {
        super.init()
        setupCaptureSession()
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraPermissionGranted = true
            startCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.cameraPermissionGranted = granted
                    if granted {
                        self?.startCaptureSession()
                    }
                }
            }
        case .denied, .restricted:
            showingPermissionAlert = true
        @unknown default:
            break
        }
    }
    
    private func setupCaptureSession() {
        captureSession.beginConfiguration()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            captureSession.commitConfiguration()
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        captureSession.commitConfiguration()
    }
    
    private func startCaptureSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    private func stopCaptureSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
    
    func capturePhoto() {
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
    
    func startAnalysis() {
        guard let image = capturedImage else { return }
        
        isAnalyzing = true
        
        // Simulate analysis
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isAnalyzing = false
            self.analysisCompleted = true
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

// MARK: - Photo Picker
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
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
                    self?.parent.selectedImage = image as? UIImage
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

#Preview {
    ContentView()
}
