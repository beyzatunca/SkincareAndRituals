import SwiftUI
import AVFoundation
import PhotosUI

struct FaceAnalysisView: View {
    @StateObject private var viewModel = FaceAnalysisViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.92, blue: 0.98),
                        Color(red: 0.98, green: 0.96, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView(geometry: geometry)
                    
                    // Camera Preview
                    cameraPreviewView(geometry: geometry)
                    
                    // Tips
                    tipsView(geometry: geometry)
                    
                    // Bottom Controls
                    bottomControlsView(geometry: geometry)
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
        VStack(spacing: geometry.size.height * 0.008) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: geometry.size.height * 0.025, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                }
                .accessibilityLabel("Back")
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, geometry.size.height * 0.02)
            
            VStack(spacing: geometry.size.height * 0.006) {
                Text("Analyze Your Skin with AI")
                    .font(.system(size: geometry.size.height * 0.028, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Get personalized skincare recommendations in seconds.")
                    .font(.system(size: geometry.size.height * 0.016))
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Camera Preview View
    private func cameraPreviewView(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height * 0.02) {
            ZStack {
                // Camera preview container
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.black.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                
                if viewModel.capturedImage != nil {
                    // Show captured image
                    Image(uiImage: viewModel.capturedImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                        .cornerRadius(24)
                } else if viewModel.cameraPermissionGranted {
                    // Camera preview
                    CameraPreviewView(session: viewModel.cameraSession)
                        .cornerRadius(24)
                } else {
                    // Permission denied state
                    permissionDeniedView(geometry: geometry)
                }
                
                // Face guidance overlay
                if viewModel.capturedImage == nil && viewModel.cameraPermissionGranted {
                    FaceGuidanceOverlay(
                        isFaceDetected: viewModel.isFaceDetected,
                        geometry: geometry
                    )
                }
            }
            .frame(height: geometry.size.height * 0.5)
            .padding(.horizontal, 20)
        }
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
        VStack(spacing: geometry.size.height * 0.008) {
            Text("Good lighting, remove glasses, keep hair away from face.")
                .font(.system(size: geometry.size.height * 0.014))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Hold still for 2–3 seconds.")
                .font(.system(size: geometry.size.height * 0.014))
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
        .padding(.top, geometry.size.height * 0.02)
    }
    
    // MARK: - Bottom Controls View
    private func bottomControlsView(geometry: GeometryProxy) -> some View {
        HStack(spacing: 24) {
            // Left button (Upload or Retake)
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
                        .frame(width: 56, height: 56)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: viewModel.capturedImage != nil ? "arrow.clockwise" : "photo.on.rectangle")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                }
            }
            .accessibilityLabel(viewModel.capturedImage != nil ? "Retake" : "Upload from Library")
            
            // Center shutter button
            Button(action: {
                if viewModel.capturedImage != nil {
                    viewModel.confirmPhoto()
                } else {
                    viewModel.capturePhoto()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(viewModel.capturedImage != nil ? AppTheme.primaryColor : Color(red: 0.8, green: 0.7, blue: 0.9))
                        .frame(width: 72, height: 72)
                        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
                    
                    Image(systemName: viewModel.capturedImage != nil ? "checkmark" : "camera.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .disabled(!viewModel.cameraPermissionGranted && viewModel.capturedImage == nil)
            .accessibilityLabel(viewModel.capturedImage != nil ? "Use Photo" : "Take Photo")
            
            // Right button (Flip camera or placeholder)
            Button(action: {
                viewModel.flipCamera()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 56, height: 56)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: "camera.rotate")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                }
            }
            .disabled(viewModel.capturedImage != nil)
            .accessibilityLabel("Flip Camera")
        }
        .padding(.horizontal, 20)
        .padding(.bottom, geometry.size.height * 0.04)
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
}

#Preview {
    FaceAnalysisView()
}
