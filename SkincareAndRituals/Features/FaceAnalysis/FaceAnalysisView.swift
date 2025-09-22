import SwiftUI
import AVFoundation
import PhotosUI

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
        .alert("Camera Access Required", isPresented: $viewModel.showingPermissionAlert) {
            Button("Settings") {
                viewModel.openSettings()
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
            // Modern Camera Preview Card
            VStack(spacing: 0) {
                ZStack {
                    if viewModel.capturedImage != nil {
                        // Show captured image with face landmarks
                        Image(uiImage: viewModel.capturedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width * 0.85, height: geometry.size.width * 0.85 * 1.2)
                            .clipped()
                            .cornerRadius(20)
                            .overlay(
                                // Face landmark points overlay
                                FaceLandmarkPointsOverlay()
                            )
                    } else {
                        // Show sample face image for design purposes
                        ZStack {
                            // Sample face image background
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppTheme.cardGradient)
                                .frame(width: geometry.size.width * 0.85, height: geometry.size.width * 0.85 * 1.2)
                                .shadow(color: AppTheme.darkCharcoal.opacity(0.08), radius: 20, x: 0, y: 8)
                            
                            // Sample face content
                            VStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .fill(AppTheme.darkCharcoal.opacity(0.15))
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: "person.crop.circle.fill")
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(AppTheme.darkCharcoal.opacity(0.8))
                                }
                                
                                Text("Position your face in the frame")
                                    .font(AppTheme.Typography.surveyOption)
                                    .foregroundColor(AppTheme.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .overlay(
                                // Face landmark points overlay for demo
                                FaceLandmarkPointsOverlay()
                            )
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
            
            // Tips Card
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
            // Modern Control Buttons
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
                
                // Center capture button - Modern gradient
                Button(action: {
                    if viewModel.capturedImage != nil {
                        viewModel.confirmPhoto()
                    } else {
                        viewModel.capturePhoto()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.accentGradient)
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
            
            // Analyze Button (if image is captured)
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
    
}

// MARK: - Camera Preview View
struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
}

// MARK: - Face Guidance Overlay
struct FaceGuidanceOverlay: View {
    let isFaceDetected: Bool
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            // Corner brackets
            VStack {
                HStack {
                    cornerBracket(.topLeading)
                    Spacer()
                    cornerBracket(.topTrailing)
                }
                Spacer()
                HStack {
                    cornerBracket(.bottomLeading)
                    Spacer()
                    cornerBracket(.bottomTrailing)
                }
            }
            .padding(40)
            
            // Face landmarks (simplified dots)
            if isFaceDetected {
                faceLandmarksView
            }
            
            // Alignment hint
            if !isFaceDetected {
                VStack {
                    Spacer()
                    Text("Center your face in the frame.")
                        .font(.system(size: geometry.size.height * 0.016, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(20)
                        .padding(.bottom, 60)
                }
            }
        }
    }
    
    private func cornerBracket(_ corner: UIRectCorner) -> some View {
        Path { path in
            let size: CGFloat = 30
            let thickness: CGFloat = 2
            
            switch corner {
            case .topLeading:
                path.move(to: CGPoint(x: 0, y: thickness))
                path.addLine(to: CGPoint(x: size, y: thickness))
                path.move(to: CGPoint(x: thickness, y: 0))
                path.addLine(to: CGPoint(x: thickness, y: size))
            case .topTrailing:
                path.move(to: CGPoint(x: -size, y: thickness))
                path.addLine(to: CGPoint(x: 0, y: thickness))
                path.move(to: CGPoint(x: -thickness, y: 0))
                path.addLine(to: CGPoint(x: -thickness, y: size))
            case .bottomLeading:
                path.move(to: CGPoint(x: 0, y: -thickness))
                path.addLine(to: CGPoint(x: size, y: -thickness))
                path.move(to: CGPoint(x: thickness, y: -size))
                path.addLine(to: CGPoint(x: thickness, y: 0))
            case .bottomTrailing:
                path.move(to: CGPoint(x: -size, y: -thickness))
                path.addLine(to: CGPoint(x: 0, y: -thickness))
                path.move(to: CGPoint(x: -thickness, y: -size))
                path.addLine(to: CGPoint(x: -thickness, y: 0))
            default:
                break
            }
        }
        .stroke(Color.white.opacity(0.8), lineWidth: 2)
        .frame(width: 30, height: 30)
    }
    
    private var faceLandmarksView: some View {
        // Simplified face landmarks as dots
        ZStack {
            // Forehead dots
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat(i - 2) * 20, y: -80)
            }
            
            // Eye dots
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat(i - 1) * 15 - 30, y: -40) // Left eye
                
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat(i - 1) * 15 + 30, y: -40) // Right eye
            }
            
            // Nose dots
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat(i - 1) * 10, y: CGFloat(i - 1) * 15)
            }
            
            // Mouth dots
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: CGFloat(i - 2) * 15, y: 30)
            }
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
            parent.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
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
    @State private var analyzeOnDevice = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your photo is used to analyze skin concerns. We don't share it with third parties.")
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Toggle("Analyze on device when possible", isOn: $analyzeOnDevice)
                        .font(.system(size: 16))
                        .foregroundColor(AppTheme.textPrimary)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    onConfirm()
                    dismiss()
                }) {
                    Text("Start Analysis")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppTheme.primaryColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Review & Consent")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Modern Analysis Completion View
    private func modernAnalysisCompletionView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 24) {
            // Success message
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppTheme.darkCharcoal.opacity(0.15))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.green)
                }
                
                VStack(spacing: 8) {
                    Text("Analysis Complete!")
                        .font(AppTheme.Typography.title2)
                        .foregroundColor(AppTheme.darkCharcoal)
                        .multilineTextAlignment(.center)
                    
                    Text("Your skin analysis has been completed successfully.")
                        .font(AppTheme.Typography.surveySubtitle)
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
            }
            .padding(.horizontal, 20)
            
            // Continue to app button
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
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppTheme.cardGradient)
                .shadow(color: AppTheme.darkCharcoal.opacity(0.08), radius: 20, x: 0, y: 8)
        )
        .padding(.horizontal, 20)
        .transition(.opacity.combined(with: .scale))
        .animation(.easeInOut(duration: 0.5), value: viewModel.analysisCompleted)
    }
}

#Preview {
    FaceAnalysisView(surveyViewModel: SurveyViewModel())
}

// MARK: - Face Landmark Overlay
struct FaceLandmarkOverlay: View {
    var body: some View {
        ZStack {
            // Face landmark points and connections
            Path { path in
                // Forehead points
                path.move(to: CGPoint(x: 0.3, y: 0.2))
                path.addLine(to: CGPoint(x: 0.7, y: 0.2))
                path.addLine(to: CGPoint(x: 0.8, y: 0.3))
                path.addLine(to: CGPoint(x: 0.7, y: 0.4))
                path.addLine(to: CGPoint(x: 0.3, y: 0.4))
                path.addLine(to: CGPoint(x: 0.2, y: 0.3))
                path.closeSubpath()
                
                // Eye area
                path.move(to: CGPoint(x: 0.25, y: 0.45))
                path.addLine(to: CGPoint(x: 0.35, y: 0.45))
                path.addLine(to: CGPoint(x: 0.35, y: 0.55))
                path.addLine(to: CGPoint(x: 0.25, y: 0.55))
                path.closeSubpath()
                
                path.move(to: CGPoint(x: 0.65, y: 0.45))
                path.addLine(to: CGPoint(x: 0.75, y: 0.45))
                path.addLine(to: CGPoint(x: 0.75, y: 0.55))
                path.addLine(to: CGPoint(x: 0.65, y: 0.55))
                path.closeSubpath()
                
                // Nose area
                path.move(to: CGPoint(x: 0.45, y: 0.5))
                path.addLine(to: CGPoint(x: 0.55, y: 0.5))
                path.addLine(to: CGPoint(x: 0.55, y: 0.7))
                path.addLine(to: CGPoint(x: 0.45, y: 0.7))
                path.closeSubpath()
                
                // Mouth area
                path.move(to: CGPoint(x: 0.35, y: 0.75))
                path.addLine(to: CGPoint(x: 0.65, y: 0.75))
                path.addLine(to: CGPoint(x: 0.65, y: 0.85))
                path.addLine(to: CGPoint(x: 0.35, y: 0.85))
                path.closeSubpath()
                
                // Jawline
                path.move(to: CGPoint(x: 0.2, y: 0.4))
                path.addLine(to: CGPoint(x: 0.1, y: 0.6))
                path.addLine(to: CGPoint(x: 0.1, y: 0.8))
                path.addLine(to: CGPoint(x: 0.9, y: 0.8))
                path.addLine(to: CGPoint(x: 0.9, y: 0.6))
                path.addLine(to: CGPoint(x: 0.8, y: 0.4))
            }
            .stroke(Color.white, lineWidth: 2)
            .scaleEffect(0.8)
            .opacity(0.8)
        }
    }
}

// MARK: - Framing Guide Overlay
struct FramingGuideOverlay: View {
    var body: some View {
        ZStack {
            // L-shaped brackets in corners
            Path { path in
                // Top-left bracket
                path.move(to: CGPoint(x: 0.1, y: 0.1))
                path.addLine(to: CGPoint(x: 0.1, y: 0.2))
                path.move(to: CGPoint(x: 0.1, y: 0.1))
                path.addLine(to: CGPoint(x: 0.2, y: 0.1))
                
                // Top-right bracket
                path.move(to: CGPoint(x: 0.9, y: 0.1))
                path.addLine(to: CGPoint(x: 0.9, y: 0.2))
                path.move(to: CGPoint(x: 0.9, y: 0.1))
                path.addLine(to: CGPoint(x: 0.8, y: 0.1))
            }
            .stroke(Color.purple.opacity(0.6), lineWidth: 3)
        }
    }
}

// MARK: - Face Landmark Points Overlay
struct FaceLandmarkPointsOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Face landmark points as shown in the design
                let points: [(x: CGFloat, y: CGFloat)] = [
                    // Forehead row
                    (0.35, 0.18), (0.5, 0.15), (0.65, 0.18),
                    // Upper face
                    (0.25, 0.28), (0.4, 0.25), (0.6, 0.25), (0.75, 0.28),
                    // Eye level
                    (0.3, 0.38), (0.45, 0.35), (0.55, 0.35), (0.7, 0.38),
                    // Mid face
                    (0.2, 0.48), (0.35, 0.45), (0.5, 0.48), (0.65, 0.45), (0.8, 0.48),
                    // Nose area
                    (0.45, 0.58), (0.5, 0.6), (0.55, 0.58),
                    // Mouth area
                    (0.35, 0.68), (0.45, 0.7), (0.55, 0.7), (0.65, 0.68),
                    // Lower face
                    (0.25, 0.78), (0.4, 0.82), (0.6, 0.82), (0.75, 0.78),
                    // Chin
                    (0.45, 0.9), (0.5, 0.92), (0.55, 0.9)
                ]
                
                ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 6, height: 6)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        )
                        .position(
                            x: point.x * geometry.size.width,
                            y: point.y * geometry.size.height
                        )
                }
            }
        }
    }
}
