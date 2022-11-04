import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:when_the_last_time/models/events/event_model.dart';

class EventsRepo {
  static Database? _db;
  static const String _repoName = 'events';
  static const String _eventUpdates = 'eventsRestoreHistory';
  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    final database =
        openDatabase(join(await getDatabasesPath(), '$_repoName.db'),
            onCreate: (db, version) async {
              // Run the CREATE TABLE statement on the database.

              db.execute(
                'create table $_repoName (id INTEGER PRIMARY KEY NOT NULL, name TEXT, date TEXT, description TEXT, category TEXT,location TEXT, image TEXT,isDeleted boolean, deletedAt Text)',
              );
              return db.execute(
                'create table $_eventUpdates (id INTEGER PRIMARY KEY NOT NULL,date TEXT,event_id INTEGER, FOREIGN KEY (event_id) REFERENCES events(id))',
              );
            },
            version: 5,
            onUpgrade: (db, oldVersion, newVersion) {
              // add isDeleted and deletedAt columns
              if (newVersion > 3) {
                db.execute(
                  'create table $_eventUpdates (id INTEGER PRIMARY KEY NOT NULL,date TEXT,event_id INTEGER, FOREIGN KEY (event_id) REFERENCES events(id))',
                );
              }
            });
    _db = await database;
    return await database;
  }

  Future<void> insertEvent(Event event) async {
    final Database? db = await this.db;
    await db!.insert(
      _repoName,
      event.toMap(),
    );
  }

  Future<List<Event>> getEvents() async {
    final Database? db = await this.db;
    final List<Map<String, dynamic>> maps =
        await db!.query(_repoName, where: "isDeleted = ?", whereArgs: [0]);
    List<Event> generated = List.generate(maps.length, (i) {
      return Event(
        name: maps[i]['name'],
        date: DateTime.parse(maps[i]['date']),
        description: maps[i]['description'],
        location: maps[i]['location'],
        image: maps[i]['image'],
        id: maps[i]['id'],
        deletedAt: maps[i]['deletedAt'] != null
            ? DateTime.parse(maps[i]['deletedAt'])
            : null,
        isDeleted: maps[i]['isDeleted'] == 1 ? true : false,
      );
    });
    // sort generated list by date
    generated.sort((a, b) => b.date.compareTo(a.date));
    return generated;
  }

  // get deleted events
  Future<List<Event>> getDeletedEvents() async {
    final Database? db = await this.db;
    final List<Map<String, dynamic>> maps =
        await db!.query(_repoName, where: 'isDeleted = ?', whereArgs: [1]);
    return List.generate(maps.length, (i) {
      return Event(
        name: maps[i]['name'],
        date: DateTime.parse(maps[i]['date']),
        description: maps[i]['description'],
        location: maps[i]['location'],
        image: maps[i]['image'],
        id: maps[i]['id'],
        deletedAt: maps[i]['deletedAt'] != null
            ? DateTime.parse(maps[i]['deletedAt'])
            : null,
        isDeleted: maps[i]['isDeleted'] == 1 ? true : false,
      );
    });
  }

  Future<void> updateEvent(Event event) async {
    final db = await this.db;
    await db!.update(
      _repoName,
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(Event event) async {
    final db = await this.db;
    // update isDeleted to true and set deletedAt to current time
    await db!.update(
      _repoName,
      {
        'isDeleted': true,
        'deletedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  // restore event
  Future<void> restoreEvent(Event event) async {
    final db = await this.db;
    // update isDeleted to false and set deletedAt to null
    await db!.update(
      _repoName,
      {
        'isDeleted': false,
        'deletedAt': null,
      },
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> hardDeleteEvent(Event event) async {
    final db = await this.db;
    await db!.delete(
      _repoName,
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteAllEvents() async {
    final db = await this.db;
    await db!.delete(_repoName);
  }

  Future<void> close() async {
    final db = await this.db;
    await db!.close();
  }

  // add event history to events_updates table
  Future<void> addEventHistory(Event event) async {
    final db = await this.db;

    // update event date to current date
    await db!.update(
      _repoName,
      {
        'date': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [event.id],
    );
    await db.insert(
      _eventUpdates,
      {
        'date': event.date.toIso8601String(),
        'event_id': event.id,
      },
    );
  }

  // get event history
  Future<List<EventRestoreHistory>> getEventHistory(Event event) async {
    final db = await this.db;
    final List<Map<String, dynamic>> maps = await db!.query(
      _eventUpdates,
      where: 'event_id = ?',
      whereArgs: [event.id],
    );
    return List.generate(maps.length, (i) {
      return EventRestoreHistory(
        date: DateTime.parse(maps[i]['date']),
        id: maps[i]['id'],
        eventId: maps[i]['event_id'],
      );
    });
  }

  // delete event history
  Future<void> deleteEventHistory(
      EventRestoreHistory eventRestoreHistory) async {
    final db = await this.db;
    await db!.delete(
      _eventUpdates,
      where: 'id = ?',
      whereArgs: [eventRestoreHistory.id],
    );
  }
}
