
import 'helpers/translation.dart';
import 'helpers/shared_value_helper.dart';

var this_year = DateTime.now().year.toString();

class AppConfig {
  static String copyright_text = "@ GameDif " + this_year; //this shows in the splash screen
  static String app_name = AppTranslation.translationsKeys[langu_choos.value]['Edifice GameDif']; //this shows in the splash screen

  static String purchase_code = "e61f6cbb-bf4f-4df0-bfc7-8b2632b513db"; //enter your purchase code for the app from codecanyon
  //static String purchase_code = ""; //enter your purchase code for the app from codecanyon

  //configure this
  static const bool HTTPS = true;

  //configure this
  static const DOMAIN_PATH = "shop.gamedif.com"; //localhost
  //static const DOMAIN_PATH = "something.com"; // directly inside the public folder

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PUBLIC_FOLDER = "public";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "${PROTOCOL}${DOMAIN_PATH}";
  static const String BASE_URL = "${RAW_BASE_URL}/${API_ENDPATH}";
  static const String BASE_URLPOS = "${PROTOCOL}pos.gamedif.com/api/";
  //configure this if you are using amazon s3 like services
  //give direct link to file like https://[[bucketname]].s3.ap-southeast-1.amazonaws.com/
  //otherwise do not change anythink
  static const String BASE_PATH = "${RAW_BASE_URL}/${PUBLIC_FOLDER}/";
  //static const String BASE_PATH = "https://tosoviti.s3.ap-southeast-2.amazonaws.com/";
}
