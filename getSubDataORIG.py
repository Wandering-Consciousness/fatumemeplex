import requests
import json
import csv
import datetime


def getPushshiftData(after, before, sub):
    # url below fetches max amount of submissions(1000) from within time frame from subreddit
    url = 'https://api.pushshift.io/reddit/search/submission/?&size=1000&after='+str(after) + '&before='+str(
        before)+'&subreddit='+sub+"&metadata=true"
    r = requests.get(url)
    data = json.loads(r.text)
    return data['data']


def collectSubData(subm):
    subData = list()  # list to store data points
    title = subm['title'].encode('ascii', 'ignore').decode('ascii')
    created = subm['created_utc']
    body = subm['selftext'].encode('ascii', 'ignore').decode('ascii') # retrieve body of post and strip of emoji chars
    if body == "":
        body = "none"
    sub_id = subm['id']
    body = body.split()
    for word in body:
        if "\n" in word:
            word.replace("\n", "")
    body = " ".join(body)

    subData.append((sub_id, title, created, body))
    subStats[sub_id] = subData


def updateSubs_file(): # makes and saves csv file
    upload_count = 0
    location = "C:\\path_to_folder"
    print("input filename of submission file, please add .csv")
    filename = input()
    file = location + filename
    with open(file, 'w', newline='', encoding='utf-8') as file:
        a = csv.writer(file, delimiter=',')
        headers = ["Post ID", "Title", "Publish Date (unix)", "Post Body"]
        a.writerow(headers)
        for sub in subStats:
            a.writerow(subStats[sub][0])
            upload_count += 1

        print(str(upload_count) + " submissions have been uploaded")

#Subreddit to fetch from
sub='randonauts'
#before and after dates (in UNIX timestamp format)
after = "1567296000"
before = "1572566400"
subCount = 0
subStats = {}

data = getPushshiftData(after, before, sub)
# Will run until all posts have been gathered
# from the after date up until before date
while len(data) > 0:
    for submission in data:
        collectSubData(submission)
        subCount += 1
    # Calls getPushshiftData() with the created date of the last submission
    print(len(data))
    print(str(datetime.datetime.fromtimestamp(data[-1]['created_utc'])))
    after = data[-1]['created_utc']
    data = getPushshiftData(after, before, sub)

print(str(len(subStats)) + " submissions have added to list")

updateSubs_file()

