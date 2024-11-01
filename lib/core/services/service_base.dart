import 'dart:convert';
import 'dart:io';

import 'package:bcrypt/bcrypt.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_http.dart';
import '../../resources/strings.dart';
import 'package:path_provider/path_provider.dart';

class ServiceBase {
  static Database? _database;

  ServiceBase();

  static Future<Database> initializeDatabase() async {
    if (_database != null) return _database!;

    final String dbPath = join(await getDatabasesPath(), 'baulog.db');

    // Überprüfen, ob die Datenbank bereits existiert
    var dbExists = await databaseExists(dbPath);

    if (!dbExists) {
      // Wenn die Datenbank nicht existiert, erstelle sie
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "baulog.db");
      // Datenbank neu erstellen
      ByteData data = await rootBundle.load(join('assets', 'baulog.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);

      _database = await openDatabase(path);
      /*_database = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(Strings.DATABASE_INIT.toString());
          // Hier rufen wir _createTablesIfNotExists auf, um sicherzustellen, dass alle Tabellen erstellt werden
          await _createTablesIfNotExists(db);
          await insertExamples(db);
        },
      );
      */
    } else {
      // Wenn die Datenbank bereits existiert, öffne sie
      _database = await openDatabase(
        dbPath,
        version: 1,
        onOpen: (db) async {
          await _createTablesIfNotExists(db); // Überprüfe, ob Tabellen existieren, und erstelle sie bei Bedarf
          await printEmailTemplates(db); // Überprüfe, ob Tabellen existieren, und erstelle sie bei Bedarf
        },
      );
    }

    return _database!; // Rückgabe des Datenbankobjekts
  }

  static Future<void> printEmailTemplates(Database db) async {
    try {
      final List<Map<String, dynamic>> emailTemplates = await await db.query(
          'users',
      );
      for (var template in emailTemplates) {
        print(template); // Gibt jeden Datensatz in der Liste aus
      }
    } catch (error) {
      print('Error fetching email templates: $error');
    }
  }

  // Hilfsfunktion zum Überprüfen, ob die Datenbank existiert
  static Future<bool> databaseExists(String path) async {
    final file = File(path);
    return file.exists();
  }

  // Funktion zum Erstellen der Tabellen, wenn sie nicht existieren
  static Future<void> _createTablesIfNotExists(Database db) async {
    // Hier führen wir die SQL-Befehle zum Erstellen von Tabellen aus
    await db.execute(Strings.DATABASE_INIT.toString());
  }


  Future<Database> get database async {
    return await initializeDatabase();
  }

  static Future<void> insertExamples(Database db) async {

    await db.execute('''
      INSERT INTO APPOINTMENT (id, appointment_date, start_time, end_time, text, description, location, participant_ids, reminder_time, platform_id, room_id, building_id, level_id)
      VALUES
      (1, '2024-04-05', '08:00:00', '09:00:00', 'Team Meeting', 'Diskutiere Projektupdates', 'Konferenzraum 1', '1,2,3', '2024-04-12 09:00:00', 1, 1, 1, 1),
      (2, '2024-04-06', '10:00:00', '11:00:00', 'Kundenbesprechung', 'Überprüfung der Projektanforderungen', 'Konferenzraum 2', '4,5,6', '2024-04-12 09:00:00', 1, 2, 1, 1),
      (3, '2024-04-07', '14:00:00', '15:00:00', 'Schulungssitzung', 'Schulung für neue Software', 'Schulungsraum', '7,8,9', '2024-04-12 09:00:00', 2, 3, 2, 1),
      (4, '2024-04-08', '09:00:00', '10:00:00', 'Team Brainstorming', 'Ideenfindung für das kommende Projekt', 'Kreativraum', '10,11,12', '2024-04-12 09:00:00', 3, 4, 2, 2),
      (5, '2024-04-09', '11:00:00', '12:00:00', 'Vertriebsbesprechung', 'Diskutiere Vertriebsstrategie', 'Vertriebsbüro', '13,14,15', '2024-04-12 09:00:00', 3, 5, 2, 2),
      (6, '2024-04-10', '15:00:00', '16:00:00', 'Vorstellungsgespräch', 'Bewerbungsgespräch', 'HR Büro', '16', '2024-04-09 16:00:00', 4, 6, 3, 2),
      (7, '2024-04-11', '16:00:00', '17:00:00', 'Produktdemo', 'Demo für potenzielle Kunden', 'Demo Raum', '17,18,19', '2024-04-10 16:00:00', 4, 7, 3, 3),
      (8, '2024-04-12', '13:00:00', '14:00:00', 'Projektüberprüfung', 'Überprüfung des aktuellen Projektstatus', 'Projektraum', '20,21,22', '2024-04-11 16:00:00', 5, 8, 4, 3),
      (9, '2024-04-13', '10:00:00', '11:00:00', 'Teambildung', 'Teambildungsaktivitäten', 'Erholungsraum', '23,24,25', '2024-04-12 16:00:00', 5, 9, 4, 3),
      (10, '2024-04-14', '11:00:00', '12:00:00', 'Kundenmittagessen', 'Lockeres Mittagessen mit Kunden', 'Cafeteria', '26,27,28', '2024-04-13 16:00:00', 6, 10, 5, 4);
    ''');

    await db.execute('''
      INSERT INTO USERS (email, password, sync_status)
      VALUES
      ('oli', 'pw123', 0),
      ('l', 'l', 0),
      ('demo', 'passwort123', 0);
    ''');

    await db.execute('''
      INSERT INTO LOG (action, table_name, record_id, old_data, new_data, sync_status)
      VALUES
      ('INSERT', 'APPOINTMENT', 1, NULL, 'Neue Terminvereinbarung erstellt', 0),
      ('UPDATE', 'APPOINTMENT', 2, 'Besprechung verschoben', 'Neue Besprechungszeit festgelegt', 0),
      ('DELETE', 'APPOINTMENT', 3, 'Abgesagter Termin', NULL, 0),
      ('INSERT', 'USERS', 1, NULL, 'Neuer Benutzer registriert', 0),
      ('UPDATE', 'USERS', 2, 'Passwortänderung', 'Passwort aktualisiert', 0),
      ('DELETE', 'USERS', 3, 'Inaktiver Benutzer gelöscht', NULL, 0),
      ('INSERT', 'BUILDING', 1, NULL, 'Neues Gebäude hinzugefügt', 0),
      ('UPDATE', 'BUILDING', 2, 'Gebäudedetails aktualisieren', 'Gebäudebeschreibung geändert', 0),
      ('DELETE', 'BUILDING', 3, 'Altes Gebäude abgerissen', NULL, 0),
      ('INSERT', 'LEVEL', 1, NULL, 'Neues Level erstellt', 0);
    ''');

    await db.execute('''
      INSERT INTO SYNC_HISTORY (table_name, record_id, action, sync_status, response_code, response_message)
      VALUES
      ('APPOINTMENT', 1, 'INSERT', 0, 200, 'Datensatz erfolgreich synchronisiert'),
      ('APPOINTMENT', 2, 'UPDATE', 0, 200, 'Datensatz erfolgreich aktualisiert'),
      ('APPOINTMENT', 3, 'DELETE', 0, 200, 'Datensatz erfolgreich gelöscht'),
      ('USERS', 1, 'INSERT', 0, 200, 'Datensatz erfolgreich synchronisiert'),
      ('USERS', 2, 'UPDATE', 0, 200, 'Datensatz erfolgreich aktualisiert'),
      ('USERS', 3, 'DELETE', 0, 200, 'Datensatz erfolgreich gelöscht'),
      ('BUILDING', 1, 'INSERT', 0, 200, 'Datensatz erfolgreich synchronisiert'),
      ('BUILDING', 2, 'UPDATE', 0, 200, 'Datensatz erfolgreich aktualisiert'),
      ('BUILDING', 3, 'DELETE', 0, 200, 'Datensatz erfolgreich gelöscht'),
      ('LEVEL', 1, 'INSERT', 0, 200, 'Datensatz erfolgreich synchronisiert');
    ''');

    await db.execute('''
      INSERT INTO BUILDING (name, description, level_count, sync_status)
      VALUES
      ('Bürogebäude A', 'Hauptsitz', 5, 0),
      ('Lagerhaus', 'Lageranlage', 3, 0),
      ('Einzelhandelsgeschäft', 'Verkaufsstelle', 1, 0),
      ('Technologiepark', 'Technologiezentrum', 8, 0),
      ('Krankenhaus', 'Medizinisches Zentrum', 6, 0),
      ('Hotel', 'Unterkunftseinrichtung', 10, 0),
      ('Schule', 'Bildungseinrichtung', 4, 0),
      ('Einkaufszentrum', 'Einkaufskomplex', 2, 0),
      ('Flughafen', 'Flughafenterminal', 7, 0),
      ('Stadion', 'Sportarena', 1, 0);
    ''');

    await db.execute('''
      INSERT INTO LEVEL (name, building_id, room_count, sync_status)
      VALUES
      ('Erdgeschoss', 1, 10, 0),
      ('Erster Stock', 1, 8, 0),
      ('Zweiter Stock', 1, 6, 0),
      ('Dritter Stock', 1, 6, 0),
      ('Vierter Stock', 1, 5, 0),
      ('Keller', 1, 4, 0),
      ('Hauptebene', 2, 15, 0),
      ('Obere Ebene', 2, 10, 0),
      ('Untere Ebene', 2, 7, 0),
      ('Lagerebene', 2, 5, 0);
    ''');

    await db.execute('''
      INSERT INTO ROOM (name, level_id, access, sync_status)
      VALUES
      ('Konferenzraum 1', 1, 1, 0),
      ('Konferenzraum 2', 1, 1, 0),
      ('Besprechungsraum A', 2, 1, 0),
      ('Besprechungsraum B', 2, 1, 0),
      ('Erholungsraum', 3, 0, 0),
      ('Schulungsraum', 4, 1, 0),
      ('Büro 101', 5, 1, 0),
      ('Büro 102', 5, 1, 0),
      ('Büro 103', 5, 1, 0),
      ('Cafeteria', 6, 0, 0);
    ''');

  }

  // CRUD Functions
  Future<List<Map<String, dynamic>>> getRecords({
    required String table,
    String? where,
    List<Object?>? whereArgs,
    String? fields = '*',
  }) async {
    final db = await database;
    return await db.query(
      table,
      columns: fields == '*' ? null : fields?.split(',').map((f) => f.trim()).toList(),
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> insertRecord({
    required String table,
    required String fields,
    required List<dynamic> values,
  }) async {
    final db = await database;
    final data = _createDataMap(fields, values);
    return await db.insert(table, data);
  }

  Future<int> updateRecord({
    required String table,
    required String fields,
    required List<dynamic> values,
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    final data = _createDataMap(fields, values);
    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> deleteRecord({
    required String table,
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<void> insertUser(String email, String password) async {
    final db = await database;
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    await db.insert('users', {
      'email': email,
      'password': hashedPassword,
    });
  }

  Future<bool> authenticateUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> user = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (user.isNotEmpty) {
      return BCrypt.checkpw(password, user.first['password']);
    }
    return false;
  }
  // API Methoden

  static String apiBaseUrl = ''; //production base url

  static Future<http.Response> get({
    String? url,
    String? baseUrl = '',
    required Map<String, String> headers,
  }) async {
    var netWorkStatus = await checkConnectionStatus();
    if (netWorkStatus) {
      String apiUrl = (baseUrl!.isEmpty ? apiBaseUrl : baseUrl) + url!;
      final response = await InterceptedHttp.build(interceptors: [])
          .get(Uri.parse(apiUrl), headers: headers);

      return response;
    }
    throw Strings.noInternetAlert;
  }

  static Future<http.Response> post({
    String? url,
    required Map data,
    String baseUrl = '',
    required Map<String, String> headers,
  }) async {
    var netWorkStatus = await checkConnectionStatus();
    if (netWorkStatus) {
      String apiUrl = apiBaseUrl + url!;
      final response = await InterceptedHttp.build(interceptors: [])
          .post(Uri.parse(apiUrl), body: jsonEncode(data), headers: headers);

      return response;
    }
    throw Strings.noInternetAlert;
  }

  static Future<http.Response> delete({
    String? url,
    required Map data,
    String baseUrl = '',
    required Map<String, String> headers,
  }) async {
    var netWorkStatus = await checkConnectionStatus();
    if (netWorkStatus) {
      String apiUrl = apiBaseUrl + url!;
      final response = await InterceptedHttp.build(interceptors: [])
          .delete(Uri.parse(apiUrl), body: jsonEncode(data), headers: headers);

      return response;
    }
    throw Strings.noInternetAlert;
  }

  static Future<http.Response> postWithoutParams({
    String? url,
    String baseUrl = '',
    required Map<String, String> headers,
  }) async {
    var netWorkStatus = await checkConnectionStatus();
    if (netWorkStatus) {
      String apiUrl = apiBaseUrl + url!;
      final response = await InterceptedHttp.build(interceptors: [])
          .post(Uri.parse(apiUrl), headers: headers);

      return response;
    }
    throw Strings.noInternetAlert;
  }

  static Future<http.Response> put({
    String? url,
    required Map data,
    String baseUrl = '',
    required Map<String, String> headers,
  }) async {
    var netWorkStatus = await checkConnectionStatus();
    if (netWorkStatus) {
      String apiUrl = apiBaseUrl + url!;
      final response = await InterceptedHttp.build(interceptors: [])
          .put(Uri.parse(apiUrl), body: jsonEncode(data), headers: headers);

      return response;
    }
    throw Strings.noInternetAlert;
  }

  static Future<http.Response> callMultipartRequest(
      String keyName, {
        required String url,
        required String type,
        String? filePath,
        required Map<String, String> headers,
        required Map<String, String> fields,
      }) async {
    var netWorkStatus = await checkConnectionStatus();
    if (netWorkStatus) {
      String apiUrl = ServiceBase.apiBaseUrl + url;
      var request = http.MultipartRequest(type, Uri.parse(apiUrl));
      var multipartFile = await http.MultipartFile.fromPath(keyName, filePath!);
      request.headers.addAll(headers);
      request.fields.addAll(fields);
      request.files.add(multipartFile);
      var streamResponse = await request.send();
      var res = await http.Response.fromStream(streamResponse);

      return res;
    }
    throw Strings.noInternetAlert;
  }
}

// Hilfsfunktion zum Erstellen einer Map aus Feldern und Werten
Map<String, dynamic> _createDataMap(String fields, List<dynamic> values) {
  final fieldList = fields.split(',').map((f) => f.trim()).toList();
  if (fieldList.length != values.length) {
    throw ArgumentError('Die Anzahl der Felder und Werte muss übereinstimmen.');
  }
  return Map.fromIterables(fieldList, values);
}
checkConnectionStatus() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
