import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ky'),
    Locale('ru'),
  ];

  /// No description provided for @appName.
  ///
  /// In ky, this message translates to:
  /// **'KAMKOR'**
  String get appName;

  /// No description provided for @cancel.
  ///
  /// In ky, this message translates to:
  /// **'Жокко чыгаруу'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In ky, this message translates to:
  /// **'Кайра аракет кылуу'**
  String get retry;

  /// No description provided for @error_network.
  ///
  /// In ky, this message translates to:
  /// **'Тармакка туташуу жок. Байланышты текшериңиз'**
  String get error_network;

  /// No description provided for @error_timeout.
  ///
  /// In ky, this message translates to:
  /// **'Сервер жооп бербей жатат. Кайра аракет кылыңыз'**
  String get error_timeout;

  /// No description provided for @error_server.
  ///
  /// In ky, this message translates to:
  /// **'Серверде ката кетти. Кийинчерээк кайра аракет кылыңыз'**
  String get error_server;

  /// No description provided for @error_unknown.
  ///
  /// In ky, this message translates to:
  /// **'Белгисиз ката кетти'**
  String get error_unknown;

  /// No description provided for @error_unauthorized.
  ///
  /// In ky, this message translates to:
  /// **'Авторизация талап кылынат'**
  String get error_unauthorized;

  /// No description provided for @login_title.
  ///
  /// In ky, this message translates to:
  /// **'Кирүү'**
  String get login_title;

  /// No description provided for @login_subtitle.
  ///
  /// In ky, this message translates to:
  /// **'Кирүү үчүн жеке шилтемеңизди же QR-кодду колдонуңуз'**
  String get login_subtitle;

  /// No description provided for @login_scan_hint.
  ///
  /// In ky, this message translates to:
  /// **'QR-кодду камерага багыттаңыз'**
  String get login_scan_hint;

  /// No description provided for @login_camera_denied.
  ///
  /// In ky, this message translates to:
  /// **'Камерага уруксат жок'**
  String get login_camera_denied;

  /// No description provided for @login_or_paste.
  ///
  /// In ky, this message translates to:
  /// **'же шилтемени киргизиңиз'**
  String get login_or_paste;

  /// No description provided for @login_link_label.
  ///
  /// In ky, this message translates to:
  /// **'Жеке шилтеме'**
  String get login_link_label;

  /// No description provided for @login_link_hint.
  ///
  /// In ky, this message translates to:
  /// **'https://kamkor.mvd.kg/pwa/?access=…'**
  String get login_link_hint;

  /// No description provided for @login_link_origin.
  ///
  /// In ky, this message translates to:
  /// **'Жеке шилтемени же QR-кодду кайрылууңузду кабыл алган кызматкер берет.'**
  String get login_link_origin;

  /// No description provided for @login_continue.
  ///
  /// In ky, this message translates to:
  /// **'Улантуу'**
  String get login_continue;

  /// No description provided for @login_link_required.
  ///
  /// In ky, this message translates to:
  /// **'Шилтемени киргизиңиз'**
  String get login_link_required;

  /// No description provided for @login_link_invalid.
  ///
  /// In ky, this message translates to:
  /// **'Шилтеме жараксыз же эскирген'**
  String get login_link_invalid;

  /// No description provided for @login_link_valid.
  ///
  /// In ky, this message translates to:
  /// **'Шилтеме ырасталды'**
  String get login_link_valid;

  /// No description provided for @login_camera_primer.
  ///
  /// In ky, this message translates to:
  /// **'QR-кодду сканерлөө үчүн камерага уруксат бериңиз.'**
  String get login_camera_primer;

  /// No description provided for @login_camera_primer_action.
  ///
  /// In ky, this message translates to:
  /// **'Камераны күйгүзүү'**
  String get login_camera_primer_action;

  /// No description provided for @login_camera_error.
  ///
  /// In ky, this message translates to:
  /// **'Камераны иштетүү мүмкүн болбоду'**
  String get login_camera_error;

  /// No description provided for @login_camera_denied_hint.
  ///
  /// In ky, this message translates to:
  /// **'Камерага уруксат берилген эмес. Сканерлөө үчүн жөндөөлөрдү ачыңыз'**
  String get login_camera_denied_hint;

  /// No description provided for @open_settings.
  ///
  /// In ky, this message translates to:
  /// **'Жөндөөлөрдү ачуу'**
  String get open_settings;

  /// No description provided for @login_submit.
  ///
  /// In ky, this message translates to:
  /// **'Кирүү'**
  String get login_submit;

  /// No description provided for @login_back.
  ///
  /// In ky, this message translates to:
  /// **'Артка'**
  String get login_back;

  /// No description provided for @checking_session.
  ///
  /// In ky, this message translates to:
  /// **'Сессия текшерилүүдө…'**
  String get checking_session;

  /// No description provided for @enter_pin.
  ///
  /// In ky, this message translates to:
  /// **'PIN-кодду киргизиңиз'**
  String get enter_pin;

  /// No description provided for @pin_invalid.
  ///
  /// In ky, this message translates to:
  /// **'PIN-код туура эмес. Кайра аракет кылыңыз'**
  String get pin_invalid;

  /// No description provided for @sos_button.
  ///
  /// In ky, this message translates to:
  /// **'SOS'**
  String get sos_button;

  /// No description provided for @sos_active.
  ///
  /// In ky, this message translates to:
  /// **'SOS активдүү'**
  String get sos_active;

  /// No description provided for @sos_sending.
  ///
  /// In ky, this message translates to:
  /// **'Сигнал жөнөтүлүүдө…'**
  String get sos_sending;

  /// No description provided for @sos_idle_title.
  ///
  /// In ky, this message translates to:
  /// **'Коркунуч учурунда жардам чакырыңыз'**
  String get sos_idle_title;

  /// No description provided for @sos_hold_hint.
  ///
  /// In ky, this message translates to:
  /// **'Жардам чакыруу үчүн баскычты 3 секунд кармап туруңуз'**
  String get sos_hold_hint;

  /// No description provided for @sos_countdown_hint.
  ///
  /// In ky, this message translates to:
  /// **'Жардам керек болбосо «Жокко чыгаруу» баскычын басыңыз'**
  String get sos_countdown_hint;

  /// No description provided for @sos_countdown_cancel.
  ///
  /// In ky, this message translates to:
  /// **'Жокко чыгаруу'**
  String get sos_countdown_cancel;

  /// No description provided for @sos_activating.
  ///
  /// In ky, this message translates to:
  /// **'Жардам чакырылууда…'**
  String get sos_activating;

  /// No description provided for @sos_activating_retry.
  ///
  /// In ky, this message translates to:
  /// **'Сигнал жөнөтүлүүдө, аракет улантылууда…'**
  String get sos_activating_retry;

  /// No description provided for @sos_activating_struggling.
  ///
  /// In ky, this message translates to:
  /// **'Сигнал жөнөтүү кечигип жатат. Байланышты текшериңиз — биз аракетти улантабыз'**
  String get sos_activating_struggling;

  /// No description provided for @sos_active_title.
  ///
  /// In ky, this message translates to:
  /// **'Жардам чакырылды'**
  String get sos_active_title;

  /// No description provided for @sos_active_subtitle.
  ///
  /// In ky, this message translates to:
  /// **'Байланышта болуңуз. Биз сиздин маалыматыңызды өткөрүп жатабыз.'**
  String get sos_active_subtitle;

  /// No description provided for @sos_coords_transmitting.
  ///
  /// In ky, this message translates to:
  /// **'Координаттар өткөрүлүүдө'**
  String get sos_coords_transmitting;

  /// No description provided for @sos_last_sent.
  ///
  /// In ky, this message translates to:
  /// **'Акыркы өткөрүү: {time}'**
  String sos_last_sent(String time);

  /// No description provided for @sos_awaiting_signal.
  ///
  /// In ky, this message translates to:
  /// **'Сигнал күтүлүүдө…'**
  String get sos_awaiting_signal;

  /// No description provided for @sos_reconnecting.
  ///
  /// In ky, this message translates to:
  /// **'Кайра туташуу…'**
  String get sos_reconnecting;

  /// No description provided for @sos_closed_title.
  ///
  /// In ky, this message translates to:
  /// **'Кайрылуу аяктады'**
  String get sos_closed_title;

  /// No description provided for @sos_closed_done.
  ///
  /// In ky, this message translates to:
  /// **'Оператор кайрылууңузду аяктады'**
  String get sos_closed_done;

  /// No description provided for @sos_closed_cancelled.
  ///
  /// In ky, this message translates to:
  /// **'Кайрылуу жокко чыгарылды'**
  String get sos_closed_cancelled;

  /// No description provided for @sos_closed_subtitle.
  ///
  /// In ky, this message translates to:
  /// **'Кайрылуу оператор тарабынан аяктады'**
  String get sos_closed_subtitle;

  /// No description provided for @sos_closed_action.
  ///
  /// In ky, this message translates to:
  /// **'Даяр'**
  String get sos_closed_action;

  /// No description provided for @sos_permission_title.
  ///
  /// In ky, this message translates to:
  /// **'Геолокацияга уруксат керек'**
  String get sos_permission_title;

  /// No description provided for @sos_permission_denied.
  ///
  /// In ky, this message translates to:
  /// **'Жардам чакыруу үчүн геолокацияга уруксат бериңиз'**
  String get sos_permission_denied;

  /// No description provided for @sos_permission_denied_forever.
  ///
  /// In ky, this message translates to:
  /// **'Геолокацияга уруксат берилген эмес. Жөндөөлөрдү ачып, уруксат бериңиз'**
  String get sos_permission_denied_forever;

  /// No description provided for @sos_service_disabled_title.
  ///
  /// In ky, this message translates to:
  /// **'Геолокация өчүрүлгөн'**
  String get sos_service_disabled_title;

  /// No description provided for @sos_service_disabled.
  ///
  /// In ky, this message translates to:
  /// **'Жайгашкан жериңизди өткөрүү үчүн геолокация кызматын күйгүзүңүз'**
  String get sos_service_disabled;

  /// No description provided for @sos_open_settings.
  ///
  /// In ky, this message translates to:
  /// **'Жөндөөлөрдү ачуу'**
  String get sos_open_settings;

  /// No description provided for @sos_enable_location.
  ///
  /// In ky, this message translates to:
  /// **'Геолокацияны күйгүзүү'**
  String get sos_enable_location;

  /// No description provided for @sos_allow.
  ///
  /// In ky, this message translates to:
  /// **'Уруксат берүү'**
  String get sos_allow;

  /// No description provided for @error_location_unavailable.
  ///
  /// In ky, this message translates to:
  /// **'Жайгашкан жерди аныктоо мүмкүн болбоду'**
  String get error_location_unavailable;

  /// No description provided for @sos_readiness_contacts_ready.
  ///
  /// In ky, this message translates to:
  /// **'Ишенимдүү байланыштар тууралган'**
  String get sos_readiness_contacts_ready;

  /// No description provided for @sos_readiness_contacts_empty.
  ///
  /// In ky, this message translates to:
  /// **'Ишенимдүү байланыштарды кошуңуз'**
  String get sos_readiness_contacts_empty;

  /// No description provided for @sos_active_badge.
  ///
  /// In ky, this message translates to:
  /// **'Тревога активдүү'**
  String get sos_active_badge;

  /// No description provided for @nav_contacts.
  ///
  /// In ky, this message translates to:
  /// **'Байланыштар'**
  String get nav_contacts;

  /// No description provided for @nav_message.
  ///
  /// In ky, this message translates to:
  /// **'Билдирүү'**
  String get nav_message;

  /// No description provided for @nav_history.
  ///
  /// In ky, this message translates to:
  /// **'Тарых'**
  String get nav_history;

  /// No description provided for @nav_sos_open.
  ///
  /// In ky, this message translates to:
  /// **'SOS ачуу'**
  String get nav_sos_open;

  /// No description provided for @contacts_title.
  ///
  /// In ky, this message translates to:
  /// **'Ишенимдүү байланыштар'**
  String get contacts_title;

  /// No description provided for @contacts_add.
  ///
  /// In ky, this message translates to:
  /// **'Байланыш кошуу'**
  String get contacts_add;

  /// No description provided for @contacts_add_title.
  ///
  /// In ky, this message translates to:
  /// **'Байланыш кошуу'**
  String get contacts_add_title;

  /// No description provided for @contacts_edit_title.
  ///
  /// In ky, this message translates to:
  /// **'Байланышты өзгөртүү'**
  String get contacts_edit_title;

  /// No description provided for @contacts_edit.
  ///
  /// In ky, this message translates to:
  /// **'Өзгөртүү'**
  String get contacts_edit;

  /// No description provided for @contacts_delete.
  ///
  /// In ky, this message translates to:
  /// **'Өчүрүү'**
  String get contacts_delete;

  /// No description provided for @contacts_delete_title.
  ///
  /// In ky, this message translates to:
  /// **'Байланышты өчүрүү'**
  String get contacts_delete_title;

  /// No description provided for @contacts_delete_message.
  ///
  /// In ky, this message translates to:
  /// **'{name} тизмеден өчүрүлсүнбү?'**
  String contacts_delete_message(String name);

  /// No description provided for @contacts_deleted.
  ///
  /// In ky, this message translates to:
  /// **'Байланыш өчүрүлдү'**
  String get contacts_deleted;

  /// No description provided for @contacts_saved.
  ///
  /// In ky, this message translates to:
  /// **'Байланыш сакталды'**
  String get contacts_saved;

  /// No description provided for @contacts_actions.
  ///
  /// In ky, this message translates to:
  /// **'Аракеттер'**
  String get contacts_actions;

  /// No description provided for @contacts_empty_message.
  ///
  /// In ky, this message translates to:
  /// **'Ишенимдүү байланыштар жок. Коркунуч учурунда сигнал жетчү жакындарыңызды кошуңуз'**
  String get contacts_empty_message;

  /// No description provided for @contacts_name_label.
  ///
  /// In ky, this message translates to:
  /// **'Аты'**
  String get contacts_name_label;

  /// No description provided for @contacts_phone_label.
  ///
  /// In ky, this message translates to:
  /// **'Телефон номери'**
  String get contacts_phone_label;

  /// No description provided for @contacts_phone_hint.
  ///
  /// In ky, this message translates to:
  /// **'+996 700 123 456'**
  String get contacts_phone_hint;

  /// No description provided for @contacts_name_required.
  ///
  /// In ky, this message translates to:
  /// **'Атын киргизиңиз'**
  String get contacts_name_required;

  /// No description provided for @contacts_phone_required.
  ///
  /// In ky, this message translates to:
  /// **'Телефон номерин киргизиңиз'**
  String get contacts_phone_required;

  /// No description provided for @contacts_phone_invalid.
  ///
  /// In ky, this message translates to:
  /// **'Телефон номери туура эмес'**
  String get contacts_phone_invalid;

  /// No description provided for @contacts_save.
  ///
  /// In ky, this message translates to:
  /// **'Сактоо'**
  String get contacts_save;

  /// No description provided for @contacts_duplicate_phone.
  ///
  /// In ky, this message translates to:
  /// **'Бул номер тизмеде бар'**
  String get contacts_duplicate_phone;

  /// No description provided for @contacts_invalid.
  ///
  /// In ky, this message translates to:
  /// **'Киргизилген маалымат туура эмес'**
  String get contacts_invalid;

  /// No description provided for @contacts_pick_from_device.
  ///
  /// In ky, this message translates to:
  /// **'Телефон байланыштарынан тандоо'**
  String get contacts_pick_from_device;

  /// No description provided for @contacts_pick_number_title.
  ///
  /// In ky, this message translates to:
  /// **'Номерди тандаңыз'**
  String get contacts_pick_number_title;

  /// No description provided for @contacts_permission_denied.
  ///
  /// In ky, this message translates to:
  /// **'Байланыштарга уруксат жок. Аны жөндөөлөрдөн бериңиз'**
  String get contacts_permission_denied;

  /// No description provided for @contacts_pick_failed.
  ///
  /// In ky, this message translates to:
  /// **'Байланыштарды ачуу мүмкүн болбоду'**
  String get contacts_pick_failed;

  /// No description provided for @message_template_title.
  ///
  /// In ky, this message translates to:
  /// **'SOS билдирүүсү'**
  String get message_template_title;

  /// No description provided for @message_template_subtitle.
  ///
  /// In ky, this message translates to:
  /// **'Коркунуч учурунда жөнөтүлүүчү билдирүүнүн текстин ырастаңыз.'**
  String get message_template_subtitle;

  /// No description provided for @message_template_message_label.
  ///
  /// In ky, this message translates to:
  /// **'Билдирүүнүн тексти'**
  String get message_template_message_label;

  /// No description provided for @message_template_geo_label.
  ///
  /// In ky, this message translates to:
  /// **'Геолокация кол тамгасы'**
  String get message_template_geo_label;

  /// No description provided for @message_template_geo_hint.
  ///
  /// In ky, this message translates to:
  /// **'{token} белгисинин ордуна учурдагы координаттар коюлат'**
  String message_template_geo_hint(String token);

  /// No description provided for @message_template_save.
  ///
  /// In ky, this message translates to:
  /// **'Сактоо'**
  String get message_template_save;

  /// No description provided for @message_template_saved.
  ///
  /// In ky, this message translates to:
  /// **'Билдирүү сакталды'**
  String get message_template_saved;

  /// No description provided for @message_template_invalid.
  ///
  /// In ky, this message translates to:
  /// **'Текст уруксат берилген узундуктан ашып кетти'**
  String get message_template_invalid;

  /// No description provided for @message_template_required.
  ///
  /// In ky, this message translates to:
  /// **'Билдирүүнүн текстин киргизиңиз'**
  String get message_template_required;

  /// No description provided for @message_template_preview_label.
  ///
  /// In ky, this message translates to:
  /// **'Жөнөтүлүүчү билдирүү'**
  String get message_template_preview_label;

  /// No description provided for @message_template_intro.
  ///
  /// In ky, this message translates to:
  /// **'Тревога күйгүзүлгөндө бул билдирүү координаттарыңыз менен ишенимдүү байланыштарыңызга автоматтык түрдө жөнөтүлөт.'**
  String get message_template_intro;

  /// No description provided for @message_template_message_hint.
  ///
  /// In ky, this message translates to:
  /// **'Мисалы: Мага жардам керек, мен коркунучтамын'**
  String get message_template_message_hint;

  /// No description provided for @message_template_geo_insert.
  ///
  /// In ky, this message translates to:
  /// **'Координат белгисин коюу'**
  String get message_template_geo_insert;

  /// No description provided for @message_template_geo_added.
  ///
  /// In ky, this message translates to:
  /// **'Координат белгиси кошулду'**
  String get message_template_geo_added;

  /// No description provided for @message_template_preview_hint.
  ///
  /// In ky, this message translates to:
  /// **'Координаттар мисал катары көрсөтүлгөн — тревога учурунда чыныгы жайгашкан жериңиз коюлат.'**
  String get message_template_preview_hint;

  /// No description provided for @message_template_location_title.
  ///
  /// In ky, this message translates to:
  /// **'Жайгашкан жеримди кошуу'**
  String get message_template_location_title;

  /// No description provided for @message_template_location_desc.
  ///
  /// In ky, this message translates to:
  /// **'Билдирүүгө турган жериңиздин координаттары кошулат'**
  String get message_template_location_desc;

  /// No description provided for @message_template_preview_empty.
  ///
  /// In ky, this message translates to:
  /// **'Текст жаза баштаңыз — бул жерде билдирүү пайда болот'**
  String get message_template_preview_empty;

  /// No description provided for @sos_history_title.
  ///
  /// In ky, this message translates to:
  /// **'Кайрылуулар тарыхы'**
  String get sos_history_title;

  /// No description provided for @sos_history_empty_message.
  ///
  /// In ky, this message translates to:
  /// **'Кайрылуулар жок. Бул жерде сиз жиберген SOS сигналдары чагылдырылат'**
  String get sos_history_empty_message;

  /// No description provided for @sos_history_no_location.
  ///
  /// In ky, this message translates to:
  /// **'Координаттар жеткиликсиз'**
  String get sos_history_no_location;

  /// No description provided for @sos_history_no_date.
  ///
  /// In ky, this message translates to:
  /// **'Күнү белгисиз'**
  String get sos_history_no_date;

  /// No description provided for @sos_history_detail_title.
  ///
  /// In ky, this message translates to:
  /// **'Кайрылуу тууралуу'**
  String get sos_history_detail_title;

  /// No description provided for @sos_history_id_label.
  ///
  /// In ky, this message translates to:
  /// **'Кайрылуунун номери'**
  String get sos_history_id_label;

  /// No description provided for @sos_history_date_label.
  ///
  /// In ky, this message translates to:
  /// **'Күнү жана убактысы'**
  String get sos_history_date_label;

  /// No description provided for @sos_history_location_label.
  ///
  /// In ky, this message translates to:
  /// **'Координаттар'**
  String get sos_history_location_label;

  /// No description provided for @sos_history_copy_location.
  ///
  /// In ky, this message translates to:
  /// **'Координаттарды көчүрүү'**
  String get sos_history_copy_location;

  /// No description provided for @sos_history_open_map.
  ///
  /// In ky, this message translates to:
  /// **'Картадан ачуу'**
  String get sos_history_open_map;

  /// No description provided for @sos_history_location_copied.
  ///
  /// In ky, this message translates to:
  /// **'Координаттар көчүрүлдү'**
  String get sos_history_location_copied;

  /// No description provided for @info_title.
  ///
  /// In ky, this message translates to:
  /// **'Маалымат'**
  String get info_title;

  /// No description provided for @info_crisis_centers.
  ///
  /// In ky, this message translates to:
  /// **'Кризистик борборлор'**
  String get info_crisis_centers;

  /// No description provided for @info_psychological_help.
  ///
  /// In ky, this message translates to:
  /// **'Психологиялык жардам'**
  String get info_psychological_help;

  /// No description provided for @info_emergency_instructions.
  ///
  /// In ky, this message translates to:
  /// **'Шашылыш нускамалар'**
  String get info_emergency_instructions;

  /// No description provided for @info_privacy_policy.
  ///
  /// In ky, this message translates to:
  /// **'Купуялык саясаты'**
  String get info_privacy_policy;

  /// No description provided for @info_crisis_centers_subtitle.
  ///
  /// In ky, this message translates to:
  /// **'Дарек жана байланыштар'**
  String get info_crisis_centers_subtitle;

  /// No description provided for @info_psychological_help_subtitle.
  ///
  /// In ky, this message translates to:
  /// **'Колдоо кызматтары'**
  String get info_psychological_help_subtitle;

  /// No description provided for @info_emergency_instructions_subtitle.
  ///
  /// In ky, this message translates to:
  /// **'Коркунуч учурунда эмне кылуу керек'**
  String get info_emergency_instructions_subtitle;

  /// No description provided for @info_privacy_policy_subtitle.
  ///
  /// In ky, this message translates to:
  /// **'Маалыматтарды иштетүү шарттары'**
  String get info_privacy_policy_subtitle;

  /// No description provided for @info_empty_message.
  ///
  /// In ky, this message translates to:
  /// **'Бул бөлүмдө азырынча материалдар жок'**
  String get info_empty_message;

  /// No description provided for @info_offline_notice.
  ///
  /// In ky, this message translates to:
  /// **'Тармак жок. Негизги шашылыш номерлер көрсөтүлдү.'**
  String get info_offline_notice;

  /// No description provided for @emergency_call.
  ///
  /// In ky, this message translates to:
  /// **'Чалуу'**
  String get emergency_call;

  /// No description provided for @emergency_service_112.
  ///
  /// In ky, this message translates to:
  /// **'Куткаруу кызматы (бирдиктүү)'**
  String get emergency_service_112;

  /// No description provided for @emergency_service_police.
  ///
  /// In ky, this message translates to:
  /// **'Милиция'**
  String get emergency_service_police;

  /// No description provided for @emergency_service_ambulance.
  ///
  /// In ky, this message translates to:
  /// **'Тез жардам'**
  String get emergency_service_ambulance;

  /// No description provided for @emergency_service_fire.
  ///
  /// In ky, this message translates to:
  /// **'Өрт өчүрүү кызматы'**
  String get emergency_service_fire;

  /// No description provided for @emergency_service_gas.
  ///
  /// In ky, this message translates to:
  /// **'Газдын авариялык кызматы'**
  String get emergency_service_gas;

  /// No description provided for @error_call_failed.
  ///
  /// In ky, this message translates to:
  /// **'Чалууну аткаруу мүмкүн болбоду'**
  String get error_call_failed;

  /// No description provided for @profile_title.
  ///
  /// In ky, this message translates to:
  /// **'Профиль'**
  String get profile_title;

  /// No description provided for @profile_edit.
  ///
  /// In ky, this message translates to:
  /// **'Профилди өзгөртүү'**
  String get profile_edit;

  /// No description provided for @profile_edit_title.
  ///
  /// In ky, this message translates to:
  /// **'Профилди өзгөртүү'**
  String get profile_edit_title;

  /// No description provided for @profile_name_label.
  ///
  /// In ky, this message translates to:
  /// **'Аты'**
  String get profile_name_label;

  /// No description provided for @profile_surname_label.
  ///
  /// In ky, this message translates to:
  /// **'Фамилиясы'**
  String get profile_surname_label;

  /// No description provided for @profile_phone_label.
  ///
  /// In ky, this message translates to:
  /// **'Телефон номери'**
  String get profile_phone_label;

  /// No description provided for @profile_address_label.
  ///
  /// In ky, this message translates to:
  /// **'Дареги'**
  String get profile_address_label;

  /// No description provided for @profile_save.
  ///
  /// In ky, this message translates to:
  /// **'Сактоо'**
  String get profile_save;

  /// No description provided for @profile_saved.
  ///
  /// In ky, this message translates to:
  /// **'Профиль жаңыртылды'**
  String get profile_saved;

  /// No description provided for @profile_name_required.
  ///
  /// In ky, this message translates to:
  /// **'Атын киргизиңиз'**
  String get profile_name_required;

  /// No description provided for @profile_invalid.
  ///
  /// In ky, this message translates to:
  /// **'Киргизилген маалымат туура эмес'**
  String get profile_invalid;

  /// No description provided for @profile_section_account.
  ///
  /// In ky, this message translates to:
  /// **'Аккаунт'**
  String get profile_section_account;

  /// No description provided for @profile_section_settings.
  ///
  /// In ky, this message translates to:
  /// **'Жөндөөлөр'**
  String get profile_section_settings;

  /// No description provided for @profile_language.
  ///
  /// In ky, this message translates to:
  /// **'Тил'**
  String get profile_language;

  /// No description provided for @profile_theme.
  ///
  /// In ky, this message translates to:
  /// **'Көрүнүш'**
  String get profile_theme;

  /// No description provided for @theme_light.
  ///
  /// In ky, this message translates to:
  /// **'Ачык'**
  String get theme_light;

  /// No description provided for @theme_dark.
  ///
  /// In ky, this message translates to:
  /// **'Караңгы'**
  String get theme_dark;

  /// No description provided for @theme_system.
  ///
  /// In ky, this message translates to:
  /// **'Системалык'**
  String get theme_system;

  /// No description provided for @profile_logout.
  ///
  /// In ky, this message translates to:
  /// **'Чыгуу'**
  String get profile_logout;

  /// No description provided for @profile_logout_title.
  ///
  /// In ky, this message translates to:
  /// **'Аккаунттан чыгуу'**
  String get profile_logout_title;

  /// No description provided for @profile_logout_message.
  ///
  /// In ky, this message translates to:
  /// **'Чыккандан кийин SOS баскычы жана ишенимдүү байланыштар жеткиликсиз болот. Кайра кирүү үчүн жеке шилтеме менен PIN керек болот.'**
  String get profile_logout_message;

  /// No description provided for @language_kyrgyz.
  ///
  /// In ky, this message translates to:
  /// **'Кыргызча'**
  String get language_kyrgyz;

  /// No description provided for @language_russian.
  ///
  /// In ky, this message translates to:
  /// **'Орусча'**
  String get language_russian;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ky', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
