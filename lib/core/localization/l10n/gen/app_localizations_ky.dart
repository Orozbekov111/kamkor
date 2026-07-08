// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get appName => 'KAMKOR';

  @override
  String get cancel => 'Жокко чыгаруу';

  @override
  String get retry => 'Кайра аракет кылуу';

  @override
  String get error_network => 'Тармакка туташуу жок. Байланышты текшериңиз';

  @override
  String get error_timeout => 'Сервер жооп бербей жатат. Кайра аракет кылыңыз';

  @override
  String get error_server =>
      'Серверде ката кетти. Кийинчерээк кайра аракет кылыңыз';

  @override
  String get error_unknown => 'Белгисиз ката кетти';

  @override
  String get error_unauthorized => 'Авторизация талап кылынат';

  @override
  String get login_title => 'Кирүү';

  @override
  String get login_subtitle =>
      'Кирүү үчүн жеке шилтемеңизди же QR-кодду колдонуңуз';

  @override
  String get login_scan_hint => 'QR-кодду камерага багыттаңыз';

  @override
  String get login_camera_denied => 'Камерага уруксат жок';

  @override
  String get login_or_paste => 'же шилтемени киргизиңиз';

  @override
  String get login_link_label => 'Жеке шилтеме';

  @override
  String get login_link_hint => 'https://kamkor.mvd.kg/pwa/?access=…';

  @override
  String get login_link_origin =>
      'Жеке шилтемени же QR-кодду кайрылууңузду кабыл алган кызматкер берет.';

  @override
  String get login_continue => 'Улантуу';

  @override
  String get login_link_required => 'Шилтемени киргизиңиз';

  @override
  String get login_link_invalid => 'Шилтеме жараксыз же эскирген';

  @override
  String get login_link_valid => 'Шилтеме ырасталды';

  @override
  String get login_camera_primer =>
      'QR-кодду сканерлөө үчүн камерага уруксат бериңиз.';

  @override
  String get login_camera_primer_action => 'Камераны күйгүзүү';

  @override
  String get login_camera_error => 'Камераны иштетүү мүмкүн болбоду';

  @override
  String get login_camera_denied_hint =>
      'Камерага уруксат берилген эмес. Сканерлөө үчүн жөндөөлөрдү ачыңыз';

  @override
  String get open_settings => 'Жөндөөлөрдү ачуу';

  @override
  String get login_submit => 'Кирүү';

  @override
  String get login_back => 'Артка';

  @override
  String get checking_session => 'Сессия текшерилүүдө…';

  @override
  String get enter_pin => 'PIN-кодду киргизиңиз';

  @override
  String get pin_invalid => 'PIN-код туура эмес. Кайра аракет кылыңыз';

  @override
  String get sos_button => 'SOS';

  @override
  String get sos_active => 'SOS активдүү';

  @override
  String get sos_sending => 'Сигнал жөнөтүлүүдө…';

  @override
  String get sos_idle_title => 'Коркунуч учурунда жардам чакырыңыз';

  @override
  String get sos_hold_hint =>
      'Жардам чакыруу үчүн баскычты 3 секунд кармап туруңуз';

  @override
  String get sos_countdown_hint =>
      'Жардам керек болбосо «Жокко чыгаруу» баскычын басыңыз';

  @override
  String get sos_countdown_cancel => 'Жокко чыгаруу';

  @override
  String get sos_activating => 'Жардам чакырылууда…';

  @override
  String get sos_activating_retry => 'Сигнал жөнөтүлүүдө, аракет улантылууда…';

  @override
  String get sos_activating_struggling =>
      'Сигнал жөнөтүү кечигип жатат. Байланышты текшериңиз — биз аракетти улантабыз';

  @override
  String get sos_active_title => 'Жардам чакырылды';

  @override
  String get sos_active_subtitle =>
      'Байланышта болуңуз. Биз сиздин маалыматыңызды өткөрүп жатабыз.';

  @override
  String get sos_coords_transmitting => 'Координаттар өткөрүлүүдө';

  @override
  String sos_last_sent(String time) {
    return 'Акыркы өткөрүү: $time';
  }

  @override
  String get sos_awaiting_signal => 'Сигнал күтүлүүдө…';

  @override
  String get sos_reconnecting => 'Кайра туташуу…';

  @override
  String get sos_closed_title => 'Кайрылуу аяктады';

  @override
  String get sos_closed_done => 'Оператор кайрылууңузду аяктады';

  @override
  String get sos_closed_cancelled => 'Кайрылуу жокко чыгарылды';

  @override
  String get sos_closed_subtitle => 'Кайрылуу оператор тарабынан аяктады';

  @override
  String get sos_closed_action => 'Даяр';

  @override
  String get sos_permission_title => 'Геолокацияга уруксат керек';

  @override
  String get sos_permission_denied =>
      'Жардам чакыруу үчүн геолокацияга уруксат бериңиз';

  @override
  String get sos_permission_denied_forever =>
      'Геолокацияга уруксат берилген эмес. Жөндөөлөрдү ачып, уруксат бериңиз';

  @override
  String get sos_service_disabled_title => 'Геолокация өчүрүлгөн';

  @override
  String get sos_service_disabled =>
      'Жайгашкан жериңизди өткөрүү үчүн геолокация кызматын күйгүзүңүз';

  @override
  String get sos_open_settings => 'Жөндөөлөрдү ачуу';

  @override
  String get sos_enable_location => 'Геолокацияны күйгүзүү';

  @override
  String get sos_allow => 'Уруксат берүү';

  @override
  String get error_location_unavailable =>
      'Жайгашкан жерди аныктоо мүмкүн болбоду';

  @override
  String get sos_readiness_contacts_ready => 'Ишенимдүү байланыштар тууралган';

  @override
  String get sos_readiness_contacts_empty => 'Ишенимдүү байланыштарды кошуңуз';

  @override
  String get sos_active_badge => 'Тревога активдүү';

  @override
  String get nav_contacts => 'Байланыштар';

  @override
  String get nav_message => 'Билдирүү';

  @override
  String get nav_history => 'Тарых';

  @override
  String get nav_sos_open => 'SOS ачуу';

  @override
  String get contacts_title => 'Ишенимдүү байланыштар';

  @override
  String get contacts_add => 'Байланыш кошуу';

  @override
  String get contacts_add_title => 'Байланыш кошуу';

  @override
  String get contacts_edit_title => 'Байланышты өзгөртүү';

  @override
  String get contacts_edit => 'Өзгөртүү';

  @override
  String get contacts_delete => 'Өчүрүү';

  @override
  String get contacts_delete_title => 'Байланышты өчүрүү';

  @override
  String contacts_delete_message(String name) {
    return '$name тизмеден өчүрүлсүнбү?';
  }

  @override
  String get contacts_deleted => 'Байланыш өчүрүлдү';

  @override
  String get contacts_saved => 'Байланыш сакталды';

  @override
  String get contacts_actions => 'Аракеттер';

  @override
  String get contacts_empty_message =>
      'Ишенимдүү байланыштар жок. Коркунуч учурунда сигнал жетчү жакындарыңызды кошуңуз';

  @override
  String get contacts_name_label => 'Аты';

  @override
  String get contacts_phone_label => 'Телефон номери';

  @override
  String get contacts_phone_hint => '+996 700 123 456';

  @override
  String get contacts_name_required => 'Атын киргизиңиз';

  @override
  String get contacts_phone_required => 'Телефон номерин киргизиңиз';

  @override
  String get contacts_phone_invalid => 'Телефон номери туура эмес';

  @override
  String get contacts_save => 'Сактоо';

  @override
  String get contacts_duplicate_phone => 'Бул номер тизмеде бар';

  @override
  String get contacts_invalid => 'Киргизилген маалымат туура эмес';

  @override
  String get contacts_pick_from_device => 'Телефон байланыштарынан тандоо';

  @override
  String get contacts_pick_number_title => 'Номерди тандаңыз';

  @override
  String get contacts_permission_denied =>
      'Байланыштарга уруксат жок. Аны жөндөөлөрдөн бериңиз';

  @override
  String get contacts_pick_failed => 'Байланыштарды ачуу мүмкүн болбоду';

  @override
  String get message_template_title => 'SOS билдирүүсү';

  @override
  String get message_template_subtitle =>
      'Коркунуч учурунда жөнөтүлүүчү билдирүүнүн текстин ырастаңыз.';

  @override
  String get message_template_message_label => 'Билдирүүнүн тексти';

  @override
  String get message_template_geo_label => 'Геолокация кол тамгасы';

  @override
  String message_template_geo_hint(String token) {
    return '$token белгисинин ордуна учурдагы координаттар коюлат';
  }

  @override
  String get message_template_save => 'Сактоо';

  @override
  String get message_template_saved => 'Билдирүү сакталды';

  @override
  String get message_template_invalid =>
      'Текст уруксат берилген узундуктан ашып кетти';

  @override
  String get message_template_required => 'Билдирүүнүн текстин киргизиңиз';

  @override
  String get message_template_preview_label => 'Жөнөтүлүүчү билдирүү';

  @override
  String get message_template_intro =>
      'Тревога күйгүзүлгөндө бул билдирүү координаттарыңыз менен ишенимдүү байланыштарыңызга автоматтык түрдө жөнөтүлөт.';

  @override
  String get message_template_message_hint =>
      'Мисалы: Мага жардам керек, мен коркунучтамын';

  @override
  String get message_template_geo_insert => 'Координат белгисин коюу';

  @override
  String get message_template_geo_added => 'Координат белгиси кошулду';

  @override
  String get message_template_preview_hint =>
      'Координаттар мисал катары көрсөтүлгөн — тревога учурунда чыныгы жайгашкан жериңиз коюлат.';

  @override
  String get message_template_location_title => 'Жайгашкан жеримди кошуу';

  @override
  String get message_template_location_desc =>
      'Билдирүүгө турган жериңиздин координаттары кошулат';

  @override
  String get message_template_preview_empty =>
      'Текст жаза баштаңыз — бул жерде билдирүү пайда болот';

  @override
  String get sos_history_title => 'Кайрылуулар тарыхы';

  @override
  String get sos_history_empty_message =>
      'Кайрылуулар жок. Бул жерде сиз жиберген SOS сигналдары чагылдырылат';

  @override
  String get sos_history_no_location => 'Координаттар жеткиликсиз';

  @override
  String get sos_history_no_date => 'Күнү белгисиз';

  @override
  String get sos_history_detail_title => 'Кайрылуу тууралуу';

  @override
  String get sos_history_id_label => 'Кайрылуунун номери';

  @override
  String get sos_history_date_label => 'Күнү жана убактысы';

  @override
  String get sos_history_location_label => 'Координаттар';

  @override
  String get sos_history_copy_location => 'Координаттарды көчүрүү';

  @override
  String get sos_history_open_map => 'Картадан ачуу';

  @override
  String get sos_history_location_copied => 'Координаттар көчүрүлдү';

  @override
  String get info_title => 'Маалымат';

  @override
  String get info_crisis_centers => 'Кризистик борборлор';

  @override
  String get info_psychological_help => 'Психологиялык жардам';

  @override
  String get info_emergency_instructions => 'Шашылыш нускамалар';

  @override
  String get info_privacy_policy => 'Купуялык саясаты';

  @override
  String get info_crisis_centers_subtitle => 'Дарек жана байланыштар';

  @override
  String get info_psychological_help_subtitle => 'Колдоо кызматтары';

  @override
  String get info_emergency_instructions_subtitle =>
      'Коркунуч учурунда эмне кылуу керек';

  @override
  String get info_privacy_policy_subtitle => 'Маалыматтарды иштетүү шарттары';

  @override
  String get info_empty_message => 'Бул бөлүмдө азырынча материалдар жок';

  @override
  String get info_offline_notice =>
      'Тармак жок. Негизги шашылыш номерлер көрсөтүлдү.';

  @override
  String get emergency_call => 'Чалуу';

  @override
  String get emergency_service_112 => 'Куткаруу кызматы (бирдиктүү)';

  @override
  String get emergency_service_police => 'Милиция';

  @override
  String get emergency_service_ambulance => 'Тез жардам';

  @override
  String get emergency_service_fire => 'Өрт өчүрүү кызматы';

  @override
  String get emergency_service_gas => 'Газдын авариялык кызматы';

  @override
  String get error_call_failed => 'Чалууну аткаруу мүмкүн болбоду';

  @override
  String get profile_title => 'Профиль';

  @override
  String get profile_edit => 'Профилди өзгөртүү';

  @override
  String get profile_edit_title => 'Профилди өзгөртүү';

  @override
  String get profile_name_label => 'Аты';

  @override
  String get profile_surname_label => 'Фамилиясы';

  @override
  String get profile_phone_label => 'Телефон номери';

  @override
  String get profile_address_label => 'Дареги';

  @override
  String get profile_save => 'Сактоо';

  @override
  String get profile_saved => 'Профиль жаңыртылды';

  @override
  String get profile_name_required => 'Атын киргизиңиз';

  @override
  String get profile_invalid => 'Киргизилген маалымат туура эмес';

  @override
  String get profile_section_account => 'Аккаунт';

  @override
  String get profile_section_settings => 'Жөндөөлөр';

  @override
  String get profile_language => 'Тил';

  @override
  String get profile_theme => 'Көрүнүш';

  @override
  String get theme_light => 'Ачык';

  @override
  String get theme_dark => 'Караңгы';

  @override
  String get theme_system => 'Системалык';

  @override
  String get profile_logout => 'Чыгуу';

  @override
  String get profile_logout_title => 'Аккаунттан чыгуу';

  @override
  String get profile_logout_message =>
      'Чыккандан кийин SOS баскычы жана ишенимдүү байланыштар жеткиликсиз болот. Кайра кирүү үчүн жеке шилтеме менен PIN керек болот.';

  @override
  String get language_kyrgyz => 'Кыргызча';

  @override
  String get language_russian => 'Орусча';
}
