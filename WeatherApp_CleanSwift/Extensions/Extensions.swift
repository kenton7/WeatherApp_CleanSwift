import Foundation
import UIKit

//MARK: - UIColor
extension UIColor {
    static var tabBarItemSelected: UIColor = .white
    static var backgroundColorTabBar: UIColor = UIColor(red: 0.322, green: 0.239, blue: 0.498, alpha: 1)
    static var mainWhite: UIColor = .white
    static var tabBarItemNonSelected: UIColor = .gray
}

//MARK: - UIImage
extension UIImage {
    /// Функция для добавления круга на зданий фон картнки
    /// - Parameter color: цвет круга
    /// - Returns: картинка с кругом на заднем фоне
    func addBackgroundCircle(_ color: UIColor?) -> UIImage? {

        let circleDiameter = max(size.width * 2, size.height * 2)
        let circleRadius = circleDiameter * 0.5
        let circleSize = CGSize(width: circleDiameter, height: circleDiameter)
        let circleFrame = CGRect(x: 0, y: 0, width: circleSize.width, height: circleSize.height)
        let imageFrame = CGRect(x: circleRadius - (size.width * 0.5), y: circleRadius - (size.height * 0.5), width: size.width, height: size.height)

        let view = UIView(frame: circleFrame)
        view.backgroundColor = color ?? .systemRed
        view.layer.cornerRadius = circleDiameter * 0.5

        UIGraphicsBeginImageContextWithOptions(circleSize, false, UIScreen.main.scale)

        let renderer = UIGraphicsImageRenderer(size: circleSize)
        let circleImage = renderer.image { ctx in
            view.drawHierarchy(in: circleFrame, afterScreenUpdates: true)
        }

        circleImage.draw(in: circleFrame, blendMode: .normal, alpha: 1.0)
        draw(in: imageFrame, blendMode: .normal, alpha: 1.0)

        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
}

//MARK: - String
extension String {
    
    /// Функция для регулировки описания погоды, если в описании погоды 2 и более слова, так как с сервера приходит каждое слово с большой буквы
    /// - Parameter info: описание погоды (например, Облачно с прояснениями)
    /// - Returns: измененное значение
    func configureWeatherDescription(info: String) -> String {
        
        var finalStr = ""
        let separatedDescription = info.components(separatedBy: " ")
        let finalDescription = "\(separatedDescription[0].capitalized )\n\(separatedDescription.last ?? "")"
        
        if separatedDescription.count == 2 {
            finalStr = finalDescription
        } else if separatedDescription.count == 3 {
            finalStr = "\(separatedDescription[0].capitalized ) \(separatedDescription[1] )\n\(separatedDescription.last ?? "")"
        } else {
            finalStr = info.prefix(1).uppercased() + (info.lowercased().dropFirst())
        }
        
        return finalStr
    }
    
    func capitalizingFirstLetter() -> String {
       return prefix(1).uppercased() + self.lowercased().dropFirst()
     }

     mutating func capitalizeFirstLetter() {
       self = self.capitalizingFirstLetter()
     }
}

//MARK: - UIView
extension UIView {
    func animateBackground(image: UIImage, on view: UIView) {
        
        //фильтруем subviews по тегам, чтобы удалить только картинки заднего фона при повторном запуске фукнкции
        view.subviews.filter {
            $0.tag == 100 || $0.tag == 101
        }.forEach {
            $0.removeFromSuperview()
        }
        
        // ширина экрана
        let imageViewWidth = view.frame.size.width
        // высота экрана
        let imageViewHeight = view.frame.size.height
        
        
        let backgroundImageView1 = UIImageView(image: image)
        backgroundImageView1.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        backgroundImageView1.tag = 100 // устанавливаем тег для первого изображения
        view.insertSubview(backgroundImageView1, at: 0)
        
        let backgroundImageView2 = UIImageView(image: image)
        backgroundImageView2.frame = CGRect(x: imageViewWidth, y: 0, width: imageViewWidth, height: imageViewHeight)
        backgroundImageView2.transform = CGAffineTransform(scaleX: -1, y: 1) // отзеркаливаем вторую картинку, чтобы создать иллюзию бесшовного перехода
        backgroundImageView2.tag = 101 // устанавливаем тег для второго изображения
        view.insertSubview(backgroundImageView2, at: 0)
        
        func animateImage() {
            UIView.animate(withDuration: 30.0, delay: 0.0, options: [.curveLinear], animations: {
                // Двигаем картинки влево
                backgroundImageView1.frame = backgroundImageView1.frame.offsetBy(dx: -imageViewWidth, dy: 0)
                backgroundImageView2.frame = backgroundImageView2.frame.offsetBy(dx: -imageViewWidth, dy: 0)
            }) { _ in
                /*
                 Данный участок кода отвечает за проверку позиции изображений backgroundImageView1 и backgroundImageView2 по оси X после анимации.
                 Если позиция по оси X уходит за пределы отрицательного значения, что означает,
                 что изображение полностью ушло за границы видимой области влево,
                 то его положение сбрасывается на начальное положение.

                 Рассмотрим подробнее:

                 backgroundImageView1.frame.origin.x - это текущая координата X (горизонтальная позиция) для backgroundImageView1.
                 backgroundImageView2.frame.origin.x - это текущая координата X (горизонтальная позиция) для backgroundImageView2.
                 imageViewWidth - это ширина видимой области (ширина экрана или контейнера для анимации).
                 Таким образом, если backgroundImageView1 или backgroundImageView2 выходят за левую границу видимой области
                 (то есть их X-координата меньше или равна -imageViewWidth), их положение сбрасывается на imageViewWidth,
                 чтобы создать эффект бесшовного движения. Это позволяет изображению переместиться "вне экрана"
                 и мгновенно вернуться на начальное положение, создавая иллюзию непрерывного движения.
                 */
                if backgroundImageView1.frame.origin.x <= -imageViewWidth {
                    backgroundImageView1.frame.origin.x = imageViewWidth
                }
                if backgroundImageView2.frame.origin.x <= -imageViewWidth {
                    backgroundImageView2.frame.origin.x = imageViewWidth
                }
                // Повторяем анимацию
                animateImage()
            }
        }
        animateImage()
    }
}

