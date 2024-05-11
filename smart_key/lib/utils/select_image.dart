import 'package:image_picker/image_picker.dart';
import 'package:smart_key/services/firebase_api.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  logger.i('No image selected.');
}
