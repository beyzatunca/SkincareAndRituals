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
                // Background gradient - Pink/Purple tones
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.85, blue: 0.92),  // Light pink
                        Color(red: 0.85, green: 0.75, blue: 0.95)   // Light purple
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView(geometry: geometry)
                    
                    Spacer(minLength: 20)
                    
                    // Camera Preview - Main face photo area
                    cameraPreviewView(geometry: geometry)
                    
                    Spacer(minLength: 30)
                    
                    // Bottom Controls
                    bottomControlsView(geometry: geometry)
                    
                    Spacer(minLength: 40)
                    
                    // Analysis Completion Button
                    if viewModel.analysisCompleted {
                        analysisCompletionView(geometry: geometry)
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
    
    // MARK: - Header View
    private func headerView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
                .accessibilityLabel("Back")
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            VStack(spacing: 8) {
                Text("Analyze Your Skin with AI")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("Get personalized skincare recommendations in seconds.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
    }
    
    // MARK: - Camera Preview View
    private func cameraPreviewView(geometry: GeometryProxy) -> some View {
        ZStack {
            if viewModel.capturedImage != nil {
                // Show captured image with face landmarks
                Image(uiImage: viewModel.capturedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width * 0.85, height: geometry.size.width * 0.85 * 1.3)
                    .clipped()
                    .cornerRadius(30)
                    .overlay(
                        // Face landmark points overlay
                        FaceLandmarkPointsOverlay()
                    )
            } else {
                // Show sample face image for design purposes
                ZStack {
                    // Sample face image background
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.9))
                        .frame(width: geometry.size.width * 0.85, height: geometry.size.width * 0.85 * 1.3)
                    
                    // Sample face content
                    VStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray.opacity(0.6))
                        
                        Text("Position your face in the frame")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .overlay(
                        // Face landmark points overlay for demo
                        FaceLandmarkPointsOverlay()
                    )
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Permission Denied View
    private func permissionDeniedView(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height * 0.02) {
            Image(systemName: "camera.fill")
                .font(.system(size: geometry.size.height * 0.08))
                .foregroundColor(AppTheme.textSecondary)
            
            Text("Enable Camera Access")
                .font(.system(size: geometry.size.height * 0.022, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)
            
            Text("Camera access is required to analyze your skin.")
                .font(.system(size: geometry.size.height * 0.016))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Tips View
    private func tipsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 8) {
            Text("Good lighting, remove glasses, keep hair away from face.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Text("Hold still for 2–3 seconds.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
        .padding(.top, 20)
    }
    
    // MARK: - Bottom Controls View
    private func bottomControlsView(geometry: GeometryProxy) -> some View {
        HStack(spacing: 50) {
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
                        .fill(Color.white)
                        .frame(width: 65, height: 65)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .accessibilityLabel("Refresh")
            
            // Center capture button - Large pink/purple gradient
            Button(action: {
                if viewModel.capturedImage != nil {
                    viewModel.confirmPhoto()
                } else {
                    viewModel.capturePhoto()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.85, green: 0.55, blue: 0.75),  // Pink
                                    Color(red: 0.75, green: 0.45, blue: 0.85)   // Purple
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 85, height: 85)
                        .shadow(color: Color.purple.opacity(0.4), radius: 12, x: 0, y: 6)
                    
                    Image(systemName: "camera.fill")
                        .font(.system(size: 32, weight: .medium))
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
                        .fill(Color.white)
                        .frame(width: 65, height: 65)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .accessibilityLabel("Upload from Gallery")
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // MARK: - Analyze Button View
    private func analyzeButtonView(geometry: GeometryProxy) -> some View {
        Button(action: {
            if viewModel.capturedImage != nil {
                viewModel.startAnalysis()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text("Analyze")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.8, green: 0.6, blue: 0.8),
                        Color(red: 0.7, green: 0.5, blue: 0.7)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .disabled(viewModel.capturedImage == nil)
        .opacity(viewModel.capturedImage == nil ? 0.5 : 1.0)
        .padding(.horizontal, 40)
        .padding(.bottom, 40)
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
    
    // MARK: - Analysis Completion View
    private func analysisCompletionView(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height * 0.02) {
            // Success message
            VStack(spacing: geometry.size.height * 0.01) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: geometry.size.height * 0.06))
                    .foregroundColor(.green)
                
                Text("Analysis Complete!")
                    .font(.system(size: geometry.size.height * 0.025, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text("Your skin analysis has been completed successfully.")
                    .font(.system(size: geometry.size.height * 0.018))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, geometry.size.width * 0.1)
            
            // Continue to app button
            Button(action: {
                surveyViewModel.completeFaceAnalysis()
            }) {
                HStack(spacing: geometry.size.width * 0.02) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: geometry.size.width * 0.04, weight: .semibold))
                    Text("Continue to App")
                        .font(.system(size: geometry.size.width * 0.045, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height * 0.06)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("PrimaryColor"), Color("SecondaryColor")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(geometry.size.height * 0.03)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, geometry.size.width * 0.05)
        }
        .padding(.vertical, geometry.size.height * 0.02)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.9))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, geometry.size.width * 0.05)
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
