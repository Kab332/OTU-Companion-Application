import sqlite3
import re
from datetime import datetime

term = '201909'  # Change this value to get a different term schedule

# Don't touch anything below this line unless you know what you're doing
# ----------------------------------------------------------------------

db_path = term + 'schedules.sqlite'

days = ['M', 'T', 'W', 'R', 'F']
hours = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23']
minutes = ['00', '10', '20', '30', '40', '50']


def create_all_schedules():
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
    except sqlite3.Error as error:
        print("Failed to create sqlite table", error)
    finally:
        db_conn.commit()
        db_cursor.close()


def get_locations():
    try:
        db_conn = sqlite3.connect(db_path)
        db_cursor = db_conn.cursor()
        db_cursor.execute("""
                        SELECT DISTINCT location
                        FROM 'occupied_schedules'
                        """)
        locations = db_cursor.fetchall()
    except sqlite3.Error as error:
        print("Failed to create sqlite table", error)
    finally:
        db_conn.commit()
        db_cursor.close()

    print(locations)

    return locations


def call_locations():
    try:
        db_conn = sqlite3.connect(db_path)
        db_cursor = db_conn.cursor()
        db_cursor.execute("""
                        CREATE TABLE IF NOT EXISTS 'locations' (
                        'location' TEXT,
                        UNIQUE('location')
                        )
                        """)

        for location in get_locations():
            location = re.search(r"\(\'([A-Za-z0-9 ()/-]+)\'\,\)", str(location)).group(1)
            db_cursor.execute("""
                                INSERT INTO 'locations'('location')
                                VALUES(?)
                                """, (location,))
    except sqlite3.Error as error:
        print(error)
    finally:
        db_conn.commit()
        db_cursor.close()


def call_days():
    try:
        db_conn = sqlite3.connect(db_path)
        db_cursor = db_conn.cursor()
        db_cursor.execute("""
                        CREATE TABLE IF NOT EXISTS 'days' (
                        'day' TEXT,
                        UNIQUE('day')
                        )
                        """)

        for day in days:
            db_cursor.execute("""
                                INSERT INTO 'days'('day')
                                VALUES(?)
                                """, (day,))
    except sqlite3.Error as error:
        print(error)
    finally:
        db_conn.commit()
        db_cursor.close()


def call_times():
    try:
        db_conn = sqlite3.connect(db_path)
        db_cursor = db_conn.cursor()
        db_cursor.execute("""
                        CREATE TABLE IF NOT EXISTS 'times' (
                        'time' TEXT,
                        UNIQUE('time')
                        )
                        """)

        for hour in hours:
            for minute in minutes:
                time_block = hour + ":" + minute
                db_cursor.execute("""
                                            INSERT INTO 'times'('time')
                                            VALUES(?)
                                            """, (time_block,))
    except sqlite3.Error as error:
        print(error)
    finally:
        db_conn.commit()
        db_cursor.close()


def cross_join():
    try:
        db_conn = sqlite3.connect(db_path)
        db_cursor = db_conn.cursor()
        db_cursor.execute("""
                        INSERT INTO 'all_schedules' 
                        SELECT *
                        FROM 'times'
                            CROSS JOIN
                            'days'
                            CROSS JOIN
                            'locations'
                        """)
    except sqlite3.Error as error:
        print(error)
    finally:
        db_conn.commit()
        db_cursor.close()


def create_empty_schedules():
    try:
        db_conn = sqlite3.connect(db_path)
        db_cursor = db_conn.cursor()

        db_cursor.execute("""
                        CREATE TABLE `empty_schedules` AS
                        SELECT 
                            'all_schedules'.*
                        FROM 
                            'all_schedules'
                        LEFT JOIN 
                            'occupied_schedules'
                        ON 
                            'all_schedules'.'time' BETWEEN 'occupied_schedules'.'start_time' AND 'occupied_schedules'.'end_time'
                            AND 'all_schedules'.'day' = 'occupied_schedules'.'day'
                            AND 'all_schedules'.'location' = 'occupied_schedules'.'location'
                        WHERE 'occupied_schedules'.'start_time' is null
                        """)
    except sqlite3.Error as error:
        print(error)
    finally:
        db_conn.commit()
        db_cursor.close()


create_all_schedules()
cross_join()
create_empty_schedules()
