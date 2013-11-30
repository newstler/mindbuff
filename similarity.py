import pymongo
from collections import defaultdict

connection = pymongo.Connection("localhost")
db = connection['mind_buff_development']

tag2id = {}

item_id = 0

item2mongoid = {}
mongoid2item = {}

matrix = defaultdict(list)

for item in db.nodes.find():
    print item
    for tag in item['tags']:
        if tag in tag2id.keys():
            tag_id = tag2id[tag]
        else:
            tag_id = len(tag2id.keys())
            tag2id[tag] = tag_id
        item2mongoid[item_id] = item['_id']
        mongoid2item[item['_id']] = item_id
        matrix[item_id].append(tag_id)
    item_id += 1


print "!", item_id, len(tag2id.keys())

import numpy as np
m = np.zeros((item_id, len(tag2id.keys())))
for i in range(item_id):
    for tag in matrix[i]:
        print tag
        m[i][tag] = 1

print type(m)
S1 = np.dot(m, m.T)
S1 = S1 / np.linalg.norm(S1)
S2 = np.dot(m.T, m)
S2 = S2 / np.linalg.norm(S2)
S1 = S1 + 0.5*np.dot(S1, S1)
S2 = S2 + 0.5*np.dot(S2, S2)

for item in db.nodes.find():
    item_id = mongoid2item[item['_id']]
    t = S1[item_id][:]
    i = 0
    l = []
    for score in t:
        l.append((score, str(item2mongoid[i])))
    print l
    item['nodes'] = l
    db.nodes.save(item) 

