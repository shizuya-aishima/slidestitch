import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  // 256x256のロゴ画像を作成
  final image = img.Image(width: 256, height: 256);

  // 背景を白で塗りつぶす
  img.fill(image, color: img.ColorRgb8(255, 255, 255));

  // 中央に青い円を描画
  img.drawCircle(
    image,
    x: 128,
    y: 128,
    radius: 100,
    color: img.ColorRgb8(66, 165, 245),
  );

  // 'S'の文字を描画（簡易的な表現）
  final white = img.ColorRgb8(255, 255, 255);
  img.drawLine(image,
      x1: 108, y1: 88, x2: 148, y2: 88, color: white, thickness: 20);
  img.drawLine(image,
      x1: 108, y1: 128, x2: 148, y2: 128, color: white, thickness: 20);
  img.drawLine(image,
      x1: 108, y1: 168, x2: 148, y2: 168, color: white, thickness: 20);
  img.drawLine(image,
      x1: 108, y1: 88, x2: 108, y2: 128, color: white, thickness: 20);
  img.drawLine(image,
      x1: 148, y1: 128, x2: 148, y2: 168, color: white, thickness: 20);

  // PNGとして保存
  final png = img.encodePng(image);
  File('assets/logo.png').writeAsBytesSync(png);
}
