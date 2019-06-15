import UIKit
import CoreImage
import AVFoundation

class ViewController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate{

    // シャッターボタン
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var custamButton: UIButton!
    var sampleCIImage: CIImage!
    var sepiaCIImage: CIImage!
    var sampleUiImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: { (action:UIAlertAction) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: { (action:UIAlertAction) in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.popoverPresentationController?.sourceView = view
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        if let shareImage = cameraImage.image {
            let shareImages = [shareImage]
            let controller = UIActivityViewController(activityItems: shareImages, applicationActivities: nil)
            // iPad対応
            controller.popoverPresentationController?.sourceView = view
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func custamButtonAction(_ sender: Any) {
        if let originalImage = cameraImage.image {
            // フィルタ名を指定
            let filterName = "CIPhotoEffectMono"
            // 元々の画像の回転角度を取得
            let rotate = originalImage.imageOrientation
            // UIImage形式の画像をCIImage形式の画像に変換
            let inputImage = CIImage(image: originalImage)
            guard let effectFilter = CIFilter(name: filterName) else {
                return
            }
            effectFilter.setDefaults()
            effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
            guard let outputImage = effectFilter.outputImage else {
                return
            }
            // CIContextのインスタンスを取得
            let ciContext = CIContext(options: nil)
            // エフェクト後の画像をCIContext上に描画し、結果をcgImageとしてCGImage形式の画像を取得
            guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                return
            }
            //エフェクト後の画像をCGImage形式からUIImage形式に変換。その後回転角度を指定、そしてimageViewに表示
            cameraImage.image = UIImage(cgImage: cgImage, scale: 1.0, orientation: rotate)
        }
    }
    // 撮影完了時
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 元の処理
        sampleUiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        cameraImage.image = sampleUiImage
        // ここからはフィルター
        if let originalImage = cameraImage.image {
            // フィルタ名を指定
            let filterName = "CIPhotoEffectMono"
            // 元々の画像の回転角度を取得
            let rotate = originalImage.imageOrientation
            // UIImage形式の画像をCIImage形式の画像に変換
            let inputImage = CIImage(image: originalImage)
            guard let effectFilter = CIFilter(name: filterName) else {
                return
            }
            effectFilter.setDefaults()
            effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
            guard let outputImage = effectFilter.outputImage else {
                return
            }
            // CIContextのインスタンスを取得
            let ciContext = CIContext(options: nil)
            // エフェクト後の画像をCIContext上に描画し、結果をcgImageとしてCGImage形式の画像を取得
            guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                return
            }
            //エフェクト後の画像をCGImage形式からUIImage形式に変換。その後回転角度を指定、そしてimageViewに表示
            cameraImage.image = UIImage(cgImage: cgImage, scale: 1.0, orientation: rotate)
        }

        // 終了
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
