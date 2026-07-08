// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'KAMKOR';

  @override
  String get cancel => 'Отмена';

  @override
  String get retry => 'Повторить';

  @override
  String get error_network => 'Нет подключения к сети. Проверьте соединение';

  @override
  String get error_timeout => 'Сервер не отвечает. Попробуйте ещё раз';

  @override
  String get error_server => 'Ошибка сервера. Попробуйте позже';

  @override
  String get error_unknown => 'Произошла неизвестная ошибка';

  @override
  String get error_unauthorized => 'Требуется авторизация';

  @override
  String get login_title => 'Вход';

  @override
  String get login_subtitle =>
      'Используйте персональную ссылку или QR-код для входа';

  @override
  String get login_scan_hint => 'Наведите камеру на QR-код';

  @override
  String get login_camera_denied => 'Нет доступа к камере';

  @override
  String get login_or_paste => 'или введите ссылку';

  @override
  String get login_link_label => 'Персональная ссылка';

  @override
  String get login_link_hint => 'https://kamkor.mvd.kg/pwa/?access=…';

  @override
  String get login_link_origin =>
      'Персональную ссылку или QR-код выдаёт сотрудник, принявший ваше обращение.';

  @override
  String get login_continue => 'Продолжить';

  @override
  String get login_link_required => 'Введите ссылку';

  @override
  String get login_link_invalid => 'Ссылка недействительна или устарела';

  @override
  String get login_link_valid => 'Ссылка подтверждена';

  @override
  String get login_camera_primer =>
      'Разрешите доступ к камере, чтобы отсканировать QR-код.';

  @override
  String get login_camera_primer_action => 'Включить камеру';

  @override
  String get login_camera_error => 'Не удалось запустить камеру';

  @override
  String get login_camera_denied_hint =>
      'Доступ к камере запрещён. Откройте настройки, чтобы разрешить сканирование';

  @override
  String get open_settings => 'Открыть настройки';

  @override
  String get login_submit => 'Войти';

  @override
  String get login_back => 'Назад';

  @override
  String get checking_session => 'Проверка сессии…';

  @override
  String get enter_pin => 'Введите свой ПИН';

  @override
  String get pin_invalid => 'Неверный PIN-код. Попробуйте ещё раз';

  @override
  String get sos_button => 'SOS';

  @override
  String get sos_active => 'SOS активен';

  @override
  String get sos_sending => 'Отправка сигнала…';

  @override
  String get sos_idle_title => 'Вызовите помощь в случае опасности';

  @override
  String get sos_hold_hint =>
      'Удерживайте кнопку 3 секунды, чтобы вызвать помощь';

  @override
  String get sos_countdown_hint => 'Нажмите «Отмена», если помощь не нужна';

  @override
  String get sos_countdown_cancel => 'Отмена';

  @override
  String get sos_activating => 'Вызываем помощь…';

  @override
  String get sos_activating_retry => 'Сигнал отправляется, продолжаем попытки…';

  @override
  String get sos_activating_struggling =>
      'Не удаётся отправить сигнал. Проверьте связь — мы продолжаем попытки';

  @override
  String get sos_active_title => 'Помощь вызвана';

  @override
  String get sos_active_subtitle =>
      'Оставайтесь на связи. Мы передаём ваши данные.';

  @override
  String get sos_coords_transmitting => 'Координаты передаются';

  @override
  String sos_last_sent(String time) {
    return 'Последняя передача: $time';
  }

  @override
  String get sos_awaiting_signal => 'Ожидание сигнала…';

  @override
  String get sos_reconnecting => 'Переподключение…';

  @override
  String get sos_closed_title => 'Обращение завершено';

  @override
  String get sos_closed_done => 'Оператор завершил ваше обращение';

  @override
  String get sos_closed_cancelled => 'Обращение отменено';

  @override
  String get sos_closed_subtitle => 'Обращение завершено оператором';

  @override
  String get sos_closed_action => 'Готово';

  @override
  String get sos_permission_title => 'Нужен доступ к геолокации';

  @override
  String get sos_permission_denied =>
      'Чтобы вызвать помощь, разрешите доступ к геолокации';

  @override
  String get sos_permission_denied_forever =>
      'Доступ к геолокации запрещён. Откройте настройки и разрешите его';

  @override
  String get sos_service_disabled_title => 'Геолокация выключена';

  @override
  String get sos_service_disabled =>
      'Включите службу геолокации, чтобы мы могли передать ваше местоположение';

  @override
  String get sos_open_settings => 'Открыть настройки';

  @override
  String get sos_enable_location => 'Включить геолокацию';

  @override
  String get sos_allow => 'Разрешить';

  @override
  String get error_location_unavailable =>
      'Не удалось определить местоположение';

  @override
  String get sos_readiness_contacts_ready => 'Доверенные контакты настроены';

  @override
  String get sos_readiness_contacts_empty => 'Добавьте доверенные контакты';

  @override
  String get sos_active_badge => 'Тревога активна';

  @override
  String get nav_contacts => 'Контакты';

  @override
  String get nav_message => 'Сообщение';

  @override
  String get nav_history => 'История';

  @override
  String get nav_sos_open => 'Открыть SOS';

  @override
  String get contacts_title => 'Доверенные контакты';

  @override
  String get contacts_add => 'Добавить контакт';

  @override
  String get contacts_add_title => 'Добавить контакт';

  @override
  String get contacts_edit_title => 'Изменить контакт';

  @override
  String get contacts_edit => 'Изменить';

  @override
  String get contacts_delete => 'Удалить';

  @override
  String get contacts_delete_title => 'Удалить контакт';

  @override
  String contacts_delete_message(String name) {
    return 'Удалить $name из списка?';
  }

  @override
  String get contacts_deleted => 'Контакт удалён';

  @override
  String get contacts_saved => 'Контакт сохранён';

  @override
  String get contacts_actions => 'Действия';

  @override
  String get contacts_empty_message =>
      'Нет доверенных контактов. Добавьте близких, которым уйдёт сигнал при тревоге';

  @override
  String get contacts_name_label => 'Имя';

  @override
  String get contacts_phone_label => 'Номер телефона';

  @override
  String get contacts_phone_hint => '+996 700 123 456';

  @override
  String get contacts_name_required => 'Введите имя';

  @override
  String get contacts_phone_required => 'Введите номер телефона';

  @override
  String get contacts_phone_invalid => 'Некорректный номер телефона';

  @override
  String get contacts_save => 'Сохранить';

  @override
  String get contacts_duplicate_phone => 'Этот номер уже есть в списке';

  @override
  String get contacts_invalid => 'Введены некорректные данные';

  @override
  String get contacts_pick_from_device => 'Выбрать из контактов телефона';

  @override
  String get contacts_pick_number_title => 'Выберите номер';

  @override
  String get contacts_permission_denied =>
      'Нет доступа к контактам. Разрешите его в настройках';

  @override
  String get contacts_pick_failed => 'Не удалось открыть контакты';

  @override
  String get message_template_title => 'SOS-сообщение';

  @override
  String get message_template_subtitle =>
      'Задайте текст сообщения, которое уйдёт при тревоге.';

  @override
  String get message_template_message_label => 'Текст сообщения';

  @override
  String get message_template_geo_label => 'Подпись с геолокацией';

  @override
  String message_template_geo_hint(String token) {
    return 'На месте $token будут подставлены координаты';
  }

  @override
  String get message_template_save => 'Сохранить';

  @override
  String get message_template_saved => 'Сообщение сохранено';

  @override
  String get message_template_invalid => 'Текст превышает допустимую длину';

  @override
  String get message_template_required => 'Введите текст сообщения';

  @override
  String get message_template_preview_label => 'Итоговое сообщение';

  @override
  String get message_template_intro =>
      'Когда вы включите тревогу, это сообщение вместе с вашими координатами автоматически уйдёт доверенным контактам.';

  @override
  String get message_template_message_hint =>
      'Например: Мне нужна помощь, я в опасности';

  @override
  String get message_template_geo_insert => 'Вставить метку координат';

  @override
  String get message_template_geo_added => 'Метка координат добавлена';

  @override
  String get message_template_preview_hint =>
      'Координаты показаны для примера — при тревоге подставятся ваши настоящие.';

  @override
  String get message_template_location_title => 'Добавлять моё местоположение';

  @override
  String get message_template_location_desc =>
      'К сообщению добавятся координаты места, где вы находитесь';

  @override
  String get message_template_preview_empty =>
      'Начните вводить текст — здесь появится сообщение';

  @override
  String get sos_history_title => 'История обращений';

  @override
  String get sos_history_empty_message =>
      'Обращений пока нет. Здесь появятся отправленные вами SOS-сигналы';

  @override
  String get sos_history_no_location => 'Координаты недоступны';

  @override
  String get sos_history_no_date => 'Дата неизвестна';

  @override
  String get sos_history_detail_title => 'Об обращении';

  @override
  String get sos_history_id_label => 'Номер обращения';

  @override
  String get sos_history_date_label => 'Дата и время';

  @override
  String get sos_history_location_label => 'Координаты';

  @override
  String get sos_history_copy_location => 'Скопировать координаты';

  @override
  String get sos_history_open_map => 'Открыть на карте';

  @override
  String get sos_history_location_copied => 'Координаты скопированы';

  @override
  String get info_title => 'Справочная информация';

  @override
  String get info_crisis_centers => 'Кризисные центры';

  @override
  String get info_psychological_help => 'Психологическая помощь';

  @override
  String get info_emergency_instructions => 'Экстренные инструкции';

  @override
  String get info_privacy_policy => 'Политика конфиденциальности';

  @override
  String get info_crisis_centers_subtitle => 'Адреса и контакты';

  @override
  String get info_psychological_help_subtitle => 'Службы поддержки';

  @override
  String get info_emergency_instructions_subtitle =>
      'Что делать в опасной ситуации';

  @override
  String get info_privacy_policy_subtitle => 'Условия обработки данных';

  @override
  String get info_empty_message => 'В этом разделе пока нет материалов';

  @override
  String get info_offline_notice =>
      'Нет сети. Показаны основные экстренные номера.';

  @override
  String get emergency_call => 'Позвонить';

  @override
  String get emergency_service_112 => 'Единая служба спасения';

  @override
  String get emergency_service_police => 'Милиция';

  @override
  String get emergency_service_ambulance => 'Скорая помощь';

  @override
  String get emergency_service_fire => 'Пожарная служба';

  @override
  String get emergency_service_gas => 'Аварийная газовая служба';

  @override
  String get error_call_failed => 'Не удалось совершить звонок';

  @override
  String get profile_title => 'Профиль';

  @override
  String get profile_edit => 'Редактировать профиль';

  @override
  String get profile_edit_title => 'Редактирование профиля';

  @override
  String get profile_name_label => 'Имя';

  @override
  String get profile_surname_label => 'Фамилия';

  @override
  String get profile_phone_label => 'Номер телефона';

  @override
  String get profile_address_label => 'Адрес';

  @override
  String get profile_save => 'Сохранить';

  @override
  String get profile_saved => 'Профиль обновлён';

  @override
  String get profile_name_required => 'Введите имя';

  @override
  String get profile_invalid => 'Введены некорректные данные';

  @override
  String get profile_section_account => 'Аккаунт';

  @override
  String get profile_section_settings => 'Настройки';

  @override
  String get profile_language => 'Язык';

  @override
  String get profile_theme => 'Оформление';

  @override
  String get theme_light => 'Светлая';

  @override
  String get theme_dark => 'Тёмная';

  @override
  String get theme_system => 'Системная';

  @override
  String get profile_logout => 'Выйти';

  @override
  String get profile_logout_title => 'Выход из аккаунта';

  @override
  String get profile_logout_message =>
      'После выхода кнопка SOS и доверенные контакты станут недоступны. Для повторного входа понадобятся персональная ссылка и PIN-код.';

  @override
  String get language_kyrgyz => 'Кыргызча';

  @override
  String get language_russian => 'Русский';
}
