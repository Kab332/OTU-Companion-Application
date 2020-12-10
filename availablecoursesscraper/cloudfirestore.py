# This program parses the sqlite database into a Google Cloud Firestore database
# The reason the crawler doesnt immediately parse the firestore database is so the user can easily access the databased
# info and verify if the output is correct before submitting to a cloud.

import sqlite3
import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials

term = '201909' # Change this value to specify a different term db

# Do not touch anything below this line unless you know what you are doing
# ------------------------------------------------------------------------

db_path = term + 'schedules.sqlite'
cred = credentials.Certificate("ServicesAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

try:
    # Opens db and gets all rows from db
    db_conn = sqlite3.connect(db_path)
    db_cursor = db_conn.cursor()
    db_cursor.execute("""SELECT * FROM 'empty_schedules';""")
    rows = db_cursor.fetchall()
except sqlite3.Error as error:
    print(error)
finally:
    db_conn.commit()
    db_cursor.close()

row_count = 0
for row in rows:
    # Gets time
    time = row[0]

    # Gets day
    day = row[1]

    # Gets location
    location = row[2].rsplit(' ', 1)
    building = location[0]
    room = location[1]

    # Writes to Cloud Firestore
    doc_ref = db.collection(u'rooms').document()
    doc_ref.set({
        u'time': time,
        u'day': day,
        u'building': building,
        u'room': room
    })

    print(time, day, building, room)
    print(row_count)
    row_count += 1
    if row_count == 500:
        break

