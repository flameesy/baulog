// Define all the strings to be used in application in this file
// To use - import this file and call required string by:
//```dart
//      Strings.<name>
//```

class Strings {
  Strings._();

  // splash screen
  static const SPLASH_TEXT = 'Created with flutter-boilerplate';

  // intro screen
  static const INTRO_TITLE = 'BauLog';
  static const INTRO_LIST_TITLE = 'A new way of construction site management!';
  static const INTRO_LIST = [
    'Create an account',
    'Get to know the app',
    'Find more infos in the help center'
  ];

  static const noInternetAlert = 'No internet availble. Please check your connection';
  static const FORMAT_ALERT = 'Format exception happen. Please check';
  static const HTTP_ALERT = 'No service available. Please try again later';
  static const GET_STARTED = 'Get Started';

  // it will return the dynamic string
  static String demo(amount) {
    return 'Total amount: $amount';
  }

  static String yourCategoryGenerates(String category) {
    return 'Your $category typically generates';
  }

  static const DATABASE_INIT = '''
  CREATE TABLE IF NOT EXISTS APPOINTMENT (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    text TEXT NOT NULL,
    description TEXT,
    location TEXT,
    participant_ids TEXT,
    reminder_time DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    platform_id INTEGER,
    room_id INTEGER,
    building_id INTEGER,
    level_id INTEGER,
    DONE INTEGER DEFAULT 0,
    sync_status INTEGER DEFAULT 0, 
    attachment_id TEXT,
    UNIQUE (building_id, level_id, room_id),
    FOREIGN KEY (platform_id) REFERENCES PLATFORM(id),
    FOREIGN KEY (room_id) REFERENCES ROOM(id),
    FOREIGN KEY (building_id) REFERENCES BUILDING(id),
    FOREIGN KEY (level_id) REFERENCES LEVEL(id)
  );

  CREATE TABLE IF NOT EXISTS USERS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    sync_status INTEGER DEFAULT 0 
  );

  CREATE TABLE IF NOT EXISTS LOG (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    action TEXT NOT NULL,
    table_name TEXT NOT NULL,
    record_id INTEGER,
    old_data TEXT,
    new_data TEXT,
    sync_status INTEGER DEFAULT 0 
  );

  CREATE TABLE IF NOT EXISTS SYNC_QUEUE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    record_id INTEGER NOT NULL,
    action TEXT NOT NULL,
    sync_status INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP 
  );

  CREATE TABLE IF NOT EXISTS SYNC_HISTORY (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    record_id INTEGER NOT NULL,
    action TEXT NOT NULL,
    sync_status INTEGER DEFAULT 0,
    response_code INTEGER,
    response_message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  );

  CREATE TABLE IF NOT EXISTS BUILDING (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    level_count INTEGER,
    sync_status INTEGER DEFAULT 0 
  );

  CREATE TABLE IF NOT EXISTS LEVEL (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    building_id INTEGER NOT NULL,
    room_count INTEGER,
    sync_status INTEGER DEFAULT 0,
    attachment_id TEXT,
    description TEXT, 
    FOREIGN KEY (building_id) REFERENCES BUILDING(id) ON DELETE CASCADE
  );

  CREATE TABLE IF NOT EXISTS ROOM (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    level_id INTEGER NOT NULL,
    access INTEGER NOT NULL,
    sync_status INTEGER DEFAULT 0, 
    description TEXT,
    attachment_id TEXT,
    FOREIGN KEY (level_id) REFERENCES LEVEL(id) ON DELETE CASCADE
  );

  CREATE TABLE IF NOT EXISTS PLATFORM (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    building_id INTEGER NOT NULL,
    sync_status INTEGER DEFAULT 0, 
    FOREIGN KEY (building_id) REFERENCES BUILDING(id) ON DELETE CASCADE
  );

  CREATE TABLE IF NOT EXISTS ADDRESS (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT,
    second_email TEXT,
    phone_number TEXT,
    landline TEXT,
    position TEXT,
    street TEXT,
    city TEXT,
    postal_code TEXT,
    country TEXT,
    sync_status INTEGER DEFAULT 0 
  );

  CREATE TABLE IF NOT EXISTS EMAIL_TEMPLATE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    subject TEXT NOT NULL,
    body TEXT NOT NULL,
    global INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    sync_status INTEGER DEFAULT 0 
  );

  CREATE TABLE IF NOT EXISTS EMAIL_CATEGORY (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    sync_status INTEGER DEFAULT 0 
  );

  CREATE TABLE IF NOT EXISTS EMAIL (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    recipient TEXT NOT NULL,
    cc TEXT,
    bcc TEXT,
    subject TEXT NOT NULL,
    body TEXT NOT NULL,
    template_id VARCHAR(30),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    sync_status INTEGER DEFAULT 0, 
    FOREIGN KEY (template_id) REFERENCES EMAIL_TEMPLATE(id)
  );

  CREATE TABLE IF NOT EXISTS EMAIL_VARIABLE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    source_table TEXT NOT NULL,
    source_field TEXT NOT NULL,
    default_value TEXT,
    data_type TEXT,
    required INTEGER DEFAULT 0,
    format TEXT
  );

  CREATE TABLE IF NOT EXISTS ATTACHMENT (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER,
    room_id INTEGER,
    email_id INTEGER,
    name TEXT,
    file_path TEXT NOT NULL,
    file_type TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES APPOINTMENT(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES ROOM(id) ON DELETE CASCADE,
    FOREIGN KEY (email_id) REFERENCES EMAIL(id) ON DELETE CASCADE
  );
''';
}