import sqlite3

term = '201909'  # Change this value to get a different term schedule

# Don't touch anything below this line unless you know what you're doing
# ----------------------------------------------------------------------

db_path = term + 'schedules.sqlite'

try:
    db_conn = sqlite3.connect(db_path)
    db_cursor = db_conn.cursor()
    db_cursor.execute("""
                    CREATE TABLE IF NOT EXISTS 'all_schedules' (
                    'time' TEXT,
                    'day' TEXT,
                    'location' TEXT,
                    UNIQUE('time', 'day', 'location')
                    )
                    """)
    db_conn.commit()
    db_cursor.close()
except sqlite3.Error as error:
    print("Failed to create sqlite table", error)