# A python scrapy project that webscrapes
# https://ssbp.mycampus.ca/prod_uoit/bwckschd.p_disp_dyn_sched?TRM=U
# for available courses per term.

# Purpose: To find occupied rooms and empty rooms on campus.
# How to use: Simply open the project directory and run "scrapy crawl myspider" in terminal (Requires scrapy to be installed)
# Results: a sqlite database containing 3 columns Time, Day, Location

# Examples:
# https://i.imgur.com/oD3vIom.png
# https://i.imgur.com/j0G7qNT.png

import scrapy
from datetime import datetime
import sqlite3

term = '201909'  # Change this value to get a different term schedule

# Don't touch anything below this line unless you know what you're doing
# ----------------------------------------------------------------------

db_path = term + 'schedules.sqlite'

subjects = [
    "ALSU", "AEDT", "APBS",
    "BIOL", "BUSI",
    "CHEM", "COMM", "CSCI", "CRMN",
    "ECON", "EDUC", "ELEE", "ENGR", "EAP", "ENVS",
    "FSCI",
    "HLSC",
    "INDG", "INFR",
    "LGLS", "LBAT",
    "MANE", "MITS", "MITSC", "MATH", "MECE", "METE", "MLSC",
    "NUCL", "NURS",
    "PHIL", "PHY", "POSC", "PSYC",
    "RADI",
    "SCCO", "SSCI", "SOCI", "SOFE", "STAT",
]

invalids = ['Time', 'Day', 'Where', 'TBA', 'N/A', 'Online', '']


class MySpider(scrapy.Spider):
    name = "myspider"
    start_urls = ['https://ssbp.mycampus.ca/prod_uoit/bwckschd.p_disp_dyn_sched?TRM=U']

    def parse(self, response):
        # Initializes db
        try:
            db_conn = sqlite3.connect(db_path)
            db_cursor = db_conn.cursor()
            db_cursor.execute("""
                            CREATE TABLE IF NOT EXISTS 'occupied_schedules' (
                            'start_time' TEXT,
                            'end_time' TEXT,
                            'day' TEXT,
                            'building' TEXT,
                            'room' TEXT,
                            UNIQUE('start_time', 'end_time', 'day', 'building', 'room')
                            )
                            """)
            db_conn.commit()
            db_cursor.close()
        except sqlite3.Error as error:
            print("Failed to create sqlite table", error)

        # Enters form data through first page to second page (Selects term)
        yield scrapy.FormRequest.from_response(
            response=response,
            formdata={'p_term': term},
            callback=self.parse_page2
        )

    def parse_page2(self, response):
        # Enters form data through second page to third page (Selects all subjects and in-class deliveries)
        for subject in subjects:
            yield scrapy.FormRequest.from_response(
                response=response,
                formdata={'SEL_SUBJ': subject, 'SEL_INSM': 'CLS'},
                callback=self.parse_page3,
            )

    def parse_page3(self, response):
        try:
            db_conn = sqlite3.connect(db_path)
            db_cursor = db_conn.cursor()

            # Gets table that contains class meeting times (Fetches via summary as origin table has no id)
            for row in response.xpath(
                    '//*[@summary="This table lists the scheduled meeting times and assigned instructors for this class."]/tr'):

                # Gets time column
                if row.xpath('td[2]//text()').extract_first() not in invalids:
                    time = str(row.xpath('td[2]//text()').extract_first())
                    time_range = time.split(' - ')
                # Gets day column
                if row.xpath('td[3]//text()').extract_first() not in invalids:
                    day = str(row.xpath('td[3]//text()').extract_first())
                # Gets location column
                if row.xpath('td[4]//text()').extract_first() not in invalids:
                    if 'Virtual Adobe Connect' not in row.xpath('td[4]//text()').extract_first():
                        location = str(row.xpath('td[4]//text()').extract_first())
                        location = location.rsplit(" ", 1)

                        db_cursor.execute("""
                            INSERT OR REPLACE INTO
                            occupied_schedules('start_time', 'end_time', 'day', 'building', 'room')
                            VALUES(?, ?, ?, ?, ?);""", (str(datetime.strptime(time_range[0], '%I:%M %p'))[11:-3], str(datetime.strptime(time_range[1], '%I:%M %p'))[11:-3], day, location[0], location[1]))
                        db_conn.commit()

        except sqlite3.Error as error:
            print("Failed to add record to sqlite table", error)
        finally:
            db_cursor.close()
